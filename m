Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932115AbaIWN7d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 09:59:33 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:49164 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932097AbaIWN7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 09:59:32 -0400
Date: Tue, 23 Sep 2014 14:59:27 +0100
From: Leif Lindholm <leif.lindholm@linaro.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Roy Franz <roy.franz@linaro.org>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        Josh Boyer <jwboyer@redhat.com>
Subject: Re: [GIT PULL] x86 fixes
Message-ID: <20140923135927.GF22224@bivouac.eciton.net>
References: <20140919104021.GA11552@gmail.com>
 <CA+55aFxW9PmtjOf9nUQwpU8swsFqJOz8whZXcONo+XFmkSwezg@mail.gmail.com>
 <20140923053510.GB27825@gmail.com>
 <20140923053711.GA28704@gmail.com>
 <20140923055802.GA29052@gmail.com>
 <1411456851.21380.355.camel@mfleming-mobl1.ger.corp.intel.com>
 <CAKv+Gu_xqnkVKuoWY=PRoAVYE_qOH8dwM+ZxG+ysC7Xvs82ZNw@mail.gmail.com>
 <20140923131805.GH18635@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140923131805.GH18635@console-pimps.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 02:18:05PM +0100, Matt Fleming wrote:
> On Tue, 23 Sep, at 10:18:07AM, Ard Biesheuvel wrote:
> > It will be difficult for me to keep up with this thread over the next
> > days, so I have added Leif and Roy on cc. If you need to make any
> > changes that affect arm64, they should be able to confirm whether it
> > causes any problems or not.
> 
> OK, below is what I've got on top of commit f3670394c29f in Linus' tree.
> Please don't anyone pick this up yet, I'm still testing it on my
> machines and it desperately needs some Tested-by tags.
> 
> Josh, your machines probably boot fine after the revert from Linus but
> it'd be good to verify that this patch doesn't make things any worse.
> 
> Maarten, please verify that your Macbook pro boots with this patch. I
> very much want to be able to add a Tested-by from you.
> 
> Ard, Leif, Roy, can you please validate this for arm64? The thing to
> look out for is whether the changes to drivers/firmware/efi/Makefile
> make sense, and in particular, whether it's ever possible to have
> CONFIG_EFI_STUB=y and CONFIG_EFI_ARM_STUB=n.

Currently, these are both selected automatically by CONFIG_EFI, and
are not selectable through the user interface. There is no relevant
case for them being individually selectable, so perhaps _EFI_ARM_STUB
should simply be set to the value of _EFI_STUB.
 
> If the answer is yes, then this patch might break your build and we
> probably want to do something like unconditionally select
> CONFIG_EFI_ARM_STUB when CONFIG_EFI_STUB=y.

For arm64:
Tested-by: Leif Lindholm <leif.lindholm@linaro.org>

