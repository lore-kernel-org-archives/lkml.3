Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612Ab3IJGv7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 02:51:59 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59044 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497Ab3IJGv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 02:51:58 -0400
Date: Tue, 10 Sep 2013 08:51:46 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: r65073@freescale.com, thierry.reding@gmail.com, grant.likely@linaro.org,
        linux@arm.linux.org.uk, rob@landley.net, ian.campbell@citrix.com,
        swarren@wwwdotorg.org, mark.rutland@arm.com, pawel.moll@arm.com,
        rob.herring@calxeda.com, linux-arm-kernel@lists.infradead.org,
        linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        Jingchang Lu <b35083@freescale.com>
Subject: Re: [PATCHv3 1/4] pwm: Add Freescale FTM PWM driver support
Message-ID: <20130910065146.GA30088@pengutronix.de>
Mail-Followup-To: Xiubo Li <Li.Xiubo@freescale.com>, r65073@freescale.com,
	thierry.reding@gmail.com, grant.likely@linaro.org,
	linux@arm.linux.org.uk, rob@landley.net, ian.campbell@citrix.com,
	swarren@wwwdotorg.org, mark.rutland@arm.com, pawel.moll@arm.com,
	rob.herring@calxeda.com, linux-arm-kernel@lists.infradead.org,
	linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
	Jingchang Lu <b35083@freescale.com>
References: <1378454907-22728-1-git-send-email-Li.Xiubo@freescale.com>
 <1378454907-22728-2-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378454907-22728-2-git-send-email-Li.Xiubo@freescale.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:40:53 up 16 days, 16:11, 41 users,  load average: 0.65, 0.33,
 0.40
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 06, 2013 at 04:08:24PM +0800, Xiubo Li wrote:
> The FTM PWM device can be found on Vybrid VF610 Tower and Layerscape LS-1 SoCs.
> 
> +
> +static int fsl_pwm_probe(struct platform_device *pdev)
> +{
> +	int ret = 0;
> +	struct fsl_pwm_chip *fpc;
> +	struct resource *res;
> +
> +	fpc = devm_kzalloc(&pdev->dev, sizeof(*fpc), GFP_KERNEL);

You don't have to output a message when kzalloc fails, but still you
should check for the result and return an error if necessary.

With this fixed:

Reviewed-by: Sascha Hauer <s.hauer@pengutronix.de>

Sascha

> +
> +	ret = fsl_pwm_parse_clk_ps(fpc);
> +	if (ret < 0)
> +		return ret;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	fpc->base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(fpc->base)) {
> +		ret = PTR_ERR(fpc->base);
> +		return ret;
> +	}
> +
> +	fpc->pinctrl = devm_pinctrl_get(&pdev->dev);
> +	if (IS_ERR(fpc->pinctrl)) {
> +		ret = PTR_ERR(fpc->pinctrl);
> +		return ret;
> +	}
> +
> +	fpc->chip.ops = &fsl_pwm_ops;
> +	fpc->chip.of_xlate = of_pwm_xlate_with_flags;
> +	fpc->chip.of_pwm_n_cells = 3;
> +	fpc->chip.base = -1;
> +	fpc->chip.npwm = FTM_MAX_CHANNEL;
> +	ret = pwmchip_add(&fpc->chip);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "failed to add PWM chip %d\n", ret);
> +		return ret;
> +	}
> +
> +	platform_set_drvdata(pdev, fpc);
> +
> +	return 0;
> +}
> +
> +static int fsl_pwm_remove(struct platform_device *pdev)
> +{
> +	struct fsl_pwm_chip *fpc;
> +
> +	fpc = platform_get_drvdata(pdev);
> +
> +	return pwmchip_remove(&fpc->chip);
> +}
> +
> +static const struct of_device_id fsl_pwm_dt_ids[] = {
> +	{ .compatible = "fsl,vf610-ftm-pwm", },
> +	{ /* sentinel */ }
> +};
> +MODULE_DEVICE_TABLE(of, fsl_pwm_dt_ids);
> +
> +static struct platform_driver fsl_pwm_driver = {
> +	.driver = {
> +		.name = "fsl-ftm-pwm",
> +		.owner = THIS_MODULE,
> +		.of_match_table = of_match_ptr(fsl_pwm_dt_ids),
> +	},
> +	.probe = fsl_pwm_probe,
> +	.remove = fsl_pwm_remove,
> +};
> +module_platform_driver(fsl_pwm_driver);
> +
> +MODULE_DESCRIPTION("Freescale FTM PWM Driver");
> +MODULE_AUTHOR("Xiubo Li <Li.Xiubo@freescale.com>");
> +MODULE_LICENSE("GPL");
> -- 
> 1.8.0
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe devicetree" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
