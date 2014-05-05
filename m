Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932896AbaEEOVj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 10:21:39 -0400
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:36868 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932877AbaEEOVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 10:21:37 -0400
Message-ID: <53679E6A.3060807@de.ibm.com>
Date: Mon, 05 May 2014 16:21:30 +0200
From: Christian Borntraeger <borntraeger@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org
CC: kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH v4] kvm/irqchip: Speed up KVM_SET_GSI_ROUTING
References: <1398703176-17812-1-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1398703176-17812-1-git-send-email-pbonzini@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14050514-0342-0000-0000-000008A7058F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/04/14 18:39, Paolo Bonzini wrote:
> From: Christian Borntraeger <borntraeger@de.ibm.com>

Given all your work, What about From: Paolo Bonzini <pbonzini@redhat.com>
plus
"Based on an inital patch from Christian Borntraeger"
> 
> When starting lots of dataplane devices the bootup takes very long on
> Christian's s390 with irqfd patches. With larger setups he is even
> able to trigger some timeouts in some components.  Turns out that the
> KVM_SET_GSI_ROUTING ioctl takes very long (strace claims up to 0.1 sec)
> when having multiple CPUs.  This is caused by the  synchronize_rcu and
> the HZ=100 of s390.  By changing the code to use a private srcu we can
> speed things up.  This patch reduces the boot time till mounting root
> from 8 to 2 seconds on my s390 guest with 100 disks.
> 
> Uses of hlist_for_each_entry_rcu, hlist_add_head_rcu, hlist_del_init_rcu
> are fine because they do not have lockdep checks (hlist_for_each_entry_rcu
> uses rcu_dereference_raw rather than rcu_dereference, and write-sides
> do not do rcu lockdep at all).
> 
> Note that we're hardly relying on the "sleepable" part of srcu.  We just
> want SRCU's faster detection of grace periods.
> 
> Testing was done by Andrew Theurer using NETPERF.  The difference between
> results "before" and "after" the patch has mean -0.2% and standard deviation
> 0.6%.  Using a paired t-test on the data points says that there is a 2.5%
> probability that the patch is the cause of the performance difference
> (rather than a random fluctuation).
> 
> Cc: Marcelo Tosatti <mtosatti@redhat.com>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

Some questions regarding expedided vs. non expedited and a comment without a necessary action.

Otherwise
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>
Tested-by: Christian Borntraeger <borntraeger@de.ibm.com> # on s390

