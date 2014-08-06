Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957AbaHFOKt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 10:10:49 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:33787 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612AbaHFOKr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 10:10:47 -0400
MIME-Version: 1.0
In-Reply-To: <20140806140155.GC15082@console-pimps.org>
References: <20140806083825.GA31711@dhcp-16-198.nay.redhat.com>
	<20140806130623.GI4179@bivouac.eciton.net>
	<20140806132021.GB15082@console-pimps.org>
	<20140806132941.GJ4179@bivouac.eciton.net>
	<20140806140155.GC15082@console-pimps.org>
Date: Wed, 6 Aug 2014 16:10:45 +0200
Message-ID: <CAKv+Gu8ey1iKu-_wS6yYaEXQaQMDXa+PF5Kiw+edA9a_OE1EAw@mail.gmail.com>
Subject: Re: [PATCH 1/2] UEFI arm64: add noefi boot param
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: Leif Lindholm <leif.lindholm@linaro.org>, Dave Young <dyoung@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Mark Salter <msalter@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 August 2014 16:01, Matt Fleming <matt@console-pimps.org> wrote:
> On Wed, 06 Aug, at 02:29:41PM, Leif Lindholm wrote:
>> On Wed, Aug 06, 2014 at 02:20:21PM +0100, Matt Fleming wrote:
>> > > Since this is really turning an x86-specific feature into a generic
>> > > one, could it be moved to core code?
>> > > Maybe an efi.mask, reusing the efi_enabled defines, with an
>> > > efi_disabled macro?
>> >
>> > Why the new efi_disabled() and efi.mask? This is all achievable with
>> > efi_enabled() and efi.flags, in fact, this kind of thing is exactly why
>> > they were invented.
>>
>> Because this flag is indicating which facilities we should not try to
>> enable, rather than which facilities we have enabled.
>>
>> The EFI_RUNTIME_SERVICES flag is set after successful call to
>> set_virtual_address_map. The apparent intent of "noefi" is to prevent
>> that call from being made in the first place.
>>
>> Anyway, it was just a suggestion - main point was it would make sense
>> to share the code.
>
> Definitely.
>
> Dave, below is the kind of thing that I had in mind. Please Cc the Xen
> and SGI folks when you submit your next version because they're likely
> to be hit the hardest by any changes to EFI_RUNTIME_SERVICES and
> "noefi".
>
> Obviously the addition of "efi=noruntime" is needed on top, but that's
> about 6 lines of code.
>
> ---
>  arch/arm64/kernel/efi.c     |  4 ++--
>  arch/x86/kernel/setup.c     |  4 +++-
>  arch/x86/platform/efi/efi.c | 33 +++++++++------------------------
>  drivers/firmware/efi/efi.c  |  7 +++++++
>  4 files changed, 21 insertions(+), 27 deletions(-)
>
> diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
> index e72f3100958f..9fdedb721a4e 100644
> --- a/arch/arm64/kernel/efi.c
> +++ b/arch/arm64/kernel/efi.c
> @@ -83,6 +83,7 @@ static int __init uefi_init(void)
>
>         set_bit(EFI_BOOT, &efi.flags);
>         set_bit(EFI_64BIT, &efi.flags);
> +       set_bit(EFI_RUNTIME_SERVICES, &efi.flags);
>
>         /*
>          * Verify the EFI Table
> @@ -386,7 +387,7 @@ static int __init arm64_enter_virtual_mode(void)
>         int count = 0;
>         unsigned long flags;
>
> -       if (!efi_enabled(EFI_BOOT)) {
> +       if (!efi_enabled(EFI_BOOT) || !efi_enabled(EFI_RUNTIME_SERVICES)) {
>                 pr_info("EFI services will not be available.\n");
>                 return -1;
>         }
> @@ -461,7 +462,6 @@ static int __init arm64_enter_virtual_mode(void)
>         /* Set up runtime services function pointers */
>         runtime = efi.systab->runtime;
>         efi_native_runtime_setup();
> -       set_bit(EFI_RUNTIME_SERVICES, &efi.flags);
>

