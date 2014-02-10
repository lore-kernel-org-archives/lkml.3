Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752487AbaBJB4Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 20:56:24 -0500
Received: from mail-qc0-f180.google.com ([209.85.216.180]:35798 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752407AbaBJB4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 20:56:01 -0500
MIME-Version: 1.0
In-Reply-To: <1391865018-3446-2-git-send-email-hanjun.guo@linaro.org>
References: <1391865018-3446-1-git-send-email-hanjun.guo@linaro.org>
	<1391865018-3446-2-git-send-email-hanjun.guo@linaro.org>
Date: Mon, 10 Feb 2014 09:55:59 +0800
Message-ID: <CAOLK0px-Ju9Oz9jdPtjWk19HJcxYWGYn8VBn5xTpQwq=ZsyrUQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] ACPI / idle: Make idle_boot_override depend on x86
 and ia64
From: Lan Tianyu <lantianyu1986@gmail.com>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Patch Tracking <patches@linaro.org>,
        "linux-kernel@vger kernel org" <linux-kernel@vger.kernel.org>,
        linaro-acpi@lists.linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-02-08 Hanjun Guo <hanjun.guo@linaro.org>:
> idle_boot_override depends on x86 and ia64 now, and we can not
> foresee it will be used on ARM or ARM64,so move the code into
> CONFIG_X86 and CONFIG_IA64 #ifdefs to make processor_core.c
> can be compiled on ARM64.
>

Reviewed-by: Lan Tianyu <tianyu.lan@intel.com>

> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
> ---
>  drivers/acpi/processor_core.c |   40 ++++++++++++++++++++++------------------
>  1 file changed, 22 insertions(+), 18 deletions(-)
>
> diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
> index 46583d7..01b2656 100644
> --- a/drivers/acpi/processor_core.c
> +++ b/drivers/acpi/processor_core.c
> @@ -19,24 +19,6 @@
>  #define _COMPONENT             ACPI_PROCESSOR_COMPONENT
>  ACPI_MODULE_NAME("processor_core");
>
> -static int __init set_no_mwait(const struct dmi_system_id *id)
> -{
> -       printk(KERN_NOTICE PREFIX "%s detected - "
> -               "disabling mwait for CPU C-states\n", id->ident);
> -       boot_option_idle_override = IDLE_NOMWAIT;
> -       return 0;
> -}
> -
> -static struct dmi_system_id processor_idle_dmi_table[] __initdata = {
> -       {
> -       set_no_mwait, "Extensa 5220", {
> -       DMI_MATCH(DMI_BIOS_VENDOR, "Phoenix Technologies LTD"),
> -       DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
> -       DMI_MATCH(DMI_PRODUCT_VERSION, "0100"),
> -       DMI_MATCH(DMI_BOARD_NAME, "Columbia") }, NULL},
> -       {},
> -};
> -
>  static int map_lapic_id(struct acpi_subtable_header *entry,
>                  u32 acpi_id, int *apic_id)
>  {
> @@ -379,13 +361,35 @@ early_init_pdc(acpi_handle handle, u32 lvl, void *context, void **rv)
>         return AE_OK;
>  }
>
> +#if defined(CONFIG_X86) || defined(CONFIG_IA64)
> +static int __init set_no_mwait(const struct dmi_system_id *id)
> +{
> +       printk(KERN_NOTICE PREFIX "%s detected - "
> +               "disabling mwait for CPU C-states\n", id->ident);
> +       boot_option_idle_override = IDLE_NOMWAIT;
> +       return 0;
> +}
> +
> +static struct dmi_system_id processor_idle_dmi_table[] __initdata = {
> +       {
> +       set_no_mwait, "Extensa 5220", {
> +       DMI_MATCH(DMI_BIOS_VENDOR, "Phoenix Technologies LTD"),
> +       DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
> +       DMI_MATCH(DMI_PRODUCT_VERSION, "0100"),
> +       DMI_MATCH(DMI_BOARD_NAME, "Columbia") }, NULL},
> +       {},
> +};
> +#endif
> +
>  void __init acpi_early_processor_set_pdc(void)
>  {
> +#if defined(CONFIG_X86) || defined(CONFIG_IA64)
>         /*
>          * Check whether the system is DMI table. If yes, OSPM
>          * should not use mwait for CPU-states.
>          */
>         dmi_check_system(processor_idle_dmi_table);
> +#endif
>
>         acpi_walk_namespace(ACPI_TYPE_PROCESSOR, ACPI_ROOT_OBJECT,
>                             ACPI_UINT32_MAX,
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Best regards
Tianyu Lan
