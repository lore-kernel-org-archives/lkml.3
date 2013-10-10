Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab3JJKg7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 06:36:59 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:54307 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753748Ab3JJKg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 06:36:58 -0400
Date: Thu, 10 Oct 2013 11:36:46 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: "broonie@kernel.org" <broonie@kernel.org>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "sbkim73@samsung.com" <sbkim73@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        YoungJun Cho <yj44.cho@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 2/2] regulator: s5m8767: Modify parsing method of the
 voltage table of buck2/3/4
Message-ID: <20131010103646.GH26954@e106331-lin.cambridge.arm.com>
References: <1381369296-17101-1-git-send-email-cw00.choi@samsung.com>
 <1381369296-17101-2-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381369296-17101-2-git-send-email-cw00.choi@samsung.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 02:41:36AM +0100, Chanwoo Choi wrote:
> The s5m8767 regulator driver parse always the voltage table of buck2/3/4.
> If gpio_dvs feature isn't used and dts haven't included the voltage table
> of buck2/3/4, s5m8767 regulator driver return error and file probe state.
> 
> This patch check only voltage table of buck on s5m8767_pmic_dt_parse_pdata()
> if buck[2-4]_gpiodvs is true.
> 
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Signed-off-by: YoungJun Cho <yj44.cho@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/regulator/s5m8767.c | 54 +++++++++++++++++++++++----------------------
>  1 file changed, 28 insertions(+), 26 deletions(-)
> 
> diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
> index cb6cdb3..29999c0 100644
> --- a/drivers/regulator/s5m8767.c
> +++ b/drivers/regulator/s5m8767.c
> @@ -522,7 +522,7 @@ static int s5m8767_pmic_dt_parse_pdata(struct platform_device *pdev,
>  	struct device_node *pmic_np, *regulators_np, *reg_np;
>  	struct sec_regulator_data *rdata;
>  	struct sec_opmode_data *rmode;
> -	unsigned int i, dvs_voltage_nr = 1, ret;
> +	unsigned int i, dvs_voltage_nr = 8, ret;
>  
>  	pmic_np = iodev->dev->of_node;
>  	if (!pmic_np) {
> @@ -586,15 +586,39 @@ static int s5m8767_pmic_dt_parse_pdata(struct platform_device *pdev,
>  		rmode++;
>  	}
>  
> -	if (of_get_property(pmic_np, "s5m8767,pmic-buck2-uses-gpio-dvs", NULL))
> +	if (of_get_property(pmic_np, "s5m8767,pmic-buck2-uses-gpio-dvs", NULL)) {
>  		pdata->buck2_gpiodvs = true;

As this line is being changed, please switch to of_property_read_bool.

>  
> -	if (of_get_property(pmic_np, "s5m8767,pmic-buck3-uses-gpio-dvs", NULL))
> +		if (of_property_read_u32_array(pmic_np,
> +				"s5m8767,pmic-buck2-dvs-voltage",
> +				pdata->buck2_voltage, dvs_voltage_nr)) {

Won't this break existing (not conforming to the binding) dts?

$(git grep s5m8767,pmic-buck2-dvs-voltage) shows me
arch/arm/boot/dts/exynos5250-arndale.dts is only has one entry in its
s5m8767,pmic-buck3-uses-gpio-dvs property's list.

> +			dev_err(iodev->dev, "buck2 voltages not specified\n");
> +			return -EINVAL;
> +		}
> +	}
> +
> +	if (of_get_property(pmic_np, "s5m8767,pmic-buck3-uses-gpio-dvs", NULL)) {
>  		pdata->buck3_gpiodvs = true;

Another of_proeprty_read_bool candidate.

>  
> -	if (of_get_property(pmic_np, "s5m8767,pmic-buck4-uses-gpio-dvs", NULL))
> +		if (of_property_read_u32_array(pmic_np,
> +				"s5m8767,pmic-buck3-dvs-voltage",
> +				pdata->buck3_voltage, dvs_voltage_nr)) {
> +			dev_err(iodev->dev, "buck3 voltages not specified\n");
> +			return -EINVAL;
> +		}
> +	}
> +
> +	if (of_get_property(pmic_np, "s5m8767,pmic-buck4-uses-gpio-dvs", NULL)) {
>  		pdata->buck4_gpiodvs = true;

Similarly.

In general I'm confused by the need for the *-uses-gpio-dvs properties.
Are they not implied by the presence of *-dvs-voltage properties?

Cheers,
Mark.
