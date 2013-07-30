Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184Ab3G3NR5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 09:17:57 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:41985 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927Ab3G3NR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 09:17:56 -0400
Message-ID: <51F7BCEC.9080803@ti.com>
Date: Tue, 30 Jul 2013 08:17:32 -0500
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
Subject: Re: [PATCH 1/1] mfd: palmas: Add power off control
References: <1375185957-28212-1-git-send-email-bilhuang@nvidia.com>
In-Reply-To: <1375185957-28212-1-git-send-email-bilhuang@nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2013 07:05 AM, Bill Huang wrote:
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
>   .../devicetree/bindings/regulator/palmas-pmic.txt  |    5 +++++
>   drivers/mfd/palmas.c                               |   23 ++++++++++++++++++--
>   include/linux/mfd/palmas.h                         |    1 +
any reason why it wont fit in drivers/power/reset/ is'nt it the right 
place to add this?
>   3 files changed, 27 insertions(+), 2 deletions(-)
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
controller or master?
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
> index e4d1c70..0662b21 100644
> --- a/drivers/mfd/palmas.c
> +++ b/drivers/mfd/palmas.c
> @@ -229,6 +229,22 @@ static void palmas_dt_to_pdata(struct i2c_client *i2c,
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
> +
> +	if (!palmas_dev)
> +		return;
> +
> +	addr = PALMAS_BASE_TO_REG(PALMAS_PMU_CONTROL_BASE, PALMAS_DEV_CTRL);
> +
> +	regmap_update_bits(palmas_dev->regmap[0], addr, 1, 0);
slave = PALMAS_BASE_TO_SLAVE(base);
addr = PALMAS_BASE_TO_REG(base, reg);

r = regmap_update_bits(palmas->regmap[slave], addr, mask, val);
instead?

just for reference, an old implementation I had done is available at [1]


[1] 
http://git.omapzoom.org/?p=kernel/omap.git;a=blob;f=drivers/mfd/palmas-poweroff.c;hb=p-linux-omap-3.4

-- 
Regards,
Nishanth Menon
