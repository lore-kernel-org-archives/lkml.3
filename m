Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752920AbaKXO63 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 09:58:29 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:61711 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751530AbaKXO61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 09:58:27 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Aaron Lu <aaron.lu@intel.com>
Cc: Lee Jones <lee.jones@linaro.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yegnesh Iyer <yegnesh.s.iyer@intel.com>, linux-acpi@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lv Zheng <lv.zheng@intel.com>
Subject: Re: [PATCH v3 updated 3/3] ACPI / PMIC: AXP288: support virtual GPIO in ACPI table
Date: Mon, 24 Nov 2014 16:19:39 +0100
Message-ID: <2204417.orosXAozvY@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <5472FB31.8000408@intel.com>
References: <1416553911-22990-1-git-send-email-aaron.lu@intel.com> <1648486.coeVgHKNdn@vostro.rjw.lan> <5472FB31.8000408@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 24, 2014 05:32:33 PM Aaron Lu wrote:
> On 11/24/2014 09:06 AM, Rafael J. Wysocki wrote:
> > On Friday, November 21, 2014 03:11:51 PM Aaron Lu wrote:
> >> +	if (!result) {
> >> +		status = acpi_install_address_space_handler(
> >> +				ACPI_HANDLE(parent), ACPI_ADR_SPACE_GPIO,
> >> +				intel_xpower_pmic_gpio_handler, NULL, NULL);
> > 
> > So here we have a problem, because we can't unregister the opregion handler
> > registered above if this fails.  Not nice.
> 
> I'm not correct in the cover letter, the actual problem with operation
> region remove is with module unload, it happens like this:
> 
> The acpi_remove_address_space_handler doesn't wait for the current
> running handler to return, so if we call
> acpi_remove_address_space_handler in a module's exit function, the
> handler's memory will be freed and the running handler will access to
> a no longer valid memory place.
> 
> So as long as we can make sure the handler will not go away from the
> memory, we are safe.

This only means that address space handlers cannot be removed from kernel
modules.

Lv was trying to add a wrapper for that some time ago, maybe it's a good
idea to revive that?

> With this said, the updated patch is here:
> 
> From: Aaron Lu <aaron.lu@intel.com>
> Date: Mon, 20 Oct 2014 17:06:20 +0800
> Subject: [PATCH 3/3] ACPI / PMIC: AXP288: support virtual GPIO in ACPI table
> 
> The same virtual GPIO strategy is also used for the AXP288 PMIC in that
> various control methods that are used to do power rail handling and
> sensor reading/setting will touch GPIO fields defined under the PMIC
> device. The GPIO fileds are only defined by the ACPI code while the
> actual hardware doesn't really have a GPIO controller, but to make those
> control method execution succeed, we have to install a GPIO handler for
> the PMIC device handle. Since we do not need the virtual GPIO strategy,
> we can simply do nothing in that handler.
> 
> Signed-off-by: Aaron Lu <aaron.lu@intel.com>
> ---
>  drivers/acpi/pmic/intel_pmic_xpower.c | 30 ++++++++++++++++++++++++++----
>  1 file changed, 26 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/acpi/pmic/intel_pmic_xpower.c b/drivers/acpi/pmic/intel_pmic_xpower.c
> index 795ca073db08..9ec57ebd81c9 100644
> --- a/drivers/acpi/pmic/intel_pmic_xpower.c
> +++ b/drivers/acpi/pmic/intel_pmic_xpower.c
> @@ -220,13 +220,35 @@ static struct intel_pmic_opregion_data intel_xpower_pmic_opregion_data = {
>  	.thermal_table_count = ARRAY_SIZE(thermal_table),
>  };
>  
> +static acpi_status intel_xpower_pmic_gpio_handler(u32 function,
> +		acpi_physical_address address, u32 bit_width, u64 *value,
> +		void *handler_context, void *region_context)
> +{
> +	return AE_OK;
> +}
>  
>  static int intel_xpower_pmic_opregion_probe(struct platform_device *pdev)
>  {
> -	struct axp20x_dev *axp20x = dev_get_drvdata(pdev->dev.parent);
> -	return intel_pmic_install_opregion_handler(&pdev->dev,
> -			ACPI_HANDLE(pdev->dev.parent), axp20x->regmap,
> -			&intel_xpower_pmic_opregion_data);
> +	struct device *parent = pdev->dev.parent;
> +	struct axp20x_dev *axp20x = dev_get_drvdata(parent);
> +	acpi_status status;
> +	int result;
> +
> +	status = acpi_install_address_space_handler(ACPI_HANDLE(parent),
> +			ACPI_ADR_SPACE_GPIO, intel_xpower_pmic_gpio_handler,
> +			NULL, NULL);
> +	if (ACPI_FAILURE(status))
> +		return -ENODEV;
> +
> +	result = intel_pmic_install_opregion_handler(&pdev->dev,
> +					ACPI_HANDLE(parent), axp20x->regmap,
> +					&intel_xpower_pmic_opregion_data);
> +	if (result)
> +		acpi_remove_address_space_handler(ACPI_HANDLE(parent),
> +						  ACPI_ADR_SPACE_GPIO,
> +						  intel_xpower_pmic_gpio_handler);
> +
> +	return result;
>  }
>  
>  static struct platform_driver intel_xpower_pmic_opregion_driver = {
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