> ---
> 
> From 8054c405f0acc8ecb74b7e29675a1e6894afedb0 Mon Sep 17 00:00:00 2001
> From: Matt Fleming <matt.fleming@intel.com>
> Date: Tue, 23 Sep 2014 10:37:43 +0100
> Subject: [PATCH] Revert "efi/x86: efistub: Move shared dependencies to
>  <asm/efi.h>"
> 
> This reverts commit f23cf8bd5c1f ("efi/x86: efistub: Move shared
> dependencies to <asm/efi.h>") as well as the x86 parts of commit
> f4f75ad5741f ("efi: efistub: Convert into static library").
> 
> The road leading to these two reverts is long and winding.
> 
> The above two commits were merged during the v3.17 merge window and
> turned the common EFI boot stub code into a static library. This
> necessitated making some symbols global in the x86 boot stub which
> introduced new entries into the early boot GOT.
> 
> The problem was that we weren't fixing up the newly created GOT entries
> before invoking the EFI boot stub, which sometimes resulted in hangs or
> resets. This failure was reported by Maarten on his Macbook pro.
> 
> The proposed fix was commit 9cb0e394234d ("x86/efi: Fixup GOT in all
> boot code paths"). However, that caused issues for Linus when booting
> his Sony Vaio Pro 11. It was subsequently reverted in commit
> f3670394c29f.
> 
> So that leaves us back with Maarten's Macbook pro not booting.
> 
> At this stage in the release cycle the least risky option is to revert
> the x86 EFI boot stub to the pre-merge window code structure where we
> explicitly #include efi-stub-helper.c instead of linking with the static
> library. The arm64 code remains unaffected.
> 
> We can take another swing at the x86 parts for v3.18.
> 
> Conflicts:
> 	arch/x86/include/asm/efi.h
> 
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
> Cc: Josh Boyer <jwboyer@fedoraproject.org>
> Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Matt Fleming <matt.fleming@intel.com>
> ---
>  arch/x86/boot/compressed/Makefile |  3 +--
>  arch/x86/boot/compressed/eboot.c  |  7 ++++++-
>  arch/x86/boot/compressed/eboot.h  | 16 ++++++++++++++++
>  arch/x86/include/asm/efi.h        | 24 ------------------------
>  drivers/firmware/efi/Makefile     |  2 +-
>  5 files changed, 24 insertions(+), 28 deletions(-)
> 
> diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
> index 7a801a310e37..0fcd9133790c 100644
> --- a/arch/x86/boot/compressed/Makefile
> +++ b/arch/x86/boot/compressed/Makefile
> @@ -33,8 +33,7 @@ VMLINUX_OBJS = $(obj)/vmlinux.lds $(obj)/head_$(BITS).o $(obj)/misc.o \
>  $(obj)/eboot.o: KBUILD_CFLAGS += -fshort-wchar -mno-red-zone
>  
>  ifeq ($(CONFIG_EFI_STUB), y)
> -	VMLINUX_OBJS += $(obj)/eboot.o $(obj)/efi_stub_$(BITS).o \
> -				$(objtree)/drivers/firmware/efi/libstub/lib.a
> +	VMLINUX_OBJS += $(obj)/eboot.o $(obj)/efi_stub_$(BITS).o
>  endif
>  
>  $(obj)/vmlinux: $(VMLINUX_OBJS) FORCE
> diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
> index dca9842d8f91..b04f1e0e3fab 100644
> --- a/arch/x86/boot/compressed/eboot.c
> +++ b/arch/x86/boot/compressed/eboot.c
> @@ -19,7 +19,10 @@
>  
>  static efi_system_table_t *sys_table;
>  
> -struct efi_config *efi_early;
> +static struct efi_config *efi_early;
> +
> +#define efi_call_early(f, ...)						\
> +	efi_early->call(efi_early->f, __VA_ARGS__);
>  
>  #define BOOT_SERVICES(bits)						\
>  static void setup_boot_services##bits(struct efi_config *c)		\
> @@ -280,6 +283,8 @@ void efi_char16_printk(efi_system_table_t *table, efi_char16_t *str)
>  	}
>  }
>  
> +#include "../../../../drivers/firmware/efi/libstub/efi-stub-helper.c"
> +
>  static void find_bits(unsigned long mask, u8 *pos, u8 *size)
>  {
>  	u8 first, len;
> diff --git a/arch/x86/boot/compressed/eboot.h b/arch/x86/boot/compressed/eboot.h
> index d487e727f1ec..c88c31ecad12 100644
> --- a/arch/x86/boot/compressed/eboot.h
> +++ b/arch/x86/boot/compressed/eboot.h
> @@ -103,4 +103,20 @@ struct efi_uga_draw_protocol {
>  	void *blt;
>  };
>  
> +struct efi_config {
> +	u64 image_handle;
> +	u64 table;
> +	u64 allocate_pool;
> +	u64 allocate_pages;
> +	u64 get_memory_map;
> +	u64 free_pool;
> +	u64 free_pages;
> +	u64 locate_handle;
> +	u64 handle_protocol;
> +	u64 exit_boot_services;
> +	u64 text_output;
> +	efi_status_t (*call)(unsigned long, ...);
> +	bool is64;
> +} __packed;
> +
>  #endif /* BOOT_COMPRESSED_EBOOT_H */
> diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
> index 044a2fd3c5fe..0ec241ede5a2 100644
> --- a/arch/x86/include/asm/efi.h
> +++ b/arch/x86/include/asm/efi.h
> @@ -159,30 +159,6 @@ static inline efi_status_t efi_thunk_set_virtual_address_map(
>  }
>  #endif /* CONFIG_EFI_MIXED */
>  
> -
> -/* arch specific definitions used by the stub code */
> -
> -struct efi_config {
> -	u64 image_handle;
> -	u64 table;
> -	u64 allocate_pool;
> -	u64 allocate_pages;
> -	u64 get_memory_map;
> -	u64 free_pool;
> -	u64 free_pages;
> -	u64 locate_handle;
> -	u64 handle_protocol;
> -	u64 exit_boot_services;
> -	u64 text_output;
> -	efi_status_t (*call)(unsigned long, ...);
> -	bool is64;
> -} __packed;
> -
> -extern struct efi_config *efi_early;
> -
> -#define efi_call_early(f, ...)						\
> -	efi_early->call(efi_early->f, __VA_ARGS__);
> -
>  extern bool efi_reboot_required(void);
>  
>  #else
> diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
> index d8be608a9f3b..aef6a95adef5 100644
> --- a/drivers/firmware/efi/Makefile
> +++ b/drivers/firmware/efi/Makefile
> @@ -7,4 +7,4 @@ obj-$(CONFIG_EFI_VARS_PSTORE)		+= efi-pstore.o
>  obj-$(CONFIG_UEFI_CPER)			+= cper.o
>  obj-$(CONFIG_EFI_RUNTIME_MAP)		+= runtime-map.o
>  obj-$(CONFIG_EFI_RUNTIME_WRAPPERS)	+= runtime-wrappers.o
> -obj-$(CONFIG_EFI_STUB)			+= libstub/
> +obj-$(CONFIG_EFI_ARM_STUB)		+= libstub/
> -- 
> 1.9.3
> 
> -- 
> Matt Fleming, Intel Open Source Technology Center
