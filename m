Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752490Ab3HUHhY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 03:37:24 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56463 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274Ab3HUHhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 03:37:23 -0400
Date: Wed, 21 Aug 2013 09:36:59 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: r65073@freescale.com, thierry.reding@gmail.com, grant.likely@linaro.org,
        linux@arm.linux.org.uk, rob@landley.net, ian.campbell@citrix.com,
        swarren@wwwdotorg.org, mark.rutland@arm.com, pawel.moll@arm.com,
        rob.herring@calxeda.com, linux-arm-kernel@lists.infradead.org,
        linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        Jingchang Lu <b35083@freescale.com>
Subject: Re: [PATCH 1/4] pwm: add freescale ftm pwm driver support
Message-ID: <20130821073659.GN31036@pengutronix.de>
Mail-Followup-To: Xiubo Li <Li.Xiubo@freescale.com>, r65073@freescale.com,
	thierry.reding@gmail.com, grant.likely@linaro.org,
	linux@arm.linux.org.uk, rob@landley.net, ian.campbell@citrix.com,
	swarren@wwwdotorg.org, mark.rutland@arm.com, pawel.moll@arm.com,
	rob.herring@calxeda.com, linux-arm-kernel@lists.infradead.org,
	linux-pwm@vger.kernel.org, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
	Jingchang Lu <b35083@freescale.com>
References: <1377054462-6283-1-git-send-email-Li.Xiubo@freescale.com>
 <1377054462-6283-2-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377054462-6283-2-git-send-email-Li.Xiubo@freescale.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:11:45 up 21 days, 16:15, 28 users,  load average: 0.14, 0.06,
 0.06
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 11:07:39AM +0800, Xiubo Li wrote:
> +
> +#define FTM_CSC_BASE        0x0C
> +#define FTM_CSC(_CHANNEL) \
> +	(FTM_CSC_BASE + (_CHANNEL * 0x08))

I see this more and more in FSL code. This is unsafe! Consider what
happens when we call FTM_CSC(1 + 1). The result is certainly not what
you want.

