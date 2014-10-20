Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553AbaJTSdG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 14:33:06 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:37534 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbaJTSdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 14:33:01 -0400
MIME-Version: 1.0
In-Reply-To: <1413829782-12891-1-git-send-email-mark.rutland@arm.com>
References: <1413829782-12891-1-git-send-email-mark.rutland@arm.com>
Date: Mon, 20 Oct 2014 20:32:59 +0200
Message-ID: <CAKv+Gu8fwvp4Ktd8xQOwzsKU95xBOT=Yd_B2K0UEPJF6QLf2zA@mail.gmail.com>
Subject: Re: [PATCH] efi: efi-stub: notify on DTB absence
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Salter <msalter@redhat.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Roy Franz <roy.franz@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 October 2014 20:29, Mark Rutland <mark.rutland@arm.com> wrote:
> In the absence of an DTB configuration table, the EFI stub will happily
> continue attempting to boot a kernel, despite the fact that this kernel
> may not function without a description of the hardware. In this case, as
> with a typo'd "dtb=" option (e.g. "dbt=") or many other possible
> failures, the only output seen by the user will be the rather terse
> output from the EFI stub:
>
> EFI stub: Booting Linux Kernel...
>
> To aid those attempting to debug such failures, this patch adds a notice
> when no DTB is found, making the output more helpful:
>
> EFI stub: Booting Linux Kernel...
> EFI stub: Generating empty DTB
>
> Similarly, a positive acknowledgement is added when a user-specified DTB
> is in use:
>
> EFI stub: Booting Linux Kernel...
> EFI stub: Using DTB from command line
>
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Acked-by: Leif Lindholm <leif.lindholm@linaro.org>

Acked-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

> Cc: Mark Salter <msalter@redhat.com>
> Cc: Matt Fleming <matt.fleming@intel.com>
> Cc: Roy Franz <roy.franz@linaro.org>
> ---
>  drivers/firmware/efi/libstub/arm-stub.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/firmware/efi/libstub/arm-stub.c b/drivers/firmware/efi/libstub/arm-stub.c
> index 480339b..10abf24 100644
> --- a/drivers/firmware/efi/libstub/arm-stub.c
> +++ b/drivers/firmware/efi/libstub/arm-stub.c
> @@ -243,9 +243,16 @@ unsigned long __init efi_entry(void *handle, efi_system_table_t *sys_table,
>                         goto fail_free_cmdline;
>                 }
>         }
> -       if (!fdt_addr)
> +
> +       if (fdt_addr) {
> +               pr_efi(sys_table, "Using DTB from command line\n");
> +       } else {
>                 /* Look for a device tree configuration table entry. */
>                 fdt_addr = (uintptr_t)get_fdt(sys_table);
> +       }
> +
> +       if (!fdt_addr)
> +               pr_efi(sys_table, "Generating empty DTB\n");
>
>         status = handle_cmdline_files(sys_table, image, cmdline_ptr,
>                                       "initrd=", dram_base + SZ_512M,
> --
> 1.9.1
>
