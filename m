Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188AbaBRA6l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 19:58:41 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:63913 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753982AbaBRA6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 19:58:38 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: linux-acpi@vger.kernel.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org
Subject: Re: [PATCH v2 1/3] ACPI / idle: Make idle_boot_override depend on x86 and ia64
Date: Tue, 18 Feb 2014 02:13:26 +0100
Message-ID: <2759379.7ZoXxYUg14@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1391865018-3446-2-git-send-email-hanjun.guo@linaro.org>
References: <1391865018-3446-1-git-send-email-hanjun.guo@linaro.org> <1391865018-3446-2-git-send-email-hanjun.guo@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, February 08, 2014 09:10:16 PM Hanjun Guo wrote:
> idle_boot_override depends on x86 and ia64 now, and we can not
> foresee it will be used on ARM or ARM64,so move the code into
> CONFIG_X86 and CONFIG_IA64 #ifdefs to make processor_core.c
> can be compiled on ARM64.
> 
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
>  #define _COMPONENT		ACPI_PROCESSOR_COMPONENT
>  ACPI_MODULE_NAME("processor_core");
>  
> -static int __init set_no_mwait(const struct dmi_system_id *id)
> -{
> -	printk(KERN_NOTICE PREFIX "%s detected - "
> -		"disabling mwait for CPU C-states\n", id->ident);
> -	boot_option_idle_override = IDLE_NOMWAIT;
> -	return 0;
> -}
> -
> -static struct dmi_system_id processor_idle_dmi_table[] __initdata = {
> -	{
> -	set_no_mwait, "Extensa 5220", {
> -	DMI_MATCH(DMI_BIOS_VENDOR, "Phoenix Technologies LTD"),
> -	DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
> -	DMI_MATCH(DMI_PRODUCT_VERSION, "0100"),
> -	DMI_MATCH(DMI_BOARD_NAME, "Columbia") }, NULL},
> -	{},
> -};
> -
>  static int map_lapic_id(struct acpi_subtable_header *entry,
>  		 u32 acpi_id, int *apic_id)
>  {
> @@ -379,13 +361,35 @@ early_init_pdc(acpi_handle handle, u32 lvl, void *context, void **rv)
>  	return AE_OK;
>  }
>  
> +#if defined(CONFIG_X86) || defined(CONFIG_IA64)
> +static int __init set_no_mwait(const struct dmi_system_id *id)
> +{
> +	printk(KERN_NOTICE PREFIX "%s detected - "
> +		"disabling mwait for CPU C-states\n", id->ident);
> +	boot_option_idle_override = IDLE_NOMWAIT;
> +	return 0;
> +}
> +
> +static struct dmi_system_id processor_idle_dmi_table[] __initdata = {
> +	{
> +	set_no_mwait, "Extensa 5220", {
> +	DMI_MATCH(DMI_BIOS_VENDOR, "Phoenix Technologies LTD"),
> +	DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
> +	DMI_MATCH(DMI_PRODUCT_VERSION, "0100"),
> +	DMI_MATCH(DMI_BOARD_NAME, "Columbia") }, NULL},
> +	{},
> +};
> +#endif
> +
>  void __init acpi_early_processor_set_pdc(void)
>  {
> +#if defined(CONFIG_X86) || defined(CONFIG_IA64)
>  	/*
>  	 * Check whether the system is DMI table. If yes, OSPM
>  	 * should not use mwait for CPU-states.
>  	 */
>  	dmi_check_system(processor_idle_dmi_table);
> +#endif

Please define processor_dmi_check() under the #if above and an empty static
inline counterpart of it for the case when the #if condition is not satisfied.
Then just call processor_dmi_check() here without the #if block in the body
of the function. 

There is a general rule to avoid preprocessor directives in function bodies.

>  
>  	acpi_walk_namespace(ACPI_TYPE_PROCESSOR, ACPI_ROOT_OBJECT,
>  			    ACPI_UINT32_MAX,
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