Shouldn't we clear the bit here if we failed to enable runtime
services for some reason? Other code may test the bit assuming that it
signifies that runtime services have been enabled successfully, while
this patch changes it to mean that we /intended/ to enable them, which
is not quite the same thing.


>         return 0;
>
> diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> index 41ead8d3bc0b..3e2f820b6007 100644
> --- a/arch/x86/kernel/setup.c
> +++ b/arch/x86/kernel/setup.c
> @@ -932,8 +932,10 @@ void __init setup_arch(char **cmdline_p)
>                 set_bit(EFI_64BIT, &efi.flags);
>         }
>
> -       if (efi_enabled(EFI_BOOT))
> +       if (efi_enabled(EFI_BOOT)) {
>                 efi_memblock_x86_reserve_range();
> +               set_bit(EFI_RUNTIME_SERVICES, &efi.flags);
> +       }
>  #endif
>
>         x86_init.oem.arch_setup();
> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> index a1f745b0bf1d..bac12cae2a80 100644
> --- a/arch/x86/platform/efi/efi.c
> +++ b/arch/x86/platform/efi/efi.c
> @@ -70,14 +70,6 @@ static efi_config_table_type_t arch_tables[] __initdata = {
>
>  u64 efi_setup;         /* efi setup_data physical address */
>
> -static bool disable_runtime __initdata = false;
> -static int __init setup_noefi(char *arg)
> -{
> -       disable_runtime = true;
> -       return 0;
> -}
> -early_param("noefi", setup_noefi);
> -
>  int add_efi_memmap;
>  EXPORT_SYMBOL(add_efi_memmap);
>
> @@ -397,20 +389,12 @@ static int __init efi_runtime_init(void)
>          * hypercall which executes relevant EFI functions) and that is why
>          * they are always enabled.
>          */
> +       if (efi_enabled(EFI_64BIT))
> +               rv = efi_runtime_init64();
> +       else
> +               rv = efi_runtime_init32();
>
> -       if (!efi_enabled(EFI_PARAVIRT)) {
> -               if (efi_enabled(EFI_64BIT))
> -                       rv = efi_runtime_init64();
> -               else
> -                       rv = efi_runtime_init32();
> -
> -               if (rv)
> -                       return rv;
> -       }
> -
> -       set_bit(EFI_RUNTIME_SERVICES, &efi.flags);
> -
> -       return 0;
> +       return rv;
>  }
>
>  static int __init efi_memmap_init(void)
> @@ -489,10 +473,11 @@ void __init efi_init(void)
>          * that doesn't match the kernel 32/64-bit mode.
>          */
>
> -       if (!efi_runtime_supported())
> +       if (!efi_runtime_supported()) {
>                 pr_info("No EFI runtime due to 32/64-bit mismatch with kernel\n");
> -       else {
> -               if (disable_runtime || efi_runtime_init())
> +               clear_bit(EFI_RUNTIME_SERVICES, &efi.flags);
> +       } else {
> +               if (!efi_enabled(EFI_RUNTIME_SERVICES) || efi_runtime_init())
>                         return;
>         }
>         if (efi_memmap_init())
> diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
> index 36ffa1747e84..e7584ac22be1 100644
> --- a/drivers/firmware/efi/efi.c
> +++ b/drivers/firmware/efi/efi.c
> @@ -415,3 +415,10 @@ int __init efi_get_fdt_params(struct efi_fdt_params *params, int verbose)
>         return of_scan_flat_dt(fdt_find_uefi_params, &info);
>  }
>  #endif /* CONFIG_EFI_PARAMS_FROM_FDT */
> +
> +static int __init setup_noefi(char *arg)
> +{
> +       clear_bit(EFI_RUNTIME_SERVICES, &efi.flags);
> +       return 0;
> +}
> +early_param("noefi", setup_noefi);
> --
> 1.9.0
>
> --
> Matt Fleming, Intel Open Source Technology Center
