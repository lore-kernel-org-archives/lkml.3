Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152AbaKXGBg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 01:01:36 -0500
Received: from mga09.intel.com ([134.134.136.24]:39574 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972AbaKXGBc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 01:01:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,447,1413270000"; 
   d="scan'208";a="642368037"
Message-ID: <5472C9B9.5020508@intel.com>
Date: Mon, 24 Nov 2014 14:01:29 +0800
From: Aaron Lu <aaron.lu@intel.com>
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Lee Jones <lee.jones@linaro.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Yegnesh Iyer <yegnesh.s.iyer@intel.com>, linux-acpi@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/3] ACPI / PMIC: AXP288: support virtual GPIO in ACPI
 table
References: <1416553911-22990-1-git-send-email-aaron.lu@intel.com> <1416553911-22990-4-git-send-email-aaron.lu@intel.com> <1648486.coeVgHKNdn@vostro.rjw.lan>
In-Reply-To: <1648486.coeVgHKNdn@vostro.rjw.lan>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2014 09:06 AM, Rafael J. Wysocki wrote:
> On Friday, November 21, 2014 03:11:51 PM Aaron Lu wrote:
>> The same virtual GPIO strategy is also used for the AXP288 PMIC in that
>> various control methods that are used to do power rail handling and
>> sensor reading/setting will touch GPIO fields defined under the PMIC
>> device. The GPIO fileds are only defined by the ACPI code while the
>> actual hardware doesn't really have a GPIO controller, but to make those
>> control method execution succeed, we have to install a GPIO handler for
>> the PMIC device handle. Since we do not need the virtual GPIO strategy,
>> we can simply do nothing in that handler.
>>
>> Signed-off-by: Aaron Lu <aaron.lu@intel.com>
>> ---
>>  drivers/acpi/pmic/intel_pmic_xpower.c | 27 +++++++++++++++++++++++----
>>  1 file changed, 23 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/acpi/pmic/intel_pmic_xpower.c b/drivers/acpi/pmic/intel_pmic_xpower.c
>> index 6c4d6ce0cff1..480c41c36444 100644
>> --- a/drivers/acpi/pmic/intel_pmic_xpower.c
>> +++ b/drivers/acpi/pmic/intel_pmic_xpower.c
>> @@ -251,13 +251,32 @@ static struct intel_pmic_opregion_data intel_xpower_pmic_opregion_data = {
>>  	.thermal_table_count = ARRAY_SIZE(thermal_table),
>>  };
>>  
>> +static acpi_status intel_xpower_pmic_gpio_handler(u32 function,
>> +		acpi_physical_address address, u32 bit_width, u64 *value,
>> +		void *handler_context, void *region_context)
>> +{
>> +	return AE_OK;
>> +}
>>  
>>  static int intel_xpower_pmic_opregion_probe(struct platform_device *pdev)
>>  {
>> -	struct axp20x_dev *axp20x = dev_get_drvdata(pdev->dev.parent);
>> -	return intel_pmic_install_opregion_handler(&pdev->dev,
>> -			ACPI_HANDLE(pdev->dev.parent), axp20x->regmap,
>> -			&intel_xpower_pmic_opregion_data);
>> +	struct device *parent = pdev->dev.parent;
>> +	struct axp20x_dev *axp20x = dev_get_drvdata(parent);
>> +	acpi_status status;
>> +	int result;
>> +
>> +	result = intel_pmic_install_opregion_handler(&pdev->dev,
>> +					ACPI_HANDLE(parent), axp20x->regmap,
>> +					&intel_xpower_pmic_opregion_data);
>> +	if (!result) {
>> +		status = acpi_install_address_space_handler(
>> +				ACPI_HANDLE(parent), ACPI_ADR_SPACE_GPIO,
>> +				intel_xpower_pmic_gpio_handler, NULL, NULL);
> 
> So here we have a problem, because we can't unregister the opregion handler
> registered above if this fails.  Not nice.

I'll add a remove_opregion_handler call if the above install failed, the
chance the remove_opregion_handler will trigger a problem during init time
is pretty low.

If that is not desired, I can install the operation region handler for
the virtual GPIO first and then the real PMIC operation region handler,
the cost of leaving a virtual GPIO operation region handler is essential
zero I think.

Thanks,
Aaron

> 
>> +		if (ACPI_FAILURE(status))
>> +			result = -ENODEV;
>> +	}
>> +
>> +	return result;
>>  }
>>  
>>  static struct platform_driver intel_xpower_pmic_opregion_driver = {
>>
> 

