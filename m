Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535AbaDUUmb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 16:42:31 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:59741 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753489AbaDUUm2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 16:42:28 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Lv Zheng <lv.zheng@intel.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>, Lv Zheng <zetalog@gmail.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 1/4] ACPICA: Add <acpi/platform/aclinuxxf.h> to remove mis-ordered inclusion of <acpi/actypes.h> from <acpi/platform/aclinux.h>.
Date: Mon, 21 Apr 2014 22:58:47 +0200
Message-ID: <3086544.JUcChlMM9C@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <330810301fa94a244fe1a755e99246a2a5778153.1396930406.git.lv.zheng@intel.com>
References: <cover.1385110130.git.lv.zheng@intel.com> <cover.1396930406.git.lv.zheng@intel.com> <330810301fa94a244fe1a755e99246a2a5778153.1396930406.git.lv.zheng@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 08, 2014 03:56:44 PM Lv Zheng wrote:
> From ACPICA's perspective, <acpi/actypes.h> should be included after
> inclusion of <acpi/platform/acenv.h>.  But currently in Linux,
> <acpi/platform/aclinux.h> included by <acpi/platform/acenv.h> has
> included <acpi/actypes.h> to find ACPICA types for inline functions.
> 
> This causes the following problem:
> 1. Redundant code in <asm/acpi.h> and <acpi/platform/aclinux.h>:
>    Linux must be careful to keep conditions for <acpi/actypes.h> inclusion
>    consistent with the conditions for <acpi/platform/aclinux.h> inclusion.
>    Which finally leads to the issue that we have to keep many useless macro
>    definitions in <acpi/platform/aclinux.h> or <asm/acpi.h>.
>    Such conditions include:
>      COMPILER_DEPENDENT_UINT64
>      COMPILER_DEPENDENT_INT64
>      ACPI_INLINE
>      ACPI_SYSTEM_XFACE
>      ACPI_EXTERNAL_XFACE
>      ACPI_INTERNAL_XFACE
>      ACPI_INTERNAL_VAR_XFACE
>      ACPI_MUTEX_TYPE
>      DEBUGGER_THREADING
>      ACPI_ACQUIRE_GLOBAL_LOCK
>      ACPI_RELEASE_GLOBAL_LOCK
>      ACPI_FLUSH_CPU_CACHE
>    They have default implementations in <include/acpi/platform/acenv.h>
>    while Linux need to keep a copy in <asm/acpi.h> to avoid build errors.
>    Typical Linux build error if we deletes COMPILER_DEPENDENT_x and
>    ACPI_x_XFACE definitions from asm/acpi.h:
>       CC      init/main.o
>     In file included from include/acpi/platform/aclinux.h:293:0,
>                      from include/acpi/platform/acenv.h:149,
>                      from include/acpi/acpi.h:56,
>                      from include/linux/acpi.h:41,
>                      from init/main.c:27:
>     include/acpi/actypes.h:129:1: error: unknown type name 'COMPILER_DEPENDENT_UINT64'
>     include/acpi/actypes.h:130:1: error: unknown type name 'COMPILER_DEPENDENT_INT64'
>     In file included from include/acpi/platform/aclinux.h:293:0,
>                      from include/acpi/platform/acenv.h:149,
>                      from include/acpi/acpi.h:56,
>                      from include/linux/acpi.h:41,
>                      from init/main.c:27:
>     include/acpi/actypes.h:1025:21: error: expected ')' before '*' token
>     include/acpi/actypes.h:1028:21: error: expected ')' before '*' token
>     In file included from include/acpi/acpi.h:63:0,
>                      from include/linux/acpi.h:41,
>                      from init/main.c:27:
>     include/acpi/acpiosxf.h:240:7: error: unknown type name 'acpi_osd_handler'
>     include/acpi/acpiosxf.h:247:6: error: unknown type name 'acpi_osd_handler'
>     include/acpi/acpiosxf.h:260:3: error: unknown type name 'acpi_osd_exec_callback'
> 
> This patch introduces <acpi/platform/aclinuxxf.h> to fix this issue by
> splitting conditions and declarations (most of them are inline functions)
> into 2 header files so that the wrong inclusion of <acpi/actypes.h> can be
> removed from <acpi/platform/aclinux.h>.
> 
> Signed-off-by: Lv Zheng <lv.zheng@intel.com>
> ---
>  include/acpi/platform/aclinux.h   |  101 ++++--------------------------
>  include/acpi/platform/aclinuxxf.h |  122 +++++++++++++++++++++++++++++++++++++
>  2 files changed, 133 insertions(+), 90 deletions(-)
>  create mode 100644 include/acpi/platform/aclinuxxf.h
> 
> diff --git a/include/acpi/platform/aclinux.h b/include/acpi/platform/aclinux.h
> index f242909..e3ac5a5 100644
> --- a/include/acpi/platform/aclinux.h
> +++ b/include/acpi/platform/aclinux.h
> @@ -130,73 +130,6 @@
>  
>  #ifdef __KERNEL__
>  
> -/*
> - * FIXME: Inclusion of actypes.h
> - * Linux kernel need this before defining inline OSL interfaces as
> - * actypes.h need to be included to find ACPICA type definitions.
> - * Since from ACPICA's perspective, the actypes.h should be included after
> - * acenv.h (aclinux.h), this leads to a inclusion mis-ordering issue.
> - */
> -#include <acpi/actypes.h>
> -
> -/*
> - * Overrides for in-kernel ACPICA
> - */
> -acpi_status __init acpi_os_initialize(void);
> -#define ACPI_USE_ALTERNATE_PROTOTYPE_acpi_os_initialize
> -
> -acpi_status acpi_os_terminate(void);
> -#define ACPI_USE_ALTERNATE_PROTOTYPE_acpi_os_terminate
> -
> -/*
> - * Memory allocation/deallocation
> - */
> -
> -/*
> - * The irqs_disabled() check is for resume from RAM.
> - * Interrupts are off during resume, just like they are for boot.
> - * However, boot has  (system_state != SYSTEM_RUNNING)
> - * to quiet __might_sleep() in kmalloc() and resume does not.
> - */
> -static inline void *acpi_os_allocate(acpi_size size)
> -{
> -	return kmalloc(size, irqs_disabled()? GFP_ATOMIC : GFP_KERNEL);
> -}
> -
> -#define ACPI_USE_ALTERNATE_PROTOTYPE_acpi_os_allocate
> -
> -/* Use native linux version of acpi_os_allocate_zeroed */
> -
> -static inline void *acpi_os_allocate_zeroed(acpi_size size)
> -{
> -	return kzalloc(size, irqs_disabled()? GFP_ATOMIC : GFP_KERNEL);
> -}
> -
> -#define ACPI_USE_ALTERNATE_PROTOTYPE_acpi_os_allocate_zeroed
> -#define USE_NATIVE_ALLOCATE_ZEROED
> -
> -static inline void acpi_os_free(void *memory)
> -{
> -	kfree(memory);
> -}
> -
> -#define ACPI_USE_ALTERNATE_PROTOTYPE_acpi_os_free
> -
> -static inline void *acpi_os_acquire_object(acpi_cache_t * cache)
> -{
> -	return kmem_cache_zalloc(cache,
> -				 irqs_disabled()? GFP_ATOMIC : GFP_KERNEL);
> -}
> -
> -#define ACPI_USE_ALTERNATE_PROTOTYPE_acpi_os_acquire_object
> -
> -static inline acpi_thread_id acpi_os_get_thread_id(void)
> -{
> -	return (acpi_thread_id) (unsigned long)current;
> -}
> -
> -#define ACPI_USE_ALTERNATE_PROTOTYPE_acpi_os_get_thread_id
> -
>  #ifndef CONFIG_PREEMPT
>  
>  /*
> @@ -212,27 +145,18 @@ static inline acpi_thread_id acpi_os_get_thread_id(void)
>  #endif
>  
>  /*
> - * When lockdep is enabled, the spin_lock_init() macro stringifies it's
> - * argument and uses that as a name for the lock in debugging.
> - * By executing spin_lock_init() in a macro the key changes from "lock" for
> - * all locks to the name of the argument of acpi_os_create_lock(), which
> - * prevents lockdep from reporting false positives for ACPICA locks.
> + * Overrides for in-kernel ACPICA
>   */
> -#define acpi_os_create_lock(__handle) \
> -	({ \
> -		spinlock_t *lock = ACPI_ALLOCATE(sizeof(*lock)); \
> -		if (lock) { \
> -			*(__handle) = lock; \
> -			spin_lock_init(*(__handle)); \
> -		} \
> -		lock ? AE_OK : AE_NO_MEMORY; \
> -	})
> +#define ACPI_USE_ALTERNATE_PROTOTYPE_acpi_os_initialize
> +#define ACPI_USE_ALTERNATE_PROTOTYPE_acpi_os_terminate
> +#define ACPI_USE_ALTERNATE_PROTOTYPE_acpi_os_allocate
> +#define ACPI_USE_ALTERNATE_PROTOTYPE_acpi_os_allocate_zeroed
> +#define USE_NATIVE_ALLOCATE_ZEROED
> +#define ACPI_USE_ALTERNATE_PROTOTYPE_acpi_os_free
> +#define ACPI_USE_ALTERNATE_PROTOTYPE_acpi_os_acquire_object
> +#define ACPI_USE_ALTERNATE_PROTOTYPE_acpi_os_get_thread_id
>  #define ACPI_USE_ALTERNATE_PROTOTYPE_acpi_os_create_lock
> -
> -void __iomem *acpi_os_map_memory(acpi_physical_address where, acpi_size length);
>  #define ACPI_USE_ALTERNATE_PROTOTYPE_acpi_os_map_memory
> -
> -void acpi_os_unmap_memory(void __iomem * logical_address, acpi_size size);
>  #define ACPI_USE_ALTERNATE_PROTOTYPE_acpi_os_unmap_memory
>  
>  /*
> @@ -253,11 +177,8 @@ void acpi_os_unmap_memory(void __iomem * logical_address, acpi_size size);
>  #define ACPI_USE_ALTERNATE_PROTOTYPE_acpi_os_get_next_filename
>  #define ACPI_USE_ALTERNATE_PROTOTYPE_acpi_os_close_directory
>  
> -/*
> - * OSL interfaces added by Linux
> - */
> -void early_acpi_os_unmap_memory(void __iomem * virt, acpi_size size);
> -
>  #endif				/* __KERNEL__ */
>  
> +#define ACPI_NATIVE_INTERFACE_HEADER	<acpi/platform/aclinuxxf.h>

This is not good.

We don't do things like this in the kernel, because they are confusing and hard
to debug if necessary, so please find a different way to make this work.

And the name aclinuxxf.h is not one of my favourite.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
