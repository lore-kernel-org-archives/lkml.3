Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482Ab3HYLxU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 07:53:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45248 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756240Ab3HYLxM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 07:53:12 -0400
Date: Sun, 25 Aug 2013 14:39:53 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
Subject: Re: [PATCH v2] tile: support KVM for tilegx
Message-ID: <20130825113953.GN8218@redhat.com>
References: <52091682.8020004@siemens.com>
 <201308122037.r7CKbo99011833@farm-0021.internal.tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201308122037.r7CKbo99011833@farm-0021.internal.tilera.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 12, 2013 at 04:24:11PM -0400, Chris Metcalf wrote:
> This change provides the initial framework support for KVM on tilegx.
> Basic virtual disk and networking is supported.
> 
This needs to be broken down to more reviewable patches. Also can you
describe the implementation a little bit? Does tile arch has vitalization
extension this implementation uses, or is it trap and emulate approach?
If later does it run unmodified guest kernels? What userspace are you
using with this implementation?

> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
> ---
> v2: remove KVM_TILE_RESET_SPR based on feedback from Jan Kiszka.
> qemu ends up modified to just use KVM_SET_SREGS instead.
> 
>  arch/tile/Kconfig                        |   19 +-
>  arch/tile/Makefile                       |    1 +
>  arch/tile/include/asm/io.h               |    2 +
>  arch/tile/include/asm/kvm.h              |   29 +
>  arch/tile/include/asm/kvm_host.h         |  101 ++
>  arch/tile/include/asm/kvm_para.h         |   20 +
>  arch/tile/include/asm/kvm_virtio.h       |   26 +
>  arch/tile/include/asm/module.h           |    9 +-
>  arch/tile/include/asm/page.h             |   56 +-
>  arch/tile/include/asm/pgtable_32.h       |    2 +-
>  arch/tile/include/asm/pgtable_64.h       |    3 +-
>  arch/tile/include/asm/processor.h        |    6 +-
>  arch/tile/include/asm/ptrace.h           |    2 +-
>  arch/tile/include/asm/switch_to.h        |   25 +-
>  arch/tile/include/asm/thread_info.h      |   17 +-
>  arch/tile/include/asm/timex.h            |    8 +
>  arch/tile/include/hv/hypervisor.h        |  183 +++-
>  arch/tile/include/uapi/arch/sim.h        |   19 +
>  arch/tile/include/uapi/arch/sim_def.h    |    8 +
>  arch/tile/include/uapi/arch/spr_def_32.h |   15 +
>  arch/tile/include/uapi/arch/spr_def_64.h |   25 +
>  arch/tile/include/uapi/asm/Kbuild        |    2 +
>  arch/tile/include/uapi/asm/kvm.h         |  267 +++++
>  arch/tile/include/uapi/asm/kvm_virtio.h  |   60 ++
>  arch/tile/kernel/Makefile                |    1 +
>  arch/tile/kernel/asm-offsets.c           |    7 +
>  arch/tile/kernel/early_printk.c          |   16 +
>  arch/tile/kernel/head_32.S               |    4 +-
>  arch/tile/kernel/head_64.S               |    6 +-
>  arch/tile/kernel/hvglue.S                |    8 +-
>  arch/tile/kernel/hvglue_trace.c          |   14 +
>  arch/tile/kernel/intvec_32.S             |   18 +-
>  arch/tile/kernel/intvec_64.S             |  226 +++--
>  arch/tile/kernel/kvm_virtio.c            |  430 ++++++++
>  arch/tile/kernel/process.c               |   40 +-
>  arch/tile/kernel/relocate_kernel_64.S    |    9 +-
>  arch/tile/kernel/setup.c                 |   21 +-
>  arch/tile/kernel/smp.c                   |   28 +-
>  arch/tile/kernel/stack.c                 |    2 +-
>  arch/tile/kernel/sysfs.c                 |    4 +
>  arch/tile/kernel/time.c                  |   14 +-
>  arch/tile/kernel/traps.c                 |    2 +-
>  arch/tile/kernel/vmlinux.lds.S           |   10 +-
>  arch/tile/kvm/Kconfig                    |    3 -
>  arch/tile/kvm/Makefile                   |   12 +
>  arch/tile/kvm/entry.S                    |   91 ++
>  arch/tile/kvm/kvm-tile.c                 | 1581 ++++++++++++++++++++++++++++++
>  arch/tile/lib/exports.c                  |   20 +-
>  arch/tile/mm/elf.c                       |    2 +
>  arch/tile/mm/fault.c                     |    4 +-
>  arch/tile/mm/init.c                      |    8 +-
>  arch/tile/mm/pgtable.c                   |   35 +-
>  include/uapi/linux/kvm.h                 |    1 +
>  virt/kvm/kvm_main.c                      |    7 +-
>  54 files changed, 3331 insertions(+), 198 deletions(-)
>  create mode 100644 arch/tile/include/asm/kvm.h
>  create mode 100644 arch/tile/include/asm/kvm_host.h
>  create mode 100644 arch/tile/include/asm/kvm_para.h
>  create mode 100644 arch/tile/include/asm/kvm_virtio.h
>  create mode 100644 arch/tile/include/uapi/asm/kvm.h
>  create mode 100644 arch/tile/include/uapi/asm/kvm_virtio.h
>  create mode 100644 arch/tile/kernel/kvm_virtio.c
>  create mode 100644 arch/tile/kvm/Makefile
>  create mode 100644 arch/tile/kvm/entry.S
>  create mode 100644 arch/tile/kvm/kvm-tile.c
> 
> diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
> index ecff467..bbb6d51 100644
> --- a/arch/tile/Kconfig
> +++ b/arch/tile/Kconfig
> @@ -5,7 +5,6 @@ config TILE
>  	def_bool y
>  	select HAVE_DMA_ATTRS
>  	select HAVE_DMA_API_DEBUG
> -	select HAVE_KVM if !TILEGX
>  	select GENERIC_FIND_FIRST_BIT
>  	select SYSCTL_EXCEPTION_TRACE
>  	select USE_GENERIC_SMP_HELPERS
> @@ -113,6 +112,7 @@ config SMP
>  	def_bool y
>  
>  config HVC_TILE
> +	depends on !KVM_GUEST
>  	depends on TTY
>  	select HVC_DRIVER
>  	select HVC_IRQ if TILEGX
> @@ -127,6 +127,7 @@ config TILEGX
>  	select HAVE_FTRACE_MCOUNT_RECORD
>  	select HAVE_KPROBES
>  	select HAVE_KRETPROBES
> +	select HAVE_KVM if !KVM_GUEST
>  
>  config TILEPRO
>  	def_bool !TILEGX
> @@ -366,11 +367,23 @@ config HARDWALL
>  	bool "Hardwall support to allow access to user dynamic network"
>  	default y
>  
> +config KVM_GUEST
> +	bool "Build kernel as guest for KVM"
> +	default n
> +	depends on TILEGX
> +	select VIRTIO
> +	select VIRTIO_RING
> +	select VIRTIO_CONSOLE
> +	---help---
> +	  This will build a kernel that runs at a lower protection level
> +	  than the default kernel and is suitable to run under KVM.
> +
> +# TILEPro kernels run at PL1; TILE-Gx runs at PL2 unless it's a KVM guest.
>  config KERNEL_PL
>  	int "Processor protection level for kernel"
>  	range 1 2
> -	default 2 if TILEGX
> -	default 1 if !TILEGX
> +	default 2 if TILEGX && !KVM_GUEST
> +	default 1 if !TILEGX || KVM_GUEST
>  	---help---
>  	  Since MDE 4.2, the Tilera hypervisor runs the kernel
>  	  at PL2 by default.  If running under an older hypervisor,
> diff --git a/arch/tile/Makefile b/arch/tile/Makefile
> index 3d15364..8e7f852 100644
> --- a/arch/tile/Makefile
> +++ b/arch/tile/Makefile
> @@ -62,6 +62,7 @@ libs-y		+= $(LIBGCC_PATH)
>  
>  # See arch/tile/Kbuild for content of core part of the kernel
>  core-y		+= arch/tile/
> +core-$(CONFIG_KVM) += arch/tile/kvm/
>  
>  core-$(CONFIG_TILE_GXIO) += arch/tile/gxio/
>  
> diff --git a/arch/tile/include/asm/io.h b/arch/tile/include/asm/io.h
> index 9fe4349..023659b 100644
> --- a/arch/tile/include/asm/io.h
> +++ b/arch/tile/include/asm/io.h
> @@ -43,6 +43,8 @@
>   * long before casting it to a pointer to avoid compiler warnings.
>   */
>  #if CHIP_HAS_MMIO()
> +extern void *generic_remap_prot(resource_size_t phys_addr, unsigned long size,
> +	unsigned long flags, pgprot_t prot);
>  extern void __iomem *ioremap(resource_size_t offset, unsigned long size);
>  extern void __iomem *ioremap_prot(resource_size_t offset, unsigned long size,
>  	pgprot_t pgprot);
> diff --git a/arch/tile/include/asm/kvm.h b/arch/tile/include/asm/kvm.h
> new file mode 100644
> index 0000000..2ea6c41
> --- /dev/null
> +++ b/arch/tile/include/asm/kvm.h
> @@ -0,0 +1,29 @@
> +/*
> + * Copyright 2013 Tilera Corporation. All Rights Reserved.
> + *
> + *   This program is free software; you can redistribute it and/or
> + *   modify it under the terms of the GNU General Public License
> + *   as published by the Free Software Foundation, version 2.
> + *
> + *   This program is distributed in the hope that it will be useful, but
> + *   WITHOUT ANY WARRANTY; without even the implied warranty of
> + *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
> + *   NON INFRINGEMENT.  See the GNU General Public License for
> + *   more details.
> + */
> +#ifndef _ASM_TILE_KVM_H
> +#define _ASM_TILE_KVM_H
> +
> +#include <hv/hypervisor.h>
> +#include <uapi/asm/kvm.h>
> +
> +#ifndef __ASSEMBLER__
> +/* For hv_*() */
> +#define KVM_EMULATE(name) [HV_SYS_##name] = kvm_emulate_hv_##name,
> +#define USER_EMULATE(name) [HV_SYS_##name] = kvm_deliver_to_user,
> +#define NO_EMULATE(name) [HV_SYS_##name] = kvm_emulate_illegal,
> +#define BOTH_EMULATE(name) [HV_SYS_##name] = kvm_emulate_hv_##name,
> +/* For others */
> +#define USER_HCALL(name) [KVM_HCALL_##name] = kvm_deliver_to_user,
> +#endif
> +#endif /* _ASM_TILE_KVM_H */
> diff --git a/arch/tile/include/asm/kvm_host.h b/arch/tile/include/asm/kvm_host.h
> new file mode 100644
> index 0000000..58b6bf3
> --- /dev/null
> +++ b/arch/tile/include/asm/kvm_host.h
> @@ -0,0 +1,101 @@
> +/*
> + * Copyright 2013 Tilera Corporation. All Rights Reserved.
> + *
> + *   This program is free software; you can redistribute it and/or
> + *   modify it under the terms of the GNU General Public License
> + *   as published by the Free Software Foundation, version 2.
> + *
> + *   This program is distributed in the hope that it will be useful, but
> + *   WITHOUT ANY WARRANTY; without even the implied warranty of
> + *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
> + *   NON INFRINGEMENT.  See the GNU General Public License for
> + *   more details.
> + */
> +
> +#ifndef _ASM_TILE_KVM_HOST_H
> +#define _ASM_TILE_KVM_HOST_H
> +
> +#define KVM_MAX_VCPUS 64
> +#define KVM_USER_MEM_SLOTS 32
> +#define KVM_PRIVATE_MEM_SLOTS 4
> +
> +/* For now, claim we have no huge pages. */
> +#define KVM_HPAGE_GFN_SHIFT(x)  0
> +#define KVM_NR_PAGE_SIZES       1
> +#define KVM_PAGES_PER_HPAGE(x)  1
> +
> +/* Max number of message tags for hv_send/receive_message() */
> +#define MAX_MSG_TAG	(sizeof(unsigned long) * 8)
> +
> +/* Bits in pending_downcalls */
> +#define DOWNCALL_MESSAGE_RCV     0x01  /**< Message receive */
> +
> +#ifndef __ASSEMBLY__
> +
> +#include <linux/types.h>
> +#include <linux/ptrace.h>
> +
> +struct kvm_vcpu_stat {
> +	/* None yet. */
> +};
> +
> +struct kvm_vcpu_arch {
> +	struct pt_regs regs;
> +	struct kvm_sregs sregs;
> +	unsigned long host_sp; /* Host "real" sp during vmresume. */
> +	HV_Context guest_context;
> +	unsigned long pending_msgs; /* Pending guest messages */
> +	unsigned long ipi_events; /* Pending guest ipi events. */
> +	unsigned long ipi_gpa; /* pa for hv_get_ipi_pte() */
> +	pte_t ipi_gpte; /* pte for hv_get_ipi_pte() */
> +	unsigned long fault_addr;  /* addr for VPGTABLE_MISS faults */
> +	int suspended;  /* true for cores not yet started by host */
> +	unsigned long timer_control;  /* AUX_TILE_TIMER_CONTROL value */
> +	unsigned long vmexit_cycles;  /* cycle count of last vmexit */
> +};
> +
> +struct kvm_vm_stat {
> +	/*
> +	 * FIXME - does this make sense for us?  It's used in common KVM
> +	 * code.
> +	 */
> +	u32 remote_tlb_flush;
> +};
> +
> +struct kvm_arch_memory_slot {
> +};
> +
> +struct kvm_arch {
> +	pgd_t *vpgd;
> +	unsigned long resv_gpa_start; /* For special purpose. */
> +	struct completion smp_start;
> +};
> +
> +struct kvm_vcpu;
> +
> +extern void kvm_vmresume(struct pt_regs *guest,
> +			 unsigned long *host_sp_ptr);
> +extern void kvm_vmexit(unsigned long host_sp);
> +extern void kvm_trigger_vmexit(struct pt_regs *regs, int exit_reason);
> +extern void kvm_do_hypervisor_call(struct pt_regs *regs, int fault_num);
> +extern void kvm_do_vpgtable_miss(struct pt_regs *regs, int fault_num,
> +				 unsigned long, unsigned long);
> +extern void kvm_do_vguest_fatal(struct pt_regs *regs, int fault_num);
> +
> +extern void kvm_vcpu_kick(struct kvm_vcpu *vcpu);
> +
> +#define gpud_offset(kvm, pgd, address) pud_offset(pgd, address)
> +
> +#define gpud_page_vaddr(kvm, pud) gfn_to_hva(kvm, pud_pfn(pud))
> +
> +#define gpmd_offset(kvm, pud, address) \
> +	((pmd_t *)gpud_page_vaddr(kvm, *(pud)) + pmd_index(address))
> +
> +#define gpmd_page_vaddr(kvm, pmd) gfn_to_hva(kvm, pmd_pfn(pmd))
> +
> +#define gpte_offset_kernel(kvm, pmd, address) \
> +	((pte_t *) gpmd_page_vaddr(kvm, *(pmd)) + pte_index(address))
> +
> +#endif /* __ASSEMBLY__*/
> +
> +#endif /* _ASM_TILE_KVM_HOST_H */
> diff --git a/arch/tile/include/asm/kvm_para.h b/arch/tile/include/asm/kvm_para.h
> new file mode 100644
> index 0000000..c8c31d5
> --- /dev/null
> +++ b/arch/tile/include/asm/kvm_para.h
> @@ -0,0 +1,20 @@
> +/*
> + * Copyright 2013 Tilera Corporation. All Rights Reserved.
> + *
> + *   This program is free software; you can redistribute it and/or
> + *   modify it under the terms of the GNU General Public License
> + *   as published by the Free Software Foundation, version 2.
> + *
> + *   This program is distributed in the hope that it will be useful, but
> + *   WITHOUT ANY WARRANTY; without even the implied warranty of
> + *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
> + *   NON INFRINGEMENT.  See the GNU General Public License for
> + *   more details.
> + */
> +#ifndef _ASM_TILE_KVM_PARA_H
> +#define _ASM_TILE_KVM_PARA_H
> +
> +#include <uapi/asm/kvm_para.h>
> +
> +int hcall_virtio(unsigned long instrument, unsigned long mem);
> +#endif /* _ASM_TILE_KVM_PARA_H */
> diff --git a/arch/tile/include/asm/kvm_virtio.h b/arch/tile/include/asm/kvm_virtio.h
> new file mode 100644
> index 0000000..8faa959
> --- /dev/null
> +++ b/arch/tile/include/asm/kvm_virtio.h
> @@ -0,0 +1,26 @@
> +/*
> + * Copyright 2013 Tilera Corporation. All Rights Reserved.
> + *
> + *   This program is free software; you can redistribute it and/or
> + *   modify it under the terms of the GNU General Public License
> + *   as published by the Free Software Foundation, version 2.
> + *
> + *   This program is distributed in the hope that it will be useful, but
> + *   WITHOUT ANY WARRANTY; without even the implied warranty of
> + *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
> + *   NON INFRINGEMENT.  See the GNU General Public License for
> + *   more details.
> + */
> +#ifndef _ASM_TILE_KVM_VIRTIO_H
> +#define _ASM_TILE_KVM_VIRTIO_H
> +
> +#include <uapi/asm/kvm_virtio.h>
> +
> +
> +struct kvm_device {
> +	struct virtio_device vdev;
> +	struct kvm_device_desc *desc;
> +	unsigned long desc_pa;
> +};
> +
> +#endif /* _ASM_TILE_KVM_VIRTIO_H */
> diff --git a/arch/tile/include/asm/module.h b/arch/tile/include/asm/module.h
> index 44ed07c..927c97f 100644
> --- a/arch/tile/include/asm/module.h
> +++ b/arch/tile/include/asm/module.h
> @@ -28,6 +28,13 @@
>  # define MODULE_PGSZ ""
>  #endif
>  
> +/* Tag guest Linux, since it uses different SPRs, etc. */
> +#if CONFIG_KERNEL_PL == 2
> +#define MODULE_PL ""
> +#else
> +#define MODULE_PL " guest"
> +#endif
> +
>  /* We don't really support no-SMP so tag if someone tries. */
>  #ifdef CONFIG_SMP
>  #define MODULE_NOSMP ""
> @@ -35,6 +42,6 @@
>  #define MODULE_NOSMP " nosmp"
>  #endif
>  
> -#define MODULE_ARCH_VERMAGIC CHIP_ARCH_NAME MODULE_PGSZ MODULE_NOSMP
> +#define MODULE_ARCH_VERMAGIC CHIP_ARCH_NAME MODULE_PGSZ MODULE_PL MODULE_NOSMP
>  
>  #endif /* _ASM_TILE_MODULE_H */
> diff --git a/arch/tile/include/asm/page.h b/arch/tile/include/asm/page.h
> index b4f96c0..65ee752 100644
> --- a/arch/tile/include/asm/page.h
> +++ b/arch/tile/include/asm/page.h
> @@ -148,8 +148,17 @@ static inline __attribute_const__ int get_order(unsigned long size)
>  #define HAVE_ARCH_HUGETLB_UNMAPPED_AREA
>  #endif
>  
> +#ifdef CONFIG_KVM_GUEST
> +/* Paravirtualized guests get half the VA, and thus half the PA. */
> +#define MAX_PA_WIDTH (CHIP_PA_WIDTH() - 1)
> +#define MAX_VA_WIDTH (CHIP_VA_WIDTH() - 1)
> +#else
> +#define MAX_PA_WIDTH CHIP_PA_WIDTH()
> +#define MAX_VA_WIDTH CHIP_VA_WIDTH()
> +#endif
> +
>  /* Each memory controller has PAs distinct in their high bits. */
> -#define NR_PA_HIGHBIT_SHIFT (CHIP_PA_WIDTH() - CHIP_LOG_NUM_MSHIMS())
> +#define NR_PA_HIGHBIT_SHIFT (MAX_PA_WIDTH - CHIP_LOG_NUM_MSHIMS())
>  #define NR_PA_HIGHBIT_VALUES (1 << CHIP_LOG_NUM_MSHIMS())
>  #define __pa_to_highbits(pa) ((phys_addr_t)(pa) >> NR_PA_HIGHBIT_SHIFT)
>  #define __pfn_to_highbits(pfn) ((pfn) >> (NR_PA_HIGHBIT_SHIFT - PAGE_SHIFT))
> @@ -160,7 +169,7 @@ static inline __attribute_const__ int get_order(unsigned long size)
>   * We reserve the lower half of memory for user-space programs, and the
>   * upper half for system code.  We re-map all of physical memory in the
>   * upper half, which takes a quarter of our VA space.  Then we have
> - * the vmalloc regions.  The supervisor code lives at 0xfffffff700000000,
> + * the vmalloc regions.  The supervisor code lives at the highest address,
>   * with the hypervisor above that.
>   *
>   * Loadable kernel modules are placed immediately after the static
> @@ -172,26 +181,25 @@ static inline __attribute_const__ int get_order(unsigned long size)
>   * Similarly, for now we don't play any struct page mapping games.
>   */
>  
> -#if CHIP_PA_WIDTH() + 2 > CHIP_VA_WIDTH()
> +#if MAX_PA_WIDTH + 2 > MAX_VA_WIDTH
>  # error Too much PA to map with the VA available!
>  #endif
> -#define HALF_VA_SPACE           (_AC(1, UL) << (CHIP_VA_WIDTH() - 1))
>  
> -#define MEM_LOW_END		(HALF_VA_SPACE - 1)         /* low half */
> -#define MEM_HIGH_START		(-HALF_VA_SPACE)            /* high half */
> -#define PAGE_OFFSET		MEM_HIGH_START
> -#define FIXADDR_BASE		_AC(0xfffffff400000000, UL) /* 4 GB */
> -#define FIXADDR_TOP		_AC(0xfffffff500000000, UL) /* 4 GB */
> +#ifdef CONFIG_KVM_GUEST
> +#define PAGE_OFFSET		(_AC(1, UL) << (MAX_VA_WIDTH - 1))
> +#define KERNEL_HIGH_VADDR	(_AC(1, UL) << MAX_VA_WIDTH)
> +#else
> +#define PAGE_OFFSET		(-(_AC(1, UL) << (MAX_VA_WIDTH - 1)))
> +#define KERNEL_HIGH_VADDR	_AC(0xfffffff800000000, UL)  /* high 32GB */
> +#endif
> +
> +#define FIXADDR_BASE		(KERNEL_HIGH_VADDR - 0x400000000) /* 4 GB */
> +#define FIXADDR_TOP		(KERNEL_HIGH_VADDR - 0x300000000) /* 4 GB */
>  #define _VMALLOC_START		FIXADDR_TOP
> -#define HUGE_VMAP_BASE		_AC(0xfffffff600000000, UL) /* 4 GB */
> -#define MEM_SV_START		_AC(0xfffffff700000000, UL) /* 256 MB */
> -#define MEM_SV_INTRPT		MEM_SV_START
> -#define MEM_MODULE_START	_AC(0xfffffff710000000, UL) /* 256 MB */
> +#define HUGE_VMAP_BASE		(KERNEL_HIGH_VADDR - 0x200000000) /* 4 GB */
> +#define MEM_SV_START		(KERNEL_HIGH_VADDR - 0x100000000) /* 256 MB */
> +#define MEM_MODULE_START	(MEM_SV_START + (256*1024*1024)) /* 256 MB */
>  #define MEM_MODULE_END		(MEM_MODULE_START + (256*1024*1024))
> -#define MEM_HV_START		_AC(0xfffffff800000000, UL) /* 32 GB */
> -
> -/* Highest DTLB address we will use */
> -#define KERNEL_HIGH_VADDR	MEM_SV_START
>  
>  #else /* !__tilegx__ */
>  
> @@ -213,8 +221,8 @@ static inline __attribute_const__ int get_order(unsigned long size)
>   * values, and after that, we show "typical" values, since the actual
>   * addresses depend on kernel #defines.
>   *
> - * MEM_HV_INTRPT                   0xfe000000
> - * MEM_SV_INTRPT (kernel code)     0xfd000000
> + * MEM_HV_START                    0xfe000000
> + * MEM_SV_START  (kernel code)     0xfd000000
>   * MEM_USER_INTRPT (user vector)   0xfc000000
>   * FIX_KMAP_xxx                    0xf8000000 (via NR_CPUS * KM_TYPE_NR)
>   * PKMAP_BASE                      0xf7000000 (via LAST_PKMAP)
> @@ -224,14 +232,8 @@ static inline __attribute_const__ int get_order(unsigned long size)
>   */
>  
>  #define MEM_USER_INTRPT		_AC(0xfc000000, UL)
> -#if CONFIG_KERNEL_PL == 1
> -#define MEM_SV_INTRPT		_AC(0xfd000000, UL)
> -#define MEM_HV_INTRPT		_AC(0xfe000000, UL)
> -#else
> -#define MEM_GUEST_INTRPT	_AC(0xfd000000, UL)
> -#define MEM_SV_INTRPT		_AC(0xfe000000, UL)
> -#define MEM_HV_INTRPT		_AC(0xff000000, UL)
> -#endif
> +#define MEM_SV_START		_AC(0xfd000000, UL)
> +#define MEM_HV_START		_AC(0xfe000000, UL)
>  
>  #define INTRPT_SIZE		0x4000
>  
> diff --git a/arch/tile/include/asm/pgtable_32.h b/arch/tile/include/asm/pgtable_32.h
> index e5bdc0e..63142ab 100644
> --- a/arch/tile/include/asm/pgtable_32.h
> +++ b/arch/tile/include/asm/pgtable_32.h
> @@ -89,7 +89,7 @@ static inline int pud_huge_page(pud_t pud)	{ return 0; }
>  /* We don't define any pgds for these addresses. */
>  static inline int pgd_addr_invalid(unsigned long addr)
>  {
> -	return addr >= MEM_HV_INTRPT;
> +	return addr >= MEM_HV_START;
>  }
>  
>  /*
> diff --git a/arch/tile/include/asm/pgtable_64.h b/arch/tile/include/asm/pgtable_64.h
> index 7cb8d35..3421177 100644
> --- a/arch/tile/include/asm/pgtable_64.h
> +++ b/arch/tile/include/asm/pgtable_64.h
> @@ -140,8 +140,7 @@ static inline unsigned long pgd_addr_normalize(unsigned long addr)
>  /* We don't define any pgds for these addresses. */
>  static inline int pgd_addr_invalid(unsigned long addr)
>  {
> -	return addr >= MEM_HV_START ||
> -		(addr > MEM_LOW_END && addr < MEM_HIGH_START);
> +	return addr >= KERNEL_HIGH_VADDR || addr != pgd_addr_normalize(addr);
>  }
>  
>  /*
> diff --git a/arch/tile/include/asm/processor.h b/arch/tile/include/asm/processor.h
> index 230b830..5aa5431 100644
> --- a/arch/tile/include/asm/processor.h
> +++ b/arch/tile/include/asm/processor.h
> @@ -15,6 +15,8 @@
>  #ifndef _ASM_TILE_PROCESSOR_H
>  #define _ASM_TILE_PROCESSOR_H
>  
> +#include <arch/chip.h>
> +
>  #ifndef __ASSEMBLY__
>  
>  /*
> @@ -25,7 +27,6 @@
>  #include <asm/ptrace.h>
>  #include <asm/percpu.h>
>  
> -#include <arch/chip.h>
>  #include <arch/spr_def.h>
>  
>  struct task_struct;
> @@ -167,7 +168,7 @@ struct thread_struct {
>  #ifndef __ASSEMBLY__
>  
>  #ifdef __tilegx__
> -#define TASK_SIZE_MAX		(MEM_LOW_END + 1)
> +#define TASK_SIZE_MAX		(_AC(1, UL) << (MAX_VA_WIDTH - 1))
>  #else
>  #define TASK_SIZE_MAX		PAGE_OFFSET
>  #endif
> @@ -347,7 +348,6 @@ extern int kdata_huge;
>  
>  /*
>   * Provide symbolic constants for PLs.
> - * Note that assembly code assumes that USER_PL is zero.
>   */
>  #define USER_PL 0
>  #if CONFIG_KERNEL_PL == 2
> diff --git a/arch/tile/include/asm/ptrace.h b/arch/tile/include/asm/ptrace.h
> index 0d25c21..b9620c0 100644
> --- a/arch/tile/include/asm/ptrace.h
> +++ b/arch/tile/include/asm/ptrace.h
> @@ -39,7 +39,7 @@ typedef unsigned long pt_reg_t;
>  #define user_stack_pointer(regs) ((regs)->sp)
>  
>  /* Does the process account for user or for system time? */
> -#define user_mode(regs) (EX1_PL((regs)->ex1) == USER_PL)
> +#define user_mode(regs) (EX1_PL((regs)->ex1) < KERNEL_PL)
>  
>  /* Fill in a struct pt_regs with the current kernel registers. */
>  struct pt_regs *get_pt_regs(struct pt_regs *);
> diff --git a/arch/tile/include/asm/switch_to.h b/arch/tile/include/asm/switch_to.h
> index b8f888c..8e9150f 100644
> --- a/arch/tile/include/asm/switch_to.h
> +++ b/arch/tile/include/asm/switch_to.h
> @@ -50,16 +50,31 @@ extern struct task_struct *__switch_to(struct task_struct *prev,
>  extern unsigned long get_switch_to_pc(void);
>  
>  /*
> + * Normally we notify the simulator whenever we change from one pid
> + * to another, so it can track symbol files appropriately on the fly.
> + * For now, we don't do this for the guest Linux, since we don't
> + * have a way to tell the simulator that we are entering a separate
> + * pid space when we are in the guest.
> + */
> +#ifdef CONFIG_KVM_GUEST
> +#define notify_sim_task_change(prev) do { } while (0)
> +#else
> +#define notify_sim_task_change(prev) do {				\
> +	if (unlikely((prev)->state == TASK_DEAD))			\
> +		__insn_mtspr(SPR_SIM_CONTROL, SIM_CONTROL_OS_EXIT |	\
> +			     ((prev)->pid << _SIM_CONTROL_OPERATOR_BITS)); \
> +	__insn_mtspr(SPR_SIM_CONTROL, SIM_CONTROL_OS_SWITCH |		\
> +		     (current->pid << _SIM_CONTROL_OPERATOR_BITS));	\
> +} while (0)
> +#endif
> +
> +/*
>   * Kernel threads can check to see if they need to migrate their
>   * stack whenever they return from a context switch; for user
>   * threads, we defer until they are returning to user-space.
>   */
>  #define finish_arch_switch(prev) do {                                     \
> -	if (unlikely((prev)->state == TASK_DEAD))                         \
> -		__insn_mtspr(SPR_SIM_CONTROL, SIM_CONTROL_OS_EXIT |       \
> -			((prev)->pid << _SIM_CONTROL_OPERATOR_BITS));     \
> -	__insn_mtspr(SPR_SIM_CONTROL, SIM_CONTROL_OS_SWITCH |             \
> -		(current->pid << _SIM_CONTROL_OPERATOR_BITS));            \
> +	notify_sim_task_change(prev);                                     \
>  	if (current->mm == NULL && !kstack_hash &&                        \
>  	    current_thread_info()->homecache_cpu != smp_processor_id())   \
>  		homecache_migrate_kthread();                              \
> diff --git a/arch/tile/include/asm/thread_info.h b/arch/tile/include/asm/thread_info.h
> index b8aa6df..1c26cdf 100644
> --- a/arch/tile/include/asm/thread_info.h
> +++ b/arch/tile/include/asm/thread_info.h
> @@ -18,7 +18,9 @@
>  
>  #include <asm/processor.h>
>  #include <asm/page.h>
> +
>  #ifndef __ASSEMBLY__
> +struct kvm_vcpu;
>  
>  /*
>   * Low level task data that assembly code needs immediate access to.
> @@ -44,6 +46,9 @@ struct thread_info {
>  	unsigned long		unalign_jit_tmp[4]; /* temp r0..r3 storage */
>  	void __user		*unalign_jit_base; /* unalign fixup JIT base */
>  #endif
> +#ifdef CONFIG_KVM
> +	struct kvm_vcpu		*vcpu;		/* vcpu during vmresume */
> +#endif
>  };
>  
>  /*
> @@ -117,8 +122,8 @@ extern void _cpu_idle(void);
>  
>  /*
>   * Thread information flags that various assembly files may need to access.
> - * Keep flags accessed frequently in low bits, particular since it makes
> - * it easier to build constants in assembly.
> + * Keep flags accessed frequently in low bits, since it makes it
> + * easier to build constants in assembly.
>   */
>  #define TIF_SIGPENDING		0	/* signal pending */
>  #define TIF_NEED_RESCHED	1	/* rescheduling necessary */
> @@ -131,6 +136,7 @@ extern void _cpu_idle(void);
>  #define TIF_MEMDIE		7	/* OOM killer at work */
>  #define TIF_NOTIFY_RESUME	8	/* callback before returning to user */
>  #define TIF_SYSCALL_TRACEPOINT	9	/* syscall tracepoint instrumentation */
> +#define TIF_VIRT_EXIT		10	/* force exit of task in vmresume */
>  
>  #define _TIF_SIGPENDING		(1<<TIF_SIGPENDING)
>  #define _TIF_NEED_RESCHED	(1<<TIF_NEED_RESCHED)
> @@ -142,11 +148,12 @@ extern void _cpu_idle(void);
>  #define _TIF_MEMDIE		(1<<TIF_MEMDIE)
>  #define _TIF_NOTIFY_RESUME	(1<<TIF_NOTIFY_RESUME)
>  #define _TIF_SYSCALL_TRACEPOINT	(1<<TIF_SYSCALL_TRACEPOINT)
> +#define _TIF_VIRT_EXIT		(1<<TIF_VIRT_EXIT)
>  
>  /* Work to do on any return to user space. */
> -#define _TIF_ALLWORK_MASK \
> -  (_TIF_SIGPENDING|_TIF_NEED_RESCHED|_TIF_SINGLESTEP|\
> -   _TIF_ASYNC_TLB|_TIF_NOTIFY_RESUME)
> +#define _TIF_ALLWORK_MASK					\
> +	(_TIF_SIGPENDING|_TIF_NEED_RESCHED|_TIF_SINGLESTEP|	\
> +	 _TIF_ASYNC_TLB|_TIF_NOTIFY_RESUME|_TIF_VIRT_EXIT)
>  
>  /* Work to do at syscall entry. */
>  #define _TIF_SYSCALL_ENTRY_WORK (_TIF_SYSCALL_TRACE | _TIF_SYSCALL_TRACEPOINT)
> diff --git a/arch/tile/include/asm/timex.h b/arch/tile/include/asm/timex.h
> index edbd7e4..0417617 100644
> --- a/arch/tile/include/asm/timex.h
> +++ b/arch/tile/include/asm/timex.h
> @@ -27,6 +27,14 @@
>  
>  typedef unsigned long long cycles_t;
>  
> +#ifdef CONFIG_KVM_GUEST
> +#define INT_LINUX_TIMER INT_AUX_TILE_TIMER
> +#define SPR_LINUX_TIMER_CONTROL SPR_AUX_TILE_TIMER_CONTROL
> +#else
> +#define INT_LINUX_TIMER INT_TILE_TIMER
> +#define SPR_LINUX_TIMER_CONTROL SPR_TILE_TIMER_CONTROL
> +#endif
> +
>  #if CHIP_HAS_SPLIT_CYCLE()
>  cycles_t get_cycles(void);
>  #define get_cycles_low() __insn_mfspr(SPR_CYCLE_LOW)
> diff --git a/arch/tile/include/hv/hypervisor.h b/arch/tile/include/hv/hypervisor.h
> index f71b08e..71abe38 100644
> --- a/arch/tile/include/hv/hypervisor.h
> +++ b/arch/tile/include/hv/hypervisor.h
> @@ -321,6 +321,18 @@
>  /** hv_set_speed */
>  #define HV_DISPATCH_SET_SPEED                     58
>  
> +/** hv_install_virt_context */
> +#define HV_DISPATCH_INSTALL_VIRT_CONTEXT          59
> +
> +/** hv_inquire_virt_context */
> +#define HV_DISPATCH_INQUIRE_VIRT_CONTEXT          60
> +
> +/** hv_install_guest_context */
> +#define HV_DISPATCH_INSTALL_GUEST_CONTEXT         61
> +
> +/** hv_inquire_guest_context */
> +#define HV_DISPATCH_INQUIRE_GUEST_CONTEXT         62
> +
>  /** hv_console_set_ipi */
>  #define HV_DISPATCH_CONSOLE_SET_IPI               63
>  
> @@ -783,12 +795,15 @@ HV_SetSpeed hv_set_speed(unsigned long speed, __hv64 start_cycle,
>   *  new page table does not need to contain any mapping for the
>   *  hv_install_context address itself.
>   *
> - *  At most one HV_CTX_PG_SM_* flag may be specified in "flags";
> + *  At most one HV_CTX_PG_SM_* flag may be specified in the flags argument;
>   *  if multiple flags are specified, HV_EINVAL is returned.
>   *  Specifying none of the flags results in using the default page size.
>   *  All cores participating in a given client must request the same
>   *  page size, or the results are undefined.
>   *
> + *  To disable an installed page table, install HV_CTX_NONE.  The access
> + *  and asid fields are ignored.
> + *
>   * @param page_table Root of the page table.
>   * @param access PTE providing info on how to read the page table.  This
>   *   value must be consistent between multiple tiles sharing a page table,
> @@ -804,16 +819,101 @@ int hv_install_context(HV_PhysAddr page_table, HV_PTE access, HV_ASID asid,
>  
>  #endif /* !__ASSEMBLER__ */
>  
> +#define HV_CTX_NONE         ((HV_PhysAddr)-1)  /**< Disable page table. */
> +
>  #define HV_CTX_DIRECTIO     0x1   /**< Direct I/O requests are accepted from
>                                         PL0. */
>  
> +#define HV_CTX_GUEST_CACHE  0x4   /**< Let guest control caching flags (only
> +                                       usable with hv_install_virt_context.) */
> +
>  #define HV_CTX_PG_SM_4K     0x10  /**< Use 4K small pages, if available. */
>  #define HV_CTX_PG_SM_16K    0x20  /**< Use 16K small pages, if available. */
>  #define HV_CTX_PG_SM_64K    0x40  /**< Use 64K small pages, if available. */
>  #define HV_CTX_PG_SM_MASK   0xf0  /**< Mask of all possible small pages. */
>  
> +
>  #ifndef __ASSEMBLER__
>  
> +/** Install a virtualization context.
> + *
> + * When a virtualization context is installed, all faults from PL0 or
> + * PL1 are handled via a "guest context" and then post-processed by
> + * the "virtualization context"; faults at PL2 are still handled by
> + * the normal context.  For guest faults, the "guest PAs" produced by
> + * the guest page table are passed through the virtualization page
> + * table as pseudo-VAs, generating the true CPA as a result.  See the
> + * individual HV_PTE_xxx bits for the effect the bits have when
> + * present in the virtualization page table.  The ASID is currently
> + * ignored in this syscall, but it might be used later, so the API
> + * includes it.  The HV_CTX_GUEST_CACHE flag indicates that all
> + * cache-related flags should be taken from the primary page table,
> + * not the virtualization page table.
> + *
> + * Once the virtualization context is installed, a guest context
> + * should also be installed; otherwise a VA-equals-PA context will be
> + * used for accesses at PL 0 or 1, i.e. VAs will be passed directly to
> + * the virtualization context to generate CPAs.
> + *
> + * When entering client PL after being at guest or user PL, the
> + * client is expected to call hv_flush_all() to clear any TLB mappings
> + * that might otherwise conflict.  Similarly, hv_flush_all() should
> + * be called before returning to guest or user PL with a virtualization
> + * context installed, so that any TLB mappings are cleared.  Future
> + * work may include adding a "vpid" or similar namespace so that
> + * the TLBs may be managed independently.
> + *
> + * Subsequent guest page table installations will have their root PA
> + * and PTE cached after translating through the virtualization
> + * context, so if entries in the virtualization page table are
> + * modified or removed, the guest context should be re-installed.
> + * This, in conjunction with flushing the TLB on return to the guest,
> + * will ensure that the new virtualization entries are honored.
> + *
> + * @param page_table Root of the page table.
> + * @param access PTE providing info on how to read the page table.  This
> + *   value must be consistent between multiple tiles sharing a page table,
> + *   and must also be consistent with any virtual mappings the client
> + *   may be using to access the page table.
> + * @param asid HV_ASID the page table is to be used for (currently ignored).
> + * @param flags Context flags, denoting attributes or privileges of the
> + *   current virtualization context (see below).
> + * @return Zero on success, or a hypervisor error code on failure.
> + */
> +
> +int hv_install_virt_context(HV_PhysAddr page_table, HV_PTE access,
> +                            HV_ASID asid, __hv32 flags);
> +
> +
> +
> +/** Install a guest context.
> + *
> + * The guest context is only consulted when a virtualization context
> + * is also installed, and for faults that occur below the client's PL.
> + * If no guest context is installed, in such a case, a VA=PA context
> + * is used instead.
> + *
> + * The access PTE will only be honored if the virtualization table was
> + * installed with HV_CTX_GUEST_CACHE.
> + *
> + * A virtualization context must already be installed prior to
> + * installing the guest context.
> + *
> + * @param page_table Root of the page table; the value is the guest's
> + *   physical address (GPA), not a CPA.
> + * @param access PTE providing info on how to read the page table.  This
> + *   value must be consistent between multiple tiles sharing a page table,
> + *   and must also be consistent with any virtual mappings the client
> + *   may be using to access the page table.
> + * @param asid HV_ASID the page table is to be used for.
> + * @param flags Context flags, denoting attributes or privileges of the
> + *   current context (HV_CTX_xxx).
> + * @return Zero on success, or a hypervisor error code on failure.
> + */
> +
> +int hv_install_guest_context(HV_PhysAddr page_table, HV_PTE access,
> +                             HV_ASID asid, __hv32 flags);
> +
>  
>  /** Set the number of pages ganged together by HV_PTE_SUPER at a
>   * particular level of the page table.
> @@ -823,7 +923,7 @@ int hv_install_context(HV_PhysAddr page_table, HV_PTE access, HV_ASID asid,
>   * "super" page size must be less than the span of the next level in
>   * the page table.  The largest size that can be requested is 64GB.
>   *
> - * The shift value is initially "0" for all page table levels,
> + * The shift value is initially 0 for all page table levels,
>   * indicating that the HV_PTE_SUPER bit is effectively ignored.
>   *
>   * If you change the count from one non-zero value to another, the
> @@ -854,11 +954,26 @@ typedef struct
>  } HV_Context;
>  
>  /** Retrieve information about the currently installed context.
> - * @return The data passed to the last successful hv_install_context call.
> + * @return The data passed to the last successful call to
> + * hv_install_context().
>   */
>  HV_Context hv_inquire_context(void);
>  
>  
> +/** Retrieve information about the currently installed virtualization context.
> + * @return The data passed to the last successful call to
> + * hv_install_virt_context().
> + */
> +HV_Context hv_inquire_virt_context(void);
> +
> +
> +/** Retrieve information about the currently installed guest context.
> + * @return The data passed to the last successful call to
> + * hv_install_guest_context().
> + */
> +HV_Context hv_inquire_guest_context(void);
> +
> +
>  /** Flushes all translations associated with the named address space
>   *  identifier from the TLB and any other hypervisor data structures.
>   *  Translations installed with the "global" bit are not flushed.
> @@ -917,7 +1032,7 @@ int hv_flush_pages(HV_VirtAddr start, HV_PageSize page_size,
>  /** Flushes all non-global translations (if preserve_global is true),
>   *  or absolutely all translations (if preserve_global is false).
>   *
> - * @param preserve_global Non-zero if we want to preserve "global" mappings.
> + * @param preserve_global Non-zero if we want to preserve global mappings.
>   * @return Zero on success, or a hypervisor error code on failure.
>  */
>  int hv_flush_all(int preserve_global);
> @@ -991,7 +1106,11 @@ typedef enum {
>    HV_INQ_TILES_HFH_CACHE       = 2,
>  
>    /** The set of tiles that can be legally used as a LOTAR for a PTE. */
> -  HV_INQ_TILES_LOTAR           = 3
> +  HV_INQ_TILES_LOTAR           = 3,
> +
> +  /** The set of "shared" driver tiles that the hypervisor may
> +   *  periodically interrupt. */
> +  HV_INQ_TILES_SHARED          = 4
>  } HV_InqTileSet;
>  
>  /** Returns specific information about various sets of tiles within the
> @@ -1271,14 +1390,21 @@ void hv_downcall_dispatch(void);
>   */
>  /** Message receive downcall interrupt vector */
>  #define INT_MESSAGE_RCV_DWNCL    INT_BOOT_ACCESS
> +/** Device interrupt downcall interrupt vector */
> +#define INT_DEV_INTR_DWNCL       INT_WORLD_ACCESS
> +#ifdef __tilegx__
> +/** Virtualization page table miss downcall interrupt vector */
> +#define INT_VPGTABLE_MISS_DWNCL  INT_I_ASID
> +/** Virtualization guest illegal page table */
> +#define INT_VGUEST_FATAL_DWNCL   INT_D_ASID
> +#else
>  /** DMA TLB miss downcall interrupt vector */
>  #define INT_DMATLB_MISS_DWNCL    INT_DMA_ASID
> -/** Static nework processor instruction TLB miss interrupt vector */
> -#define INT_SNITLB_MISS_DWNCL    INT_SNI_ASID
>  /** DMA TLB access violation downcall interrupt vector */
>  #define INT_DMATLB_ACCESS_DWNCL  INT_DMA_CPL
> -/** Device interrupt downcall interrupt vector */
> -#define INT_DEV_INTR_DWNCL       INT_WORLD_ACCESS
> +/** Static nework processor instruction TLB miss interrupt vector */
> +#define INT_SNITLB_MISS_DWNCL    INT_SNI_ASID
> +#endif
>  
>  #ifndef __ASSEMBLER__
>  
> @@ -2041,8 +2167,16 @@ int hv_flush_remote(HV_PhysAddr cache_pa, unsigned long cache_control,
>  #define HV_PTE_PTFN_BITS             29  /**< Number of bits in a PTFN */
>  
>  /*
> - * Legal values for the PTE's mode field
> + * Legal values for the PTE's mode field.
> + *
> + * If a virtualization page table is installed, this field is only honored
> + * in the primary page table if HV_CTX_GUEST_CACHE was set when the page
> + * table was installed, otherwise only in the virtualization page table.
> + * Note that if HV_CTX_GUEST_CACHE is not set, guests will only be able
> + * to access MMIO resources via pseudo PAs that map to MMIO in the
> + * virtualization page table.
>   */
> +
>  /** Data is not resident in any caches; loads and stores access memory
>   *  directly.
>   */
> @@ -2161,6 +2295,8 @@ int hv_flush_remote(HV_PhysAddr cache_pa, unsigned long cache_control,
>   * doing so may race with the hypervisor's update of ACCESSED and DIRTY bits.
>   *
>   * This bit is ignored in level-1 PTEs unless the Page bit is set.
> + * This bit is ignored in the primary page table if a virtualization
> + * page table is installed.
>   */
>  #define HV_PTE_GLOBAL                (__HV_PTE_ONE << HV_PTE_INDEX_GLOBAL)
>  
> @@ -2174,6 +2310,7 @@ int hv_flush_remote(HV_PhysAddr cache_pa, unsigned long cache_control,
>   * doing so may race with the hypervisor's update of ACCESSED and DIRTY bits.
>   *
>   * This bit is ignored in level-1 PTEs unless the Page bit is set.
> + * This bit is ignored in the virtualization page table.
>   */
>  #define HV_PTE_USER                  (__HV_PTE_ONE << HV_PTE_INDEX_USER)
>  
> @@ -2185,7 +2322,7 @@ int hv_flush_remote(HV_PhysAddr cache_pa, unsigned long cache_control,
>   * has been cleared, subsequent references are not guaranteed to set
>   * it again until the translation has been flushed from the TLB.
>   *
> - * This bit is ignored in level-1 PTEs unless the Page bit is set.
> + * This bit is ignored in level-0 or level-1 PTEs unless the Page bit is set.
>   */
>  #define HV_PTE_ACCESSED              (__HV_PTE_ONE << HV_PTE_INDEX_ACCESSED)
>  
> @@ -2197,7 +2334,7 @@ int hv_flush_remote(HV_PhysAddr cache_pa, unsigned long cache_control,
>   * has been cleared, subsequent references are not guaranteed to set
>   * it again until the translation has been flushed from the TLB.
>   *
> - * This bit is ignored in level-1 PTEs unless the Page bit is set.
> + * This bit is ignored in level-0 or level-1 PTEs unless the Page bit is set.
>   */
>  #define HV_PTE_DIRTY                 (__HV_PTE_ONE << HV_PTE_INDEX_DIRTY)
>  
> @@ -2239,6 +2376,10 @@ int hv_flush_remote(HV_PhysAddr cache_pa, unsigned long cache_control,
>   *
>   * In level-1 PTEs, if the Page bit is clear, this bit determines how the
>   * level-2 page table is accessed.
> + *
> + * If a virtualization page table is installed, this field is only honored
> + * in the primary page table if HV_CTX_GUEST_CACHE was set when the page
> + * table was installed, otherwise only in the virtualization page table.
>   */
>  #define HV_PTE_NC                    (__HV_PTE_ONE << HV_PTE_INDEX_NC)
>  
> @@ -2252,6 +2393,10 @@ int hv_flush_remote(HV_PhysAddr cache_pa, unsigned long cache_control,
>   *
>   * In level-1 PTEs, if the Page bit is clear, this bit
>   * determines how the level-2 page table is accessed.
> + *
> + * If a virtualization page table is installed, this field is only honored
> + * in the primary page table if HV_CTX_GUEST_CACHE was set when the page
> + * table was installed, otherwise only in the virtualization page table.
>   */
>  #define HV_PTE_NO_ALLOC_L1           (__HV_PTE_ONE << HV_PTE_INDEX_NO_ALLOC_L1)
>  
> @@ -2265,6 +2410,10 @@ int hv_flush_remote(HV_PhysAddr cache_pa, unsigned long cache_control,
>   *
>   * In level-1 PTEs, if the Page bit is clear, this bit determines how the
>   * level-2 page table is accessed.
> + *
> + * If a virtualization page table is installed, this field is only honored
> + * in the primary page table if HV_CTX_GUEST_CACHE was set when the page
> + * table was installed, otherwise only in the virtualization page table.
>   */
>  #define HV_PTE_NO_ALLOC_L2           (__HV_PTE_ONE << HV_PTE_INDEX_NO_ALLOC_L2)
>  
> @@ -2284,6 +2433,10 @@ int hv_flush_remote(HV_PhysAddr cache_pa, unsigned long cache_control,
>   * the page map directly to memory.
>   *
>   * This bit is ignored in level-1 PTEs unless the Page bit is set.
> + *
> + * If a virtualization page table is installed, this field is only honored
> + * in the primary page table if HV_CTX_GUEST_CACHE was set when the page
> + * table was installed, otherwise only in the virtualization page table.
>   */
>  #define HV_PTE_CACHED_PRIORITY       (__HV_PTE_ONE << \
>                                        HV_PTE_INDEX_CACHED_PRIORITY)
> @@ -2297,6 +2450,8 @@ int hv_flush_remote(HV_PhysAddr cache_pa, unsigned long cache_control,
>   * It is illegal for this bit to be clear if the Writable bit is set.
>   *
>   * This bit is ignored in level-1 PTEs unless the Page bit is set.
> + * If a virtualization page table is present, the final Readable status
> + * is the logical "and" of this bit in both page tables.
>   */
>  #define HV_PTE_READABLE              (__HV_PTE_ONE << HV_PTE_INDEX_READABLE)
>  
> @@ -2307,6 +2462,8 @@ int hv_flush_remote(HV_PhysAddr cache_pa, unsigned long cache_control,
>   * PTE.
>   *
>   * This bit is ignored in level-1 PTEs unless the Page bit is set.
> + * If a virtualization page table is present, the final Writable status
> + * is the logical "and" of this bit in both page tables.
>   */
>  #define HV_PTE_WRITABLE              (__HV_PTE_ONE << HV_PTE_INDEX_WRITABLE)
>  
> @@ -2319,6 +2476,8 @@ int hv_flush_remote(HV_PhysAddr cache_pa, unsigned long cache_control,
>   * than one.
>   *
>   * This bit is ignored in level-1 PTEs unless the Page bit is set.
> + * If a virtualization page table is present, the final Executable status
> + * is the logical "and" of this bit in both page tables.
>   */
>  #define HV_PTE_EXECUTABLE            (__HV_PTE_ONE << HV_PTE_INDEX_EXECUTABLE)
>  
> diff --git a/arch/tile/include/uapi/arch/sim.h b/arch/tile/include/uapi/arch/sim.h
> index e54b7b0..36fb24c 100644
> --- a/arch/tile/include/uapi/arch/sim.h
> +++ b/arch/tile/include/uapi/arch/sim.h
> @@ -611,6 +611,25 @@ sim_profiler_chip_clear(unsigned int mask)
>    __insn_mtspr(SPR_SIM_CONTROL, SIM_PROFILER_CHIP_CLEAR_SPR_ARG(mask));
>  }
>  
> +/**
> + * Set vCPU number for a given task.
> + * @param vcpu Virtual cpu to set.
> + */
> +static __inline void
> +sim_set_vcpu(int vcpu)
> +{
> +  __insn_mtspr(SPR_SIM_CONTROL,
> +               SIM_CONTROL_VCPU | (vcpu << _SIM_CONTROL_OPERATOR_BITS));
> +}
> +
> +/** Clear vCPU status for a given task. */
> +static __inline void
> +sim_clear_vcpu(void)
> +{
> +  __insn_mtspr(SPR_SIM_CONTROL,
> +               SIM_CONTROL_VCPU | (-1 << _SIM_CONTROL_OPERATOR_BITS));
> +}
> +
>  
>  /*
>   * Event support.
> diff --git a/arch/tile/include/uapi/arch/sim_def.h b/arch/tile/include/uapi/arch/sim_def.h
> index 4b44a2b..b9aad66 100644
> --- a/arch/tile/include/uapi/arch/sim_def.h
> +++ b/arch/tile/include/uapi/arch/sim_def.h
> @@ -221,6 +221,14 @@
>   */
>  #define SIM_CONTROL_ENABLE_MPIPE_LINK_MAGIC_BYTE 36
>  
> +/**
> + * If written to SPR_SIM_CONTROL, combined with a signed virtual cpu
> + * number shifted by 8, will tag any identification of the cpu that
> + * task is running on with the given virtual cpu number.  If the
> + * virtual cpu number is -1, the tag is removed.
> + */
> +#define SIM_CONTROL_VCPU 37
> +
>  
>  /*
>   * Syscall numbers for use with "sim_syscall()".
> diff --git a/arch/tile/include/uapi/arch/spr_def_32.h b/arch/tile/include/uapi/arch/spr_def_32.h
> index c689446..4644c8d 100644
> --- a/arch/tile/include/uapi/arch/spr_def_32.h
> +++ b/arch/tile/include/uapi/arch/spr_def_32.h
> @@ -121,6 +121,9 @@
>  #define SPR_MPL_DMA_NOTIFY_SET_0 0x3800
>  #define SPR_MPL_DMA_NOTIFY_SET_1 0x3801
>  #define SPR_MPL_DMA_NOTIFY_SET_2 0x3802
> +#define SPR_MPL_GPV_SET_0 0x0600
> +#define SPR_MPL_GPV_SET_1 0x0601
> +#define SPR_MPL_GPV_SET_2 0x0602
>  #define SPR_MPL_IDN_ACCESS_SET_0 0x0a00
>  #define SPR_MPL_IDN_ACCESS_SET_1 0x0a01
>  #define SPR_MPL_IDN_ACCESS_SET_2 0x0a02
> @@ -142,6 +145,9 @@
>  #define SPR_MPL_IDN_TIMER_SET_0 0x3400
>  #define SPR_MPL_IDN_TIMER_SET_1 0x3401
>  #define SPR_MPL_IDN_TIMER_SET_2 0x3402
> +#define SPR_MPL_ILL_SET_0 0x0400
> +#define SPR_MPL_ILL_SET_1 0x0401
> +#define SPR_MPL_ILL_SET_2 0x0402
>  #define SPR_MPL_INTCTRL_0_SET_0 0x4a00
>  #define SPR_MPL_INTCTRL_0_SET_1 0x4a01
>  #define SPR_MPL_INTCTRL_0_SET_2 0x4a02
> @@ -166,6 +172,12 @@
>  #define SPR_MPL_SN_NOTIFY_SET_0 0x2a00
>  #define SPR_MPL_SN_NOTIFY_SET_1 0x2a01
>  #define SPR_MPL_SN_NOTIFY_SET_2 0x2a02
> +#define SPR_MPL_SWINT_0_SET_0 0x1c00
> +#define SPR_MPL_SWINT_0_SET_1 0x1c01
> +#define SPR_MPL_SWINT_0_SET_2 0x1c02
> +#define SPR_MPL_SWINT_1_SET_0 0x1a00
> +#define SPR_MPL_SWINT_1_SET_1 0x1a01
> +#define SPR_MPL_SWINT_1_SET_2 0x1a02
>  #define SPR_MPL_UDN_ACCESS_SET_0 0x0c00
>  #define SPR_MPL_UDN_ACCESS_SET_1 0x0c01
>  #define SPR_MPL_UDN_ACCESS_SET_2 0x0c02
> @@ -187,6 +199,9 @@
>  #define SPR_MPL_UDN_TIMER_SET_0 0x3600
>  #define SPR_MPL_UDN_TIMER_SET_1 0x3601
>  #define SPR_MPL_UDN_TIMER_SET_2 0x3602
> +#define SPR_MPL_UNALIGN_DATA_SET_0 0x1e00
> +#define SPR_MPL_UNALIGN_DATA_SET_1 0x1e01
> +#define SPR_MPL_UNALIGN_DATA_SET_2 0x1e02
>  #define SPR_MPL_WORLD_ACCESS_SET_0 0x4e00
>  #define SPR_MPL_WORLD_ACCESS_SET_1 0x4e01
>  #define SPR_MPL_WORLD_ACCESS_SET_2 0x4e02
> diff --git a/arch/tile/include/uapi/arch/spr_def_64.h b/arch/tile/include/uapi/arch/spr_def_64.h
> index 67a6c17..727cda7 100644
> --- a/arch/tile/include/uapi/arch/spr_def_64.h
> +++ b/arch/tile/include/uapi/arch/spr_def_64.h
> @@ -21,6 +21,10 @@
>  #define SPR_AUX_PERF_COUNT_1 0x2106
>  #define SPR_AUX_PERF_COUNT_CTL 0x2107
>  #define SPR_AUX_PERF_COUNT_STS 0x2108
> +#define SPR_AUX_TILE_TIMER_CONTROL 0x1705
> +#define SPR_AUX_TILE_TIMER_CONTROL__COUNT_MASK  0xffffffff
> +#define SPR_AUX_TILE_TIMER_CONTROL__DISABLE_SHIFT 62
> +#define SPR_AUX_TILE_TIMER_CONTROL__UNDERFLOW_SHIFT 63
>  #define SPR_CMPEXCH_VALUE 0x2780
>  #define SPR_CYCLE 0x2781
>  #define SPR_DONE 0x2705
> @@ -101,6 +105,9 @@
>  #define SPR_MPL_AUX_TILE_TIMER_SET_0 0x1700
>  #define SPR_MPL_AUX_TILE_TIMER_SET_1 0x1701
>  #define SPR_MPL_AUX_TILE_TIMER_SET_2 0x1702
> +#define SPR_MPL_GPV_SET_0 0x0900
> +#define SPR_MPL_GPV_SET_1 0x0901
> +#define SPR_MPL_GPV_SET_2 0x0902
>  #define SPR_MPL_IDN_ACCESS_SET_0 0x0a00
>  #define SPR_MPL_IDN_ACCESS_SET_1 0x0a01
>  #define SPR_MPL_IDN_ACCESS_SET_2 0x0a02
> @@ -116,6 +123,12 @@
>  #define SPR_MPL_IDN_TIMER_SET_0 0x1800
>  #define SPR_MPL_IDN_TIMER_SET_1 0x1801
>  #define SPR_MPL_IDN_TIMER_SET_2 0x1802
> +#define SPR_MPL_ILL_SET_0 0x0800
> +#define SPR_MPL_ILL_SET_1 0x0801
> +#define SPR_MPL_ILL_SET_2 0x0802
> +#define SPR_MPL_ILL_TRANS_SET_0 0x1000
> +#define SPR_MPL_ILL_TRANS_SET_1 0x1001
> +#define SPR_MPL_ILL_TRANS_SET_2 0x1002
>  #define SPR_MPL_INTCTRL_0_SET_0 0x2500
>  #define SPR_MPL_INTCTRL_0_SET_1 0x2501
>  #define SPR_MPL_INTCTRL_0_SET_2 0x2502
> @@ -140,6 +153,15 @@
>  #define SPR_MPL_PERF_COUNT_SET_0 0x2000
>  #define SPR_MPL_PERF_COUNT_SET_1 0x2001
>  #define SPR_MPL_PERF_COUNT_SET_2 0x2002
> +#define SPR_MPL_SINGLE_STEP_1_SET_0 0x0300
> +#define SPR_MPL_SINGLE_STEP_1_SET_1 0x0301
> +#define SPR_MPL_SINGLE_STEP_1_SET_2 0x0302
> +#define SPR_MPL_SWINT_0_SET_0 0x0f00
> +#define SPR_MPL_SWINT_0_SET_1 0x0f01
> +#define SPR_MPL_SWINT_0_SET_2 0x0f02
> +#define SPR_MPL_SWINT_1_SET_0 0x0e00
> +#define SPR_MPL_SWINT_1_SET_1 0x0e01
> +#define SPR_MPL_SWINT_1_SET_2 0x0e02
>  #define SPR_MPL_UDN_ACCESS_SET_0 0x0b00
>  #define SPR_MPL_UDN_ACCESS_SET_1 0x0b01
>  #define SPR_MPL_UDN_ACCESS_SET_2 0x0b02
> @@ -155,6 +177,9 @@
>  #define SPR_MPL_UDN_TIMER_SET_0 0x1900
>  #define SPR_MPL_UDN_TIMER_SET_1 0x1901
>  #define SPR_MPL_UDN_TIMER_SET_2 0x1902
> +#define SPR_MPL_UNALIGN_DATA_SET_0 0x1100
> +#define SPR_MPL_UNALIGN_DATA_SET_1 0x1101
> +#define SPR_MPL_UNALIGN_DATA_SET_2 0x1102
>  #define SPR_MPL_WORLD_ACCESS_SET_0 0x2700
>  #define SPR_MPL_WORLD_ACCESS_SET_1 0x2701
>  #define SPR_MPL_WORLD_ACCESS_SET_2 0x2702
> diff --git a/arch/tile/include/uapi/asm/Kbuild b/arch/tile/include/uapi/asm/Kbuild
> index c20db8e..f07cc24 100644
> --- a/arch/tile/include/uapi/asm/Kbuild
> +++ b/arch/tile/include/uapi/asm/Kbuild
> @@ -6,7 +6,9 @@ header-y += bitsperlong.h
>  header-y += byteorder.h
>  header-y += cachectl.h
>  header-y += hardwall.h
> +header-y += kvm.h
>  header-y += kvm_para.h
> +header-y += kvm_virtio.h
>  header-y += mman.h
>  header-y += ptrace.h
>  header-y += setup.h
> diff --git a/arch/tile/include/uapi/asm/kvm.h b/arch/tile/include/uapi/asm/kvm.h
> new file mode 100644
> index 0000000..4346520
> --- /dev/null
> +++ b/arch/tile/include/uapi/asm/kvm.h
> @@ -0,0 +1,267 @@
> +/*
> + * Copyright 2013 Tilera Corporation. All Rights Reserved.
> + *
> + *   This program is free software; you can redistribute it and/or
> + *   modify it under the terms of the GNU General Public License
> + *   as published by the Free Software Foundation, version 2.
> + *
> + *   This program is distributed in the hope that it will be useful, but
> + *   WITHOUT ANY WARRANTY; without even the implied warranty of
> + *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
> + *   NON INFRINGEMENT.  See the GNU General Public License for
> + *   more details.
> + */
> +
> +#ifndef _UAPI_ASM_TILE_KVM_H
> +#define _UAPI_ASM_TILE_KVM_H
> +
> +#ifndef __ASSEMBLER__
> +#include <linux/ptrace.h>
> +#endif
> +
> +#include <arch/abi.h>
> +
> +/*
> + * For Hypervisor syscalls. Note this comes from the hv: syscall.h,
> + * with small modifications: Remove HV_SYS_fence_incoherent.
> + */
> +/* Syscall allowed from guest PL bit mask. */
> +#define HV_SYS_GUEST_SHIFT                12
> +#define HV_SYS_GUEST_MASK                 (1 << HV_SYS_GUEST_SHIFT)
> +/* downcall_dispatch; this syscall number must be zero */
> +#define HV_SYS_downcall_dispatch          0
> +/* install_context */
> +#define HV_SYS_install_context            1
> +/* sysconf */
> +#define HV_SYS_sysconf                    2
> +/* get_rtc */
> +#define HV_SYS_get_rtc                    3
> +/* set_rtc */
> +#define HV_SYS_set_rtc                    4
> +/* flush_asid */
> +#define HV_SYS_flush_asid                 5
> +/* flush_page */
> +#define HV_SYS_flush_page                 6
> +/* flush_pages */
> +#define HV_SYS_flush_pages                7
> +/* restart */
> +#define HV_SYS_restart                    8
> +/* halt */
> +#define HV_SYS_halt                       9
> +/* power_off */
> +#define HV_SYS_power_off                 10
> +/* inquire_physical */
> +#define HV_SYS_inquire_physical          11
> +/* inquire_memory_controller */
> +#define HV_SYS_inquire_memory_controller 12
> +/* inquire_virtual */
> +#define HV_SYS_inquire_virtual           13
> +/* inquire_asid */
> +#define HV_SYS_inquire_asid              14
> +/* console_read_if_ready */
> +#define HV_SYS_console_read_if_ready     15
> +/* console_write */
> +#define HV_SYS_console_write             16
> +/* init */
> +#define HV_SYS_init                      17
> +/* inquire_topology */
> +#define HV_SYS_inquire_topology          18
> +/* fs_findfile */
> +#define HV_SYS_fs_findfile               19
> +/* fs_fstat */
> +#define HV_SYS_fs_fstat                  20
> +/* fs_pread */
> +#define HV_SYS_fs_pread                  21
> +/* physaddr_read64 */
> +#define HV_SYS_physaddr_read64           22
> +/* physaddr_write64 */
> +#define HV_SYS_physaddr_write64          23
> +/* get_command_line */
> +#define HV_SYS_get_command_line          24
> +/* set_caching */
> +#define HV_SYS_set_caching               25
> +/* bzero_page */
> +#define HV_SYS_bzero_page                26
> +/* register_message_state */
> +#define HV_SYS_register_message_state    27
> +/* send_message */
> +#define HV_SYS_send_message              28
> +/* receive_message */
> +#define HV_SYS_receive_message           29
> +/* inquire_context */
> +#define HV_SYS_inquire_context           30
> +/* start_all_tiles */
> +#define HV_SYS_start_all_tiles           31
> +/* dev_open */
> +#define HV_SYS_dev_open                  32
> +/* dev_close */
> +#define HV_SYS_dev_close                 33
> +/* dev_pread */
> +#define HV_SYS_dev_pread                 34
> +/* dev_pwrite */
> +#define HV_SYS_dev_pwrite                35
> +/* dev_poll */
> +#define HV_SYS_dev_poll                  36
> +/* dev_poll_cancel */
> +#define HV_SYS_dev_poll_cancel           37
> +/* dev_preada */
> +#define HV_SYS_dev_preada                38
> +/* dev_pwritea */
> +#define HV_SYS_dev_pwritea               39
> +/* flush_remote */
> +#define HV_SYS_flush_remote              40
> +/* console_putc */
> +#define HV_SYS_console_putc              41
> +/* inquire_tiles */
> +#define HV_SYS_inquire_tiles             42
> +/* confstr */
> +#define HV_SYS_confstr                   43
> +/* reexec */
> +#define HV_SYS_reexec                    44
> +/* set_command_line */
> +#define HV_SYS_set_command_line          45
> +
> +/* store_mapping */
> +#define HV_SYS_store_mapping             52
> +/* inquire_realpa */
> +#define HV_SYS_inquire_realpa            53
> +/* flush_all */
> +#define HV_SYS_flush_all                 54
> +/* get_ipi_pte */
> +#define HV_SYS_get_ipi_pte               55
> +/* set_pte_super_shift */
> +#define HV_SYS_set_pte_super_shift       56
> +/* set_speed */
> +#define HV_SYS_set_speed                 57
> +/* install_virt_context */
> +#define HV_SYS_install_virt_context      58
> +/* inquire_virt_context */
> +#define HV_SYS_inquire_virt_context      59
> +/* inquire_guest_context */
> +#define HV_SYS_install_guest_context     60
> +/* inquire_guest_context */
> +#define HV_SYS_inquire_guest_context     61
> +
> +/*
> + * Number of hypercall (from guest os to host os) other than hv_*().
> + * We leave the previous 128 entries to the usual hv_*() calls
> + * as defined in hypervisor.h.
> + */
> +#define KVM_OTHER_HCALL                  128
> +
> +/* Hypercall index for virtio. */
> +#define KVM_HCALL_virtio                 128
> +
> +/* One greater than the maximum hypercall number. */
> +#define KVM_NUM_HCALLS                   256
> +
> +#ifndef __ASSEMBLER__
> +
> +struct kvm_regs {
> +	struct pt_regs regs;
> +};
> +
> +#define FOR_EACH_GUEST_SPR(f)			\
> +	f(INTERRUPT_MASK_1);			\
> +	f(INTERRUPT_VECTOR_BASE_1);		\
> +	f(EX_CONTEXT_1_0);			\
> +	f(EX_CONTEXT_1_1);			\
> +	f(SYSTEM_SAVE_1_0);			\
> +	f(SYSTEM_SAVE_1_1);			\
> +	f(SYSTEM_SAVE_1_2);			\
> +	f(SYSTEM_SAVE_1_3);			\
> +	f(INTCTRL_1_STATUS);			\
> +	f(IPI_MASK_1);				\
> +	f(IPI_EVENT_1);				\
> +	f(SINGLE_STEP_CONTROL_1);		\
> +	f(SINGLE_STEP_EN_1_1);			\
> +
> +struct kvm_sregs {
> +#define DECLARE_SPR(f) unsigned long f
> +	FOR_EACH_GUEST_SPR(DECLARE_SPR)
> +#undef DECLARE_SPR
> +};
> +
> +struct kvm_fpu {
> +};
> +
> +struct kvm_debug_exit_arch {
> +};
> +
> +struct kvm_guest_debug_arch {
> +};
> +
> +/* definition of registers in kvm_run */
> +struct kvm_sync_regs {
> +};
> +
> +#ifndef __KERNEL__
> +/* For hv_*() */
> +#define KVM_EMULATE(name) [HV_SYS_##name] = qemu_emulate_illegal,
> +#define USER_EMULATE(name) [HV_SYS_##name] = qemu_emulate_hv_##name,
> +#define NO_EMULATE(name) [HV_SYS_##name] = qemu_emulate_illegal,
> +#define BOTH_EMULATE(name) [HV_SYS_##name] = qemu_emulate_hv_##name,
> +/* For others */
> +#define USER_HCALL(name) [KVM_HCALL_##name] = qemu_handle_##name,
> +#endif
> +
> +#define HCALL_DEFS \
> +	/* For hv_*() */ \
> +	KVM_EMULATE(init) \
> +	NO_EMULATE(install_context) \
> +	KVM_EMULATE(sysconf) \
> +	KVM_EMULATE(get_rtc) \
> +	KVM_EMULATE(set_rtc) \
> +	NO_EMULATE(flush_asid) \
> +	NO_EMULATE(flush_page) \
> +	NO_EMULATE(flush_pages) \
> +	USER_EMULATE(restart) \
> +	USER_EMULATE(halt) \
> +	USER_EMULATE(power_off) \
> +	USER_EMULATE(inquire_physical) \
> +	USER_EMULATE(inquire_memory_controller) \
> +	KVM_EMULATE(inquire_virtual) \
> +	KVM_EMULATE(inquire_asid) \
> +	NO_EMULATE(console_read_if_ready) \
> +	NO_EMULATE(console_write) \
> +	NO_EMULATE(downcall_dispatch) \
> +	KVM_EMULATE(inquire_topology) \
> +	USER_EMULATE(fs_findfile) \
> +	USER_EMULATE(fs_fstat) \
> +	USER_EMULATE(fs_pread) \
> +	KVM_EMULATE(physaddr_read64) \
> +	KVM_EMULATE(physaddr_write64) \
> +	USER_EMULATE(get_command_line) \
> +	USER_EMULATE(set_caching) \
> +	NO_EMULATE(bzero_page) \
> +	KVM_EMULATE(register_message_state) \
> +	KVM_EMULATE(send_message) \
> +	KVM_EMULATE(receive_message) \
> +	KVM_EMULATE(inquire_context) \
> +	KVM_EMULATE(start_all_tiles) \
> +	USER_EMULATE(dev_open) \
> +	USER_EMULATE(dev_close) \
> +	USER_EMULATE(dev_pread) \
> +	USER_EMULATE(dev_pwrite) \
> +	USER_EMULATE(dev_poll) \
> +	USER_EMULATE(dev_poll_cancel) \
> +	USER_EMULATE(dev_preada) \
> +	USER_EMULATE(dev_pwritea) \
> +	USER_EMULATE(flush_remote) \
> +	NO_EMULATE(console_putc) \
> +	KVM_EMULATE(inquire_tiles) \
> +	KVM_EMULATE(confstr) \
> +	USER_EMULATE(reexec) \
> +	USER_EMULATE(set_command_line) \
> +	USER_EMULATE(store_mapping) \
> +	NO_EMULATE(inquire_realpa) \
> +	NO_EMULATE(flush_all) \
> +	KVM_EMULATE(get_ipi_pte) \
> +	KVM_EMULATE(set_pte_super_shift) \
> +	KVM_EMULATE(set_speed) \
> +	/* For others */ \
> +	USER_HCALL(virtio)
> +
> +#endif
> +
> +#endif /* _UAPI_ASM_TILE_KVM_H */
> diff --git a/arch/tile/include/uapi/asm/kvm_virtio.h b/arch/tile/include/uapi/asm/kvm_virtio.h
> new file mode 100644
> index 0000000..d94f535
> --- /dev/null
> +++ b/arch/tile/include/uapi/asm/kvm_virtio.h
> @@ -0,0 +1,60 @@
> +/*
> + * Copyright 2013 Tilera Corporation. All Rights Reserved.
> + *
> + *   This program is free software; you can redistribute it and/or
> + *   modify it under the terms of the GNU General Public License
> + *   as published by the Free Software Foundation, version 2.
> + *
> + *   This program is distributed in the hope that it will be useful, but
> + *   WITHOUT ANY WARRANTY; without even the implied warranty of
> + *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
> + *   NON INFRINGEMENT.  See the GNU General Public License for
> + *   more details.
> + */
> +
> +#ifndef _UAPI_ASM_TILE_KVM_VIRTIO_H
> +#define _UAPI_ASM_TILE_KVM_VIRTIO_H
> +
> +#include <linux/types.h>
> +
> +#define KVM_VIRTIO_UNKNOWN	0
> +#define KVM_VIRTIO_NOTIFY	1
> +#define KVM_VIRTIO_RESET	2
> +#define KVM_VIRTIO_SET_STATUS	3
> +
> +struct kvm_device_desc {
> +	/* The device type: console, network, disk etc.  Type 0 terminates. */
> +	__u8 type;
> +	/* The number of virtqueues (first in config array) */
> +	__u8 num_vq;
> +	/*
> +	 * The number of bytes of feature bits.  Multiply by 2: one for host
> +	 * features and one for Guest acknowledgements.
> +	 */
> +	__u8 feature_len;
> +	/* The number of bytes of the config array after virtqueues. */
> +	__u8 config_len;
> +	/* A status byte, written by the Guest. */
> +	__u8 status;
> +	__u64 config[0];
> +};
> +
> +struct kvm_vqinfo {
> +	/* Pointer to the information contained in the device config. */
> +	struct kvm_vqconfig *config;
> +	/* The address where we mapped the virtio ring, so we can unmap it. */
> +	void *pages;
> +};
> +
> +struct kvm_vqconfig {
> +	/* The physical address of the virtio ring */
> +	__u64 pa;
> +	/* The number of entries in the virtio_ring */
> +	__u64 num;
> +	/* The interrupt we get when something happens. Set by the guest. */
> +	__u32 irq;
> +
> +};
> +
> +
> +#endif /* _UAPI_ASM_TILE_KVM_VIRTIO_H */
> diff --git a/arch/tile/kernel/Makefile b/arch/tile/kernel/Makefile
> index b7c8b5e..b638d3e 100644
> --- a/arch/tile/kernel/Makefile
> +++ b/arch/tile/kernel/Makefile
> @@ -29,5 +29,6 @@ obj-$(CONFIG_TILE_USB)		+= usb.o
>  obj-$(CONFIG_TILE_HVGLUE_TRACE)	+= hvglue_trace.o
>  obj-$(CONFIG_FUNCTION_TRACER)	+= ftrace.o mcount_64.o
>  obj-$(CONFIG_KPROBES)		+= kprobes.o
> +obj-$(CONFIG_KVM_GUEST)		+= kvm_virtio.o
>  
>  obj-y				+= vdso/
> diff --git a/arch/tile/kernel/asm-offsets.c b/arch/tile/kernel/asm-offsets.c
> index 97ea6ac..0a04a16 100644
> --- a/arch/tile/kernel/asm-offsets.c
> +++ b/arch/tile/kernel/asm-offsets.c
> @@ -20,6 +20,9 @@
>  #include <linux/hardirq.h>
>  #include <linux/ptrace.h>
>  #include <hv/hypervisor.h>
> +#ifdef CONFIG_KVM
> +#include <linux/kvm_host.h>
> +#endif
>  
>  /* Check for compatible compiler early in the build. */
>  #ifdef CONFIG_TILEGX
> @@ -68,6 +71,10 @@ void foo(void)
>  	DEFINE(THREAD_INFO_UNALIGN_JIT_TMP_OFFSET,
>  	       offsetof(struct thread_info, unalign_jit_tmp));
>  #endif
> +#ifdef CONFIG_KVM
> +	DEFINE(THREAD_INFO_VCPU_OFFSET,
> +	       offsetof(struct thread_info, vcpu));
> +#endif
>  
>  	DEFINE(TASK_STRUCT_THREAD_KSP_OFFSET,
>  	       offsetof(struct task_struct, thread.ksp));
> diff --git a/arch/tile/kernel/early_printk.c b/arch/tile/kernel/early_printk.c
> index b608e00..53f2be4 100644
> --- a/arch/tile/kernel/early_printk.c
> +++ b/arch/tile/kernel/early_printk.c
> @@ -18,11 +18,26 @@
>  #include <linux/string.h>
>  #include <linux/irqflags.h>
>  #include <linux/printk.h>
> +#ifdef CONFIG_KVM_GUEST
> +#include <linux/virtio_console.h>
> +#include <linux/kvm_para.h>
> +#include <asm/kvm_virtio.h>
> +#endif
>  #include <asm/setup.h>
>  #include <hv/hypervisor.h>
>  
>  static void early_hv_write(struct console *con, const char *s, unsigned n)
>  {
> +#ifdef CONFIG_KVM_GUEST
> +	char buf[512];
> +
> +	if (n > sizeof(buf) - 1)
> +		n = sizeof(buf) - 1;
> +	memcpy(buf, s, n);
> +	buf[n] = '\0';
> +
> +	hcall_virtio(KVM_VIRTIO_NOTIFY, __pa(buf));
> +#else
>  	tile_console_write(s, n);
>  
>  	/*
> @@ -32,6 +47,7 @@ static void early_hv_write(struct console *con, const char *s, unsigned n)
>  	 */
>  	if (n && s[n-1] == '\n')
>  		tile_console_write("\r", 1);
> +#endif
>  }
>  
>  static struct console early_hv_console = {
> diff --git a/arch/tile/kernel/head_32.S b/arch/tile/kernel/head_32.S
> index f3f17b0..8d5b40f 100644
> --- a/arch/tile/kernel/head_32.S
> +++ b/arch/tile/kernel/head_32.S
> @@ -162,8 +162,8 @@ ENTRY(swapper_pg_dir)
>  	.set addr, addr + PGDIR_SIZE
>  	.endr
>  
> -	/* The true text VAs are mapped as VA = PA + MEM_SV_INTRPT */
> -	PTE MEM_SV_INTRPT, 0, (1 << (HV_PTE_INDEX_READABLE - 32)) | \
> +	/* The true text VAs are mapped as VA = PA + MEM_SV_START */
> +	PTE MEM_SV_START, 0, (1 << (HV_PTE_INDEX_READABLE - 32)) | \
>  			      (1 << (HV_PTE_INDEX_EXECUTABLE - 32))
>  	.org swapper_pg_dir + PGDIR_SIZE
>  	END(swapper_pg_dir)
> diff --git a/arch/tile/kernel/head_64.S b/arch/tile/kernel/head_64.S
> index 652b814..bd0e12f 100644
> --- a/arch/tile/kernel/head_64.S
> +++ b/arch/tile/kernel/head_64.S
> @@ -135,9 +135,9 @@ ENTRY(_start)
>  1:
>  
>  	/* Install the interrupt base. */
> -	moveli r0, hw2_last(MEM_SV_START)
> -	shl16insli r0, r0, hw1(MEM_SV_START)
> -	shl16insli r0, r0, hw0(MEM_SV_START)
> +	moveli r0, hw2_last(intrpt_start)
> +	shl16insli r0, r0, hw1(intrpt_start)
> +	shl16insli r0, r0, hw0(intrpt_start)
>  	mtspr SPR_INTERRUPT_VECTOR_BASE_K, r0
>  
>  	/* Get our processor number and save it away in SAVE_K_0. */
> diff --git a/arch/tile/kernel/hvglue.S b/arch/tile/kernel/hvglue.S
> index 16576c6..2914a9e 100644
> --- a/arch/tile/kernel/hvglue.S
> +++ b/arch/tile/kernel/hvglue.S
> @@ -71,5 +71,11 @@ gensym hv_flush_all, 0x6e0, 32
>  gensym hv_get_ipi_pte, 0x700, 32
>  gensym hv_set_pte_super_shift, 0x720, 32
>  gensym hv_set_speed, 0x740, 32
> +gensym hv_install_virt_context, 0x760, 32
> +gensym hv_inquire_virt_context, 0x780, 32
> +gensym hv_install_guest_context, 0x7a0, 32
> +gensym hv_inquire_guest_context, 0x7c0, 32
>  gensym hv_console_set_ipi, 0x7e0, 32
> -gensym hv_glue_internals, 0x800, 30720
> +gensym hv_glue_internals, 0x800, 2048
> +gensym hcall_virtio, 0x1000, 32
> +gensym hv_hcall_internals, 0x1020, 28640
> diff --git a/arch/tile/kernel/hvglue_trace.c b/arch/tile/kernel/hvglue_trace.c
> index 16ef6c1..3b15c76 100644
> --- a/arch/tile/kernel/hvglue_trace.c
> +++ b/arch/tile/kernel/hvglue_trace.c
> @@ -75,6 +75,10 @@
>  #define hv_get_ipi_pte _hv_get_ipi_pte
>  #define hv_set_pte_super_shift _hv_set_pte_super_shift
>  #define hv_set_speed _hv_set_speed
> +#define hv_install_virt_context _hv_install_virt_context
> +#define hv_inquire_virt_context _hv_inquire_virt_context
> +#define hv_install_guest_context _hv_install_guest_context
> +#define hv_inquire_guest_context _hv_inquire_guest_context
>  #define hv_console_set_ipi _hv_console_set_ipi
>  #include <hv/hypervisor.h>
>  #undef hv_init
> @@ -135,6 +139,10 @@
>  #undef hv_get_ipi_pte
>  #undef hv_set_pte_super_shift
>  #undef hv_set_speed
> +#undef hv_install_virt_context
> +#undef hv_inquire_virt_context
> +#undef hv_install_guest_context
> +#undef hv_inquire_guest_context
>  #undef hv_console_set_ipi
>  
>  /*
> @@ -209,8 +217,14 @@ HV_WRAP3(HV_SetSpeed, hv_set_speed, unsigned long, speed, __hv64, start_cycle,
>  	 unsigned long, flags)
>  HV_WRAP4(int, hv_install_context, HV_PhysAddr, page_table, HV_PTE, access,
>  	 HV_ASID, asid, __hv32, flags)
> +HV_WRAP4(int, hv_install_virt_context, HV_PhysAddr, page_table, HV_PTE, access,
> +	 HV_ASID, asid, __hv32, flags)
> +HV_WRAP4(int, hv_install_guest_context, HV_PhysAddr, page_table, HV_PTE, access,
> +	 HV_ASID, asid, __hv32, flags)
>  HV_WRAP2(int, hv_set_pte_super_shift, int, level, int, log2_count)
>  HV_WRAP0(HV_Context, hv_inquire_context)
> +HV_WRAP0(HV_Context, hv_inquire_virt_context)
> +HV_WRAP0(HV_Context, hv_inquire_guest_context)
>  HV_WRAP1(int, hv_flush_asid, HV_ASID, asid)
>  HV_WRAP2(int, hv_flush_page, HV_VirtAddr, address, HV_PageSize, page_size)
>  HV_WRAP3(int, hv_flush_pages, HV_VirtAddr, start, HV_PageSize, page_size,
> diff --git a/arch/tile/kernel/intvec_32.S b/arch/tile/kernel/intvec_32.S
> index f3d26f4..2ce69a5 100644
> --- a/arch/tile/kernel/intvec_32.S
> +++ b/arch/tile/kernel/intvec_32.S
> @@ -353,7 +353,7 @@ intvec_\vecname:
>  #ifdef __COLLECT_LINKER_FEEDBACK__
>  	.pushsection .text.intvec_feedback,"ax"
>  	.org    (\vecnum << 5)
> -	FEEDBACK_ENTER_EXPLICIT(intvec_\vecname, .intrpt1, 1 << 8)
> +	FEEDBACK_ENTER_EXPLICIT(intvec_\vecname, .intrpt, 1 << 8)
>  	jrp     lr
>  	.popsection
>  #endif
> @@ -806,7 +806,7 @@ handle_interrupt:
>  STD_ENTRY(interrupt_return)
>  	/* If we're resuming to kernel space, don't check thread flags. */
>  	{
> -	 bnz    r30, .Lrestore_all  /* NMIs don't special-case user-space */
> +	 bnz    r30, restore_all  /* NMIs don't special-case user-space */
>  	 PTREGS_PTR(r29, PTREGS_OFFSET_EX1)
>  	}
>  	lw      r29, r29
> @@ -845,11 +845,11 @@ STD_ENTRY(interrupt_return)
>  	 seq    r27, r27, r28
>  	}
>  	{
> -	 bbns   r27, .Lrestore_all
> +	 bbns   r27, restore_all
>  	 addi   r28, r28, 8
>  	}
>  	sw      r29, r28
> -	j       .Lrestore_all
> +	j       restore_all
>  
>  .Lresume_userspace:
>  	FEEDBACK_REENTER(interrupt_return)
> @@ -887,7 +887,7 @@ STD_ENTRY(interrupt_return)
>  	 auli   r1, r1, ha16(_TIF_ALLWORK_MASK)
>  	}
>  	and     r1, r29, r1
> -	bzt     r1, .Lrestore_all
> +	bzt     r1, restore_all
>  
>  	/*
>  	 * Make sure we have all the registers saved for signal
> @@ -926,7 +926,9 @@ STD_ENTRY(interrupt_return)
>  	 * profile interrupt will actually disable interrupts in both SPRs
>  	 * before returning, which is OK.)
>  	 */
> -.Lrestore_all:
> +	.global restore_all
> +	.type restore_all, @function
> +restore_all:
>  	PTREGS_PTR(r0, PTREGS_OFFSET_EX1)
>  	{
>  	 lw     r0, r0
> @@ -1890,8 +1892,8 @@ int_unalign:
>  	push_extra_callee_saves r0
>  	j       do_trap
>  
> -/* Include .intrpt1 array of interrupt vectors */
> -	.section ".intrpt1", "ax"
> +/* Include .intrpt array of interrupt vectors */
> +	.section ".intrpt", "ax"
>  
>  #define op_handle_perf_interrupt bad_intr
>  #define op_handle_aux_perf_interrupt bad_intr
> diff --git a/arch/tile/kernel/intvec_64.S b/arch/tile/kernel/intvec_64.S
> index 18b2dcc..2c5cbe0 100644
> --- a/arch/tile/kernel/intvec_64.S
> +++ b/arch/tile/kernel/intvec_64.S
> @@ -29,11 +29,25 @@
>  #include <arch/abi.h>
>  #include <arch/interrupts.h>
>  #include <arch/spr_def.h>
> +#include <arch/opcode.h>
> +#ifdef CONFIG_KVM
> +#include <asm/kvm_host.h>
> +#endif
>  
>  #define PTREGS_PTR(reg, ptreg) addli reg, sp, C_ABI_SAVE_AREA_SIZE + (ptreg)
>  
>  #define PTREGS_OFFSET_SYSCALL PTREGS_OFFSET_REG(TREG_SYSCALL_NR)
>  
> +#if CONFIG_KERNEL_PL == 1 || CONFIG_KERNEL_PL == 2
> +/*
> + * Set "result" non-zero if ex1 holds the PL of the kernel
> + * (with or without ICS being set).  Note this works only
> + * because we never find the PL at level 3.
> + */
> +# define IS_KERNEL_EX1(result, ex1) andi result, ex1, CONFIG_KERNEL_PL
> +#else
> +# error Recode IS_KERNEL_EX1 for CONFIG_KERNEL_PL
> +#endif
>  
>  	.macro  push_reg reg, ptr=sp, delta=-8
>  	{
> @@ -308,7 +322,7 @@ intvec_\vecname:
>  	 */
>  	{
>  	 blbs   sp, 2f
> -	 andi   r0, r0, SPR_EX_CONTEXT_1_1__PL_MASK  /* mask off ICS */
> +	 IS_KERNEL_EX1(r0, r0)
>  	}
>  
>  	.ifc    \vecnum, INT_DOUBLE_FAULT
> @@ -347,10 +361,6 @@ intvec_\vecname:
>  	 *
>  	 * Note that the hypervisor *always* sets SYSTEM_SAVE_K_2 for
>  	 * any path that turns into a downcall to one of our TLB handlers.
> -	 *
> -	 * FIXME: if we end up never using this path, perhaps we should
> -	 * prevent the hypervisor from generating downcalls in this case.
> -	 * The advantage of getting a downcall is we can panic in Linux.
>  	 */
>  	mfspr   r0, SPR_SYSTEM_SAVE_K_2
>  	{
> @@ -490,6 +500,10 @@ intvec_\vecname:
>  	mfspr   r2, SPR_SYSTEM_SAVE_K_3   /* address of page fault */
>  	mfspr   r3, SPR_SYSTEM_SAVE_K_2   /* info about page fault */
>  	.else
> +	.ifc \c_routine, kvm_vpgtable_miss
> +	mfspr   r2, SPR_SYSTEM_SAVE_K_3   /* address of page fault */
> +	mfspr   r3, SPR_SYSTEM_SAVE_K_2   /* info about page fault */
> +	.else
>  	.ifc \vecnum, INT_ILL_TRANS
>  	mfspr   r2, ILL_VA_PC
>  	.else
> @@ -512,6 +526,7 @@ intvec_\vecname:
>  	.endif
>  	.endif
>  	.endif
> +	.endif
>  	/* Put function pointer in r0 */
>  	moveli  r0, hw2_last(\c_routine)
>  	shl16insli r0, r0, hw1(\c_routine)
> @@ -525,7 +540,7 @@ intvec_\vecname:
>  #ifdef __COLLECT_LINKER_FEEDBACK__
>  	.pushsection .text.intvec_feedback,"ax"
>  	.org    (\vecnum << 5)
> -	FEEDBACK_ENTER_EXPLICIT(intvec_\vecname, .intrpt1, 1 << 8)
> +	FEEDBACK_ENTER_EXPLICIT(intvec_\vecname, .intrpt, 1 << 8)
>  	jrp     lr
>  	.popsection
>  #endif
> @@ -641,24 +656,25 @@ intvec_\vecname:
>  	/*
>  	 * If we will be returning to the kernel, we will need to
>  	 * reset the interrupt masks to the state they had before.
> -	 * Set DISABLE_IRQ in flags iff we came from PL1 with irqs disabled.
> +	 * Set DISABLE_IRQ in flags iff we came from kernel pl with
> +	 * irqs disabled.
>  	 */
> -	mfspr   r32, SPR_EX_CONTEXT_K_1
> +	mfspr   r22, SPR_EX_CONTEXT_K_1
>  	{
> -	 andi   r32, r32, SPR_EX_CONTEXT_1_1__PL_MASK  /* mask off ICS */
> +	 IS_KERNEL_EX1(r22, r22)
>  	 PTREGS_PTR(r21, PTREGS_OFFSET_FLAGS)
>  	}
> -	beqzt   r32, 1f       /* zero if from user space */
> -	IRQS_DISABLED(r32)    /* zero if irqs enabled */
> +	beqzt  r22, 1f        /* zero if from user space */
> +	IRQS_DISABLED(r22)    /* zero if irqs enabled */
>  #if PT_FLAGS_DISABLE_IRQ != 1
>  # error Value of IRQS_DISABLED used to set PT_FLAGS_DISABLE_IRQ; fix
>  #endif
>  1:
>  	.ifnc \function,handle_syscall
>  	/* Record the fact that we saved the caller-save registers above. */
> -	ori     r32, r32, PT_FLAGS_CALLER_SAVES
> +	ori     r22, r22, PT_FLAGS_CALLER_SAVES
>  	.endif
> -	st      r21, r32
> +	st      r21, r22
>  
>  	/*
>  	 * we've captured enough state to the stack (including in
> @@ -698,12 +714,29 @@ intvec_\vecname:
>  	move    tp, zero
>  #endif
>  
> +	/*
> +	 * Prepare the first 256 stack bytes to be rapidly accessible
> +	 * without having to fetch the background data.
> +	 */
> +	addi    r52, sp, -64
> +	{
> +	 wh64   r52
> +	 addi   r52, r52, -64
> +	}
> +	{
> +	 wh64   r52
> +	 addi   r52, r52, -64
> +	}
> +	{
> +	 wh64   r52
> +	 addi   r52, r52, -64
> +	}
> +	wh64    r52
> +
>  #ifdef __COLLECT_LINKER_FEEDBACK__
>  	/*
>  	 * Notify the feedback routines that we were in the
> -	 * appropriate fixed interrupt vector area.  Note that we
> -	 * still have ICS set at this point, so we can't invoke any
> -	 * atomic operations or we will panic.  The feedback
> +	 * appropriate fixed interrupt vector area.  The feedback
>  	 * routines internally preserve r0..r10 and r30 up.
>  	 */
>  	.ifnc \function,handle_syscall
> @@ -722,23 +755,15 @@ intvec_\vecname:
>  #endif
>  
>  	/*
> -	 * Prepare the first 256 stack bytes to be rapidly accessible
> -	 * without having to fetch the background data.
> +	 * Stash any interrupt state in r30..r33 for now.
> +	 * This makes it easier to call C code in the code that follows.
> +	 * We don't need to on the syscall path since we reload
> +	 * them from the stack instead.
>  	 */
> -	addi    r52, sp, -64
> -	{
> -	 wh64   r52
> -	 addi   r52, r52, -64
> -	}
> -	{
> -	 wh64   r52
> -	 addi   r52, r52, -64
> -	}
> -	{
> -	 wh64   r52
> -	 addi   r52, r52, -64
> -	}
> -	wh64    r52
> +	.ifnc \function,handle_syscall
> +	{ move r30, r0; move r31, r1 }
> +	{ move r32, r2; move r33, r3 }
> +	.endif
>  
>  #ifdef CONFIG_TRACE_IRQFLAGS
>  	.ifnc \function,handle_nmi
> @@ -749,17 +774,8 @@ intvec_\vecname:
>  	 * For syscalls, we already have the register state saved away
>  	 * on the stack, so we don't bother to do any register saves here,
>  	 * and later we pop the registers back off the kernel stack.
> -	 * For interrupt handlers, save r0-r3 in callee-saved registers.
>  	 */
> -	.ifnc \function,handle_syscall
> -	{ move r30, r0; move r31, r1 }
> -	{ move r32, r2; move r33, r3 }
> -	.endif
>  	TRACE_IRQS_OFF
> -	.ifnc \function,handle_syscall
> -	{ move r0, r30; move r1, r31 }
> -	{ move r2, r32; move r3, r33 }
> -	.endif
>  	.endif
>  #endif
>  
> @@ -808,11 +824,11 @@ handle_interrupt:
>  STD_ENTRY(interrupt_return)
>  	/* If we're resuming to kernel space, don't check thread flags. */
>  	{
> -	 bnez   r30, .Lrestore_all  /* NMIs don't special-case user-space */
> +	 bnez   r30, restore_all  /* NMIs don't special-case user-space */
>  	 PTREGS_PTR(r29, PTREGS_OFFSET_EX1)
>  	}
>  	ld      r29, r29
> -	andi    r29, r29, SPR_EX_CONTEXT_1_1__PL_MASK  /* mask off ICS */
> +	IS_KERNEL_EX1(r29, r29)
>  	{
>  	 beqzt  r29, .Lresume_userspace
>  	 move   r29, sp
> @@ -824,14 +840,25 @@ STD_ENTRY(interrupt_return)
>  	addli   r28, r29, THREAD_INFO_FLAGS_OFFSET
>  	{
>  	 ld     r28, r28
> -	 addli  r29, r29, THREAD_INFO_PREEMPT_COUNT_OFFSET
> +	 addli  r26, r29, THREAD_INFO_PREEMPT_COUNT_OFFSET
>  	}
>  	{
> -	 andi   r28, r28, _TIF_NEED_RESCHED
> -	 ld4s   r29, r29
> +	 andi   r27, r28, _TIF_NEED_RESCHED
> +	 ld4s   r26, r26
>  	}
> -	beqzt   r28, 1f
> -	bnez    r29, 1f
> +	beqzt   r27, 1f
> +	bnez    r26, 1f
> +#ifdef CONFIG_KVM
> +	addli   r27, r29, THREAD_INFO_VCPU_OFFSET
> +	ld	r27, r27
> +	{
> +	 beqzt  r27, 0f
> +	 movei  r1, KVM_EXIT_AGAIN
> +	}
> +	push_extra_callee_saves r0
> +	j       kvm_trigger_vmexit
> +0:
> +#endif
>  	jal     preempt_schedule_irq
>  	FEEDBACK_REENTER(interrupt_return)
>  1:
> @@ -853,11 +880,11 @@ STD_ENTRY(interrupt_return)
>  	 cmpeq  r27, r27, r28
>  	}
>  	{
> -	 blbc   r27, .Lrestore_all
> +	 blbc   r27, restore_all
>  	 addi   r28, r28, 8
>  	}
>  	st      r29, r28
> -	j       .Lrestore_all
> +	j       restore_all
>  
>  .Lresume_userspace:
>  	FEEDBACK_REENTER(interrupt_return)
> @@ -897,7 +924,7 @@ STD_ENTRY(interrupt_return)
>  	 shl16insli r1, r1, hw0(_TIF_ALLWORK_MASK)
>  	}
>  	and     r1, r29, r1
> -	beqzt   r1, .Lrestore_all
> +	beqzt   r1, restore_all
>  
>  	/*
>  	 * Make sure we have all the registers saved for signal
> @@ -929,14 +956,16 @@ STD_ENTRY(interrupt_return)
>  	 * ICS can only be used in very tight chunks of code to avoid
>  	 * tripping over various assertions that it is off.
>  	 */
> -.Lrestore_all:
> +	.global restore_all
> +	.type restore_all, @function
> +restore_all:
>  	PTREGS_PTR(r0, PTREGS_OFFSET_EX1)
>  	{
>  	 ld      r0, r0
>  	 PTREGS_PTR(r32, PTREGS_OFFSET_FLAGS)
>  	}
>  	{
> -	 andi   r0, r0, SPR_EX_CONTEXT_1_1__PL_MASK
> +	 IS_KERNEL_EX1(r0, r0)
>  	 ld     r32, r32
>  	}
>  	bnez    r0, 1f
> @@ -1007,7 +1036,7 @@ STD_ENTRY(interrupt_return)
>  	pop_reg r21, sp, PTREGS_OFFSET_REG(31) - PTREGS_OFFSET_PC
>  	{
>  	 mtspr  SPR_EX_CONTEXT_K_1, lr
> -	 andi   lr, lr, SPR_EX_CONTEXT_1_1__PL_MASK  /* mask off ICS */
> +	 IS_KERNEL_EX1(lr, lr)
>  	}
>  	{
>  	 mtspr  SPR_EX_CONTEXT_K_0, r21
> @@ -1457,6 +1486,26 @@ int_unalign:
>  	j       do_unaligned
>  ENDPROC(hand_unalign_slow)
>  
> +#ifdef CONFIG_KVM
> +/*
> + * Any call path that may lead to a vmexit needs to save the full
> + * callee-save register state, since if we vmexit we don't unwind
> + * the callee-saves from the C function stack frames, and instead
> + * just save away the register state from the interrupt handler as-is
> + * and later reload it directly and call back into the guest.
> + */
> +	.macro  save_callee_saves_and_tailcall func
> +kvm_\func:
> +	push_extra_callee_saves r0
> +	j       kvm_do_\func
> +	ENDPROC(\func)
> +	.endm
> +
> +	save_callee_saves_and_tailcall hypervisor_call
> +	save_callee_saves_and_tailcall vpgtable_miss
> +	save_callee_saves_and_tailcall vguest_fatal
> +#endif
> +
>  /* Fill the return address stack with nonzero entries. */
>  STD_ENTRY(fill_ra_stack)
>  	{
> @@ -1469,13 +1518,57 @@ STD_ENTRY(fill_ra_stack)
>  4:	jrp	r0
>  	STD_ENDPROC(fill_ra_stack)
>  
> +#ifdef CONFIG_KVM
> +/*
> + * Handle the downcall dispatch service.  On entry, the client's
> + * system save register 3 holds the original contents of
> + * REG_SYSCALL_NR_NAME, which we need to restore before we iret to
> + * the correct interrupt vector.
> + * Note that we only support the INT_MESSAGE_RCV_DWNCL interrupt
> + * here, since this is the only interrupt handled this way on GX.
> + */
> +handle_downcall_dispatch:
> +	/*
> +	 * If we were called from PL0, jump back to slow path.
> +	 * We check just the low bit to make sure it's set, since we
> +	 * can only be called from PL0 or PL1.
> +	 */
> +	mfspr	TREG_SYSCALL_NR_NAME, SPR_EX_CONTEXT_K_1
> +	blbc	TREG_SYSCALL_NR_NAME, intvec_SWINT_0
> +
> +	/* Set the PC to the downcall interrupt vector, and PL to guest. */
> +	mfspr	TREG_SYSCALL_NR_NAME, SPR_INTERRUPT_VECTOR_BASE_1
> +	addli	TREG_SYSCALL_NR_NAME, TREG_SYSCALL_NR_NAME, \
> +	 	INT_MESSAGE_RCV_DWNCL << 8
> +	{
> +	 mtspr	SPR_EX_CONTEXT_K_0, TREG_SYSCALL_NR_NAME
> +	 movei	TREG_SYSCALL_NR_NAME, GUEST_PL | SPR_EX_CONTEXT_1_1__ICS_MASK
> +	}
> +	mtspr	SPR_EX_CONTEXT_K_1, TREG_SYSCALL_NR_NAME
> +
> +	/* Restore REG_SYSCALL_NR_NAME and return to the new vector. */
> +	mfspr	TREG_SYSCALL_NR_NAME, SPR_SYSTEM_SAVE_1_3
> +	iret
> +
> +	.macro int_hand_kvm_hcall  vecnum, vecname, c_routine, \
> +	       processing=handle_interrupt
> +	.org   (\vecnum << 8)
> +		/* Need special code for downcall dispatch syscall. */
> +		beqz TREG_SYSCALL_NR_NAME, handle_downcall_dispatch
> +		__int_hand   \vecnum, \vecname, \c_routine, \processing
> +	.endm
> +
> +#endif /* CONFIG_KVM */
> +
>  	.macro int_hand  vecnum, vecname, c_routine, processing=handle_interrupt
>  	.org   (\vecnum << 8)
>  		__int_hand   \vecnum, \vecname, \c_routine, \processing
>  	.endm
>  
> -/* Include .intrpt1 array of interrupt vectors */
> -	.section ".intrpt1", "ax"
> +/* Include .intrpt array of interrupt vectors */
> +	.section ".intrpt", "ax"
> +	.global intrpt_start
> +intrpt_start:
>  
>  #define op_handle_perf_interrupt bad_intr
>  #define op_handle_aux_perf_interrupt bad_intr
> @@ -1484,6 +1577,11 @@ STD_ENTRY(fill_ra_stack)
>  #define do_hardwall_trap bad_intr
>  #endif
>  
> +#ifndef CONFIG_KVM
> +#define kvm_vpgtable_miss bad_intr
> +#define kvm_vguest_fatal bad_intr
> +#endif
> +
>  	int_hand     INT_MEM_ERROR, MEM_ERROR, do_trap
>  	int_hand     INT_SINGLE_STEP_3, SINGLE_STEP_3, bad_intr
>  #if CONFIG_KERNEL_PL == 2
> @@ -1504,14 +1602,24 @@ STD_ENTRY(fill_ra_stack)
>  	int_hand     INT_SWINT_3, SWINT_3, do_trap
>  	int_hand     INT_SWINT_2, SWINT_2, do_trap
>  	int_hand     INT_SWINT_1, SWINT_1, SYSCALL, handle_syscall
> +#ifdef CONFIG_KVM
> +	int_hand_kvm_hcall INT_SWINT_0, SWINT_0, kvm_hypervisor_call
> +#else
>  	int_hand     INT_SWINT_0, SWINT_0, do_trap
> +#endif
>  	int_hand     INT_ILL_TRANS, ILL_TRANS, do_trap
>  	int_hand_unalign_fast INT_UNALIGN_DATA, UNALIGN_DATA
>  	int_hand     INT_DTLB_MISS, DTLB_MISS, do_page_fault
>  	int_hand     INT_DTLB_ACCESS, DTLB_ACCESS, do_page_fault
>  	int_hand     INT_IDN_FIREWALL, IDN_FIREWALL, do_hardwall_trap
>  	int_hand     INT_UDN_FIREWALL, UDN_FIREWALL, do_hardwall_trap
> +#ifndef CONFIG_KVM_GUEST
>  	int_hand     INT_TILE_TIMER, TILE_TIMER, do_timer_interrupt
> +	int_hand     INT_AUX_TILE_TIMER, AUX_TILE_TIMER, bad_intr
> +#else
> +	int_hand     INT_TILE_TIMER, TILE_TIMER, bad_intr
> +	int_hand     INT_AUX_TILE_TIMER, AUX_TILE_TIMER, do_timer_interrupt
> +#endif
>  	int_hand     INT_IDN_TIMER, IDN_TIMER, bad_intr
>  	int_hand     INT_UDN_TIMER, UDN_TIMER, bad_intr
>  	int_hand     INT_IDN_AVAIL, IDN_AVAIL, bad_intr
> @@ -1541,8 +1649,10 @@ STD_ENTRY(fill_ra_stack)
>  	int_hand     INT_MESSAGE_RCV_DWNCL, MESSAGE_RCV_DWNCL, \
>  		     hv_message_intr
>  	int_hand     INT_DEV_INTR_DWNCL, DEV_INTR_DWNCL, bad_intr
> -	int_hand     INT_I_ASID, I_ASID, bad_intr
> -	int_hand     INT_D_ASID, D_ASID, bad_intr
> +	int_hand     INT_VPGTABLE_MISS_DWNCL, VPGTABLE_MISS_DWNCL, \
> +	             kvm_vpgtable_miss
> +	int_hand     INT_VGUEST_FATAL_DWNCL, VGUEST_FATAL_DWNCL, \
> +		     kvm_vguest_fatal
>  	int_hand     INT_DOUBLE_FAULT, DOUBLE_FAULT, do_trap
>  
>  	/* Synthetic interrupt delivered only by the simulator */
> diff --git a/arch/tile/kernel/kvm_virtio.c b/arch/tile/kernel/kvm_virtio.c
> new file mode 100644
> index 0000000..c6b6c6a
> --- /dev/null
> +++ b/arch/tile/kernel/kvm_virtio.c
> @@ -0,0 +1,430 @@
> +/*
> + * Copyright 2013 Tilera Corporation. All Rights Reserved.
> + *
> + *   This program is free software; you can redistribute it and/or
> + *   modify it under the terms of the GNU General Public License
> + *   as published by the Free Software Foundation, version 2.
> + *
> + *   This program is distributed in the hope that it will be useful, but
> + *   WITHOUT ANY WARRANTY; without even the implied warranty of
> + *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
> + *   NON INFRINGEMENT.  See the GNU General Public License for
> + *   more details.
> + */
> +
> +/* Referred lguest & s390 implemenation */
> +/*
> + * kvm_virtio.c - virtio for kvm on s390
> + *
> + * Copyright IBM Corp. 2008
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License (version 2 only)
> + * as published by the Free Software Foundation.
> + *
> + *    Author(s): Christian Borntraeger <borntraeger@de.ibm.com>
> + */
> +
> +#include <linux/bootmem.h>
> +#include <linux/io.h>
> +#include <linux/vmalloc.h>
> +#include <linux/interrupt.h>
> +#include <linux/irq.h>
> +#include <linux/export.h>
> +#include <linux/virtio.h>
> +#include <linux/virtio_config.h>
> +#include <linux/virtio_console.h>
> +#include <linux/virtio_ring.h>
> +#include <linux/virtio_pci.h>
> +
> +#include <linux/kvm_para.h>
> +#include <asm/kvm_virtio.h>
> +
> +static void *kvm_devices;
> +
> +/*
> + * TODO: We actually does not use PCI virtio here. We use this
> + * because qemu: virtqueue_init() uses VIRTIO_PCI_VRING_ALIGN.
> + * Maybe we should change them to generic definitions in both qemu & Linux.
> + * Besides, Let's check whether the alignment value (4096, i.e. default
> + * x86 page size) affects performance later.
> + */
> +#define KVM_TILE_VIRTIO_RING_ALIGN	VIRTIO_PCI_VRING_ALIGN
> +#define to_kvmdev(vd)	container_of(vd, struct kvm_device, vdev)
> +
> +/*
> + * memory layout: (Total: PAGE_SIZE)
> + * <device 0>
> + * - kvm device descriptor
> + *        struct kvm_device_desc
> + * - vqueue configuration (totally desc->num_vq)
> + *        struct kvm_vqconfig
> + *        ......
> + *        struct kvm_vqconfig
> + * - feature bits (size: desc->feature_len * 2)
> + * - config space (size: desc->config_len)
> + * <device 1>
> + * ......
> + */
> +static struct kvm_vqconfig *kvm_vq_config(const struct kvm_device_desc *desc)
> +{
> +	return (struct kvm_vqconfig *)(desc + 1);
> +}
> +
> +static u8 *kvm_vq_features(const struct kvm_device_desc *desc)
> +{
> +	return (u8 *)(kvm_vq_config(desc) + desc->num_vq);
> +}
> +
> +static u8 *kvm_vq_configspace(const struct kvm_device_desc *desc)
> +{
> +	return kvm_vq_features(desc) + desc->feature_len * 2;
> +}
> +
> +/*
> + * The total size of the config page used by this device (incl. desc)
> + */
> +static unsigned desc_size(const struct kvm_device_desc *desc)
> +{
> +	return sizeof(*desc)
> +		+ desc->num_vq * sizeof(struct kvm_vqconfig)
> +		+ desc->feature_len * 2
> +		+ desc->config_len;
> +}
> +
> +/* This gets the device's feature bits. */
> +static u32 kvm_get_features(struct virtio_device *vdev)
> +{
> +	unsigned int i;
> +	u32 features = 0;
> +	struct kvm_device_desc *desc = to_kvmdev(vdev)->desc;
> +	u8 *in_features = kvm_vq_features(desc);
> +
> +	for (i = 0; i < min(desc->feature_len * 8, 32); i++)
> +		if (in_features[i / 8] & (1 << (i % 8)))
> +			features |= (1 << i);
> +	return features;
> +}
> +
> +static void kvm_finalize_features(struct virtio_device *vdev)
> +{
> +	unsigned int i, bits;
> +	struct kvm_device_desc *desc = to_kvmdev(vdev)->desc;
> +	/* Second half of bitmap is features we accept. */
> +	u8 *out_features = kvm_vq_features(desc) + desc->feature_len;
> +
> +	/* Give virtio_ring a chance to accept features. */
> +	vring_transport_features(vdev);
> +
> +	memset(out_features, 0, desc->feature_len);
> +	bits = min_t(unsigned, desc->feature_len, sizeof(vdev->features)) * 8;
> +	for (i = 0; i < bits; i++) {
> +		if (test_bit(i, vdev->features))
> +			out_features[i / 8] |= (1 << (i % 8));
> +	}
> +}
> +
> +/*
> + * Reading and writing elements in config space
> + */
> +static void kvm_get(struct virtio_device *vdev, unsigned int offset,
> +		   void *buf, unsigned len)
> +{
> +	struct kvm_device_desc *desc = to_kvmdev(vdev)->desc;
> +
> +	BUG_ON(offset + len > desc->config_len);
> +	memcpy(buf, kvm_vq_configspace(desc) + offset, len);
> +}
> +
> +static void kvm_set(struct virtio_device *vdev, unsigned int offset,
> +		   const void *buf, unsigned len)
> +{
> +	struct kvm_device_desc *desc = to_kvmdev(vdev)->desc;
> +
> +	BUG_ON(offset + len > desc->config_len);
> +	memcpy(kvm_vq_configspace(desc) + offset, buf, len);
> +}
> +
> +/*
> + * The operations to get and set the status word just access
> + * the status field of the device descriptor. set_status will also
> + * make a hypercall to the host, to tell about status changes
> + */
> +static u8 kvm_get_status(struct virtio_device *vdev)
> +{
> +	return to_kvmdev(vdev)->desc->status;
> +}
> +
> +static void kvm_set_status(struct virtio_device *vdev, u8 status)
> +{
> +	BUG_ON(!status);
> +	to_kvmdev(vdev)->desc->status = status;
> +	hcall_virtio(KVM_VIRTIO_SET_STATUS, to_kvmdev(vdev)->desc_pa);
> +}
> +
> +/*
> + * To reset the device, we use the KVM_VIRTIO_RESET hypercall, using the
> + * descriptor address. The Host will zero the status and all the
> + * features.
> + */
> +static void kvm_reset(struct virtio_device *vdev)
> +{
> +	hcall_virtio(KVM_VIRTIO_RESET, to_kvmdev(vdev)->desc_pa);
> +}
> +
> +/*
> + * When the virtio_ring code wants to notify the Host, it calls us here and we
> + * make a hypercall.  We hand the address  of the virtqueue so the Host
> + * knows which virtqueue we're talking about.
> + */
> +static void kvm_notify(struct virtqueue *vq)
> +{
> +	struct kvm_vqinfo *vqi = vq->priv;
> +
> +	hcall_virtio(KVM_VIRTIO_NOTIFY, vqi->config->pa);
> +}
> +
> +/*
> + * Must set some caching mode to keep set_pte() happy.
> + * It doesn't matter what we choose, because the PFN
> + * is illegal, so we're going to take a page fault anyway.
> + */
> +static inline pgprot_t io_prot(void)
> +{
> +	return hv_pte_set_mode(PAGE_KERNEL, HV_PTE_MODE_UNCACHED);
> +}
> +
> +/*
> + * This routine finds the first virtqueue described in the configuration of
> + * this device and sets it up.
> + */
> +static struct virtqueue *kvm_find_vq(struct virtio_device *vdev,
> +				     unsigned index,
> +				     void (*callback)(struct virtqueue *vq),
> +				     const char *name)
> +{
> +	struct kvm_device *kdev = to_kvmdev(vdev);
> +	struct kvm_vqinfo *vqi;
> +	struct kvm_vqconfig *config;
> +	struct virtqueue *vq;
> +	long irq;
> +	int err = -EINVAL;
> +
> +	if (index >= kdev->desc->num_vq)
> +		return ERR_PTR(-ENOENT);
> +
> +	vqi = kzalloc(sizeof(*vqi), GFP_KERNEL);
> +	if (!vqi)
> +		return ERR_PTR(-ENOMEM);
> +
> +	config = kvm_vq_config(kdev->desc)+index;
> +
> +	vqi->config = config;
> +	vqi->pages = generic_remap_prot(config->pa,
> +				vring_size(config->num,
> +					KVM_TILE_VIRTIO_RING_ALIGN),
> +					0, io_prot());
> +	if (!vqi->pages) {
> +		err = -ENOMEM;
> +		goto out;
> +	}
> +
> +	vq = vring_new_virtqueue(index, config->num, KVM_TILE_VIRTIO_RING_ALIGN,
> +				 vdev, 0, vqi->pages,
> +				 kvm_notify, callback, name);
> +	if (!vq) {
> +		err = -ENOMEM;
> +		goto unmap;
> +	}
> +
> +	/*
> +	 * Trigger the IPI interrupt in SW way.
> +	 * TODO: We do not need to create one irq for each vq. A bit wasteful.
> +	 */
> +	irq = create_irq();
> +	if (irq < 0) {
> +		err = -ENXIO;
> +		goto del_virtqueue;
> +	}
> +
> +	tile_irq_activate(irq, TILE_IRQ_SW_CLEAR);
> +
> +	if (request_irq(irq, vring_interrupt, 0, dev_name(&vdev->dev), vq)) {
> +		err = -ENXIO;
> +		destroy_irq(irq);
> +		goto del_virtqueue;
> +	}
> +
> +	config->irq = irq;
> +
> +	vq->priv = vqi;
> +	return vq;
> +
> +del_virtqueue:
> +	vring_del_virtqueue(vq);
> +unmap:
> +	vunmap(vqi->pages);
> +out:
> +	return ERR_PTR(err);
> +}
> +
> +static void kvm_del_vq(struct virtqueue *vq)
> +{
> +	struct kvm_vqinfo *vqi = vq->priv;
> +
> +	vring_del_virtqueue(vq);
> +	vunmap(vqi->pages);
> +	kfree(vqi);
> +}
> +
> +static void kvm_del_vqs(struct virtio_device *vdev)
> +{
> +	struct virtqueue *vq, *n;
> +
> +	list_for_each_entry_safe(vq, n, &vdev->vqs, list)
> +		kvm_del_vq(vq);
> +}
> +
> +static int kvm_find_vqs(struct virtio_device *vdev, unsigned nvqs,
> +			struct virtqueue *vqs[],
> +			vq_callback_t *callbacks[],
> +			const char *names[])
> +{
> +	struct kvm_device *kdev = to_kvmdev(vdev);
> +	int i;
> +
> +	/* We must have this many virtqueues. */
> +	if (nvqs > kdev->desc->num_vq)
> +		return -ENOENT;
> +
> +	for (i = 0; i < nvqs; ++i) {
> +		vqs[i] = kvm_find_vq(vdev, i, callbacks[i], names[i]);
> +		if (IS_ERR(vqs[i]))
> +			goto error;
> +	}
> +	return 0;
> +
> +error:
> +	kvm_del_vqs(vdev);
> +	return PTR_ERR(vqs[i]);
> +}
> +
> +/*
> + * The config ops structure as defined by virtio config
> + */
> +static struct virtio_config_ops kvm_vq_config_ops = {
> +	.get_features = kvm_get_features,
> +	.finalize_features = kvm_finalize_features,
> +	.get = kvm_get,
> +	.set = kvm_set,
> +	.get_status = kvm_get_status,
> +	.set_status = kvm_set_status,
> +	.reset = kvm_reset,
> +	.find_vqs = kvm_find_vqs,
> +	.del_vqs = kvm_del_vqs,
> +};
> +
> +/*
> + * The root device for the kvm virtio devices.
> + * This makes them appear as /sys/devices/kvm_tile/0,1,2 not /sys/devices/0,1,2.
> + */
> +static struct device *kvm_root;
> +
> +/*
> + * adds a new device and register it with virtio
> + * appropriate drivers are loaded by the device model
> + */
> +static void add_kvm_device(struct kvm_device_desc *d, unsigned int offset)
> +{
> +	struct kvm_device *kdev;
> +
> +	kdev = kzalloc(sizeof(*kdev), GFP_KERNEL);
> +	if (!kdev) {
> +		pr_emerg("Cannot allocate kvm dev %u type %u\n",
> +			 offset, d->type);
> +		return;
> +	}
> +
> +	kdev->vdev.dev.parent = kvm_root;
> +	kdev->vdev.id.device = d->type;
> +	kdev->vdev.config = &kvm_vq_config_ops;
> +	kdev->desc = d;
> +	kdev->desc_pa = PFN_PHYS(max_pfn) + offset;
> +
> +	if (register_virtio_device(&kdev->vdev) != 0) {
> +		pr_err("Failed to register kvm device %u type %u\n",
> +		       offset, d->type);
> +		kfree(kdev);
> +	}
> +}
> +
> +/*
> + * scan_devices() simply iterates through the device page.
> + * The type 0 is reserved to mean "end of devices".
> + */
> +static void scan_devices(void)
> +{
> +	unsigned int i;
> +	struct kvm_device_desc *d;
> +
> +	for (i = 0; i < PAGE_SIZE; i += desc_size(d)) {
> +		d = kvm_devices + i;
> +
> +		if (d->type == 0)
> +			break;
> +
> +		add_kvm_device(d, i);
> +	}
> +}
> +
> +/*
> + * Init function for virtio.
> + * devices are in a single page above the top of "normal" mem.
> + */
> +static int __init kvm_devices_init(void)
> +{
> +	int rc = -ENOMEM;
> +
> +	kvm_root = root_device_register("kvm_tile");
> +	if (IS_ERR(kvm_root)) {
> +		rc = PTR_ERR(kvm_root);
> +		pr_err("Could not register kvm_tile root device");
> +		return rc;
> +	}
> +
> +	kvm_devices = generic_remap_prot(PFN_PHYS(max_pfn), PAGE_SIZE,
> +					 0, io_prot());
> +	if (!kvm_devices) {
> +		kvm_devices = NULL;
> +		root_device_unregister(kvm_root);
> +		return rc;
> +	}
> +
> +	scan_devices();
> +	return 0;
> +}
> +
> +/* code for early console output with virtio_console */
> +static __init int early_put_chars(u32 vtermno, const char *buf, int len)
> +{
> +	char scratch[512];
> +
> +	if (len > sizeof(scratch) - 1)
> +		len = sizeof(scratch) - 1;
> +	scratch[len] = '\0';
> +	memcpy(scratch, buf, len);
> +	hcall_virtio(KVM_VIRTIO_NOTIFY, __pa(scratch));
> +
> +	return len;
> +}
> +
> +static int __init tile_virtio_console_init(void)
> +{
> +	return virtio_cons_early_init(early_put_chars);
> +}
> +console_initcall(tile_virtio_console_init);
> +
> +/*
> + * We do this after core stuff, but before the drivers.
> + */
> +postcore_initcall(kvm_devices_init);
> diff --git a/arch/tile/kernel/process.c b/arch/tile/kernel/process.c
> index 44cdc4a..2629ff1 100644
> --- a/arch/tile/kernel/process.c
> +++ b/arch/tile/kernel/process.c
> @@ -27,6 +27,7 @@
>  #include <linux/kernel.h>
>  #include <linux/tracehook.h>
>  #include <linux/signal.h>
> +#include <linux/kvm_host.h>
>  #include <asm/stack.h>
>  #include <asm/switch_to.h>
>  #include <asm/homecache.h>
> @@ -247,11 +248,13 @@ struct task_struct *validate_current(void)
>  /* Take and return the pointer to the previous task, for schedule_tail(). */
>  struct task_struct *sim_notify_fork(struct task_struct *prev)
>  {
> +#ifndef CONFIG_KVM_GUEST   /* see notify_sim_task_change() */
>  	struct task_struct *tsk = current;
>  	__insn_mtspr(SPR_SIM_CONTROL, SIM_CONTROL_OS_FORK_PARENT |
>  		     (tsk->thread.creator_pid << _SIM_CONTROL_OPERATOR_BITS));
>  	__insn_mtspr(SPR_SIM_CONTROL, SIM_CONTROL_OS_FORK |
>  		     (tsk->pid << _SIM_CONTROL_OPERATOR_BITS));
> +#endif
>  	return prev;
>  }
>  
> @@ -450,6 +453,11 @@ void _prepare_arch_switch(struct task_struct *next)
>  struct task_struct *__sched _switch_to(struct task_struct *prev,
>  				       struct task_struct *next)
>  {
> +#ifdef CONFIG_KVM
> +	/* vmexit is needed before context switch. */
> +	BUG_ON(task_thread_info(prev)->vcpu);
> +#endif
> +
>  	/* DMA state is already saved; save off other arch state. */
>  	save_arch_state(&prev->thread);
>  
> @@ -519,6 +527,29 @@ int do_work_pending(struct pt_regs *regs, u32 thread_info_flags)
>  	/* Enable interrupts; they are disabled again on return to caller. */
>  	local_irq_enable();
>  
> +#ifdef CONFIG_KVM
> +	/*
> +	 * Some work requires us to exit the VM first.  Typically this
> +	 * allows the process running the VM to respond to the work
> +	 * (e.g. a signal), or allows the VM mechanism to latch
> +	 * modified host state (e.g. a "hypervisor" message sent to a
> +	 * different vcpu).  It also means that if we are considering
> +	 * calling schedule(), we exit the VM first, so we never have
> +	 * to worry about context-switching into a VM.
> +	 */
> +	if (current_thread_info()->vcpu) {
> +		u32 do_exit = thread_info_flags &
> +			(_TIF_NEED_RESCHED|_TIF_SIGPENDING|_TIF_VIRT_EXIT);
> +
> +		if (thread_info_flags & _TIF_VIRT_EXIT)
> +			clear_thread_flag(TIF_VIRT_EXIT);
> +		if (do_exit) {
> +			kvm_trigger_vmexit(regs, KVM_EXIT_AGAIN);
> +			/*NORETURN*/
> +		}
> +	}
> +#endif
> +
>  	if (thread_info_flags & _TIF_NEED_RESCHED) {
>  		schedule();
>  		return 1;
> @@ -538,11 +569,12 @@ int do_work_pending(struct pt_regs *regs, u32 thread_info_flags)
>  		tracehook_notify_resume(regs);
>  		return 1;
>  	}
> -	if (thread_info_flags & _TIF_SINGLESTEP) {
> +
> +	/* Handle a few flags here that stay set. */
> +	if (thread_info_flags & _TIF_SINGLESTEP)
>  		single_step_once(regs);
> -		return 0;
> -	}
> -	panic("work_pending: bad flags %#x\n", thread_info_flags);
> +
> +	return 0;
>  }
>  
>  unsigned long get_wchan(struct task_struct *p)
> diff --git a/arch/tile/kernel/relocate_kernel_64.S b/arch/tile/kernel/relocate_kernel_64.S
> index 1c09a4f..02bc446 100644
> --- a/arch/tile/kernel/relocate_kernel_64.S
> +++ b/arch/tile/kernel/relocate_kernel_64.S
> @@ -34,11 +34,11 @@ STD_ENTRY(relocate_new_kernel)
>  	addi	sp, sp, -8
>  	/* we now have a stack (whether we need one or not) */
>  
> +#ifdef RELOCATE_NEW_KERNEL_VERBOSE
>  	moveli	r40, hw2_last(hv_console_putc)
>  	shl16insli r40, r40, hw1(hv_console_putc)
>  	shl16insli r40, r40, hw0(hv_console_putc)
>  
> -#ifdef RELOCATE_NEW_KERNEL_VERBOSE
>  	moveli	r0, 'r'
>  	jalr	r40
>  
> @@ -176,10 +176,12 @@ STD_ENTRY(relocate_new_kernel)
>  
>  	/* we should not get here */
>  
> +#ifdef RELOCATE_NEW_KERNEL_VERBOSE
>  	moveli	r0, '?'
>  	jalr	r40
>  	moveli	r0, '\n'
>  	jalr	r40
> +#endif
>  
>  	j	.Lhalt
>  
> @@ -237,7 +239,9 @@ STD_ENTRY(relocate_new_kernel)
>  	j	.Lloop
>  
>  
> -.Lerr:	moveli	r0, 'e'
> +.Lerr:
> +#ifdef RELOCATE_NEW_KERNEL_VERBOSE
> +	moveli	r0, 'e'
>  	jalr	r40
>  	moveli	r0, 'r'
>  	jalr	r40
> @@ -245,6 +249,7 @@ STD_ENTRY(relocate_new_kernel)
>  	jalr	r40
>  	moveli	r0, '\n'
>  	jalr	r40
> +#endif
>  .Lhalt:
>  	moveli r41, hw2_last(hv_halt)
>  	shl16insli r41, r41, hw1(hv_halt)
> diff --git a/arch/tile/kernel/setup.c b/arch/tile/kernel/setup.c
> index 774e819..2352a81 100644
> --- a/arch/tile/kernel/setup.c
> +++ b/arch/tile/kernel/setup.c
> @@ -268,7 +268,7 @@ early_param("vmalloc", parse_vmalloc);
>  /*
>   * Determine for each controller where its lowmem is mapped and how much of
>   * it is mapped there.  On controller zero, the first few megabytes are
> - * already mapped in as code at MEM_SV_INTRPT, so in principle we could
> + * already mapped in as code at MEM_SV_START, so in principle we could
>   * start our data mappings higher up, but for now we don't bother, to avoid
>   * additional confusion.
>   *
> @@ -1074,7 +1074,20 @@ void __cpuinit setup_cpu(int boot)
>  	 * SPRs, as well as the interrupt mask.
>  	 */
>  	__insn_mtspr(SPR_MPL_INTCTRL_0_SET_0, 1);
> +
> +#ifdef CONFIG_KVM
> +	/*
> +	 * If we launch a guest kernel, it will need some interrupts
> +	 * that otherwise are not used by the host or by userspace.
> +	 * Set them to MPL 1 now and leave them alone going forward;
> +	 * they are masked in the host so will never fire there anyway,
> +	 * and we mask them at PL1 as we exit the guest.
> +	 */
>  	__insn_mtspr(SPR_MPL_INTCTRL_1_SET_1, 1);
> +	__insn_mtspr(SPR_MPL_SINGLE_STEP_1_SET_1, 1);
> +	__insn_mtspr(SPR_MPL_AUX_TILE_TIMER_SET_1, 1);
> +	__insn_mtspr(SPR_MPL_IPI_1_SET_1, 1);
> +#endif
>  
>  	/* Initialize IRQ support for this cpu. */
>  	setup_irq_regs();
> @@ -1242,7 +1255,7 @@ static void __init validate_va(void)
>  #ifndef __tilegx__   /* FIXME: GX: probably some validation relevant here */
>  	/*
>  	 * Similarly, make sure we're only using allowed VAs.
> -	 * We assume we can contiguously use MEM_USER_INTRPT .. MEM_HV_INTRPT,
> +	 * We assume we can contiguously use MEM_USER_INTRPT .. MEM_HV_START,
>  	 * and 0 .. KERNEL_HIGH_VADDR.
>  	 * In addition, make sure we CAN'T use the end of memory, since
>  	 * we use the last chunk of each pgd for the pgd_list.
> @@ -1257,7 +1270,7 @@ static void __init validate_va(void)
>  		if (range.size == 0)
>  			break;
>  		if (range.start <= MEM_USER_INTRPT &&
> -		    range.start + range.size >= MEM_HV_INTRPT)
> +		    range.start + range.size >= MEM_HV_START)
>  			user_kernel_ok = 1;
>  		if (range.start == 0)
>  			max_va = range.size;
> @@ -1693,7 +1706,7 @@ insert_ram_resource(u64 start_pfn, u64 end_pfn, bool reserved)
>  static int __init request_standard_resources(void)
>  {
>  	int i;
> -	enum { CODE_DELTA = MEM_SV_INTRPT - PAGE_OFFSET };
> +	enum { CODE_DELTA = MEM_SV_START - PAGE_OFFSET };
>  
>  #if defined(CONFIG_PCI) && !defined(__tilegx__)
>  	insert_non_bus_resource();
> diff --git a/arch/tile/kernel/smp.c b/arch/tile/kernel/smp.c
> index 0ae1c59..62b3ba9 100644
> --- a/arch/tile/kernel/smp.c
> +++ b/arch/tile/kernel/smp.c
> @@ -223,30 +223,34 @@ void __init ipi_init(void)
>  
>  #if CHIP_HAS_IPI()
>  
> -void smp_send_reschedule(int cpu)
> +static void __smp_send_reschedule(int cpu)
>  {
> -	WARN_ON(cpu_is_offline(cpu));
> -
>  	/*
>  	 * We just want to do an MMIO store.  The traditional writeq()
>  	 * functions aren't really correct here, since they're always
>  	 * directed at the PCI shim.  For now, just do a raw store,
> -	 * casting away the __iomem attribute.
> +	 * casting away the __iomem attribute.  We do the store as a
> +	 * single asm() instruction to ensure that we can force a step
> +	 * over it in the KVM case, if we are not binding vcpus to cpus,
> +	 * rather than require it to be possible to issue validly.
>  	 */
> -	((unsigned long __force *)ipi_mappings[cpu])[IRQ_RESCHEDULE] = 0;
> +	unsigned long *addr =
> +		&((unsigned long __force *)ipi_mappings[cpu])[IRQ_RESCHEDULE];
> +	asm volatile("st %0, zero" :: "r" (addr));
>  }
>  
>  #else
>  
> -void smp_send_reschedule(int cpu)
> +static void __smp_send_reschedule(int cpu)
>  {
> -	HV_Coord coord;
> -
> -	WARN_ON(cpu_is_offline(cpu));
> -
> -	coord.y = cpu_y(cpu);
> -	coord.x = cpu_x(cpu);
> +	HV_Coord coord = { .y = cpu_y(cpu), .x = cpu_x(cpu) };
>  	hv_trigger_ipi(coord, IRQ_RESCHEDULE);
>  }
>  
>  #endif /* CHIP_HAS_IPI() */
> +
> +void smp_send_reschedule(int cpu)
> +{
> +	WARN_ON(cpu_is_offline(cpu));
> +	__smp_send_reschedule(cpu);
> +}
> diff --git a/arch/tile/kernel/stack.c b/arch/tile/kernel/stack.c
> index 24fd223..362284a 100644
> --- a/arch/tile/kernel/stack.c
> +++ b/arch/tile/kernel/stack.c
> @@ -103,7 +103,7 @@ static struct pt_regs *valid_fault_handler(struct KBacktraceIterator* kbt)
>  	    p->sp >= sp) {
>  		if (kbt->verbose)
>  			pr_err("  <%s while in kernel mode>\n", fault);
> -	} else if (EX1_PL(p->ex1) == USER_PL &&
> +	} else if (user_mode(p) &&
>  		   p->sp < PAGE_OFFSET && p->sp != 0) {
>  		if (kbt->verbose)
>  			pr_err("  <%s while in user mode>\n", fault);
> diff --git a/arch/tile/kernel/sysfs.c b/arch/tile/kernel/sysfs.c
> index e25b0a8..024b978 100644
> --- a/arch/tile/kernel/sysfs.c
> +++ b/arch/tile/kernel/sysfs.c
> @@ -69,7 +69,11 @@ static ssize_t type_show(struct device *dev,
>  			    struct device_attribute *attr,
>  			    char *page)
>  {
> +#ifdef CONFIG_KVM_GUEST
> +	return sprintf(page, "KVM\n");
> +#else
>  	return sprintf(page, "tilera\n");
> +#endif
>  }
>  static DEVICE_ATTR(type, 0444, type_show, NULL);
>  
> diff --git a/arch/tile/kernel/time.c b/arch/tile/kernel/time.c
> index 3c2dc87..b0b7264 100644
> --- a/arch/tile/kernel/time.c
> +++ b/arch/tile/kernel/time.c
> @@ -117,9 +117,9 @@ void __init time_init(void)
>  
>  /*
>   * Define the tile timer clock event device.  The timer is driven by
> - * the TILE_TIMER_CONTROL register, which consists of a 31-bit down
> + * the TILE_[AUX_]TIMER_CONTROL register, which consists of a 31-bit down
>   * counter, plus bit 31, which signifies that the counter has wrapped
> - * from zero to (2**31) - 1.  The INT_TILE_TIMER interrupt will be
> + * from zero to (2**31) - 1.  The INT_[AUX_]TILE_TIMER interrupt will be
>   * raised as long as bit 31 is set.
>   */
>  
> @@ -129,8 +129,8 @@ static int tile_timer_set_next_event(unsigned long ticks,
>  				     struct clock_event_device *evt)
>  {
>  	BUG_ON(ticks > MAX_TICK);
> -	__insn_mtspr(SPR_TILE_TIMER_CONTROL, ticks);
> -	arch_local_irq_unmask_now(INT_TILE_TIMER);
> +	__insn_mtspr(SPR_LINUX_TIMER_CONTROL, ticks);
> +	arch_local_irq_unmask_now(INT_LINUX_TIMER);
>  	return 0;
>  }
>  
> @@ -141,7 +141,7 @@ static int tile_timer_set_next_event(unsigned long ticks,
>  static void tile_timer_set_mode(enum clock_event_mode mode,
>  				struct clock_event_device *evt)
>  {
> -	arch_local_irq_mask_now(INT_TILE_TIMER);
> +	arch_local_irq_mask_now(INT_LINUX_TIMER);
>  }
>  
>  static DEFINE_PER_CPU(struct clock_event_device, tile_timer) = {
> @@ -161,7 +161,7 @@ void __cpuinit setup_tile_timer(void)
>  	evt->cpumask = cpumask_of(smp_processor_id());
>  
>  	/* Start out with timer not firing. */
> -	arch_local_irq_mask_now(INT_TILE_TIMER);
> +	arch_local_irq_mask_now(INT_LINUX_TIMER);
>  
>  	/*
>  	 * Register tile timer.  Set min_delta to 1 microsecond, since
> @@ -181,7 +181,7 @@ void do_timer_interrupt(struct pt_regs *regs, int fault_num)
>  	 * Mask the timer interrupt here, since we are a oneshot timer
>  	 * and there are now by definition no events pending.
>  	 */
> -	arch_local_irq_mask(INT_TILE_TIMER);
> +	arch_local_irq_mask(INT_LINUX_TIMER);
>  
>  	/* Track time spent here in an interrupt context */
>  	irq_enter();
> diff --git a/arch/tile/kernel/traps.c b/arch/tile/kernel/traps.c
> index f110785..19d465c 100644
> --- a/arch/tile/kernel/traps.c
> +++ b/arch/tile/kernel/traps.c
> @@ -30,7 +30,7 @@
>  
>  void __init trap_init(void)
>  {
> -	/* Nothing needed here since we link code at .intrpt1 */
> +	/* Nothing needed here since we link code at .intrpt */
>  }
>  
>  int unaligned_fixup = 1;
> diff --git a/arch/tile/kernel/vmlinux.lds.S b/arch/tile/kernel/vmlinux.lds.S
> index c7ae53d..8b20163 100644
> --- a/arch/tile/kernel/vmlinux.lds.S
> +++ b/arch/tile/kernel/vmlinux.lds.S
> @@ -5,7 +5,7 @@
>  #include <hv/hypervisor.h>
>  
>  /* Text loads starting from the supervisor interrupt vector address. */
> -#define TEXT_OFFSET MEM_SV_INTRPT
> +#define TEXT_OFFSET MEM_SV_START
>  
>  OUTPUT_ARCH(tile)
>  ENTRY(_start)
> @@ -13,7 +13,7 @@ jiffies = jiffies_64;
>  
>  PHDRS
>  {
> -  intrpt1 PT_LOAD ;
> +  intrpt PT_LOAD ;
>    text PT_LOAD ;
>    data PT_LOAD ;
>  }
> @@ -24,11 +24,11 @@ SECTIONS
>    #define LOAD_OFFSET TEXT_OFFSET
>  
>    /* Interrupt vectors */
> -  .intrpt1 (LOAD_OFFSET) : AT ( 0 )   /* put at the start of physical memory */
> +  .intrpt (LOAD_OFFSET) : AT ( 0 )   /* put at the start of physical memory */
>    {
>      _text = .;
> -    *(.intrpt1)
> -  } :intrpt1 =0
> +    *(.intrpt)
> +  } :intrpt =0
>  
>    /* Hypervisor call vectors */
>    . = ALIGN(0x10000);
> diff --git a/arch/tile/kvm/Kconfig b/arch/tile/kvm/Kconfig
> index 2298cb1..65f7f9d 100644
> --- a/arch/tile/kvm/Kconfig
> +++ b/arch/tile/kvm/Kconfig
> @@ -27,9 +27,6 @@ config KVM
>  	  This module provides access to the hardware capabilities through
>  	  a character device node named /dev/kvm.
>  
> -	  To compile this as a module, choose M here: the module
> -	  will be called kvm.
> -
>  	  If unsure, say N.
>  
>  source drivers/vhost/Kconfig
> diff --git a/arch/tile/kvm/Makefile b/arch/tile/kvm/Makefile
> new file mode 100644
> index 0000000..2c3d206
> --- /dev/null
> +++ b/arch/tile/kvm/Makefile
> @@ -0,0 +1,12 @@
> +#
> +# Makefile for Kernel-based Virtual Machine module
> +#
> +
> +ccflags-y := -Ivirt/kvm -Iarch/tile/kvm
> +
> +kvm-y += $(addprefix ../../../virt/kvm/, kvm_main.o)
> +
> +kvm-y += kvm-tile.o
> +kvm-y += entry.o
> +
> +obj-$(CONFIG_KVM) += kvm.o
> diff --git a/arch/tile/kvm/entry.S b/arch/tile/kvm/entry.S
> new file mode 100644
> index 0000000..07aa3a6
> --- /dev/null
> +++ b/arch/tile/kvm/entry.S
> @@ -0,0 +1,91 @@
> +/*
> + * Copyright 2013 Tilera Corporation. All Rights Reserved.
> + *
> + *   This program is free software; you can redistribute it and/or
> + *   modify it under the terms of the GNU General Public License
> + *   as published by the Free Software Foundation, version 2.
> + *
> + *   This program is distributed in the hope that it will be useful, but
> + *   WITHOUT ANY WARRANTY; without even the implied warranty of
> + *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
> + *   NON INFRINGEMENT.  See the GNU General Public License for
> + *   more details.
> + */
> +
> +#include <linux/linkage.h>
> +#include <asm/switch_to.h>
> +#include <asm/processor.h>
> +#include <arch/spr_def.h>
> +#include <arch/abi.h>
> +
> +#define FRAME_SIZE ((4 + CALLEE_SAVED_REGS_COUNT) * 8)
> +#define SAVE_REG(r) { st r12, r; addi r12, r12, 8 }
> +#define LOAD_REG(r) { ld r, r12; addi r12, r12, 8 }
> +#define FOR_EACH_CALLEE_SAVED_REG(f)					\
> +							f(r30); f(r31); \
> +	f(r32); f(r33); f(r34); f(r35);	f(r36); f(r37); f(r38); f(r39); \
> +	f(r40); f(r41); f(r42); f(r43); f(r44); f(r45); f(r46); f(r47); \
> +	f(r48); f(r49); f(r50); f(r51); f(r52);
> +
> +/*
> + * Called with interrupts disabled from kvm_tile_run() and is responsible
> + * just for saving the callee-save registers and the stack pointer, then
> + * resetting ksp0 so subsequent interrupts don't wipe the kernel stack.
> + * It uses restore_all in intvec_64.S to jump back into the guest.
> + * The kvm_vmexit function below undoes the stack manipulation.
> + */
> +STD_ENTRY(kvm_vmresume)
> +	/* Do function prolog and save callee-saves on stack. */
> +	{
> +	  move r10, sp
> +	  st sp, lr
> +	}
> +	{
> +	  addli r11, sp, -FRAME_SIZE + 8
> +	  addli sp, sp, -FRAME_SIZE
> +	}
> +	{
> +	  st r11, r10
> +	  addi r12, sp, 16
> +	}
> +	FOR_EACH_CALLEE_SAVED_REG(SAVE_REG)
> +	SAVE_REG(tp)
> +	SAVE_REG(lr)
> +
> +	/* Save frame pointer in thread_info so we can get it back later. */
> +	st r1, sp
> +
> +	/* Set the ksp0 for this core to be below this frame. */
> +	mfspr r10, SPR_SYSTEM_SAVE_K_0
> +	bfins r10, sp, 0, CPU_SHIFT-1
> +	mtspr SPR_SYSTEM_SAVE_K_0, r10
> +
> +	/* sp points to ABI save area below pt_regs for restore_all. */
> +	addli sp, r0, -C_ABI_SAVE_AREA_SIZE
> +
> +	/* Execute an "interrupt return" to the guest. */
> +	{
> +	 movei r30, 0
> +	 j restore_all
> +	}
> +	STD_ENDPROC(kvm_vmresume)
> +
> +/*
> + * Called with interrupts disabled from kvm_trigger_vmexit(); returns with
> + * interrupts still disabled to kvm_vmresume()'s caller, discarding all the
> + * stack contents below the kvm_vmresume() frame.  kvm_vmresume()'s caller
> + * is responsible for resetting SPR_SYSTEM_SAVE_K_0 to its previous value.
> + */
> +STD_ENTRY(kvm_vmexit)
> +	{
> +	 move sp, r0
> +	 addi r12, r0, 16
> +	}
> +	FOR_EACH_CALLEE_SAVED_REG(LOAD_REG)
> +	LOAD_REG(tp)
> +	LOAD_REG(lr)
> +	{
> +	  addli sp, sp, FRAME_SIZE
> +	  jrp lr
> +	}
> +	STD_ENDPROC(kvm_vmexit)
> diff --git a/arch/tile/kvm/kvm-tile.c b/arch/tile/kvm/kvm-tile.c
> new file mode 100644
> index 0000000..4c33991
> --- /dev/null
> +++ b/arch/tile/kvm/kvm-tile.c
> @@ -0,0 +1,1581 @@
> +/*
> + * Copyright 2013 Tilera Corporation. All Rights Reserved.
> + *
> + *   This program is free software; you can redistribute it and/or
> + *   modify it under the terms of the GNU General Public License
> + *   as published by the Free Software Foundation, version 2.
> + *
> + *   This program is distributed in the hope that it will be useful, but
> + *   WITHOUT ANY WARRANTY; without even the implied warranty of
> + *   MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE, GOOD TITLE or
> + *   NON INFRINGEMENT.  See the GNU General Public License for
> + *   more details.
> + */
> +
> +#include <linux/err.h>
> +#include <linux/init.h>
> +#include <linux/fs.h>
> +#include <linux/kvm.h>
> +#include <linux/kvm_host.h>
> +#include <linux/kvm_types.h>
> +#include <linux/module.h>
> +#include <linux/types.h>
> +#include <linux/uaccess.h>
> +#include <linux/ptrace.h>
> +#include <asm/traps.h>
> +#include <asm/pgalloc.h>
> +#include <hv/hypervisor.h>
> +#include <linux/rtc.h>
> +#include <asm/atomic.h>
> +#include <asm/tlbflush.h>
> +#include <arch/spr_def.h>
> +#include <arch/sim.h>
> +#include <generated/utsrelease.h>
> +
> +
> +struct kvm_stats_debugfs_item debugfs_entries[] = {
> +	{ NULL }
> +};
> +
> +static pte_t *get_vpgd_pte(struct kvm *kvm, unsigned long address)
> +{
> +	struct mm_struct *mm = kvm->mm;
> +	pgd_t *pgd;
> +	pud_t *pud;
> +	pmd_t *pmd;
> +
> +	if (kvm->arch.vpgd == NULL)
> +		kvm->arch.vpgd = pgd_alloc(kvm->mm);
> +	pgd = kvm->arch.vpgd + pgd_index(address);
> +	pud = pud_alloc(mm, pgd, address);
> +	if (!pud)
> +		return NULL;
> +	pmd = pmd_alloc(mm, pud, address);
> +	if (!pmd)
> +		return NULL;
> +	return pte_alloc_kernel(pmd, address);
> +}
> +
> +int kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
> +{
> +	return VM_FAULT_SIGBUS;
> +}
> +
> +void kvm_arch_free_memslot(struct kvm_memory_slot *free,
> +			   struct kvm_memory_slot *dont)
> +{
> +}
> +
> +int kvm_arch_create_memslot(struct kvm_memory_slot *slot, unsigned long npages)
> +{
> +	return 0;
> +}
> +
> +/* FIXME: support huge pages. */
> +int kvm_arch_prepare_memory_region(struct kvm *kvm,
> +				   struct kvm_memory_slot *memslot,
> +				   struct kvm_userspace_memory_region *mem,
> +				   enum kvm_mr_change change)
> +{
> +	unsigned long gpa, i;
> +
> +	gpa = mem->guest_phys_addr;
> +	for (i = 0; i < mem->memory_size; i += PAGE_SIZE, gpa += PAGE_SIZE)
> +		if (get_vpgd_pte(kvm, gpa) == NULL)
> +			return -ENOMEM;
> +
> +	return 0;
> +}
> +
> +void kvm_arch_commit_memory_region(struct kvm *kvm,
> +				   struct kvm_userspace_memory_region *mem,
> +				   const struct kvm_memory_slot *old,
> +				   enum kvm_mr_change change)
> +{
> +	unsigned long gpa, address, pfn, i;
> +	struct page *page[1];
> +	pte_t *ptep, *vptep;
> +
> +	gpa = mem->guest_phys_addr;
> +	address = mem->userspace_addr;
> +	for (i = 0; i < mem->memory_size;
> +	     i += PAGE_SIZE, gpa += PAGE_SIZE, address += PAGE_SIZE) {
> +		vptep = get_vpgd_pte(kvm, gpa);
> +		BUG_ON(vptep == NULL);
> +		get_user_pages_fast(address, 1, 1, page);
> +		pfn = page_to_pfn(page[0]);
> +		ptep = virt_to_pte(NULL, (unsigned long)__va(PFN_PHYS(pfn)));
> +		*vptep = *ptep;
> +	}
> +}
> +
> +void kvm_arch_flush_shadow_all(struct kvm *kvm)
> +{
> +}
> +
> +void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
> +				   struct kvm_memory_slot *slot)
> +{
> +	kvm_arch_flush_shadow_all(kvm);
> +}
> +
> +gfn_t unalias_gfn(struct kvm *kvm, gfn_t gfn)
> +{
> +	return 0;
> +}
> +
> +long kvm_arch_dev_ioctl(struct file *filp,
> +			unsigned int ioctl, unsigned long arg)
> +{
> +	return 0;
> +}
> +
> +static int kvm_vcpu_ioctl_interrupt(struct kvm_vcpu *vcpu, unsigned long irq)
> +{
> +	if (irq < 0)
> +		return -EINVAL;
> +
> +	set_bit(irq, &vcpu->arch.ipi_events);
> +	kvm_vcpu_kick(vcpu);
> +
> +	return 0;
> +}
> +
> +long kvm_arch_vcpu_ioctl(struct file *filp,
> +			 unsigned int ioctl, unsigned long arg)
> +{
> +	struct kvm_vcpu *vcpu = filp->private_data;
> +	void __user *argp = (void __user *)arg;
> +	int r = 0;
> +
> +	switch (ioctl) {
> +	case KVM_INTERRUPT: {
> +		struct kvm_interrupt irq;
> +
> +		r = -EFAULT;
> +		if (copy_from_user(&irq, argp, sizeof(irq)))
> +			goto out;
> +		r = kvm_vcpu_ioctl_interrupt(vcpu, irq.irq);
> +		if (r)
> +			goto out;
> +		r = 0;
> +		break;
> +	}
> +	default:
> +		r = -EINVAL;
> +	}
> +
> +out:
> +	return r;
> +}
> +
> +int kvm_dev_ioctl_check_extension(long ext)
> +{
> +	return 0;
> +}
> +
> +int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
> +			       struct kvm_dirty_log *log)
> +{
> +	return 0;
> +}
> +
> +long kvm_arch_vm_ioctl(struct file *filp,
> +		       unsigned int ioctl, unsigned long arg)
> +{
> +	long r = -EINVAL;
> +
> +	return r;
> +}
> +
> +int kvm_arch_vcpu_ioctl_get_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
> +{
> +	return 0;
> +}
> +
> +int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
> +{
> +	return 0;
> +}
> +
> +int kvm_arch_vcpu_ioctl_translate(struct kvm_vcpu *vcpu,
> +				  struct kvm_translation *tr)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +	unsigned long page_size;
> +	unsigned long gva = tr->linear_address;
> +	unsigned long gpgd_gpa, gpmd_gpa, gpte_gpa;
> +	pud_t gpud;
> +	pmd_t gpmd;
> +	pte_t gpte;
> +
> +	/* Get guest pgd (aka pud for three-level tables). */
> +	gpgd_gpa = vcpu->arch.guest_context.page_table +
> +		(sizeof(pgd_t) * pgd_index(gva));
> +	if (kvm_read_guest(kvm, gpgd_gpa, &gpud, sizeof(pgd_t)) < 0)
> +		goto fail;
> +	if (!pud_present(gpud))
> +		goto fail;
> +
> +	/* Get guest pmd. */
> +	if (pud_huge_page(gpud)) {
> +		/* FIXME: no super huge page support yet. */
> +		if (pte_super(*(pte_t *)&gpud))
> +			goto fail;
> +		gpte = *(pte_t *)&gpud;
> +		page_size = PGDIR_SIZE;
> +		goto ok;
> +	}
> +	gpmd_gpa = (pud_ptfn(gpud) << HV_LOG2_PAGE_TABLE_ALIGN) +
> +		(sizeof(pmd_t) * pmd_index(gva));
> +	if (kvm_read_guest(kvm, gpmd_gpa, &gpmd, sizeof(pmd_t)) < 0)
> +		goto fail;
> +	if (!pmd_present(gpmd))
> +		goto fail;
> +
> +	/* Get guest pte. */
> +	if (pmd_huge_page(gpmd)) {
> +		/* FIXME: no super huge page support yet. */
> +		if (pte_super(*(pte_t *)&gpmd))
> +			goto fail;
> +		gpte = *(pte_t *)&gpmd;
> +		page_size = PMD_SIZE;
> +		goto ok;
> +	}
> +	gpte_gpa = (pmd_ptfn(gpmd) << HV_LOG2_PAGE_TABLE_ALIGN) +
> +		(sizeof(pte_t) * pte_index(gva));
> +	if (kvm_read_guest(kvm, gpte_gpa, &gpte, sizeof(pte_t)) < 0)
> +		goto fail;
> +	if (!pte_present(gpte))
> +		goto fail;
> +
> +	page_size = PAGE_SIZE;
> +
> +ok:
> +	tr->physical_address =
> +		PFN_PHYS(pte_pfn(gpte)) + (gva & (page_size - 1));
> +	tr->valid = 1;
> +	tr->writeable = pte_write(gpte);
> +	tr->usermode = pte_user(gpte);
> +
> +	return 0;
> +
> +fail:
> +	tr->valid = 0;
> +	return 0;
> +}
> +
> +int kvm_arch_vcpu_ioctl_get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
> +{
> +	regs->regs = vcpu->arch.regs;
> +	return 0;
> +}
> +
> +int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
> +{
> +	vcpu->arch.regs = regs->regs;
> +	vcpu->arch.regs.flags = PT_FLAGS_CALLER_SAVES | PT_FLAGS_RESTORE_REGS;
> +	return 0;
> +}
> +
> +int kvm_arch_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
> +				  struct kvm_sregs *sregs)
> +{
> +	*sregs = vcpu->arch.sregs;
> +	return 0;
> +}
> +
> +int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
> +				  struct kvm_sregs *sregs)
> +{
> +	vcpu->arch.sregs = *sregs;
> +	return 0;
> +}
> +
> +int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
> +				    struct kvm_mp_state *mp_state)
> +{
> +	return 0;
> +}
> +
> +int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
> +				    struct kvm_mp_state *mp_state)
> +{
> +	return 0;
> +}
> +
> +int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
> +					struct kvm_guest_debug *dbg)
> +{
> +	return 0;
> +}
> +
> +/*
> + * panic_hv() will dump stack info of both guest os and host os, and set
> + * proper exit reason so that qemu can terminate the guest process.
> + *
> + * FIXME: Probably KVM_EXIT_EXCEPTION?  If using KVM_EXIT_EXCEPTION,
> + * current qemu process will "hang" (killable but Ctrl+C not working),
> + * so use KVM_EXIT_SHUTDOWN here temporarily.
> + */
> +static int panic_hv(struct kvm_vcpu *vcpu, const char *fmt, ...)
> +{
> +	char panic_buf[256];
> +	struct pt_regs *regs;
> +	va_list ap;
> +	int i;
> +
> +	va_start(ap, fmt);
> +	vsnprintf(panic_buf, sizeof(panic_buf), fmt, ap);
> +	va_end(ap);
> +	pr_err("KVM guest panic (vcpu %d) - %s\n", vcpu->vcpu_id, panic_buf);
> +
> +	/* Show guest os info */
> +	regs = &vcpu->arch.regs;
> +	for (i = 0; i < 17; i++)
> +		pr_err(" r%-2d: "REGFMT" r%-2d: "REGFMT" r%-2d: "REGFMT"\n",
> +		       i, regs->regs[i], i+18, regs->regs[i+18],
> +		       i+36, regs->regs[i+36]);
> +	pr_err(" r18: "REGFMT" r35: "REGFMT" tp : "REGFMT"\n",
> +	       regs->regs[18], regs->regs[35], regs->tp);
> +	pr_err(" sp : "REGFMT" lr : "REGFMT"\n", regs->sp, regs->lr);
> +	pr_err(" pc : "REGFMT" ex1: %ld     faultnum: %ld\n",
> +	       regs->pc, regs->ex1, regs->faultnum);
> +
> +	/* Show host os info */
> +	pr_err("\nKVM stack in the host:\n");
> +	dump_stack();
> +
> +	/* Shut down the guest os */
> +	pr_err("Shutting down guest.\n");
> +	vcpu->run->exit_reason = KVM_EXIT_SHUTDOWN;
> +	return 0;
> +}
> +
> +/* Copied from virt/kvm/kvm_main.c */
> +static int next_segment(unsigned long len, int offset)
> +{
> +	if (len > PAGE_SIZE - offset)
> +		return PAGE_SIZE - offset;
> +	else
> +		return len;
> +}
> +
> +static int kvm_read_guest_va(struct kvm_vcpu *vcpu, unsigned long gva,
> +			     void *data, unsigned long len)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +	int seg;
> +	int offset = offset_in_page(gva);
> +	int ret;
> +
> +	while ((seg = next_segment(len, offset)) != 0) {
> +		struct kvm_translation tr;
> +		tr.linear_address = gva;
> +		kvm_arch_vcpu_ioctl_translate(vcpu, &tr);
> +		if (!tr.valid)
> +			return -EFAULT;
> +		ret = kvm_read_guest_page(kvm, PFN_DOWN(tr.physical_address),
> +					  data, offset, seg);
> +		if (ret < 0)
> +			return ret;
> +		offset = 0;
> +		len -= seg;
> +		data += seg;
> +		gva += seg;
> +	}
> +	return 0;
> +}
> +
> +static int kvm_write_guest_va(struct kvm_vcpu *vcpu, unsigned long gva,
> +			      const void *data, unsigned long len)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +	int seg;
> +	int offset = offset_in_page(gva);
> +	int ret;
> +
> +	while ((seg = next_segment(len, offset)) != 0) {
> +		struct kvm_translation tr;
> +		tr.linear_address = gva;
> +		kvm_arch_vcpu_ioctl_translate(vcpu, &tr);
> +		if (!tr.valid)
> +			return -EFAULT;
> +		ret = kvm_write_guest_page(kvm, PFN_DOWN(tr.physical_address),
> +					   data, offset, seg);
> +		if (ret < 0)
> +			return ret;
> +		offset = 0;
> +		len -= seg;
> +		data += seg;
> +		gva += seg;
> +	}
> +	return 0;
> +}
> +
> +static int kvm_clear_guest_va(struct kvm_vcpu *vcpu, unsigned long gva,
> +			      unsigned long len)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +	int seg;
> +	int offset = offset_in_page(gva);
> +	int ret;
> +
> +	while ((seg = next_segment(len, offset)) != 0) {
> +		struct kvm_translation tr;
> +		tr.linear_address = gva;
> +		kvm_arch_vcpu_ioctl_translate(vcpu, &tr);
> +		if (!tr.valid)
> +			return -EFAULT;
> +		ret = kvm_clear_guest_page(kvm, PFN_DOWN(tr.physical_address),
> +					   offset, seg);
> +		if (ret < 0)
> +			return ret;
> +		offset = 0;
> +		len -= seg;
> +		gva += seg;
> +	}
> +	return 0;
> +}
> +
> +/*
> + * The following functions are emulation functions for various
> + * hypervisor system calls (i.e. hv_*()). Return value:
> + *   1 if the host os can emulate it completely.
> + *   < 0 if errors occur and then qemu will handle them.
> + *   0 if qemu emulation is needed.
> + * In both the < 0 and the == 0 cases, exit reason should
> + * be set for qemu handling.
> + */
> +
> +/* generic handler for hypercall which needs user (QEMU) to handle. */
> +static int kvm_deliver_to_user(struct kvm_vcpu *vcpu)
> +{
> +	vcpu->run->exit_reason = KVM_EXIT_HYPERCALL;
> +	return 0;
> +}
> +
> +/* handler for illegal hypercall */
> +static int kvm_emulate_illegal(struct kvm_vcpu *vcpu)
> +{
> +	return panic_hv(vcpu, "Illegal kvm hypercall: %ld",
> +			(unsigned long)vcpu->arch.regs.regs[10]);
> +}
> +
> +static int kvm_emulate_hv_init(struct kvm_vcpu *vcpu)
> +{
> +	int version = vcpu->arch.regs.regs[0];
> +	int chip_num = vcpu->arch.regs.regs[1];
> +	int chip_rev_num = vcpu->arch.regs.regs[2];
> +	int client_pl = vcpu->arch.regs.regs[3];
> +
> +	if (client_pl != 1)
> +		return panic_hv(vcpu, "Guest is requesting PL %d, but KVM"
> +				" guests must request PL 1.\n"
> +				"Reconfigure your guest with KVM_GUEST set.\n",
> +				client_pl);
> +
> +	if (version != HV_VERSION)
> +		return panic_hv(vcpu, "Client built for hv version %d, but"
> +				" this hv is version %d\n",
> +				version, HV_VERSION);
> +
> +	if (chip_num != TILE_CHIP)
> +		return panic_hv(vcpu, "Client built for chip %d, but this"
> +				" hardware is chip %d\n",
> +				chip_num, TILE_CHIP);
> +
> +	if (chip_rev_num != TILE_CHIP_REV)
> +		return panic_hv(vcpu, "Client built for chip rev %d, but this"
> +				" hardware is chip rev %d\n",
> +				chip_rev_num, TILE_CHIP_REV);
> +
> +	return 1;
> +}
> +
> +static int kvm_emulate_hv_sysconf(struct kvm_vcpu *vcpu)
> +{
> +	HV_SysconfQuery query = (HV_SysconfQuery)vcpu->arch.regs.regs[0];
> +	long rc;
> +
> +	switch (query) {
> +	case HV_SYSCONF_PAGE_SIZE_SMALL:
> +		rc = PAGE_SIZE;
> +		break;
> +
> +	case HV_SYSCONF_PAGE_SIZE_LARGE:
> +		rc = HPAGE_SIZE;
> +		break;
> +
> +	case HV_SYSCONF_VALID_PAGE_SIZES:
> +#if PAGE_SHIFT == 16
> +		rc = HV_CTX_PG_SM_64K;
> +#elif PAGE_SHIFT == 14
> +		rc = HV_CTX_PG_SM_16K;
> +#else
> +# error Fix hv_sysconf emulation for new page size
> +#endif
> +		break;
> +
> +	case HV_SYSCONF_PAGE_SIZE_JUMBO:
> +		rc = 0;  /* FIXME add super page support */
> +		break;
> +
> +	case HV_SYSCONF_CPU_SPEED:
> +	case HV_SYSCONF_CPU_TEMP:
> +	case HV_SYSCONF_BOARD_TEMP:
> +		rc = hv_sysconf(query);
> +		break;
> +
> +	default:
> +		rc = -EINVAL;
> +		break;
> +	}
> +
> +	vcpu->arch.regs.regs[0] = rc;
> +	return 1;
> +}
> +
> +static int kvm_emulate_hv_confstr(struct kvm_vcpu *vcpu)
> +{
> +	HV_SysconfQuery query = (HV_SysconfQuery)vcpu->arch.regs.regs[0];
> +	long buflen = vcpu->arch.regs.regs[2];
> +	char hvbuf[256];
> +	const char *p;
> +	long rc;
> +
> +	switch (query) {
> +
> +	/* For hardware attributes, just pass to the hypervisor. */
> +	case HV_CONFSTR_BOARD_PART_NUM:
> +	case HV_CONFSTR_BOARD_SERIAL_NUM:
> +	case HV_CONFSTR_CHIP_SERIAL_NUM:
> +	case HV_CONFSTR_BOARD_REV:
> +	case HV_CONFSTR_CHIP_MODEL:
> +	case HV_CONFSTR_BOARD_DESC:
> +	case HV_CONFSTR_MEZZ_PART_NUM:
> +	case HV_CONFSTR_MEZZ_SERIAL_NUM:
> +	case HV_CONFSTR_MEZZ_REV:
> +	case HV_CONFSTR_MEZZ_DESC:
> +	case HV_CONFSTR_SWITCH_CONTROL:
> +	case HV_CONFSTR_CHIP_REV:
> +	case HV_CONFSTR_CPUMOD_PART_NUM:
> +	case HV_CONFSTR_CPUMOD_SERIAL_NUM:
> +	case HV_CONFSTR_CPUMOD_REV:
> +	case HV_CONFSTR_CPUMOD_DESC:
> +		rc = hv_confstr(query, (HV_VirtAddr)hvbuf, sizeof(hvbuf));
> +		if (rc > sizeof(hvbuf)) {
> +			/* Not the best answer, but very unlikely anyway. */
> +			rc = sizeof(hvbuf);
> +			hvbuf[sizeof(hvbuf)-1] = '\0';
> +		}
> +		p = hvbuf;
> +		break;
> +
> +	/* For hypervisor version info, just report the kernel version. */
> +	case HV_CONFSTR_HV_SW_VER:
> +		p = UTS_RELEASE;
> +		break;
> +	case HV_CONFSTR_HV_CONFIG:
> +	case HV_CONFSTR_HV_CONFIG_VER:
> +		p = "";
> +		break;
> +
> +	default:
> +		rc = HV_EINVAL;
> +		goto done;
> +	}
> +
> +	rc = strlen(p) + 1;  /* include NUL */
> +	if (kvm_write_guest_va(vcpu, vcpu->arch.regs.regs[1],
> +			       p, min(rc, buflen)))
> +		rc = HV_EFAULT;
> +
> +done:
> +	vcpu->arch.regs.regs[0] = rc;
> +	return 1;
> +}
> +
> +static int kvm_emulate_hv_get_rtc(struct kvm_vcpu *vcpu)
> +{
> +	HV_RTCTime *hvtm = (HV_RTCTime *) &vcpu->arch.regs.regs[0];
> +	struct rtc_time tm;
> +	struct timeval tv;
> +
> +	do_gettimeofday(&tv);
> +	rtc_time_to_tm(tv.tv_sec, &tm);
> +	hvtm->tm_sec = tm.tm_sec;
> +	hvtm->tm_min = tm.tm_min;
> +	hvtm->tm_hour = tm.tm_hour;
> +	hvtm->tm_mday = tm.tm_mday;
> +	hvtm->tm_mon = tm.tm_mon;
> +	hvtm->tm_year = tm.tm_year;
> +	hvtm->flags = 0;
> +
> +	return 1;
> +}
> +
> +static int kvm_emulate_hv_set_rtc(struct kvm_vcpu *vcpu)
> +{
> +	/* Do nothing here. */
> +	pr_warn("hv_set_rtc() will not work in kvm guest\n");
> +	return 1;
> +}
> +
> +static int kvm_emulate_hv_inquire_virtual(struct kvm_vcpu *vcpu)
> +{
> +	int idx = vcpu->arch.regs.regs[0];
> +	HV_VirtAddrRange *var = (HV_VirtAddrRange *)&vcpu->arch.regs.regs[0];
> +
> +	switch (idx) {
> +	case 0:
> +		var->start =                  0UL;
> +		var->size  =       0x20000000000UL;
> +		break;
> +	case 1:
> +		var->start = 0xFFFFFFFF80000000UL;
> +		var->size  =         0x80000000UL;
> +		break;
> +	default:
> +		var->start =                  0UL;
> +		var->size  =                  0UL;
> +		break;
> +	}
> +
> +	return 1;
> +}
> +
> +/* Give all the ASIDs to the guest; we flush the whole TLB anyway. */
> +static int kvm_emulate_hv_inquire_asid(struct kvm_vcpu *vcpu)
> +{
> +	int idx = vcpu->arch.regs.regs[0];
> +	HV_ASIDRange *var = (HV_ASIDRange *)&vcpu->arch.regs.regs[0];
> +
> +	if (idx == 0) {
> +		var->start = min_asid;
> +		var->size = max_asid - min_asid + 1;
> +	} else {
> +		var->start = 0;
> +		var->size = 0;
> +	}
> +
> +	return 1;
> +}
> +
> +static int kvm_emulate_hv_inquire_topology(struct kvm_vcpu *vcpu)
> +{
> +	HV_Topology *tp;
> +	int cpus;
> +
> +	/* Depends on the definition of struct HV_Topology */
> +	tp = (HV_Topology *)&vcpu->arch.regs.regs[0];
> +
> +	cpus = atomic_read(&vcpu->kvm->online_vcpus);
> +	tp->coord.x = vcpu->vcpu_id;
> +	tp->coord.y = 0;
> +	tp->width = cpus;
> +	tp->height = 1;
> +
> +	return 1;
> +}
> +
> +static int xy_to_vcpu(struct kvm *kvm, int x, int y)
> +{
> +	if (y != 0 || x < 0 || x >= atomic_read(&kvm->online_vcpus))
> +		return -1;
> +	return x;
> +}
> +
> +/*
> + * The primary vcpu is the one that initially runs while the others
> + * all block.  It is the only that is allowed to call hv_start_all_tiles().
> + * The other cpus are secondary.
> + */
> +static bool is_secondary_vcpu(struct kvm_vcpu *vcpu)
> +{
> +	return vcpu->vcpu_id != 0;
> +}
> +
> +static int kvm_emulate_hv_start_all_tiles(struct kvm_vcpu *vcpu)
> +{
> +	struct completion *c = &vcpu->kvm->arch.smp_start;
> +	if (is_secondary_vcpu(vcpu) || completion_done(c))
> +		return panic_hv(vcpu, "start_all_tiles() called again");
> +	complete_all(c);
> +	return 1;
> +}
> +
> +static int kvm_emulate_hv_physaddr_read64(struct kvm_vcpu *vcpu)
> +{
> +	gpa_t gpa = vcpu->arch.regs.regs[0];
> +	HV_PTE *access = (HV_PTE *) &vcpu->arch.regs.regs[1];
> +	gfn_t gfn;
> +	pfn_t pfn;
> +	hpa_t hpa;
> +
> +	gfn = gpa_to_gfn(gpa);
> +	pfn = gfn_to_pfn(vcpu->kvm, gfn);
> +	if (is_error_pfn(pfn))
> +		return panic_hv(vcpu, "bogus PA %llx in physaddr_write64()",
> +			 gpa);
> +	hpa = pfn_to_hpa(pfn) | (gpa & ~PAGE_MASK);
> +
> +	vcpu->arch.regs.regs[0] = hv_physaddr_read64(hpa, *access);
> +
> +	return 1;
> +}
> +
> +static int kvm_emulate_hv_physaddr_write64(struct kvm_vcpu *vcpu)
> +{
> +	gpa_t gpa = vcpu->arch.regs.regs[0];
> +	HV_PTE *access = (HV_PTE *)vcpu->arch.regs.regs[1];
> +	uint64_t val = vcpu->arch.regs.regs[2];
> +	gfn_t gfn;
> +	pfn_t pfn;
> +	hpa_t hpa;
> +
> +	gfn = gpa_to_gfn(gpa);
> +	pfn = gfn_to_pfn(vcpu->kvm, gfn);
> +	if (is_error_pfn(pfn))
> +		return panic_hv(vcpu, "bogus PA %llx in physaddr_write64()",
> +			 gpa);
> +	hpa = pfn_to_hpa(pfn) | (gpa & ~PAGE_MASK);
> +
> +	hv_physaddr_write64(hpa, *access, val);
> +
> +	return 1;
> +}
> +
> +static int kvm_emulate_hv_register_message_state(struct kvm_vcpu *vcpu)
> +{
> +	/* Do we care about the argument msgstate? */
> +	vcpu->arch.regs.regs[0] = HV_OK;
> +
> +	return 1;
> +}
> +
> +/*
> + * NOTE: we may coalesce multiple messages with the same tag to the
> + * same recepient.  Currently the only messages used by Linux are
> + * start/stop cpu (where coalescing is OK), and the smp_call_function()
> + * IPI message tag.  In the latter case we rely on the generic
> + * smp_call_function code to properly handle this, and since it only
> + * uses the IPI as a way to wake up the generic list-walking code,
> + * it's OK if we coalesce several IPI deliveries before the recipient
> + * core takes action.
> + */
> +static int kvm_emulate_hv_send_message(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +	struct kvm_vcpu *vcpui;
> +	HV_Recipient recip[NR_CPUS];
> +	HV_Recipient *recips = (HV_Recipient *)vcpu->arch.regs.regs[0];
> +	int nrecip = vcpu->arch.regs.regs[1];
> +	int buflen = vcpu->arch.regs.regs[3];
> +	int sent, vcpu_id, tag;
> +
> +	/* NOTE: we only support the Linux usage of buflen == sizeof(int). */
> +	if (unlikely(buflen != sizeof(int) ||
> +		     nrecip >= atomic_read(&kvm->online_vcpus))) {
> +		vcpu->arch.regs.regs[0] = HV_EINVAL;
> +		return 1;
> +	}
> +
> +	/* Get the buf info */
> +	if (kvm_read_guest_va(vcpu, vcpu->arch.regs.regs[2],
> +			      &tag, sizeof(tag))) {
> +		vcpu->arch.regs.regs[0] = HV_EFAULT;
> +		return 1;
> +	}
> +
> +	/* Range-check the tag value. */
> +	if (tag < 0 || tag >= MAX_MSG_TAG) {
> +		vcpu->arch.regs.regs[0] = HV_EFAULT;
> +		return 1;
> +	}
> +
> +	/* Get all the recipients */
> +	if (kvm_read_guest_va(vcpu, (unsigned long)recips, &recip,
> +			      nrecip * sizeof(HV_Recipient))) {
> +		vcpu->arch.regs.regs[0] = HV_EFAULT;
> +		return 1;
> +	}
> +
> +	for (sent = 0; sent < nrecip; sent++) {
> +		if (recip[sent].state != HV_TO_BE_SENT)
> +			continue;
> +		vcpu_id = xy_to_vcpu(kvm, recip[sent].x, recip[sent].y);
> +		if (unlikely(vcpu_id < 0 || vcpu_id == vcpu->vcpu_id)) {
> +			recip[sent].state = HV_BAD_RECIP;
> +			continue;
> +		}
> +		vcpui = kvm_get_vcpu(kvm, vcpu_id);
> +		set_bit(tag, &vcpui->arch.pending_msgs);
> +		kvm_vcpu_kick(vcpui);
> +		recip[sent].state = HV_SENT;
> +	}
> +
> +	if (kvm_write_guest_va(vcpu, (unsigned long)recips, &recip,
> +			       nrecip * sizeof(HV_Recipient))) {
> +		vcpu->arch.regs.regs[0] = HV_EFAULT;
> +		return 1;
> +	}
> +
> +	vcpu->arch.regs.regs[0] = sent;
> +
> +	return 1;
> +}
> +
> +static int kvm_emulate_hv_receive_message(struct kvm_vcpu *vcpu)
> +{
> +	HV_RcvMsgInfo *rmi = (HV_RcvMsgInfo *)&vcpu->arch.regs.regs[0];
> +	int buflen = vcpu->arch.regs.regs[3];
> +	int tag;
> +
> +	/* Currently we only support messages from other tiles. */
> +	rmi->source = HV_MSG_TILE;
> +
> +	if (buflen <= sizeof(int)) {
> +		rmi->msglen = HV_E2BIG;
> +		return 1;
> +	}
> +
> +	tag = find_first_bit(&vcpu->arch.pending_msgs, MAX_MSG_TAG);
> +	if (tag >= MAX_MSG_TAG) {
> +		/* No more messages */
> +		rmi->msglen = 0;
> +		return 1;
> +	}
> +
> +	if (kvm_write_guest_va(vcpu, vcpu->arch.regs.regs[2],
> +			       &tag, sizeof(int))) {
> +		rmi->msglen = HV_EFAULT;
> +		return 1;
> +	}
> +
> +	/*
> +	 * This clear_bit could race with a set_bit as another core
> +	 * delivers a new smp_function_call to this core.  However,
> +	 * the smp_function_call code will have set up the additional
> +	 * smp_function_call data on the kernel's list prior to
> +	 * raising the interrupt, so even if we lose the new
> +	 * interrupt due to the race, we still haven't dispatched
> +	 * to the original interrupt handler, and when we do, it
> +	 * will find both smp_function_calls waiting for it, so the
> +	 * race is harmless.  This is consistent with the fact that
> +	 * the generic code is trying to support pretty much
> +	 * arbitrary architecture-dependent IPI semantics, so it
> +	 * is very conservative about what it assumes.
> +	 *
> +	 * Also note that we only clear_bit on the core that owns
> +	 * the mask, so there's no race condition caused by the
> +	 * find_first_bit above and the clear_bit here, since once
> +	 * a bit is found it will stay set until this point.
> +	 */
> +	clear_bit(tag, &vcpu->arch.pending_msgs);
> +	rmi->msglen = sizeof(int);
> +	return 1;
> +}
> +
> +static int kvm_emulate_hv_inquire_context(struct kvm_vcpu *vcpu)
> +{
> +	HV_Context *ctx = (HV_Context *) &vcpu->arch.regs.regs[0];
> +
> +	*ctx = hv_inquire_guest_context();
> +
> +	return 1;
> +}
> +
> +static int kvm_emulate_hv_inquire_tiles(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +	HV_InqTileSet set = vcpu->arch.regs.regs[0];
> +	unsigned long gva = vcpu->arch.regs.regs[1];
> +	int length = vcpu->arch.regs.regs[2];
> +	struct cpumask mask = CPU_MASK_NONE;
> +	int cpus, i, retval, bytes2copy, bytes2zero;
> +
> +	switch (set) {
> +	case HV_INQ_TILES_AVAIL:
> +	case HV_INQ_TILES_HFH_CACHE:
> +	case HV_INQ_TILES_LOTAR:
> +		cpus = atomic_read(&kvm->online_vcpus);
> +		for (i = 0; i < cpus; ++i)
> +			cpumask_set_cpu(i, &mask);
> +		break;
> +	case HV_INQ_TILES_SHARED:
> +		break;
> +	default:
> +		retval = HV_EINVAL;
> +		goto done;
> +	}
> +
> +	bytes2copy = (length > sizeof(mask)) ? sizeof(mask) : length;
> +	bytes2zero = length - bytes2copy;
> +
> +	if (kvm_write_guest_va(vcpu, gva, &mask, bytes2copy)) {
> +		retval = HV_EFAULT;
> +		goto done;
> +	}
> +
> +	if (kvm_clear_guest_va(vcpu, gva + bytes2copy, bytes2zero)) {
> +		retval = HV_EFAULT;
> +		goto done;
> +	}
> +
> +	retval = HV_OK;
> +done:
> +	vcpu->arch.regs.regs[0] = retval;
> +	return 1;
> +}
> +
> +static int kvm_emulate_hv_get_ipi_pte(struct kvm_vcpu *vcpu)
> +{
> +	HV_Coord vtarget = *(HV_Coord *)&vcpu->arch.regs.regs[0];
> +	int pl = (int) vcpu->arch.regs.regs[1];
> +	struct kvm_vcpu *target_vcpu;
> +	int vcpu_id;
> +
> +	vcpu_id = vtarget.x;
> +	if (pl != GUEST_PL || vtarget.y != 0 || vcpu_id < 0 ||
> +	    vcpu_id >= atomic_read(&vcpu->kvm->online_vcpus)) {
> +		vcpu->arch.regs.regs[0] = HV_EINVAL;
> +		return 1;
> +	}
> +
> +	target_vcpu = kvm_get_vcpu(vcpu->kvm, vcpu_id);
> +	if (kvm_write_guest_va(vcpu, vcpu->arch.regs.regs[2],
> +			    &target_vcpu->arch.ipi_gpte, sizeof(pte_t))) {
> +		vcpu->arch.regs.regs[0] = HV_EFAULT;
> +		return 1;
> +	}
> +
> +	vcpu->arch.regs.regs[0] = HV_OK;
> +
> +	return 1;
> +}
> +
> +struct kvm_vcpu *ipi_vcpu_lookup(struct kvm *kvm, unsigned long gpa)
> +{
> +	struct kvm_vcpu *vcpui;
> +	unsigned long idx;
> +
> +	kvm_for_each_vcpu(idx, vcpui, kvm)
> +		if (vcpui->arch.ipi_gpa == gpa)
> +			return vcpui;
> +
> +	return NULL;
> +}
> +
> +/*
> + * Most page faults will be downcall-ed from hv to and be handled directly
> + * by either guest os or host os. This function is used to handle the
> + * rest cases.
> + */
> +static int handle_mmio(struct kvm_vcpu *vcpu)
> +{
> +	struct kvm *kvm = vcpu->kvm;
> +	struct kvm_translation tr;
> +	struct kvm_vcpu *ipi_vcpu;
> +
> +	tr.linear_address = (__u64) vcpu->arch.fault_addr;
> +	kvm_arch_vcpu_ioctl_translate(vcpu, &tr);
> +	if (!tr.valid)
> +		return 0;
> +
> +	/* ipi PTE for rescheduling interrupt? */
> +	ipi_vcpu = ipi_vcpu_lookup(kvm, tr.physical_address);
> +	if (!ipi_vcpu)
> +		return 0;
> +
> +	set_bit(IRQ_RESCHEDULE, &ipi_vcpu->arch.ipi_events);
> +	kvm_vcpu_kick(ipi_vcpu);
> +
> +	/* Juke the PC past the store instruction. */
> +	vcpu->arch.regs.pc += 8;
> +	return 1;
> +}
> +
> +static int kvm_emulate_hv_set_pte_super_shift(struct kvm_vcpu *vcpu)
> +{
> +	/*
> +	 * We do not expect this call in guest so far. At least guest os
> +	 * should just follow host os instead of *set*. Besides,
> +	 * hv_set_pte_super_shift() will not be called in guest os with
> +	 * current guest os setting.
> +	 */
> +	vcpu->arch.regs.regs[0] = HV_EINVAL;
> +
> +	return 1;
> +}
> +
> +static int kvm_emulate_hv_set_speed(struct kvm_vcpu *vcpu)
> +{
> +	HV_SetSpeed *hvss = (HV_SetSpeed *) &vcpu->arch.regs.regs[0];
> +
> +	hvss->new_speed = HV_EPERM;
> +	hvss->end_cycle = 0;
> +	hvss->delta_ns = 0;
> +
> +	return 1;
> +}
> +
> +static int (*hcall_handlers[KVM_NUM_HCALLS])(struct kvm_vcpu *vcpu) = {
> +	HCALL_DEFS
> +};
> +
> +static int kvm_handle_exit(struct kvm_vcpu *vcpu)
> +{
> +	unsigned long hcall_idx;
> +
> +	switch (vcpu->run->exit_reason) {
> +	case KVM_EXIT_HYPERCALL:
> +		hcall_idx = vcpu->arch.regs.regs[10];
> +		if (unlikely(hcall_idx >= KVM_NUM_HCALLS ||
> +			     hcall_handlers[hcall_idx] == NULL))
> +			return kvm_emulate_illegal(vcpu);
> +
> +		/* Juke us past the swint0 when we return. */
> +		vcpu->arch.regs.pc += 8;
> +
> +		return hcall_handlers[hcall_idx](vcpu);
> +
> +	case KVM_EXIT_MMIO:
> +		if (handle_mmio(vcpu))
> +			return 1;
> +		return panic_hv(vcpu, "Out-of-bounds client memory access");
> +
> +	case KVM_EXIT_AGAIN:
> +		return 1;
> +
> +	default:
> +		return 0;
> +	}
> +}
> +
> +static void kvm_kick_func(void *info)
> +{
> +	struct kvm_vcpu *vcpu = info;
> +
> +	/* If this is not the thread that we expect, just return. */
> +	if (unlikely(vcpu->pid != get_task_pid(current, PIDTYPE_PID)))
> +		return;
> +
> +	/* Setting this flag will cause a vmexit instead of a vmresume. */
> +	set_thread_flag(TIF_VIRT_EXIT);
> +}
> +
> +/* Note this function has been a standard kvm interface in latest Linux. */
> +void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
> +{
> +	int me, cpu;
> +
> +	/* If it is waiting in kvm_vcpu_block(), wake it up. */
> +	if (waitqueue_active(&vcpu->wq))
> +		wake_up_interruptible(&vcpu->wq);
> +
> +	/* If we are kicking our own vcpu, make sure we vmexit. */
> +	if (vcpu == current_thread_info()->vcpu) {
> +		set_thread_flag(TIF_VIRT_EXIT);
> +		return;
> +	}
> +
> +	/*
> +	 * If the vcpu is running the guest, interrupt its cpu,
> +	 * causing it to vmexit by setting TIF_VIRT_EXIT.  Note we can
> +	 * race with a guest already doing a vmexit, but that is benign.
> +	 */
> +	cpu = vcpu->cpu;
> +	me = get_cpu();
> +	if (cpu != me && (unsigned) cpu < nr_cpu_ids && cpu_online(cpu))
> +		if (!test_and_set_bit(KVM_REQ_KICK, &vcpu->requests))
> +			smp_call_function_single(cpu, kvm_kick_func, vcpu, 0);
> +	put_cpu();
> +}
> +EXPORT_SYMBOL_GPL(kvm_vcpu_kick);
> +
> +/*
> + * Any interrupt that would normally be handled by the host at PL2
> + * needs to be reassigned to the guest at PL1 as we enter.
> + *
> + * The TLB interrupts remain handled by the hypervisor and are downcalled
> + * to the appropriate host or guest as necessary.
> + *
> + * FIXME: We don't give the UDN interrupts for now; at some point we
> + * plan to allow an option to pin the vcpus and report the true
> + * geometry to the guest, at which point passing the UDN access would
> + * make sense.
> + *
> + * FIXME: For now we don't pass the profiling interrupts to the guest,
> + * and instead require profiling be run in the host; we should be able
> + * to support guest-level profiling pretty easily, but we need to
> + * think about whether there are vcpu migration issues there.
> + */
> +static void kvm_grant_mpls(void)
> +{
> +	__insn_mtspr(SPR_MPL_SWINT_1_SET_1, 1);
> +	__insn_mtspr(SPR_MPL_ILL_SET_1, 1);
> +	__insn_mtspr(SPR_MPL_GPV_SET_1, 1);
> +	__insn_mtspr(SPR_MPL_ILL_TRANS_SET_1, 1);
> +	__insn_mtspr(SPR_MPL_UNALIGN_DATA_SET_1, 1);
> +}
> +
> +static void kvm_ungrant_mpls(void)
> +{
> +	__insn_mtspr(SPR_MPL_SWINT_1_SET_2, 1);
> +	__insn_mtspr(SPR_MPL_ILL_SET_2, 1);
> +	__insn_mtspr(SPR_MPL_GPV_SET_2, 1);
> +	__insn_mtspr(SPR_MPL_ILL_TRANS_SET_2, 1);
> +	__insn_mtspr(SPR_MPL_UNALIGN_DATA_SET_2, 1);
> +}
> +
> +/*
> + * There is lots of state that is (for the non-virtualized case) held
> + * permanently in SPRs, or that is in any case not context-switched.
> + * The next two routines switch in and out all the SPR state.
> + *
> + * We try to fix the timer so that when we restart, we fix up the
> + * timer value so that will fire at the correct wall-clock time even
> + * if we have been scheduled out for a little bit.  This may also
> + * mean we end up firing it immediately on return, and suffer a
> + * timer delay in the guest.
> + */
> +static void kvm_save_sprs(struct kvm_vcpu *vcpu)
> +{
> +	vcpu->arch.timer_control = __insn_mfspr(SPR_AUX_TILE_TIMER_CONTROL);
> +	vcpu->arch.vmexit_cycles = get_cycles();
> +
> +#define SAVE_SPR(x) vcpu->arch.sregs.x = __insn_mfspr(SPR_ ## x)
> +	FOR_EACH_GUEST_SPR(SAVE_SPR);
> +#undef SAVE_SPR
> +}
> +
> +static void kvm_restore_sprs(struct kvm_vcpu *vcpu)
> +{
> +	unsigned long count = vcpu->arch.timer_control;
> +	unsigned long underflow =
> +		(count >> SPR_AUX_TILE_TIMER_CONTROL__UNDERFLOW_SHIFT) & 1;
> +	unsigned long disabled =
> +		(count >> SPR_AUX_TILE_TIMER_CONTROL__DISABLE_SHIFT) & 1;
> +
> +	if (!disabled) {
> +		unsigned long delta = get_cycles() - vcpu->arch.vmexit_cycles;
> +		count &= SPR_AUX_TILE_TIMER_CONTROL__COUNT_MASK;
> +		underflow |= delta > count;
> +		count -= delta;
> +		count &= SPR_AUX_TILE_TIMER_CONTROL__COUNT_MASK;
> +		count |= (underflow << SPR_AUX_TILE_TIMER_CONTROL__UNDERFLOW_SHIFT);
> +	}
> +	__insn_mtspr(SPR_AUX_TILE_TIMER_CONTROL, count);
> +
> +#define RESTORE_SPR(x) __insn_mtspr(SPR_ ## x, vcpu->arch.sregs.x)
> +	FOR_EACH_GUEST_SPR(RESTORE_SPR);
> +#undef RESTORE_SPR
> +}
> +
> +/*
> + * When entering the guest, we need to eliminate any PL0 translations
> + * that were in use by qemu, since the guest's PL0 translations will
> + * be different.  We also flush PL1 translations in case there have
> + * been changes to the virtualization page table, etc.
> + *
> + * FIXME: Add a way to just flush PL0/PL1, or just flush below
> + * the host PAGE_OFFSET, or add vpid support, etc.
> + */
> +static void kvm_guest_context_enter(struct kvm_vcpu *vcpu)
> +{
> +	HV_Context *ctx;
> +	pgd_t *vpgdir;
> +	pte_t *ptep;
> +	int rc;
> +
> +	/* Install virtualization context */
> +	vpgdir = vcpu->kvm->arch.vpgd;
> +	BUG_ON(vpgdir == NULL);
> +	ptep = virt_to_pte(NULL, (unsigned long)vpgdir);
> +	rc = hv_install_virt_context(__pa(vpgdir), *ptep, 0, 0);
> +	WARN_ON_ONCE(rc < 0);
> +
> +	/* Install guest context */
> +	ctx = &vcpu->arch.guest_context;
> +	rc = hv_install_guest_context(ctx->page_table, ctx->access,
> +				      ctx->asid, ctx->flags);
> +	WARN_ONCE(rc < 0, "install_guest_context(%#llx,%#llx,%#x,%#x): %d\n",
> +		  ctx->page_table, ctx->access.val,
> +		  ctx->asid, ctx->flags, rc);
> +
> +	hv_flush_all(0);
> +}
> +
> +/*
> + * De-install the virtualization context so we take faults below the
> + * host Linux PL in the normal manner going forward.
> + *
> + * We flush all the TLB mappings as we exit the guest, since the
> + * guest has been using the ASIDs as it pleases, and may have installed
> + * incompatible mappings for qemu's process as well.  Note that we don't
> + * worry about host-PL interrupts that occur while the guest is running,
> + * on the assumption that such interrupts can't touch userspace
> + * addresses legally anyway.
> + *
> + * NOTE: we may want to add a hypervisor call to just flush mappings
> + * below PL2 and use that here instead.
> + */
> +static void kvm_guest_context_exit(struct kvm_vcpu *vcpu)
> +{
> +	int rc;
> +
> +	/* Remember guest context */
> +	vcpu->arch.guest_context = hv_inquire_guest_context();
> +
> +	/* Disable virtualization context */
> +	rc = hv_install_virt_context(HV_CTX_NONE, hv_pte(0), 0, 0);
> +	WARN_ON_ONCE(rc < 0);
> +
> +	/* Flush everything in the TLB. */
> +	hv_flush_all(0);
> +}
> +
> +static void kvm_inject_interrupts(struct kvm_vcpu *vcpu)
> +{
> +	/*
> +	 * Capture current set of ipi_events.  We might race with
> +	 * another thread adding an event, but if so we'll just miss
> +	 * it on this go-around and see it next time.
> +	 */
> +	vcpu->arch.sregs.IPI_EVENT_1 |= __insn_exch(&vcpu->arch.ipi_events, 0);
> +
> +	/*
> +	 * Note: We could set PC and EX1 for the guest os to jump
> +	 * directly to the INT_MESSAGE_RCV_DWNCL handler if the interrupt
> +	 * is unmasked and the guest is not at PL1 with ICS set.
> +	 * But in fact it's about as fast to just set INTCTRL_1_STATUS
> +	 * here and then run the short INTCTRL_1 handler in the guest.
> +	 */
> +	vcpu->arch.sregs.INTCTRL_1_STATUS = (vcpu->arch.pending_msgs != 0);
> +}
> +
> +static void kvm_tile_run(struct kvm_vcpu *vcpu)
> +{
> +	struct thread_info *ti = current_thread_info();
> +	unsigned long prev_k_0 = __insn_mfspr(SPR_SYSTEM_SAVE_K_0);
> +
> +	/*
> +	 * Disable interrupts while we set up the guest state.
> +	 * This way, if we race with another core trying to tell us
> +	 * to fix up our guest state, we will take the kick only as
> +	 * we actually try to enter the guest, and instead we will
> +	 * vmexit and end up retrying.
> +	 */
> +	local_irq_disable();
> +	kvm_guest_context_enter(vcpu);
> +	clear_bit(KVM_REQ_KICK, &vcpu->requests);
> +	ti->vcpu = vcpu;
> +	vcpu->cpu = get_cpu();
> +	kvm_inject_interrupts(vcpu);
> +	kvm_grant_mpls();
> +	kvm_restore_sprs(vcpu);
> +
> +	/* Calling this function irets into the guest. */
> +	kvm_vmresume(&vcpu->arch.regs, &vcpu->arch.host_sp);
> +
> +	/* We resume here due to a call to kvm_vmexit. */
> +	__insn_mtspr(SPR_SYSTEM_SAVE_K_0, prev_k_0);
> +
> +	vcpu->cpu = -1;
> +	put_cpu();
> +	ti->vcpu = NULL;
> +	set_bit(KVM_REQ_KICK, &vcpu->requests);
> +	vcpu->run->ready_for_interrupt_injection = 1;
> +	kvm_ungrant_mpls();
> +	kvm_save_sprs(vcpu);
> +	__insn_mtspr(SPR_INTERRUPT_MASK_1, -1UL);
> +	kvm_guest_context_exit(vcpu);
> +	local_irq_enable();
> +}
> +
> +static int __vcpu_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
> +{
> +	int r = 1;
> +
> +	while (r > 0) {
> +		kvm_guest_enter();
> +		kvm_tile_run(vcpu);
> +		kvm_guest_exit();
> +
> +		r = kvm_handle_exit(vcpu);
> +		/*
> +		 * <0: error for userspace.
> +		 * =0: QEMU to handle.
> +		 * >0: host os can handle it fully.
> +		 */
> +		if (r <= 0)
> +			break;
> +
> +		if (signal_pending(current)) {
> +			vcpu->run->exit_reason = KVM_EXIT_INTR;
> +			r = -EINTR;
> +			break;
> +		}
> +
> +#ifdef CONFIG_HOMECACHE
> +		if (current_thread_info()->homecache_cpu !=
> +		    smp_processor_id()) {
> +			/* Do homecache migration when returning to qemu. */
> +			vcpu->run->exit_reason = KVM_EXIT_INTR;
> +			r = -EINTR;
> +			break;
> +		}
> +#endif
> +
> +		kvm_resched(vcpu);
> +	}
> +
> +	return r;
> +}
> +
> +int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
> +{
> +	int r;
> +	sigset_t sigsaved;
> +
> +	/* Secondary cpus must wait until they are told they can start. */
> +	if (vcpu->arch.suspended) {
> +		struct completion *c = &vcpu->kvm->arch.smp_start;
> +		if (wait_for_completion_interruptible(c))
> +			return -EINTR;
> +		vcpu->arch.suspended = 0;
> +	}
> +
> +	if (vcpu->sigset_active)
> +		sigprocmask(SIG_SETMASK, &vcpu->sigset, &sigsaved);
> +
> +	r = __vcpu_run(vcpu, kvm_run);
> +
> +	if (vcpu->sigset_active)
> +		sigprocmask(SIG_SETMASK, &sigsaved, NULL);
> +
> +	return r;
> +}
> +
> +int kvm_arch_init(void *opaque)
> +{
> +	return 0;
> +}
> +
> +void kvm_arch_exit(void)
> +{
> +}
> +
> +int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
> +{
> +	int i;
> +	unsigned long resv_gfn_start;
> +	struct kvm_memory_slot *s;
> +	struct kvm *kvm = vcpu->kvm;
> +
> +	if (!kvm->arch.resv_gpa_start) {
> +		resv_gfn_start = 0;
> +
> +		for (i = 0; i < KVM_USER_MEM_SLOTS; i++) {
> +			s = &kvm->memslots->memslots[i];
> +
> +			if (!s->npages)
> +				continue;
> +
> +			if ((s->base_gfn + s->npages) > resv_gfn_start)
> +				resv_gfn_start = s->base_gfn + s->npages;
> +		}
> +
> +		kvm->arch.resv_gpa_start = PFN_PHYS(resv_gfn_start);
> +	}
> +
> +	/* Initialize to enter fake PA=VA mode in hypervisor. */
> +	vcpu->arch.guest_context.page_table = HV_CTX_NONE;
> +
> +	vcpu->arch.ipi_gpa =
> +		kvm->arch.resv_gpa_start + (vcpu->vcpu_id * PAGE_SIZE);
> +	vcpu->arch.ipi_gpte =
> +		pfn_pte(PFN_DOWN(vcpu->arch.ipi_gpa), PAGE_KERNEL);
> +
> +	/* Mark the core suspended if it is not the boot cpu. */
> +	vcpu->arch.suspended = is_secondary_vcpu(vcpu);
> +
> +	return 0;
> +}
> +
> +void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu)
> +{
> +}
> +
> +void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
> +{
> +	/* Notify simulator that this task handles this vcpu. */
> +	sim_set_vcpu(vcpu->vcpu_id);
> +}
> +
> +void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
> +{
> +	sim_clear_vcpu();
> +}
> +
> +struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm, unsigned int id)
> +{
> +	/* FIXME: some archs set up a cache for these structs? */
> +	struct kvm_vcpu *vcpu = kzalloc(sizeof(struct kvm_vcpu), GFP_KERNEL);
> +	int rc;
> +
> +	if (!vcpu)
> +		return ERR_PTR(-ENOMEM);
> +
> +	rc = kvm_vcpu_init(vcpu, kvm, id);
> +	if (rc) {
> +		kfree(vcpu);
> +		return ERR_PTR(rc);
> +	}
> +
> +	return vcpu;
> +}
> +
> +int kvm_arch_vcpu_setup(struct kvm_vcpu *vcpu)
> +{
> +	memset(&vcpu->arch.regs, 0, sizeof(struct pt_regs));
> +	memset(&vcpu->arch.sregs, 0, sizeof(struct pt_regs));
> +	vcpu->arch.sregs.IPI_MASK_1 = -1UL;
> +	vcpu->arch.sregs.INTERRUPT_MASK_1 = -1UL;
> +	vcpu->arch.sregs.INTERRUPT_VECTOR_BASE_1 = 0xfd000000;
> +	return 0;
> +}
> +
> +int kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
> +{
> +	return 0;
> +}
> +
> +void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
> +{
> +	kvm_vcpu_uninit(vcpu);
> +	kfree(vcpu);
> +}
> +
> +void kvm_arch_vcpu_free(struct kvm_vcpu *vcpu)
> +{
> +	return kvm_arch_vcpu_destroy(vcpu);
> +}
> +
> +int kvm_arch_hardware_enable(void *garbage)
> +{
> +	return 0;
> +}
> +
> +void kvm_arch_hardware_disable(void *garbage)
> +{
> +}
> +
> +int kvm_arch_hardware_setup(void)
> +{
> +	return 0;
> +}
> +
> +void kvm_arch_hardware_unsetup(void)
> +{
> +}
> +
> +void kvm_arch_check_processor_compat(void *rtn)
> +{
> +}
> +
> +int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
> +{
> +	return 0;
> +}
> +
> +int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
> +{
> +	if (type)
> +		return -EINVAL;
> +
> +	init_completion(&kvm->arch.smp_start);
> +	return 0;
> +}
> +
> +void kvm_arch_destroy_vm(struct kvm *kvm)
> +{
> +	struct kvm_vcpu *vcpu;
> +	int i;
> +
> +	kvm_for_each_vcpu(i, vcpu, kvm)
> +		kvm_arch_vcpu_free(vcpu);
> +
> +	/* Seems to be unnecessary? */
> +	mutex_lock(&kvm->lock);
> +	for (i = 0; i < atomic_read(&kvm->online_vcpus); i++)
> +		kvm->vcpus[i] = NULL;
> +
> +	atomic_set(&kvm->online_vcpus, 0);
> +	mutex_unlock(&kvm->lock);
> +
> +	/* FIXME: release all the pmds and ptes as well! */
> +	if (kvm->arch.vpgd)
> +		pgd_free(kvm->mm, kvm->arch.vpgd);
> +}
> +
> +void kvm_arch_sync_events(struct kvm *kvm)
> +{
> +}
> +
> +int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
> +{
> +	return 0;
> +}
> +
> +/* Called from guest hv glue via swint0 traps. */
> +void kvm_do_hypervisor_call(struct pt_regs *regs, int fault_num)
> +{
> +	/* Hypercalls are only valid from PL1. */
> +	if (EX1_PL(regs->ex1) != 0) {
> +		kvm_trigger_vmexit(regs, KVM_EXIT_HYPERCALL);
> +		/*NORETURN*/
> +	}
> +	do_trap(regs, fault_num, 0);
> +}
> +
> +void kvm_do_vpgtable_miss(struct pt_regs *regs, int fault_num,
> +			  unsigned long fault_addr, unsigned long write)
> +{
> +	struct kvm_vcpu *vcpu = current_thread_info()->vcpu;
> +	BUG_ON(vcpu == NULL);
> +	vcpu->arch.fault_addr = fault_addr;
> +	kvm_trigger_vmexit(regs, KVM_EXIT_MMIO);
> +	/*NORETURN*/
> +}
> +
> +void kvm_do_vguest_fatal(struct pt_regs *regs, int fault_num)
> +{
> +	kvm_trigger_vmexit(regs, KVM_EXIT_SHUTDOWN);
> +	/*NORETURN*/
> +}
> +
> +void kvm_trigger_vmexit(struct pt_regs *regs, int exit_reason)
> +{
> +	struct kvm_vcpu *vcpu = current_thread_info()->vcpu;
> +	vcpu->run->exit_reason = exit_reason;
> +	vcpu->arch.regs = *regs;
> +	vcpu->arch.regs.flags = PT_FLAGS_CALLER_SAVES | PT_FLAGS_RESTORE_REGS;
> +	kvm_vmexit(vcpu->arch.host_sp);
> +	/*NORETURN*/
> +}
> +
> +static int __init kvm_tile_init(void)
> +{
> +	return kvm_init(NULL, sizeof(struct kvm_vcpu),
> +			__alignof__(struct kvm_vcpu), THIS_MODULE);
> +}
> +
> +static void __exit kvm_tile_exit(void)
> +{
> +	kvm_exit();
> +}
> +
> +module_init(kvm_tile_init);
> +module_exit(kvm_tile_exit);
> diff --git a/arch/tile/lib/exports.c b/arch/tile/lib/exports.c
> index 82733c8..1590282 100644
> --- a/arch/tile/lib/exports.c
> +++ b/arch/tile/lib/exports.c
> @@ -50,18 +50,26 @@ EXPORT_SYMBOL(__copy_in_user_inatomic);
>  
>  /* hypervisor glue */
>  #include <hv/hypervisor.h>
> +EXPORT_SYMBOL(hv_confstr);
> +EXPORT_SYMBOL(hv_dev_close);
>  EXPORT_SYMBOL(hv_dev_open);
> +EXPORT_SYMBOL(hv_dev_poll);
> +EXPORT_SYMBOL(hv_dev_poll_cancel);
>  EXPORT_SYMBOL(hv_dev_pread);
> -EXPORT_SYMBOL(hv_dev_pwrite);
>  EXPORT_SYMBOL(hv_dev_preada);
> +EXPORT_SYMBOL(hv_dev_pwrite);
>  EXPORT_SYMBOL(hv_dev_pwritea);
> -EXPORT_SYMBOL(hv_dev_poll);
> -EXPORT_SYMBOL(hv_dev_poll_cancel);
> -EXPORT_SYMBOL(hv_dev_close);
> -EXPORT_SYMBOL(hv_sysconf);
> -EXPORT_SYMBOL(hv_confstr);
> +EXPORT_SYMBOL(hv_flush_all);
>  EXPORT_SYMBOL(hv_get_rtc);
> +#ifdef __tilegx__
> +EXPORT_SYMBOL(hv_inquire_guest_context);
> +EXPORT_SYMBOL(hv_install_guest_context);
> +EXPORT_SYMBOL(hv_install_virt_context);
> +#endif
> +EXPORT_SYMBOL(hv_physaddr_read64);
> +EXPORT_SYMBOL(hv_physaddr_write64);
>  EXPORT_SYMBOL(hv_set_rtc);
> +EXPORT_SYMBOL(hv_sysconf);
>  
>  /* libgcc.a */
>  uint32_t __udivsi3(uint32_t dividend, uint32_t divisor);
> diff --git a/arch/tile/mm/elf.c b/arch/tile/mm/elf.c
> index 23f044e..86cff48 100644
> --- a/arch/tile/mm/elf.c
> +++ b/arch/tile/mm/elf.c
> @@ -42,7 +42,9 @@ static int notify_exec(struct mm_struct *mm)
>  	char *buf, *path;
>  	struct vm_area_struct *vma;
>  
> +#ifndef CONFIG_KVM_GUEST   /* see notify_sim_task_change() */
>  	if (!sim_is_simulator())
> +#endif
>  		return 1;
>  
>  	if (mm->exe_file == NULL)
> diff --git a/arch/tile/mm/fault.c b/arch/tile/mm/fault.c
> index 64eec3f..39c48cb 100644
> --- a/arch/tile/mm/fault.c
> +++ b/arch/tile/mm/fault.c
> @@ -283,7 +283,7 @@ static int handle_page_fault(struct pt_regs *regs,
>  	flags = (FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE |
>  		 (write ? FAULT_FLAG_WRITE : 0));
>  
> -	is_kernel_mode = (EX1_PL(regs->ex1) != USER_PL);
> +	is_kernel_mode = !user_mode(regs);
>  
>  	tsk = validate_current();
>  
> @@ -824,7 +824,7 @@ void do_page_fault(struct pt_regs *regs, int fault_num,
>  	}
>  
>  #if CHIP_HAS_TILE_DMA() || CHIP_HAS_SN_PROC()
> -	if (EX1_PL(regs->ex1) != USER_PL) {
> +	if (!user_mode(regs)) {
>  		struct async_tlb *async;
>  		switch (fault_num) {
>  #if CHIP_HAS_TILE_DMA()
> diff --git a/arch/tile/mm/init.c b/arch/tile/mm/init.c
> index 3bfa127..c6d2160 100644
> --- a/arch/tile/mm/init.c
> +++ b/arch/tile/mm/init.c
> @@ -234,7 +234,7 @@ static pgprot_t __init init_pgprot(ulong address)
>  {
>  	int cpu;
>  	unsigned long page;
> -	enum { CODE_DELTA = MEM_SV_INTRPT - PAGE_OFFSET };
> +	enum { CODE_DELTA = MEM_SV_START - PAGE_OFFSET };
>  
>  #if CHIP_HAS_CBOX_HOME_MAP()
>  	/* For kdata=huge, everything is just hash-for-home. */
> @@ -538,7 +538,7 @@ static void __init kernel_physical_mapping_init(pgd_t *pgd_base)
>  		}
>  	}
>  
> -	address = MEM_SV_INTRPT;
> +	address = MEM_SV_START;
>  	pmd = get_pmd(pgtables, address);
>  	pfn = 0;  /* code starts at PA 0 */
>  	if (ktext_small) {
> @@ -1021,7 +1021,7 @@ static void free_init_pages(char *what, unsigned long begin, unsigned long end)
>  
>  void free_initmem(void)
>  {
> -	const unsigned long text_delta = MEM_SV_INTRPT - PAGE_OFFSET;
> +	const unsigned long text_delta = MEM_SV_START - PAGE_OFFSET;
>  
>  	/*
>  	 * Evict the dirty initdata on the boot cpu, evict the w1data
> @@ -1040,7 +1040,7 @@ void free_initmem(void)
>  
>  	/*
>  	 * Free the pages mapped from 0xc0000000 that correspond to code
> -	 * pages from MEM_SV_INTRPT that we won't use again after init.
> +	 * pages from MEM_SV_START that we won't use again after init.
>  	 */
>  	free_init_pages("unused kernel text",
>  			(unsigned long)_sinittext - text_delta,
> diff --git a/arch/tile/mm/pgtable.c b/arch/tile/mm/pgtable.c
> index 3004433..d6948d4 100644
> --- a/arch/tile/mm/pgtable.c
> +++ b/arch/tile/mm/pgtable.c
> @@ -486,25 +486,18 @@ void check_mm_caching(struct mm_struct *prev, struct mm_struct *next)
>  
>  #if CHIP_HAS_MMIO()
>  
> -/* Map an arbitrary MMIO address, homed according to pgprot, into VA space. */
> -void __iomem *ioremap_prot(resource_size_t phys_addr, unsigned long size,
> -			   pgprot_t home)
> +void *generic_remap_prot(resource_size_t phys_addr, unsigned long size,
> +		    unsigned long flags, pgprot_t prot)
>  {
>  	void *addr;
>  	struct vm_struct *area;
>  	unsigned long offset, last_addr;
> -	pgprot_t pgprot;
>  
>  	/* Don't allow wraparound or zero size */
>  	last_addr = phys_addr + size - 1;
>  	if (!size || last_addr < phys_addr)
>  		return NULL;
>  
> -	/* Create a read/write, MMIO VA mapping homed at the requested shim. */
> -	pgprot = PAGE_KERNEL;
> -	pgprot = hv_pte_set_mode(pgprot, HV_PTE_MODE_MMIO);
> -	pgprot = hv_pte_set_lotar(pgprot, hv_pte_get_lotar(home));
> -
>  	/*
>  	 * Mappings have to be page-aligned
>  	 */
> @@ -515,17 +508,35 @@ void __iomem *ioremap_prot(resource_size_t phys_addr, unsigned long size,
>  	/*
>  	 * Ok, go for it..
>  	 */
> -	area = get_vm_area(size, VM_IOREMAP /* | other flags? */);
> +	area = get_vm_area(size, flags);
>  	if (!area)
>  		return NULL;
>  	area->phys_addr = phys_addr;
>  	addr = area->addr;
>  	if (ioremap_page_range((unsigned long)addr, (unsigned long)addr + size,
> -			       phys_addr, pgprot)) {
> +			       phys_addr, prot)) {
>  		free_vm_area(area);
>  		return NULL;
>  	}
> -	return (__force void __iomem *) (offset + (char *)addr);
> +	return (void *) (offset + (char *)addr);
> +}
> +EXPORT_SYMBOL(generic_remap_prot);
> +
> +/* Map an arbitrary MMIO address, homed according to pgprot, into VA space. */
> +void __iomem *ioremap_prot(resource_size_t phys_addr, unsigned long size,
> +			   pgprot_t home)
> +{
> +	pgprot_t pgprot;
> +	unsigned long flags;
> +
> +	/* Create a read/write, MMIO VA mapping homed at the requested shim. */
> +	pgprot = PAGE_KERNEL;
> +	pgprot = hv_pte_set_mode(pgprot, HV_PTE_MODE_MMIO);
> +	pgprot = hv_pte_set_lotar(pgprot, hv_pte_get_lotar(home));
> +	flags = VM_IOREMAP; /* | other flags? */
> +
> +	return (__force void __iomem *) generic_remap_prot(phys_addr,
> +							   size, flags, pgprot);
>  }
>  EXPORT_SYMBOL(ioremap_prot);
>  
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index acccd08..b622337 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -171,6 +171,7 @@ struct kvm_pit_config {
>  #define KVM_EXIT_WATCHDOG         21
>  #define KVM_EXIT_S390_TSCH        22
>  #define KVM_EXIT_EPR              23
> +#define KVM_EXIT_AGAIN            24
>  
>  /* For KVM_EXIT_INTERNAL_ERROR */
>  /* Emulate instruction failed. */
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 1580dd4..1b8a1f1 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1691,7 +1691,7 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
>  	finish_wait(&vcpu->wq, &wait);
>  }
>  
> -#ifndef CONFIG_S390
> +#if !defined(CONFIG_S390) && !defined(CONFIG_TILE)
>  /*
>   * Kick a sleeping VCPU, or a guest VCPU in guest mode, into host kernel mode.
>   */
> @@ -1714,7 +1714,7 @@ void kvm_vcpu_kick(struct kvm_vcpu *vcpu)
>  	put_cpu();
>  }
>  EXPORT_SYMBOL_GPL(kvm_vcpu_kick);
> -#endif /* !CONFIG_S390 */
> +#endif
>  
>  void kvm_resched(struct kvm_vcpu *vcpu)
>  {
> @@ -1978,7 +1978,8 @@ static long kvm_vcpu_ioctl(struct file *filp,
>  	if (vcpu->kvm->mm != current->mm)
>  		return -EIO;
>  
> -#if defined(CONFIG_S390) || defined(CONFIG_PPC) || defined(CONFIG_MIPS)
> +#if defined(CONFIG_S390) || defined(CONFIG_PPC) || defined(CONFIG_MIPS) || \
> +	defined(CONFIG_TILEGX)
>  	/*
>  	 * Special cases: vcpu ioctls that are asynchronous to vcpu execution,
>  	 * so vcpu_load() would break it.
> -- 
> 1.8.3.1

--
			Gleb.
