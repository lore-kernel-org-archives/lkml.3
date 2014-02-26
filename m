Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904AbaBZU3O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 15:29:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34197 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753866AbaBZU3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 15:29:12 -0500
Date: Wed, 26 Feb 2014 17:25:26 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Andrew Jones <drjones@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH 1/2] x86: kvm: rate-limit global clock updates
Message-ID: <20140226202526.GA9218@amt.cnet>
References: <1393438512-21273-1-git-send-email-drjones@redhat.com>
 <1393438512-21273-2-git-send-email-drjones@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393438512-21273-2-git-send-email-drjones@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 07:15:11PM +0100, Andrew Jones wrote:
> When we update a vcpu's local clock it may pick up an NTP correction.
> We can't wait an indeterminate amount of time for other vcpus to pick
> up that correction, so commit 0061d53daf26f introduced a global clock
> update. However, we can't request a global clock update on every vcpu
> load either (which is what happens if the tsc is marked as unstable).
> The solution is to rate-limit the global clock updates. Marcelo
> calculated that we should delay the global clock updates no more
> than 0.1s as follows:
> 
> Assume an NTP correction c is applied to one vcpu, but not the other,
> then in n seconds the delta of the vcpu system_timestamps will be
> c * n. If we assume a correction of 500ppm (worst-case), then the two
> vcpus will diverge 100us in 0.1s, which is a considerable amount.

100us -> 50us.

> Signed-off-by: Andrew Jones <drjones@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  1 +
>  arch/x86/kvm/x86.c              | 33 +++++++++++++++++++++++++++++----
>  2 files changed, 30 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index e714f8c08ccf2..9aa09d330a4b5 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -598,6 +598,7 @@ struct kvm_arch {
>  	bool use_master_clock;
>  	u64 master_kernel_ns;
>  	cycle_t master_cycle_now;
> +	struct delayed_work kvmclock_update_work;
>  
>  	struct kvm_xen_hvm_config xen_hvm_config;
>  
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 4cca45853dfeb..a2d30de597b7d 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -1628,20 +1628,43 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
>   * the others.
>   *
>   * So in those cases, request a kvmclock update for all vcpus.
> - * The worst case for a remote vcpu to update its kvmclock
> - * is then bounded by maximum nohz sleep latency.
> + * We need to rate-limit these requests though, as they can
> + * considerably slow guests that have a large number of vcpus.
> + * The time for a remote vcpu to update its kvmclock is bound
> + * by the delay we use to rate-limit the updates.
>   */
>  
> -static void kvm_gen_kvmclock_update(struct kvm_vcpu *v)
> +#define KVMCLOCK_UPDATE_DELAY msecs_to_jiffies(100)
> +
> +static void kvmclock_update_fn(struct work_struct *work)
>  {
>  	int i;
> -	struct kvm *kvm = v->kvm;
> +	struct delayed_work *dwork = to_delayed_work(work);
> +	struct kvm_arch *ka = container_of(dwork, struct kvm_arch,
> +					   kvmclock_update_work);
> +	struct kvm *kvm = container_of(ka, struct kvm, arch);
>  	struct kvm_vcpu *vcpu;
>  
>  	kvm_for_each_vcpu(i, vcpu, kvm) {
>  		set_bit(KVM_REQ_CLOCK_UPDATE, &vcpu->requests);
>  		kvm_vcpu_kick(vcpu);
>  	}
> +	kvm_put_kvm(kvm);
> +}

Can cancel_work_sync on vm shutdown instead of get/put kvm ?

(somewhat annoying for vm to not go down immediatelly).

> +static void kvm_schedule_kvmclock_update(struct kvm *kvm)
> +{
> +	kvm_get_kvm(kvm);
> +	schedule_delayed_work(&kvm->arch.kvmclock_update_work,
> +					KVMCLOCK_UPDATE_DELAY);
> +}
> +
> +static void kvm_gen_kvmclock_update(struct kvm_vcpu *v)
> +{
> +	struct kvm *kvm = v->kvm;
> +
> +	set_bit(KVM_REQ_CLOCK_UPDATE, &v->requests);
> +	kvm_schedule_kvmclock_update(kvm);
>  }
>  
>  static bool msr_mtrr_valid(unsigned msr)
> @@ -7019,6 +7042,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
>  
>  	pvclock_update_vm_gtod_copy(kvm);
>  
> +	INIT_DELAYED_WORK(&kvm->arch.kvmclock_update_work, kvmclock_update_fn);
> +
>  	return 0;
>  }
>  
> -- 
> 1.8.1.4
