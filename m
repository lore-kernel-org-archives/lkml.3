Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157AbaAPQEg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 11:04:36 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44083 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714AbaAPQEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 11:04:33 -0500
Date: Thu, 16 Jan 2014 17:03:57 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Lothar =?iso-8859-15?Q?Wa=DFmann?= <LW@KARO-electronics.de>
Cc: linux-arm-kernel@lists.infradead.org, Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        linux-pwm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 2/2] pwm: imx: support polarity inversion
Message-ID: <20140116160356.GY16215@pengutronix.de>
References: <1389859585-14006-1-git-send-email-LW@KARO-electronics.de>
 <1389859585-14006-3-git-send-email-LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1389859585-14006-3-git-send-email-LW@KARO-electronics.de>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 16:58:53 up 145 days,  1:29, 44 users,  load average: 0.41, 0.25,
 0.44
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 16, 2014 at 09:06:25AM +0100, Lothar Waﬂmann wrote:
> The i.MX PWM controller supports inverting the polarity of the PWM
> output. Make this feature available in the pxm-imx driver.
> 
> Signed-off-by: Lothar Waﬂmann <LW@KARO-electronics.de>
> ---
>  Documentation/devicetree/bindings/pwm/imx-pwm.txt |    5 +-
>  drivers/pwm/pwm-imx.c                             |   42 +++++++++++++++++++++
>  2 files changed, 45 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/pwm/imx-pwm.txt b/Documentation/devicetree/bindings/pwm/imx-pwm.txt
> index b50d7a6d..d0b04b5 100644
> --- a/Documentation/devicetree/bindings/pwm/imx-pwm.txt
> +++ b/Documentation/devicetree/bindings/pwm/imx-pwm.txt
> @@ -3,8 +3,9 @@ Freescale i.MX PWM controller
>  Required properties:
>  - compatible: should be "fsl,<soc>-pwm"
>  - reg: physical base address and length of the controller's registers
> -- #pwm-cells: should be 2. See pwm.txt in this directory for a description of
> -  the cells format.
> +- #pwm-cells: may be 2 for backwards compatibility or 3 to support
> +  switching the output polarity. See pwm.txt in this directory for a
> +  description of the cells format.
>  - interrupts: The interrupt for the pwm controller
>  
>  Example:
> diff --git a/drivers/pwm/pwm-imx.c b/drivers/pwm/pwm-imx.c
> index 3b00a82..05461bb 100644
> --- a/drivers/pwm/pwm-imx.c
> +++ b/drivers/pwm/pwm-imx.c
> @@ -36,6 +36,7 @@
>  #define MX3_PWMCR_DOZEEN		(1 << 24)
>  #define MX3_PWMCR_WAITEN		(1 << 23)
>  #define MX3_PWMCR_DBGEN			(1 << 22)
> +#define MX3_PWMCR_POUTC			(1 << 18)
>  #define MX3_PWMCR_CLKSRC_IPG_HIGH	(2 << 16)
>  #define MX3_PWMCR_CLKSRC_IPG		(1 << 16)
>  #define MX3_PWMCR_EN			(1 << 0)
> @@ -138,6 +139,9 @@ static int imx_pwm_config_v2(struct pwm_chip *chip,
>  	if (test_bit(PWMF_ENABLED, &pwm->flags))
>  		cr |= MX3_PWMCR_EN;
>  
> +	if (pwm->polarity == PWM_POLARITY_INVERSED)
> +		cr |= MX3_PWMCR_POUTC;
> +
>  	writel(cr, imx->mmio_base + MX3_PWMCR);
>  
>  	return 0;
> @@ -155,6 +159,11 @@ static void imx_pwm_set_enable_v2(struct pwm_chip *chip, bool enable)
>  	else
>  		val &= ~MX3_PWMCR_EN;
>  
> +	if (chip->pwms[0].polarity == PWM_POLARITY_INVERSED)
> +		val |= MX3_PWMCR_POUTC;
> +	else
> +		val &= ~MX3_PWMCR_POUTC;
> +
>  	writel(val, imx->mmio_base + MX3_PWMCR);
>  }
>  
> @@ -198,6 +207,17 @@ static void imx_pwm_disable(struct pwm_chip *chip, struct pwm_device *pwm)
>  	clk_disable_unprepare(imx->clk_per);
>  }
>  
> +static int imx_pwm_set_polarity(struct pwm_chip *chip, struct pwm_device *pwm,
> +				enum pwm_polarity polarity)
> +{
> +	struct imx_chip *imx = to_imx_chip(chip);
> +
> +	dev_dbg(imx->chip.dev, "%s: polarity set to %s\n", __func__,
> +		polarity == PWM_POLARITY_INVERSED ? "inverted" : "normal");
> +
> +	return 0;
> +}
> +
>  static struct pwm_ops imx_pwm_ops = {
>  	.enable = imx_pwm_enable,
>  	.disable = imx_pwm_disable,
> @@ -209,6 +229,7 @@ struct imx_pwm_data {
>  	int (*config)(struct pwm_chip *chip,
>  		struct pwm_device *pwm, int duty_ns, int period_ns);
>  	void (*set_enable)(struct pwm_chip *chip, bool enable);
> +	unsigned output_polarity:1;
>  };
>  
>  static struct imx_pwm_data imx_pwm_data_v1 = {
> @@ -219,6 +240,7 @@ static struct imx_pwm_data imx_pwm_data_v1 = {
>  static struct imx_pwm_data imx_pwm_data_v2 = {
>  	.config = imx_pwm_config_v2,
>  	.set_enable = imx_pwm_set_enable_v2,
> +	.output_polarity = 1,
>  };
>  
>  static const struct of_device_id imx_pwm_dt_ids[] = {
> @@ -271,6 +293,26 @@ static int imx_pwm_probe(struct platform_device *pdev)
>  		return PTR_ERR(imx->mmio_base);
>  
>  	data = of_id->data;
> +	if (data->output_polarity) {
> +		const struct device_node *np = pdev->dev.of_node;
> +		u32 num_cells;
> +
> +		dev_dbg(&pdev->dev, "PWM supports output inversion\n");
> +		ret = of_property_read_u32(np, "#pwm-cells", &num_cells);
> +		if (ret < 0) {
> +			dev_err(&pdev->dev, "missing property '#pwm-cells'\n");
> +			return ret;
> +		}
> +		if (num_cells == 3) {
> +			imx_pwm_ops.set_polarity = imx_pwm_set_polarity;
> +			imx->chip.of_xlate = of_pwm_xlate_with_flags;
> +		} else if (num_cells != 2) {
> +			dev_err(&pdev->dev, "'#pwm-cells' must be <2> or <3>\n");
> +			return -EINVAL;
> +		}
> +		imx->chip.of_pwm_n_cells = num_cells;
> +	}

Can't this be done in the PWM core? Right now the PWM core checks for
of_pwm_n_cells before calling ->of_xlate. IMO this check should be done
in the of_xlate hook. Then of_pwm_simple_xlate and
of_pwm_xlate_with_flags can be merged into something like:

static struct pwm_device *
of_pwm_simple_xlate(struct pwm_chip *pc, const struct of_phandle_args
*args)
{
	struct pwm_device *pwm;
	int ret;

	if (pc->of_pwm_n_cells < 2)
		return ERR_PTR(-EINVAL);

	if (args->args[0] >= pc->npwm)
		return ERR_PTR(-EINVAL);

	pwm = pwm_request_from_chip(pc, args->args[0], NULL);
	if (IS_ERR(pwm))
		return pwm;

	if (pc->of_pwm_n_cells >= 3) {
		if (args->args[2] & PWM_POLARITY_INVERTED)
			ret = pwm_set_polarity(pwm, PWM_POLARITY_INVERSED);
		else
			ret = pwm_set_polarity(pwm, PWM_POLARITY_NORMAL);
		if (ret)
			return ret;
	}

	pwm_set_period(pwm, args->args[1]);

	return pwm;
}

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
