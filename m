Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756407AbaDQMdT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 08:33:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6248 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752149AbaDQMdQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 08:33:16 -0400
Date: Thu, 17 Apr 2014 15:33:55 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, gleb@kernel.org, kvm@vger.kernel.org,
        mtosatti@redhat.com
Subject: Re: [PATCH 2/2] vmx: speed up wildcard MMIO EVENTFD
Message-ID: <20140417123354.GA16748@redhat.com>
References: <1396291468-12120-1-git-send-email-mst@redhat.com>
 <1396291468-12120-2-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1396291468-12120-2-git-send-email-mst@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2014 at 09:50:44PM +0300, Michael S. Tsirkin wrote:
> With KVM, MMIO is much slower than PIO, due to the need to
> do page walk and emulation. But with EPT, it does not have to be: we
> know the address from the VMCS so if the address is unique, we can look
> up the eventfd directly, bypassing emulation.
> 
> Unfortunately, this only works if userspace does not need to match on
> access length and data.  The implementation adds a separate FAST_MMIO
> bus internally. This serves two purposes:
>     - minimize overhead for old userspace that does not use eventfd with lengtth = 0
>     - minimize disruption in other code (since we don't know the length,
>       devices on the MMIO bus only get a valid address in write, this
>       way we don't need to touch all devices to teach them to handle
>       an invalid length)
> 
> At the moment, this optimization only has effect for EPT on x86.
> 
> It will be possible to speed up MMIO for NPT and MMU using the same
> idea in the future.
> 
> With this patch applied, on VMX MMIO EVENTFD is essentially as fast as PIO.
> I was unable to detect any measureable slowdown to non-eventfd MMIO.
> 
> Making MMIO faster is important for the upcoming virtio 1.0 which
> includes an MMIO signalling capability.
> 
> The idea was suggested by Peter Anvin.  Lots of thanks to Gleb for
> pre-review and suggestions.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Ping.
Marcelo, any chance you could merge this for 3.16?

> ---
>  include/linux/kvm_host.h |  1 +
>  include/uapi/linux/kvm.h |  1 +
>  arch/x86/kvm/vmx.c       |  4 ++++
>  virt/kvm/eventfd.c       | 16 ++++++++++++++++
>  virt/kvm/kvm_main.c      |  1 +
>  5 files changed, 23 insertions(+)
> 
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index b8e9a43..c2eaa9f 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -163,6 +163,7 @@ enum kvm_bus {
>  	KVM_MMIO_BUS,
>  	KVM_PIO_BUS,
>  	KVM_VIRTIO_CCW_NOTIFY_BUS,
> +	KVM_FAST_MMIO_BUS,
>  	KVM_NR_BUSES
>  };
>  
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index d73007e..fc75810 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -450,6 +450,7 @@ enum {
>  	kvm_ioeventfd_flag_nr_pio,
>  	kvm_ioeventfd_flag_nr_deassign,
>  	kvm_ioeventfd_flag_nr_virtio_ccw_notify,
> +	kvm_ioeventfd_flag_nr_fast_mmio,
>  	kvm_ioeventfd_flag_nr_max,
>  };
>  
> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> index 3927528..78a1932 100644
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -5493,6 +5493,10 @@ static int handle_ept_misconfig(struct kvm_vcpu *vcpu)
>  	gpa_t gpa;
>  
>  	gpa = vmcs_read64(GUEST_PHYSICAL_ADDRESS);
> +	if (!kvm_io_bus_write(vcpu->kvm, KVM_FAST_MMIO_BUS, gpa, 0, NULL)) {
> +		skip_emulated_instruction(vcpu);
> +		return 1;
> +	}
>  
>  	ret = handle_mmio_page_fault_common(vcpu, gpa, true);
>  	if (likely(ret == RET_MMIO_PF_EMULATE))
> diff --git a/virt/kvm/eventfd.c b/virt/kvm/eventfd.c
> index 9eadb59..c61f2eb 100644
> --- a/virt/kvm/eventfd.c
> +++ b/virt/kvm/eventfd.c
> @@ -770,6 +770,16 @@ kvm_assign_ioeventfd(struct kvm *kvm, struct kvm_ioeventfd *args)
>  	if (ret < 0)
>  		goto unlock_fail;
>  
> +	/* When length is ignored, MMIO is also put on a separate bus, for
> +	 * faster lookups.
> +	 */
> +	if (!args->len && !(args->flags & KVM_IOEVENTFD_FLAG_PIO)) {
> +		ret = kvm_io_bus_register_dev(kvm, KVM_FAST_MMIO_BUS,
> +					      p->addr, 0, &p->dev);
> +		if (ret < 0)
> +			goto register_fail;
> +	}
> +
>  	kvm->buses[bus_idx]->ioeventfd_count++;
>  	list_add_tail(&p->list, &kvm->ioeventfds);
>  
> @@ -777,6 +787,8 @@ kvm_assign_ioeventfd(struct kvm *kvm, struct kvm_ioeventfd *args)
>  
>  	return 0;
>  
> +register_fail:
> +	kvm_io_bus_unregister_dev(kvm, bus_idx, &p->dev);
>  unlock_fail:
>  	mutex_unlock(&kvm->slots_lock);
>  
> @@ -816,6 +828,10 @@ kvm_deassign_ioeventfd(struct kvm *kvm, struct kvm_ioeventfd *args)
>  			continue;
>  
>  		kvm_io_bus_unregister_dev(kvm, bus_idx, &p->dev);
> +		if (!p->length) {
> +			kvm_io_bus_unregister_dev(kvm, KVM_FAST_MMIO_BUS,
> +						  &p->dev);
> +		}
>  		kvm->buses[bus_idx]->ioeventfd_count--;
>  		ioeventfd_release(p);
>  		ret = 0;
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 03a0381..22a4e1b 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2920,6 +2920,7 @@ static int __kvm_io_bus_read(struct kvm_io_bus *bus, struct kvm_io_range *range,
>  
>  	return -EOPNOTSUPP;
>  }
> +EXPORT_SYMBOL_GPL(kvm_io_bus_write);
>  
>  /* kvm_io_bus_read - called under kvm->slots_lock */
>  int kvm_io_bus_read(struct kvm *kvm, enum kvm_bus bus_idx, gpa_t addr,
> -- 
> MST
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
