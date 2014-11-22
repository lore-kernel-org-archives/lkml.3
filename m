Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174AbaKVQWz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 11:22:55 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:61864 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbaKVQWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 11:22:53 -0500
Message-ID: <5470B859.3000104@redhat.com>
Date: Sat, 22 Nov 2014 17:22:49 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        KVM list <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH] kvm: x86: move assigned-dev.c and iommu.c to arch/x86/
References: <1416604910-13978-1-git-send-email-rkrcmar@redhat.com>
In-Reply-To: <1416604910-13978-1-git-send-email-rkrcmar@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 21/11/2014 22:21, Radim Krčmář wrote:
> Now that ia64 is gone, we can hide deprecated device assignment in x86.
> 
> Notable changes:
>  - kvm_vm_ioctl_assigned_device() was moved to x86/kvm_arch_vm_ioctl()
> 
> The easy parts were removed from generic kvm code, remaining
>  - kvm_iommu_(un)map_pages() would require new code to be moved
>  - struct kvm_assigned_dev_kernel depends on struct kvm_irq_ack_notifier

kvm_assign_device and kvm_deassign_device can also be moved to arch/x86,
in a new assigned-dev.h header.  The header could include struct
kvm_assigned_dev_kernel too but, if you change the argument of
kvm_assign_device and kvm_deassign_device to struct pci_dev, the struct
can move directly to assigned-dev.c and remain hidden there.

It's fine to do this as a follow up.

Thanks!

Paolo

> Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
> ---
>  Or are we going to remove it instead? ;)
> 
>  arch/x86/include/asm/kvm_host.h       | 23 +++++++++++++++++++++++
>  arch/x86/kvm/Makefile                 |  2 +-
>  {virt => arch/x86}/kvm/assigned-dev.c |  0
>  {virt => arch/x86}/kvm/iommu.c        |  0
>  arch/x86/kvm/x86.c                    |  2 +-
>  include/linux/kvm_host.h              | 26 --------------------------
>  virt/kvm/kvm_main.c                   |  2 --
>  7 files changed, 25 insertions(+), 30 deletions(-)
>  rename {virt => arch/x86}/kvm/assigned-dev.c (100%)
>  rename {virt => arch/x86}/kvm/iommu.c (100%)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 76ff3e2..d549cf8 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1112,4 +1112,27 @@ int kvm_pmu_read_pmc(struct kvm_vcpu *vcpu, unsigned pmc, u64 *data);
>  void kvm_handle_pmu_event(struct kvm_vcpu *vcpu);
>  void kvm_deliver_pmi(struct kvm_vcpu *vcpu);
>  
> +#ifdef CONFIG_KVM_DEVICE_ASSIGNMENT
> +int kvm_iommu_map_guest(struct kvm *kvm);
> +int kvm_iommu_unmap_guest(struct kvm *kvm);
> +
> +long kvm_vm_ioctl_assigned_device(struct kvm *kvm, unsigned ioctl,
> +				  unsigned long arg);
> +
> +void kvm_free_all_assigned_devices(struct kvm *kvm);
> +#else
> +static inline int kvm_iommu_unmap_guest(struct kvm *kvm)
> +{
> +	return 0;
> +}
> +
> +static inline long kvm_vm_ioctl_assigned_device(struct kvm *kvm, unsigned ioctl,
> +						unsigned long arg)
> +{
> +	return -ENOTTY;
> +}
> +
> +static inline void kvm_free_all_assigned_devices(struct kvm *kvm) {}
> +#endif
> +
>  #endif /* _ASM_X86_KVM_HOST_H */
> diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
> index ee1cd92..08f790d 100644
> --- a/arch/x86/kvm/Makefile
> +++ b/arch/x86/kvm/Makefile
> @@ -9,11 +9,11 @@ KVM := ../../../virt/kvm
>  
>  kvm-y			+= $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o \
>  				$(KVM)/eventfd.o $(KVM)/irqchip.o $(KVM)/vfio.o
> -kvm-$(CONFIG_KVM_DEVICE_ASSIGNMENT)	+= $(KVM)/assigned-dev.o $(KVM)/iommu.o
>  kvm-$(CONFIG_KVM_ASYNC_PF)	+= $(KVM)/async_pf.o
>  
>  kvm-y			+= x86.o mmu.o emulate.o i8259.o irq.o lapic.o \
>  			   i8254.o ioapic.o irq_comm.o cpuid.o pmu.o
> +kvm-$(CONFIG_KVM_DEVICE_ASSIGNMENT)	+= assigned-dev.o iommu.o
>  kvm-intel-y		+= vmx.o
>  kvm-amd-y		+= svm.o
>  
> diff --git a/virt/kvm/assigned-dev.c b/arch/x86/kvm/assigned-dev.c
> similarity index 100%
> rename from virt/kvm/assigned-dev.c
> rename to arch/x86/kvm/assigned-dev.c
> diff --git a/virt/kvm/iommu.c b/arch/x86/kvm/iommu.c
> similarity index 100%
> rename from virt/kvm/iommu.c
> rename to arch/x86/kvm/iommu.c
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 5337039..782e4ea 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4007,7 +4007,7 @@ long kvm_arch_vm_ioctl(struct file *filp,
>  	}
>  
>  	default:
> -		;
> +		r = kvm_vm_ioctl_assigned_device(kvm, ioctl, arg);
>  	}
>  out:
>  	return r;
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index d2d4270..746e3ef 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -764,8 +764,6 @@ void kvm_free_irq_source_id(struct kvm *kvm, int irq_source_id);
>  #ifdef CONFIG_KVM_DEVICE_ASSIGNMENT
>  int kvm_iommu_map_pages(struct kvm *kvm, struct kvm_memory_slot *slot);
>  void kvm_iommu_unmap_pages(struct kvm *kvm, struct kvm_memory_slot *slot);
> -int kvm_iommu_map_guest(struct kvm *kvm);
> -int kvm_iommu_unmap_guest(struct kvm *kvm);
>  int kvm_assign_device(struct kvm *kvm,
>  		      struct kvm_assigned_dev_kernel *assigned_dev);
>  int kvm_deassign_device(struct kvm *kvm,
> @@ -781,11 +779,6 @@ static inline void kvm_iommu_unmap_pages(struct kvm *kvm,
>  					 struct kvm_memory_slot *slot)
>  {
>  }
> -
> -static inline int kvm_iommu_unmap_guest(struct kvm *kvm)
> -{
> -	return 0;
> -}
>  #endif
>  
>  static inline void kvm_guest_enter(void)
> @@ -1005,25 +998,6 @@ static inline bool kvm_vcpu_compatible(struct kvm_vcpu *vcpu) { return true; }
>  
>  #endif
>  
> -#ifdef CONFIG_KVM_DEVICE_ASSIGNMENT
> -
> -long kvm_vm_ioctl_assigned_device(struct kvm *kvm, unsigned ioctl,
> -				  unsigned long arg);
> -
> -void kvm_free_all_assigned_devices(struct kvm *kvm);
> -
> -#else
> -
> -static inline long kvm_vm_ioctl_assigned_device(struct kvm *kvm, unsigned ioctl,
> -						unsigned long arg)
> -{
> -	return -ENOTTY;
> -}
> -
> -static inline void kvm_free_all_assigned_devices(struct kvm *kvm) {}
> -
> -#endif
> -
>  static inline void kvm_make_request(int req, struct kvm_vcpu *vcpu)
>  {
>  	set_bit(req, &vcpu->requests);
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 3be4342..5b45330 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -2582,8 +2582,6 @@ static long kvm_vm_ioctl(struct file *filp,
>  		break;
>  	default:
>  		r = kvm_arch_vm_ioctl(filp, ioctl, arg);
> -		if (r == -ENOTTY)
> -			r = kvm_vm_ioctl_assigned_device(kvm, ioctl, arg);
>  	}
>  out:
>  	return r;
> 