> ---
>  include/linux/kvm_host.h |  1 +
>  virt/kvm/eventfd.c       | 25 +++++++++++++++----------
>  virt/kvm/irq_comm.c      | 17 +++++++++--------
>  virt/kvm/irqchip.c       | 31 ++++++++++++++++---------------
>  virt/kvm/kvm_main.c      | 16 ++++++++++------
>  5 files changed, 51 insertions(+), 39 deletions(-)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 820fc2e1d9df..cd0df9a9352d 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -368,6 +368,7 @@ struct kvm {
>  	struct mm_struct *mm; /* userspace tied to this vm */
>  	struct kvm_memslots *memslots;
>  	struct srcu_struct srcu;
> +	struct srcu_struct irq_srcu;
>  #ifdef CONFIG_KVM_APIC_ARCHITECTURE
>  	u32 bsp_vcpu_id;
>  #endif
> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> index 912ec5a95e2c..20c3af7692c5 100644
> --- a/virt/kvm/eventfd.c
> +++ b/virt/kvm/eventfd.c
> @@ -31,6 +31,7 @@
>  #include <linux/list.h>
>  #include <linux/eventfd.h>
>  #include <linux/kernel.h>
> +#include <linux/srcu.h>
>  #include <linux/slab.h>
> 
>  #include "iodev.h"
> @@ -118,19 +119,22 @@ static void
>  irqfd_resampler_ack(struct kvm_irq_ack_notifier *kian)
>  {
>  	struct _irqfd_resampler *resampler;
> +	struct kvm *kvm;
>  	struct _irqfd *irqfd;
> +	int idx;
> 
>  	resampler = container_of(kian, struct _irqfd_resampler, notifier);
> +	kvm = resampler->kvm;
> 
> -	kvm_set_irq(resampler->kvm, KVM_IRQFD_RESAMPLE_IRQ_SOURCE_ID,
> +	kvm_set_irq(kvm, KVM_IRQFD_RESAMPLE_IRQ_SOURCE_ID,
>  		    resampler->notifier.gsi, 0, false);
> 
> -	rcu_read_lock();
> +	idx = srcu_read_lock(&kvm->irq_srcu);
> 
>  	list_for_each_entry_rcu(irqfd, &resampler->list, resampler_link)
>  		eventfd_signal(irqfd->resamplefd, 1);
> 
> -	rcu_read_unlock();
> +	srcu_read_unlock(&kvm->irq_srcu, idx);
>  }
> 
>  static void
> @@ -142,7 +146,7 @@ irqfd_resampler_shutdown(struct _irqfd *irqfd)
>  	mutex_lock(&kvm->irqfds.resampler_lock);
> 
>  	list_del_rcu(&irqfd->resampler_link);
> -	synchronize_rcu();
> +	synchronize_srcu(&kvm->irq_srcu);
> 
>  	if (list_empty(&resampler->list)) {
>  		list_del(&resampler->link);
> @@ -221,17 +225,18 @@ irqfd_wakeup(wait_queue_t *wait, unsigned mode, int sync, void *key)
>  	unsigned long flags = (unsigned long)key;
>  	struct kvm_kernel_irq_routing_entry *irq;
>  	struct kvm *kvm = irqfd->kvm;
> +	int idx;
> 
>  	if (flags & POLLIN) {
> -		rcu_read_lock();
> -		irq = rcu_dereference(irqfd->irq_entry);
> +		idx = srcu_read_lock(&kvm->irq_srcu);
> +		irq = srcu_dereference(irqfd->irq_entry, &kvm->irq_srcu);
>  		/* An event has been signaled, inject an interrupt */
>  		if (irq)
>  			kvm_set_msi(irq, kvm, KVM_USERSPACE_IRQ_SOURCE_ID, 1,
>  					false);
>  		else
>  			schedule_work(&irqfd->inject);
> -		rcu_read_unlock();
> +		srcu_read_unlock(&kvm->irq_srcu, idx);
>  	}
> 
>  	if (flags & POLLHUP) {
> @@ -363,7 +368,7 @@ kvm_irqfd_assign(struct kvm *kvm, struct kvm_irqfd *args)
>  		}
> 
>  		list_add_rcu(&irqfd->resampler_link, &irqfd->resampler->list);
> -		synchronize_rcu();
> +		synchronize_srcu(&kvm->irq_srcu);

No idea what resampler is, can this become time critical as well - iow do we need expedited here?


> 
>  		mutex_unlock(&kvm->irqfds.resampler_lock);
>  	}
> @@ -465,7 +470,7 @@ kvm_irqfd_deassign(struct kvm *kvm, struct kvm_irqfd *args)
>  			 * another thread calls kvm_irq_routing_update before
>  			 * we flush workqueue below (we synchronize with
>  			 * kvm_irq_routing_update using irqfds.lock).
> -			 * It is paired with synchronize_rcu done by caller
> +			 * It is paired with synchronize_srcu done by caller
>  			 * of that function.
>  			 */
>  			rcu_assign_pointer(irqfd->irq_entry, NULL);
> @@ -524,7 +529,7 @@ kvm_irqfd_release(struct kvm *kvm)
> 
>  /*
>   * Change irq_routing and irqfd.
> - * Caller must invoke synchronize_rcu afterwards.
> + * Caller must invoke synchronize_srcu(&kvm->irq_srcu) afterwards.
>   */
>  void kvm_irq_routing_update(struct kvm *kvm,
>  			    struct kvm_irq_routing_table *irq_rt)
> diff --git a/virt/kvm/irq_comm.c b/virt/kvm/irq_comm.c
> index e2e6b4473a96..ced4a542a031 100644
> --- a/virt/kvm/irq_comm.c
> +++ b/virt/kvm/irq_comm.c
> @@ -163,6 +163,7 @@ int kvm_set_irq_inatomic(struct kvm *kvm, int irq_source_id, u32 irq, int level)
>  	struct kvm_kernel_irq_routing_entry *e;
>  	int ret = -EINVAL;
>  	struct kvm_irq_routing_table *irq_rt;
> +	int idx;
> 
>  	trace_kvm_set_irq(irq, level, irq_source_id);
> 
> @@ -174,8 +175,8 @@ int kvm_set_irq_inatomic(struct kvm *kvm, int irq_source_id, u32 irq, int level)
>  	 * Since there's no easy way to do this, we only support injecting MSI
>  	 * which is limited to 1:1 GSI mapping.
>  	 */
> -	rcu_read_lock();
> -	irq_rt = rcu_dereference(kvm->irq_routing);
> +	idx = srcu_read_lock(&kvm->irq_srcu);
> +	irq_rt = srcu_dereference(kvm->irq_routing, &kvm->irq_srcu);
>  	if (irq < irq_rt->nr_rt_entries)
>  		hlist_for_each_entry(e, &irq_rt->map[irq], link) {
>  			if (likely(e->type == KVM_IRQ_ROUTING_MSI))
> @@ -184,7 +185,7 @@ int kvm_set_irq_inatomic(struct kvm *kvm, int irq_source_id, u32 irq, int level)
>  				ret = -EWOULDBLOCK;
>  			break;
>  		}
> -	rcu_read_unlock();
> +	srcu_read_unlock(&kvm->irq_srcu, idx);
>  	return ret;
>  }
> 
> @@ -253,22 +254,22 @@ void kvm_unregister_irq_mask_notifier(struct kvm *kvm, int irq,
>  	mutex_lock(&kvm->irq_lock);
>  	hlist_del_rcu(&kimn->link);
>  	mutex_unlock(&kvm->irq_lock);
> -	synchronize_rcu();
> +	synchronize_srcu(&kvm->irq_srcu);
>  }
> 
>  void kvm_fire_mask_notifiers(struct kvm *kvm, unsigned irqchip, unsigned pin,
>  			     bool mask)
>  {
>  	struct kvm_irq_mask_notifier *kimn;
> -	int gsi;
> +	int idx, gsi;
> 
> -	rcu_read_lock();
> -	gsi = rcu_dereference(kvm->irq_routing)->chip[irqchip][pin];
> +	idx = srcu_read_lock(&kvm->irq_srcu);
> +	gsi = srcu_dereference(kvm->irq_routing, &kvm->irq_srcu)->chip[irqchip][pin];
>  	if (gsi != -1)
>  		hlist_for_each_entry_rcu(kimn, &kvm->mask_notifier_list, link)
>  			if (kimn->irq == gsi)
>  				kimn->func(kimn, mask);
> -	rcu_read_unlock();
> +	srcu_read_unlock(&kvm->irq_srcu, idx);
>  }
> 
>  int kvm_set_routing_entry(struct kvm_irq_routing_table *rt,
> diff --git a/virt/kvm/irqchip.c b/virt/kvm/irqchip.c
> index 20dc9e4a8f6c..58bf5ba1aab1 100644
> --- a/virt/kvm/irqchip.c
> +++ b/virt/kvm/irqchip.c
> @@ -26,6 +26,7 @@
> 
>  #include <linux/kvm_host.h>
>  #include <linux/slab.h>
> +#include <linux/srcu.h>
>  #include <linux/export.h>
>  #include <trace/events/kvm.h>
>  #include "irq.h"
> @@ -33,19 +34,19 @@
>  bool kvm_irq_has_notifier(struct kvm *kvm, unsigned irqchip, unsigned pin)
>  {
>  	struct kvm_irq_ack_notifier *kian;
> -	int gsi;
> +	int gsi, idx;
> 
> -	rcu_read_lock();
> -	gsi = rcu_dereference(kvm->irq_routing)->chip[irqchip][pin];
> +	idx = srcu_read_lock(&kvm->irq_srcu);
> +	gsi = srcu_dereference(kvm->irq_routing, &kvm->irq_srcu)->chip[irqchip][pin];
>  	if (gsi != -1)
>  		hlist_for_each_entry_rcu(kian, &kvm->irq_ack_notifier_list,
>  					 link)
>  			if (kian->gsi == gsi) {
> -				rcu_read_unlock();
> +				srcu_read_unlock(&kvm->irq_srcu, idx);
>  				return true;
>  			}
> 
> -	rcu_read_unlock();
> +	srcu_read_unlock(&kvm->irq_srcu, idx);
> 
>  	return false;
>  }
> @@ -54,18 +55,18 @@ EXPORT_SYMBOL_GPL(kvm_irq_has_notifier);
>  void kvm_notify_acked_irq(struct kvm *kvm, unsigned irqchip, unsigned pin)
>  {
>  	struct kvm_irq_ack_notifier *kian;
> -	int gsi;
> +	int gsi, idx;
> 
>  	trace_kvm_ack_irq(irqchip, pin);
> 
> -	rcu_read_lock();
> -	gsi = rcu_dereference(kvm->irq_routing)->chip[irqchip][pin];
> +	idx = srcu_read_lock(&kvm->irq_srcu);
> +	gsi = srcu_dereference(kvm->irq_routing, &kvm->irq_srcu)->chip[irqchip][pin];
>  	if (gsi != -1)
>  		hlist_for_each_entry_rcu(kian, &kvm->irq_ack_notifier_list,
>  					 link)
>  			if (kian->gsi == gsi)
>  				kian->irq_acked(kian);
> -	rcu_read_unlock();
> +	srcu_read_unlock(&kvm->irq_srcu, idx);
>  }
> 
>  void kvm_register_irq_ack_notifier(struct kvm *kvm,
> @@ -85,7 +86,7 @@ void kvm_unregister_irq_ack_notifier(struct kvm *kvm,
>  	mutex_lock(&kvm->irq_lock);
>  	hlist_del_init_rcu(&kian->link);
>  	mutex_unlock(&kvm->irq_lock);
> -	synchronize_rcu();
> +	synchronize_srcu_expedited(&kvm->irq_srcu);

Hmm, looks like all callers are slow path (shutdown, deregister assigned dev). Couldnt 
we use the non expedited variant?


>  #ifdef __KVM_HAVE_IOAPIC
>  	kvm_vcpu_request_scan_ioapic(kvm);
>  #endif
> @@ -115,7 +116,7 @@ int kvm_set_irq(struct kvm *kvm, int irq_source_id, u32 irq, int level,
>  		bool line_status)
>  {
>  	struct kvm_kernel_irq_routing_entry *e, irq_set[KVM_NR_IRQCHIPS];
> -	int ret = -1, i = 0;
> +	int ret = -1, i = 0, idx;
>  	struct kvm_irq_routing_table *irq_rt;
> 
>  	trace_kvm_set_irq(irq, level, irq_source_id);
> @@ -124,12 +125,12 @@ int kvm_set_irq(struct kvm *kvm, int irq_source_id, u32 irq, int level,
>  	 * IOAPIC.  So set the bit in both. The guest will ignore
>  	 * writes to the unused one.
>  	 */
> -	rcu_read_lock();
> -	irq_rt = rcu_dereference(kvm->irq_routing);
> +	idx = srcu_read_lock(&kvm->irq_srcu);
> +	irq_rt = srcu_dereference(kvm->irq_routing, &kvm->irq_srcu);
>  	if (irq < irq_rt->nr_rt_entries)
>  		hlist_for_each_entry(e, &irq_rt->map[irq], link)
>  			irq_set[i++] = *e;
> -	rcu_read_unlock();
> +	srcu_read_unlock(&kvm->irq_srcu, idx);
> 
>  	while(i--) {
>  		int r;
> @@ -226,7 +227,7 @@ int kvm_set_irq_routing(struct kvm *kvm,
>  	kvm_irq_routing_update(kvm, new);
>  	mutex_unlock(&kvm->irq_lock);
> 
> -	synchronize_rcu();
> +	synchronize_srcu_expedited(&kvm->irq_srcu);
> 
>  	new = old;
>  	r = 0;
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index fa70c6e642b4..95b4c2b3906a 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -457,11 +457,11 @@ static struct kvm *kvm_create_vm(unsigned long type)
> 
>  	r = kvm_arch_init_vm(kvm, type);
>  	if (r)
> -		goto out_err_nodisable;
> +		goto out_err_no_disable;
> 
>  	r = hardware_enable_all();
>  	if (r)
> -		goto out_err_nodisable;
> +		goto out_err_no_disable;
> 
>  #ifdef CONFIG_HAVE_KVM_IRQCHIP
>  	INIT_HLIST_HEAD(&kvm->mask_notifier_list);
> @@ -473,10 +473,12 @@ static struct kvm *kvm_create_vm(unsigned long type)
>  	r = -ENOMEM;
>  	kvm->memslots = kzalloc(sizeof(struct kvm_memslots), GFP_KERNEL);
>  	if (!kvm->memslots)
> -		goto out_err_nosrcu;
> +		goto out_err_no_srcu;
>  	kvm_init_memslots_id(kvm);
>  	if (init_srcu_struct(&kvm->srcu))
> -		goto out_err_nosrcu;
> +		goto out_err_no_srcu;
> +	if (init_srcu_struct(&kvm->irq_srcu))
> +		goto out_err_no_irq_srcu;
>  	for (i = 0; i < KVM_NR_BUSES; i++) {
>  		kvm->buses[i] = kzalloc(sizeof(struct kvm_io_bus),
>  					GFP_KERNEL);
> @@ -505,10 +507,12 @@ static struct kvm *kvm_create_vm(unsigned long type)
>  	return kvm;
> 
>  out_err:
> +	cleanup_srcu_struct(&kvm->irq_srcu);
> +out_err_no_irq_srcu:
>  	cleanup_srcu_struct(&kvm->srcu);
> -out_err_nosrcu:
> +out_err_no_srcu:
>  	hardware_disable_all();
> -out_err_nodisable:
> +out_err_no_disable:


the patch would be smaller without this change, but it makes the naming more consistent, so ok.


>  	for (i = 0; i < KVM_NR_BUSES; i++)
>  		kfree(kvm->buses[i]);
>  	kfree(kvm->memslots);
> 