> +
> +static int fsl_pwm_request_channel(struct pwm_chip *chip,
> +			       struct pwm_device *pwm)
> +{
> +	int ret = 0;

No need to initialize this variable.

> +	struct fsl_pwm_chip *fpc;
> +
> +	fpc = to_fsl_chip(chip);
> +
> +	ret = clk_prepare_enable(fpc->clk);
> +	if (ret) {
> +		dev_err(&fpc->pdev->dev,
> +				"failed to clk_prepare_enable "
> +				"ftm pwm module clock : %d\n",
> +				ret);

Just return ret. We do not need a message for each failed function in
the kernel.

> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +

> +static int fsl_updata_config(struct fsl_pwm_chip *fpc,
> +			     struct pwm_device *pwm)
> +{
> +	int i;
> +	unsigned long reg, cntin = FTM_CNTIN_VAL;
> +	struct pwm_chip *chip = &fpc->chip;
> +
> +	reg = readl(fpc->base + FTM_SC);
> +	reg &= ~(FTMSC_CPWMS);
> +	reg |= (fpc->cpwm ? FTMSC_CPWMS : 0x00);
> +	writel(reg, fpc->base + FTM_SC);
> +
> +	if (pwm && fpc->cpwm) {
> +		writel(fpc->fpwms[pwm->hwpwm].period_cycles / 2 + cntin,
> +				fpc->base + FTM_MOD);
> +		writel(fpc->fpwms[pwm->hwpwm].duty_cycles / 2 + cntin,
> +				fpc->base + FTM_CV(pwm->hwpwm));
> +	} else if (pwm) {
> +		writel(fpc->fpwms[pwm->hwpwm].period_cycles + cntin - 1,
> +				fpc->base + FTM_MOD);
> +		writel(fpc->fpwms[pwm->hwpwm].duty_cycles + cntin,
> +				fpc->base + FTM_CV(pwm->hwpwm));
> +	}
> +
> +	if (pwm)
> +		return 0;
> +
> +	for (i = 0; i < chip->npwm; i++) {
> +		if (!test_bit(PWMF_ENABLED, &chip->pwms[i].flags))
> +			continue;
> +		if (fpc->cpwm) {
> +			writel(fpc->fpwms[i].period_cycles / 2 + cntin,
> +					fpc->base + FTM_MOD);
> +			writel(fpc->fpwms[i].duty_cycles / 2 + cntin,
> +					fpc->base + FTM_CV(i));
> +		} else {
> +			writel(fpc->fpwms[i].period_cycles + cntin - 1,
> +					fpc->base + FTM_MOD);
> +			writel(fpc->fpwms[i].duty_cycles + cntin,
> +					fpc->base + FTM_CV(i));
> +		}
> +	}
> +

The behaviour of this function is completely different for pwm == NULL
and pwm != NULL. This indicates that it should really be two functions.
This probably makes the intention of this code much clearer.

> +static int fsl_pwm_config_channel(struct pwm_chip *chip,
> +			      struct pwm_device *pwm,
> +			      int duty_ns,
> +			      int period_ns)
> +{
> +	unsigned long period_cycles, duty_cycles;
> +	struct fsl_pwm_chip *fpc;
> +
> +	fpc = to_fsl_chip(chip);
> +
> +	if (WARN_ON(!test_bit(PWMF_REQUESTED, &pwm->flags)))
> +		return -ESHUTDOWN;
> +
> +	period_cycles = fsl_rate_to_cycles(fpc, period_ns);
> +	if (period_cycles > 0xFFFF) {
> +		dev_warn(&fpc->pdev->dev,
> +				"required PWM period cycles(%lu) "
> +				"overflow 16-bits counter!\n",
> +				period_cycles);
> +		period_cycles = 0xFFFF;

If you can't fulfill the requirements you have to return an error. It's
the caller that needs to know the failure. The caller can't read read
the syslog.

> +static int fsl_pwm_enable_channel(struct pwm_chip *chip,
> +			      struct pwm_device *pwm)
> +{
> +	int ret;
> +	unsigned long reg;
> +	struct fsl_pwm_chip *fpc;
> +	struct pinctrl_state *pins_state;
> +	const char *statename;
> +
> +	fpc = to_fsl_chip(chip);
> +
> +	if (WARN_ON(!test_bit(PWMF_REQUESTED, &pwm->flags)))
> +		return -ESHUTDOWN;
> +
> +	statename = kasprintf(GFP_KERNEL, "en%d", pwm->hwpwm);
> +	pins_state = pinctrl_lookup_state(fpc->pinctrl,
> +			statename);
> +	/* enable pins to be muxed in and configured */
> +	if (!IS_ERR(pins_state)) {
> +		ret = pinctrl_select_state(fpc->pinctrl, pins_state);
> +		if (ret)
> +			dev_warn(&fpc->pdev->dev,
> +					"could not set default pins\n");

Why do you need to manipulate the pinctrl to en/disable a channel?

> +static ssize_t fsl_pwm_cpwm_store(struct device *dev,
> +				  struct device_attribute *attr,
> +				  const char *buf,
> +				  size_t count)
> +{
> +	int ret;
> +	unsigned int val;
> +	struct fsl_pwm_chip *fpc;
> +
> +	fpc = dev_get_drvdata(dev);
> +
> +	ret = kstrtouint(buf, 0, &val);
> +	if (ret)
> +		return ret;
> +
> +	mutex_lock(&fpc->lock);
> +	if (!!(val) != !!(fpc->cpwm)) {
> +		fpc->cpwm = !!val;
> +		fsl_updata_config(fpc, NULL);
> +	}
> +	mutex_unlock(&fpc->lock);
> +
> +	return count;
> +}

What is this cpwm thingy?

> +
> +static DEVICE_ATTR(cpwm, S_IRUGO | S_IWUSR | S_IWGRP,
> +		fsl_pwm_cpwm_show, fsl_pwm_cpwm_store);
> +
> +static struct attribute *fsl_pwm_attrs[] = {
> +	&dev_attr_cpwm.attr,
> +	NULL
> +};
> +


> +static int fsl_pwm_probe(struct platform_device *pdev)
> +{
> +	int ret = 0;
> +	struct fsl_pwm_chip *fpc;
> +	struct resource *res;
> +
> +	fpc = devm_kzalloc(&pdev->dev, sizeof(*fpc), GFP_KERNEL);
> +	if (!fpc) {
> +		dev_err(&pdev->dev,
> +				"failed to allocate memory\n");

Drop this message. You'll never see it.

> +		return -ENOMEM;
> +	}
> +
> +	mutex_init(&fpc->lock);
> +
> +	fpc->pdev = pdev;
> +
> +	ret = fsl_pwm_parse_dt(fpc);
> +	if (ret < 0)
> +		return ret;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	fpc->base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(fpc->base)) {
> +		dev_err(&pdev->dev,
> +				"failed to ioremap() registers\n");
> +		ret = PTR_ERR(fpc->base);
> +		return ret;
> +	}
> +
> +	fpc->chip.dev = &pdev->dev;
> +	fpc->chip.ops = &fsl_pwm_ops;
> +	fpc->chip.of_xlate = of_pwm_xlate_with_flags;
> +	fpc->chip.of_pwm_n_cells = 3;
> +	fpc->chip.base = -1;
> +
> +	ret = pwmchip_add(&fpc->chip);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev,
> +				"failed to add ftm0 pwm chip %d\n",
> +				ret);
> +		return ret;
> +	}

You can only add the PWM when you grabbed all resources, not before
this.

> +
> +	fpc->clk = devm_clk_get(&pdev->dev, "ftm0");
> +	if (IS_ERR(fpc->clk)) {
> +		ret = PTR_ERR(fpc->clk);
> +		dev_err(&pdev->dev,
> +				"failed to get ftm0's module clock %d\n",
> +				ret);
> +		return ret;
> +	}
> +
> +	fpc->pinctrl = devm_pinctrl_get(&pdev->dev);
> +	if (IS_ERR(fpc->pinctrl)) {
> +		ret = PTR_ERR(fpc->pinctrl);
> +		return ret;
> +	}
> +
> +	ret = sysfs_create_group(&pdev->dev.kobj,
> +				 &fsl_pwm_attr_group);
> +	if (ret) {
> +		dev_err(&pdev->dev,
> +				"Failed to create sysfs "
> +				"attributes, err: %d\n",
> +				ret);
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
> +	if (fpc == NULL)
> +		return -ENODEV;

This won't happen.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
