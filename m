Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952Ab3D1KNn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Apr 2013 06:13:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17117 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753158Ab3D1KNm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Apr 2013 06:13:42 -0400
Date: Sun, 28 Apr 2013 13:13:39 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: mtosatti@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        agraf@suse.de
Subject: Re: [PATCH] kvm: Allow build-time configuration of KVM device
 assignment
Message-ID: <20130428101339.GF30504@redhat.com>
References: <20130416194605.23183.31789.stgit@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130416194605.23183.31789.stgit@bling.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 16, 2013 at 01:49:18PM -0600, Alex Williamson wrote:
> We hope to at some point deprecate KVM legacy device assignment in
> favor of VFIO-based assignment.  Towards that end, allow legacy
> device assignment to be deconfigured.
> 
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Applied, thanks.

> ---
> 
> This depends on Alex Graf's irqfd generalization series to remove
> IRQ routing code from assigned-dev.c.
> 
>  arch/ia64/include/uapi/asm/kvm.h |    1 -
>  arch/ia64/kvm/Kconfig            |   13 +++++++++++--
>  arch/ia64/kvm/Makefile           |    6 +++---
>  arch/ia64/kvm/kvm-ia64.c         |    2 --
>  arch/x86/include/uapi/asm/kvm.h  |    1 -
>  arch/x86/kvm/Kconfig             |   13 +++++++++++--
>  arch/x86/kvm/Makefile            |    5 +++--
>  arch/x86/kvm/x86.c               |    6 ++++--
>  include/linux/kvm_host.h         |   30 ++++++++----------------------
>  include/uapi/linux/kvm.h         |    4 ----
>  10 files changed, 40 insertions(+), 41 deletions(-)
> 
> diff --git a/arch/ia64/include/uapi/asm/kvm.h b/arch/ia64/include/uapi/asm/kvm.h
> index ec6c6b3..99503c2 100644
> --- a/arch/ia64/include/uapi/asm/kvm.h
> +++ b/arch/ia64/include/uapi/asm/kvm.h
> @@ -27,7 +27,6 @@
>  /* Select x86 specific features in <linux/kvm.h> */
>  #define __KVM_HAVE_IOAPIC
>  #define __KVM_HAVE_IRQ_LINE
> -#define __KVM_HAVE_DEVICE_ASSIGNMENT
>  
>  /* Architectural interrupt line count. */
>  #define KVM_NR_INTERRUPTS 256
> diff --git a/arch/ia64/kvm/Kconfig b/arch/ia64/kvm/Kconfig
> index 2cd225f..e792664 100644
> --- a/arch/ia64/kvm/Kconfig
> +++ b/arch/ia64/kvm/Kconfig
> @@ -21,8 +21,6 @@ config KVM
>  	tristate "Kernel-based Virtual Machine (KVM) support"
>  	depends on BROKEN
>  	depends on HAVE_KVM && MODULES
> -	# for device assignment:
> -	depends on PCI
>  	depends on BROKEN
>  	select PREEMPT_NOTIFIERS
>  	select ANON_INODES
> @@ -50,6 +48,17 @@ config KVM_INTEL
>  	  Provides support for KVM on Itanium 2 processors equipped with the VT
>  	  extensions.
>  
> +config KVM_DEVICE_ASSIGNMENT
> +	bool "KVM legacy PCI device assignment support"
> +	depends on KVM && PCI && IOMMU_API
> +	default y
> +	---help---
> +	  Provide support for legacy PCI device assignment through KVM.  The
> +	  kernel now also supports a full featured userspace device driver
> +	  framework through VFIO, which supersedes much of this support.
> +
> +	  If unsure, say Y.
> +
>  source drivers/vhost/Kconfig
>  
>  endif # VIRTUALIZATION
> diff --git a/arch/ia64/kvm/Makefile b/arch/ia64/kvm/Makefile
> index db3d7c5..1a40537 100644
> --- a/arch/ia64/kvm/Makefile
> +++ b/arch/ia64/kvm/Makefile
> @@ -49,10 +49,10 @@ ccflags-y := -Ivirt/kvm -Iarch/ia64/kvm/
>  asflags-y := -Ivirt/kvm -Iarch/ia64/kvm/
>  
>  common-objs = $(addprefix ../../../virt/kvm/, kvm_main.o ioapic.o \
> -		coalesced_mmio.o irq_comm.o assigned-dev.o)
> +		coalesced_mmio.o irq_comm.o)
>  
> -ifeq ($(CONFIG_IOMMU_API),y)
> -common-objs += $(addprefix ../../../virt/kvm/, iommu.o)
> +ifeq ($(CONFIG_KVM_DEVICE_ASSIGNMENT),y)
> +common-objs += $(addprefix ../../../virt/kvm/, assigned-dev.o iommu.o)
>  endif
>  
>  kvm-objs := $(common-objs) kvm-ia64.o kvm_fw.o
> diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
> index 7a54455..a21c2c5 100644
> --- a/arch/ia64/kvm/kvm-ia64.c
> +++ b/arch/ia64/kvm/kvm-ia64.c
> @@ -1366,9 +1366,7 @@ void kvm_arch_sync_events(struct kvm *kvm)
>  void kvm_arch_destroy_vm(struct kvm *kvm)
>  {
>  	kvm_iommu_unmap_guest(kvm);
> -#ifdef  KVM_CAP_DEVICE_ASSIGNMENT
>  	kvm_free_all_assigned_devices(kvm);
> -#endif
>  	kfree(kvm->arch.vioapic);
>  	kvm_release_vm_pages(kvm);
>  }
> diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
> index 923478e..63e6622 100644
> --- a/arch/x86/include/uapi/asm/kvm.h
> +++ b/arch/x86/include/uapi/asm/kvm.h
> @@ -30,7 +30,6 @@
>  #define __KVM_HAVE_IOAPIC
>  #define __KVM_HAVE_IRQCHIP
>  #define __KVM_HAVE_IRQ_LINE
> -#define __KVM_HAVE_DEVICE_ASSIGNMENT
>  #define __KVM_HAVE_MSI
>  #define __KVM_HAVE_USER_NMI
>  #define __KVM_HAVE_GUEST_DEBUG
> diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
> index 586f000..46e0832 100644
> --- a/arch/x86/kvm/Kconfig
> +++ b/arch/x86/kvm/Kconfig
> @@ -21,8 +21,6 @@ config KVM
>  	tristate "Kernel-based Virtual Machine (KVM) support"
>  	depends on HAVE_KVM
>  	depends on HIGH_RES_TIMERS
> -	# for device assignment:
> -	depends on PCI
>  	# for TASKSTATS/TASK_DELAY_ACCT:
>  	depends on NET
>  	select PREEMPT_NOTIFIERS
> @@ -82,6 +80,17 @@ config KVM_MMU_AUDIT
>  	 This option adds a R/W kVM module parameter 'mmu_audit', which allows
>  	 audit  KVM MMU at runtime.
>  
> +config KVM_DEVICE_ASSIGNMENT
> +	bool "KVM legacy PCI device assignment support"
> +	depends on KVM && PCI && IOMMU_API
> +	default y
> +	---help---
> +	  Provide support for legacy PCI device assignment through KVM.  The
> +	  kernel now also supports a full featured userspace device driver
> +	  framework through VFIO, which supersedes much of this support.
> +
> +	  If unsure, say Y.
> +
>  # OK, it's a little counter-intuitive to do this, but it puts it neatly under
>  # the virtualization menu.
>  source drivers/vhost/Kconfig
> diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
> index a797b8e..d609e1d 100644
> --- a/arch/x86/kvm/Makefile
> +++ b/arch/x86/kvm/Makefile
> @@ -7,8 +7,9 @@ CFLAGS_vmx.o := -I.
>  
>  kvm-y			+= $(addprefix ../../../virt/kvm/, kvm_main.o ioapic.o \
>  				coalesced_mmio.o irq_comm.o eventfd.o \
> -				assigned-dev.o irqchip.o)
> -kvm-$(CONFIG_IOMMU_API)	+= $(addprefix ../../../virt/kvm/, iommu.o)
> +				irqchip.o)
> +kvm-$(CONFIG_KVM_DEVICE_ASSIGNMENT)	+= $(addprefix ../../../virt/kvm/, \
> +				assigned-dev.o iommu.o)
>  kvm-$(CONFIG_KVM_ASYNC_PF)	+= $(addprefix ../../../virt/kvm/, async_pf.o)
>  
>  kvm-y			+= x86.o mmu.o emulate.o i8259.o irq.o lapic.o \
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 9d9904f..86b9217 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -2492,7 +2492,6 @@ int kvm_dev_ioctl_check_extension(long ext)
>  	case KVM_CAP_USER_NMI:
>  	case KVM_CAP_REINJECT_CONTROL:
>  	case KVM_CAP_IRQ_INJECT_STATUS:
> -	case KVM_CAP_ASSIGN_DEV_IRQ:
>  	case KVM_CAP_IRQFD:
>  	case KVM_CAP_IOEVENTFD:
>  	case KVM_CAP_PIT2:
> @@ -2510,9 +2509,12 @@ int kvm_dev_ioctl_check_extension(long ext)
>  	case KVM_CAP_XSAVE:
>  	case KVM_CAP_ASYNC_PF:
>  	case KVM_CAP_GET_TSC_KHZ:
> -	case KVM_CAP_PCI_2_3:
>  	case KVM_CAP_KVMCLOCK_CTRL:
>  	case KVM_CAP_READONLY_MEM:
> +#ifdef CONFIG_KVM_DEVICE_ASSIGNMENT
> +	case KVM_CAP_ASSIGN_DEV_IRQ:
> +	case KVM_CAP_PCI_2_3:
> +#endif
>  		r = 1;
>  		break;
>  	case KVM_CAP_COALESCED_MMIO:
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 8b25ea2..3358428 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -667,7 +667,6 @@ static inline wait_queue_head_t *kvm_arch_vcpu_wq(struct kvm_vcpu *vcpu)
>  
>  int kvm_arch_init_vm(struct kvm *kvm, unsigned long type);
>  void kvm_arch_destroy_vm(struct kvm *kvm);
> -void kvm_free_all_assigned_devices(struct kvm *kvm);
>  void kvm_arch_sync_events(struct kvm *kvm);
>  
>  int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu);
> @@ -736,7 +735,7 @@ void kvm_free_irq_source_id(struct kvm *kvm, int irq_source_id);
>  /* For vcpu->arch.iommu_flags */
>  #define KVM_IOMMU_CACHE_COHERENCY	0x1
>  
> -#ifdef CONFIG_IOMMU_API
> +#ifdef CONFIG_KVM_DEVICE_ASSIGNMENT
>  int kvm_iommu_map_pages(struct kvm *kvm, struct kvm_memory_slot *slot);
>  void kvm_iommu_unmap_pages(struct kvm *kvm, struct kvm_memory_slot *slot);
>  int kvm_iommu_map_guest(struct kvm *kvm);
> @@ -745,7 +744,7 @@ int kvm_assign_device(struct kvm *kvm,
>  		      struct kvm_assigned_dev_kernel *assigned_dev);
>  int kvm_deassign_device(struct kvm *kvm,
>  			struct kvm_assigned_dev_kernel *assigned_dev);
> -#else /* CONFIG_IOMMU_API */
> +#else
>  static inline int kvm_iommu_map_pages(struct kvm *kvm,
>  				      struct kvm_memory_slot *slot)
>  {
> @@ -757,28 +756,11 @@ static inline void kvm_iommu_unmap_pages(struct kvm *kvm,
>  {
>  }
>  
> -static inline int kvm_iommu_map_guest(struct kvm *kvm)
> -{
> -	return -ENODEV;
> -}
> -
>  static inline int kvm_iommu_unmap_guest(struct kvm *kvm)
>  {
>  	return 0;
>  }
> -
> -static inline int kvm_assign_device(struct kvm *kvm,
> -		struct kvm_assigned_dev_kernel *assigned_dev)
> -{
> -	return 0;
> -}
> -
> -static inline int kvm_deassign_device(struct kvm *kvm,
> -		struct kvm_assigned_dev_kernel *assigned_dev)
> -{
> -	return 0;
> -}
> -#endif /* CONFIG_IOMMU_API */
> +#endif
>  
>  static inline void __guest_enter(void)
>  {
> @@ -1032,11 +1014,13 @@ static inline bool kvm_vcpu_compatible(struct kvm_vcpu *vcpu) { return true; }
>  
>  #endif
>  
> -#ifdef __KVM_HAVE_DEVICE_ASSIGNMENT
> +#ifdef CONFIG_KVM_DEVICE_ASSIGNMENT
>  
>  long kvm_vm_ioctl_assigned_device(struct kvm *kvm, unsigned ioctl,
>  				  unsigned long arg);
>  
> +void kvm_free_all_assigned_devices(struct kvm *kvm);
> +
>  #else
>  
>  static inline long kvm_vm_ioctl_assigned_device(struct kvm *kvm, unsigned ioctl,
> @@ -1045,6 +1029,8 @@ static inline long kvm_vm_ioctl_assigned_device(struct kvm *kvm, unsigned ioctl,
>  	return -ENOTTY;
>  }
>  
> +static inline void kvm_free_all_assigned_devices(struct kvm *kvm) {}
> +
>  #endif
>  
>  static inline void kvm_make_request(int req, struct kvm_vcpu *vcpu)
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index c38d269..d647b56 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -561,9 +561,7 @@ struct kvm_ppc_smmu_info {
>  #define KVM_CAP_MP_STATE 14
>  #define KVM_CAP_COALESCED_MMIO 15
>  #define KVM_CAP_SYNC_MMU 16  /* Changes to host mmap are reflected in guest */
> -#ifdef __KVM_HAVE_DEVICE_ASSIGNMENT
>  #define KVM_CAP_DEVICE_ASSIGNMENT 17
> -#endif
>  #define KVM_CAP_IOMMU 18
>  #ifdef __KVM_HAVE_MSI
>  #define KVM_CAP_DEVICE_MSI 20
> @@ -583,9 +581,7 @@ struct kvm_ppc_smmu_info {
>  #define KVM_CAP_IRQ_ROUTING 25
>  #endif
>  #define KVM_CAP_IRQ_INJECT_STATUS 26
> -#ifdef __KVM_HAVE_DEVICE_ASSIGNMENT
>  #define KVM_CAP_DEVICE_DEASSIGNMENT 27
> -#endif
>  #ifdef __KVM_HAVE_MSIX
>  #define KVM_CAP_DEVICE_MSIX 28
>  #endif

--
			Gleb.
