Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373AbaBESJQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 13:09:16 -0500
Received: from mail-lb0-f176.google.com ([209.85.217.176]:51945 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753315AbaBESJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 13:09:13 -0500
MIME-Version: 1.0
In-Reply-To: <1391619853-10601-22-git-send-email-leif.lindholm@linaro.org>
References: <1391619853-10601-1-git-send-email-leif.lindholm@linaro.org>
	<1391619853-10601-22-git-send-email-leif.lindholm@linaro.org>
Date: Wed, 5 Feb 2014 19:09:11 +0100
Message-ID: <CAKv+Gu-yD+MjN70cVRCwdBB=LLmJX9X7RVv13gTEuZcko+2E8A@mail.gmail.com>
Subject: Re: [PATCH 21/22] arm: efistub: ignore dtb= when UEFI SecureBoot is enabled
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Patch Tracking <patches@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 February 2014 18:04, Leif Lindholm <leif.lindholm@linaro.org> wrote:
> From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>
> Loading unauthenticated FDT blobs directly from storage is a security hazard,
> so this should only be allowed when running with UEFI Secure Boot disabled.
>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
> ---
>  drivers/firmware/efi/arm-stub.c        |    4 +++-
>  drivers/firmware/efi/efi-stub-helper.c |   24 ++++++++++++++++++++++++
>  2 files changed, 27 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/firmware/efi/arm-stub.c b/drivers/firmware/efi/arm-stub.c
> index b505fde..c651082 100644
> --- a/drivers/firmware/efi/arm-stub.c
> +++ b/drivers/firmware/efi/arm-stub.c
> @@ -95,7 +95,9 @@ unsigned long efi_entry(void *handle, efi_system_table_t *sys_table,
>
>         /* Load a device tree from the configuration table, if present. */
>         fdt_addr = (uintptr_t)get_fdt(sys_table);
> -       if (!fdt_addr) {
> +       if (efi_secureboot_enabled(sys_table))
> +               pr_efi(sys_table, "UEFI Secure Boot is enabled, ignoring dtb= commandline option.\n");

I am pretty sure my original patch had braces on both branches of the if () :-)

Also, I think the precedence is backward here: dtb= should trump
config table, not the other way around.

-- 
Ard.


> +       else if (!fdt_addr) {
>                 status = handle_cmdline_files(sys_table, image, cmdline_ptr,
>                                               "dtb=",
>                                               ~0UL, (unsigned long *)&fdt_addr,
> diff --git a/drivers/firmware/efi/efi-stub-helper.c b/drivers/firmware/efi/efi-stub-helper.c
> index 2ee69ea..6221be7 100644
> --- a/drivers/firmware/efi/efi-stub-helper.c
> +++ b/drivers/firmware/efi/efi-stub-helper.c
> @@ -721,3 +721,27 @@ static char *efi_convert_cmdline(efi_system_table_t *sys_table_arg,
>         *cmd_line_len = options_bytes;
>         return (char *)cmdline_addr;
>  }
> +
> +static int __init efi_secureboot_enabled(efi_system_table_t *sys_table_arg)
> +{
> +       static efi_guid_t const var_guid __initconst = EFI_GLOBAL_VARIABLE_GUID;
> +       static efi_char16_t const var_name[] __initconst = {
> +               'S', 'e', 'c', 'u', 'r', 'e', 'B', 'o', 'o', 't', 0 };
> +
> +       efi_get_variable_t *f_getvar = sys_table_arg->runtime->get_variable;
> +       unsigned long size = sizeof(u8);
> +       efi_status_t status;
> +       u8 val;
> +
> +       status = efi_call_phys5(f_getvar, (efi_char16_t *)var_name,
> +                               (efi_guid_t *)&var_guid, NULL, &size, &val);
> +
> +       switch (status) {
> +       case EFI_SUCCESS:
> +               return val;
> +       case EFI_NOT_FOUND:
> +               return 0;
> +       default:
> +               return 1;
> +       }
> +}
> --
> 1.7.10.4
>
