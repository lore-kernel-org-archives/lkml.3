Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531AbaBRJAF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 04:00:05 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:41037 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057AbaBRJAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 04:00:03 -0500
Message-ID: <5303210D.7050107@linaro.org>
Date: Tue, 18 Feb 2014 16:59:57 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: linux-acpi@vger.kernel.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, linaro-acpi@lists.linaro.org
Subject: Re: [PATCH v2 1/3] ACPI / idle: Make idle_boot_override depend on
 x86 and ia64
References: <1391865018-3446-1-git-send-email-hanjun.guo@linaro.org> <1391865018-3446-2-git-send-email-hanjun.guo@linaro.org> <2759379.7ZoXxYUg14@vostro.rjw.lan>
In-Reply-To: <2759379.7ZoXxYUg14@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-2-18 9:13, Rafael J. Wysocki wrote:
> On Saturday, February 08, 2014 09:10:16 PM Hanjun Guo wrote:
>> idle_boot_override depends on x86 and ia64 now, and we can not
>> foresee it will be used on ARM or ARM64,so move the code into
>> CONFIG_X86 and CONFIG_IA64 #ifdefs to make processor_core.c
>> can be compiled on ARM64.
>>
>> Signed-off-by: Hanjun Guo <hanjun.guo@linaro.org>
>> ---
>>  drivers/acpi/processor_core.c |   40 ++++++++++++++++++++++------------------
>>  1 file changed, 22 insertions(+), 18 deletions(-)
>>
>> diff --git a/drivers/acpi/processor_core.c b/drivers/acpi/processor_core.c
>> index 46583d7..01b2656 100644
>> --- a/drivers/acpi/processor_core.c
>> +++ b/drivers/acpi/processor_core.c
>> @@ -19,24 +19,6 @@
>>  #define _COMPONENT		ACPI_PROCESSOR_COMPONENT
>>  ACPI_MODULE_NAME("processor_core");
>>  
>> -static int __init set_no_mwait(const struct dmi_system_id *id)
>> -{
>> -	printk(KERN_NOTICE PREFIX "%s detected - "
>> -		"disabling mwait for CPU C-states\n", id->ident);
>> -	boot_option_idle_override = IDLE_NOMWAIT;
>> -	return 0;
>> -}
>> -
>> -static struct dmi_system_id processor_idle_dmi_table[] __initdata = {
>> -	{
>> -	set_no_mwait, "Extensa 5220", {
>> -	DMI_MATCH(DMI_BIOS_VENDOR, "Phoenix Technologies LTD"),
>> -	DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
>> -	DMI_MATCH(DMI_PRODUCT_VERSION, "0100"),
>> -	DMI_MATCH(DMI_BOARD_NAME, "Columbia") }, NULL},
>> -	{},
>> -};
>> -
>>  static int map_lapic_id(struct acpi_subtable_header *entry,
>>  		 u32 acpi_id, int *apic_id)
>>  {
>> @@ -379,13 +361,35 @@ early_init_pdc(acpi_handle handle, u32 lvl, void *context, void **rv)
>>  	return AE_OK;
>>  }
>>  
>> +#if defined(CONFIG_X86) || defined(CONFIG_IA64)
>> +static int __init set_no_mwait(const struct dmi_system_id *id)
>> +{
>> +	printk(KERN_NOTICE PREFIX "%s detected - "
>> +		"disabling mwait for CPU C-states\n", id->ident);
>> +	boot_option_idle_override = IDLE_NOMWAIT;
>> +	return 0;
>> +}
>> +
>> +static struct dmi_system_id processor_idle_dmi_table[] __initdata = {
>> +	{
>> +	set_no_mwait, "Extensa 5220", {
>> +	DMI_MATCH(DMI_BIOS_VENDOR, "Phoenix Technologies LTD"),
>> +	DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
>> +	DMI_MATCH(DMI_PRODUCT_VERSION, "0100"),
>> +	DMI_MATCH(DMI_BOARD_NAME, "Columbia") }, NULL},
>> +	{},
>> +};
>> +#endif
>> +
>>  void __init acpi_early_processor_set_pdc(void)
>>  {
>> +#if defined(CONFIG_X86) || defined(CONFIG_IA64)
>>  	/*
>>  	 * Check whether the system is DMI table. If yes, OSPM
>>  	 * should not use mwait for CPU-states.
>>  	 */
>>  	dmi_check_system(processor_idle_dmi_table);
>> +#endif
> 
> Please define processor_dmi_check() under the #if above and an empty static
> inline counterpart of it for the case when the #if condition is not satisfied.
> Then just call processor_dmi_check() here without the #if block in the body
> of the function. 
> 
> There is a general rule to avoid preprocessor directives in function bodies.

Ok,will update soon, thanks for the comments.

Thanks
Hanjun

