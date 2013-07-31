Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759639Ab3GaL6l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 07:58:41 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:50027 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098Ab3GaL6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 07:58:39 -0400
Message-ID: <51F8FBC4.1040009@ti.com>
Date: Wed, 31 Jul 2013 06:57:56 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Bill Huang <bilhuang@nvidia.com>
CC: <sameo@linux.intel.com>, <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <ian.campbell@citrix.com>, <rob@landley.net>, <lee.jones@linaro.org>,
        <broonie@linaro.org>, <j-keerthy@ti.com>, <grant.likely@linaro.org>,
        <ian@slimlogic.co.uk>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Mallikarjun Kasoju <mkasoju@nvidia.com>
Subject: Re: [PATCH v2 1/1] mfd: palmas: Add power off control
References: <1375255037-10024-1-git-send-email-bilhuang@nvidia.com>
In-Reply-To: <1375255037-10024-1-git-send-email-bilhuang@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2013 02:17 AM, Bill Huang wrote:
> Hook up "pm_power_off" to palmas power off routine if there is DT
> property "ti,system-power-controller" defined, so platform which is
> powered by this regulator can be powered off properly.
>
> Based on work by:
> Mallikarjun Kasoju <mkasoju@nvidia.com>
>
> Signed-off-by: Bill Huang <bilhuang@nvidia.com>
> cc: Mallikarjun Kasoju <mkasoju@nvidia.com>
> ---
>   .../devicetree/bindings/regulator/palmas-pmic.txt  |    5 +++
>   drivers/mfd/palmas.c                               |   33 ++++++++++++++++++--

Since the specific question on v1 was not answered, I will ask again, 
any reason why it wont fit in drivers/power/reset/ is'nt it the right
place to add this?


>   include/linux/mfd/palmas.h                         |    1 +
>   3 files changed, 37 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/regulator/palmas-pmic.txt b/Documentation/devicetree/bindings/regulator/palmas-pmic.txt
> index 30b0581..4adca2a 100644
> --- a/Documentation/devicetree/bindings/regulator/palmas-pmic.txt
> +++ b/Documentation/devicetree/bindings/regulator/palmas-pmic.txt
> @@ -36,6 +36,9 @@ Optional nodes:
>   	       ti,smps-range - OTP has the wrong range set for the hardware so override
>   	       0 - low range, 1 - high range.
>
> +- ti,system-power-controller: Telling whether or not this pmic is controlling
> +			      the system power.
> +
>   Example:
>
>   #include <dt-bindings/interrupt-controller/irq.h>
> @@ -48,6 +51,8 @@ pmic {
>
>   	ti,ldo6-vibrator;
>
> +	ti,system-power-controller;
> +
>   	regulators {
>   		smps12_reg : smps12 {
>   			regulator-name = "smps12";
> diff --git a/drivers/mfd/palmas.c b/drivers/mfd/palmas.c
> index e4d1c70..220a34d 100644
> --- a/drivers/mfd/palmas.c
> +++ b/drivers/mfd/palmas.c
> @@ -229,6 +229,32 @@ static void palmas_dt_to_pdata(struct i2c_client *i2c,
>   					PALMAS_POWER_CTRL_ENABLE2_MASK;
>   	if (i2c->irq)
>   		palmas_set_pdata_irq_flag(i2c, pdata);
> +
> +	pdata->pm_off = of_property_read_bool(node,
> +			"ti,system-power-controller");
> +}
> +
> +static struct palmas *palmas_dev;
> +static void palmas_power_off(void)
> +{
> +	unsigned int addr;
> +	int ret, slave;
> +
> +	if (!palmas_dev)
> +		return;
> +

If you notice the reference code I send, atleast on TWL6035/37 variants 
of Palmas, USB IRQ unmask is mandatory for power on with USB cable - 
example usage scenario: extremely low battery, device powered off, plug 
in usb cable to restart charging - you'd like to initiate charging logic 
in bootloader, but that wont work if the device does not do OFF-ON 
transition with usb cable plugged in for vbus.

> +	slave = PALMAS_BASE_TO_SLAVE(PALMAS_PMU_CONTROL_BASE);
> +	addr = PALMAS_BASE_TO_REG(PALMAS_PMU_CONTROL_BASE, PALMAS_DEV_CTRL);
> +
> +	ret = regmap_update_bits(
> +			palmas_dev->regmap[slave],
> +			addr,
> +			PALMAS_DEV_CTRL_DEV_ON,
> +			0);
> +
> +	if (ret)
> +		pr_err("%s: Unable to write to DEV_CTRL_DEV_ON: %d\n",
> +				__func__, ret);
>   }
>
>   static unsigned int palmas_features = PALMAS_PMIC_FEATURE_SMPS10_BOOST;
> @@ -423,10 +449,13 @@ no_irq:
>   	 */
>   	if (node) {
>   		ret = of_platform_populate(node, NULL, NULL, &i2c->dev);
> -		if (ret < 0)
> +		if (ret < 0) {
>   			goto err_irq;
> -		else
> +		} else if (pdata->pm_off && !pm_power_off) {
> +			palmas_dev = palmas;
> +			pm_power_off = palmas_power_off;
>   			return ret;
> +		}
>   	}
>
>   	return ret;
> diff --git a/include/linux/mfd/palmas.h b/include/linux/mfd/palmas.h
> index 1a8dd7a..061cce0 100644
> --- a/include/linux/mfd/palmas.h
> +++ b/include/linux/mfd/palmas.h
> @@ -258,6 +258,7 @@ struct palmas_platform_data {
>   	 */
>   	int mux_from_pdata;
>   	u8 pad1, pad2;
> +	bool pm_off;
>
>   	struct palmas_pmic_platform_data *pmic_pdata;
>   	struct palmas_gpadc_platform_data *gpadc_pdata;
>


-- 
Regards,
Nishanth Menon
