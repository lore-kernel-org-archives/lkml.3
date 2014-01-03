Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098AbaACTBx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 14:01:53 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:34902 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658AbaACTBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 14:01:50 -0500
Date: Fri, 3 Jan 2014 17:01:11 -0200
From: Leandro Dorileo <l@dorileo.org>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: lenb@kernel.org, rjw@rjwysocki.net, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, fcr@adinet.com.uy,
        "3.8+" <stable@vger.kernel.org>
Subject: Re: [PATCH] ACPI/Battery: Add a _BIX quirk for NEC LZ750/LS
Message-ID: <20140103190033.GA20314@dorilex-lnv.amr.corp.intel.com>
References: <1388648277-23453-1-git-send-email-tianyu.lan@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1388648277-23453-1-git-send-email-tianyu.lan@intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 02, 2014 at 03:37:57PM +0800, Lan Tianyu wrote:
> The aml method _BIX of NEC LZ750/LS returns a broken package which
> skip the first member "Revision" according ACPI 5.0 spec Table 10-234.
> 
> This patch is to add a quirk for this machine to skip member "Revision"
> during parsing _BIX returned package.
> 
> Reported-and-tested-by: Francisco Castro <fcr@adinet.com.uy>
> Reference: https://bugzilla.kernel.org/show_bug.cgi?id=67351
> Cc: 3.8+ <stable@vger.kernel.org>
> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
> ---
>  drivers/acpi/battery.c |   28 +++++++++++++++++++++++++++-
>  1 file changed, 27 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
> index fbf1ace..3d64a87 100644
> --- a/drivers/acpi/battery.c
> +++ b/drivers/acpi/battery.c
> @@ -62,6 +62,7 @@ MODULE_AUTHOR("Alexey Starikovskiy <astarikovskiy@suse.de>");
>  MODULE_DESCRIPTION("ACPI Battery Driver");
>  MODULE_LICENSE("GPL");
>  
> +static int battery_bix_broken_package;
>  static unsigned int cache_time = 1000;
>  module_param(cache_time, uint, 0644);
>  MODULE_PARM_DESC(cache_time, "cache time in milliseconds");
> @@ -416,7 +417,12 @@ static int acpi_battery_get_info(struct acpi_battery *battery)
>  		ACPI_EXCEPTION((AE_INFO, status, "Evaluating %s", name));
>  		return -ENODEV;
>  	}
> -	if (test_bit(ACPI_BATTERY_XINFO_PRESENT, &battery->flags))
> +
> +	if (battery_bix_broken_package)
> +		result = extract_package(battery, buffer.pointer,
> +				extended_info_offsets + 1,
> +				ARRAY_SIZE(extended_info_offsets) - 1);
> +	else if (test_bit(ACPI_BATTERY_XINFO_PRESENT, &battery->flags))
>  		result = extract_package(battery, buffer.pointer,
>  				extended_info_offsets,
>  				ARRAY_SIZE(extended_info_offsets));
> @@ -754,6 +760,24 @@ static int battery_notify(struct notifier_block *nb,
>  	return 0;
>  }
>  
> +static int battery_bix_package_quirk(const struct dmi_system_id *id)
> +{
> +	battery_bix_broken_package = 1;
> +	return 0;
> +}
> +


Do you really need this callback? Why don't you just do:

if (dmi_check_system(bat_dmi_table))
       battery_bix_broken_package = 1;


> +static struct dmi_system_id bat_dmi_table[] = {
> +	{
> +	.callback = battery_bix_package_quirk,
> +	.ident = "NEC LZ750/LS",
> +	.matches = {
> +		DMI_MATCH(DMI_SYS_VENDOR, "NEC"),
> +		DMI_MATCH(DMI_PRODUCT_NAME, "PC-LZ750LS"),
> +		},
> +	},
> +	{},
> +};
> +
>  static int acpi_battery_add(struct acpi_device *device)
>  {
>  	int result = 0;
> @@ -846,6 +870,8 @@ static void __init acpi_battery_init_async(void *unused, async_cookie_t cookie)
>  {
>  	if (acpi_disabled)
>  		return;
> +
> +	dmi_check_system(bat_dmi_table);
>  	acpi_bus_register_driver(&acpi_battery_driver);
>  }
>  
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Leandro Dorileo
