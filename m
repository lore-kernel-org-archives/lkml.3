Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996Ab3HUJZU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 05:25:20 -0400
Received: from [216.32.180.188] ([216.32.180.188]:24767 "EHLO
	co1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751944Ab3HUJZP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 05:25:15 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 4
X-BigFish: VS4(zz98dI1432I78fbmzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de097hz2dh2a8h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5hbe9i1155h)
From: Xiubo Li-B47053 <B47053@freescale.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
CC: Guo Shawn-R65073 <r65073@freescale.com>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "rob@landley.net" <rob@landley.net>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Lu Jingchang-B35083 <B35083@freescale.com>
Subject: RE: [PATCH 1/4] pwm: add freescale ftm pwm driver support
Thread-Topic: [PATCH 1/4] pwm: add freescale ftm pwm driver support
Thread-Index: AQHOnhwdSdSsv5GKTkyhA3muKUAEeJmfRjeAgAALZzA=
Date: Wed, 21 Aug 2013 09:24:56 +0000
Message-ID: <1DD289F6464F0949A2FCA5AA6DC23F827D1C51@039-SN2MPN1-013.039d.mgd.msft.net>
References: <1377054462-6283-1-git-send-email-Li.Xiubo@freescale.com>
 <1377054462-6283-2-git-send-email-Li.Xiubo@freescale.com>
 <20130821073659.GN31036@pengutronix.de>
In-Reply-To: <20130821073659.GN31036@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.208.56]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TO Sascha,

Thanks very much for your comments.


> Subject: Re: [PATCH 1/4] pwm: add freescale ftm pwm driver support
> 
> On Wed, Aug 21, 2013 at 11:07:39AM +0800, Xiubo Li wrote:
> > +
> > +#define FTM_CSC_BASE        0x0C
> > +#define FTM_CSC(_CHANNEL) \
> > +	(FTM_CSC_BASE + (_CHANNEL * 0x08))
> 
> I see this more and more in FSL code. This is unsafe! Consider what
> happens when we call FTM_CSC(1 + 1). The result is certainly not what you
> want.
> 

Oh yes, I'll fix it in v2.


> > +
> > +static int fsl_pwm_request_channel(struct pwm_chip *chip,
> > +			       struct pwm_device *pwm)
> > +{
> > +	int ret = 0;
> 
> No need to initialize this variable.
> 

Yeah, I'll fix it in v2.


> > +	ret = clk_prepare_enable(fpc->clk);
> > +	if (ret) {
> > +		dev_err(&fpc->pdev->dev,
> > +				"failed to clk_prepare_enable "
> > +				"ftm pwm module clock : %d\n",
> > +				ret);
> 
> Just return ret. We do not need a message for each failed function in the
> kernel.
> 

OK, I will remove it in v2.


> > +static int fsl_updata_config(struct fsl_pwm_chip *fpc,
> > +			     struct pwm_device *pwm)
> > +{
> > +	int i;
> > +	unsigned long reg, cntin = FTM_CNTIN_VAL;
> > +	struct pwm_chip *chip = &fpc->chip;
> > +
> > +	reg = readl(fpc->base + FTM_SC);
> > +	reg &= ~(FTMSC_CPWMS);
> > +	reg |= (fpc->cpwm ? FTMSC_CPWMS : 0x00);
> > +	writel(reg, fpc->base + FTM_SC);
> > +
> > +	if (pwm && fpc->cpwm) {
> > +		writel(fpc->fpwms[pwm->hwpwm].period_cycles / 2 + cntin,
> > +				fpc->base + FTM_MOD);
> > +		writel(fpc->fpwms[pwm->hwpwm].duty_cycles / 2 + cntin,
> > +				fpc->base + FTM_CV(pwm->hwpwm));
> > +	} else if (pwm) {
> > +		writel(fpc->fpwms[pwm->hwpwm].period_cycles + cntin - 1,
> > +				fpc->base + FTM_MOD);
> > +		writel(fpc->fpwms[pwm->hwpwm].duty_cycles + cntin,
> > +				fpc->base + FTM_CV(pwm->hwpwm));
> > +	}
> > +
> > +	if (pwm)
> > +		return 0;
> > +
> > +	for (i = 0; i < chip->npwm; i++) {
> > +		if (!test_bit(PWMF_ENABLED, &chip->pwms[i].flags))
> > +			continue;
> > +		if (fpc->cpwm) {
> > +			writel(fpc->fpwms[i].period_cycles / 2 + cntin,
> > +					fpc->base + FTM_MOD);
> > +			writel(fpc->fpwms[i].duty_cycles / 2 + cntin,
> > +					fpc->base + FTM_CV(i));
> > +		} else {
> > +			writel(fpc->fpwms[i].period_cycles + cntin - 1,
> > +					fpc->base + FTM_MOD);
> > +			writel(fpc->fpwms[i].duty_cycles + cntin,
> > +					fpc->base + FTM_CV(i));
> > +		}
> > +	}
> > +
> 
> The behaviour of this function is completely different for pwm == NULL
> and pwm != NULL. This indicates that it should really be two functions.
> This probably makes the intention of this code much clearer.
> 

OK, I will split it into two functions in v2.


> > +	period_cycles = fsl_rate_to_cycles(fpc, period_ns);
> > +	if (period_cycles > 0xFFFF) {
> > +		dev_warn(&fpc->pdev->dev,
> > +				"required PWM period cycles(%lu) "
> > +				"overflow 16-bits counter!\n",
> > +				period_cycles);
> > +		period_cycles = 0xFFFF;
> 
> If you can't fulfill the requirements you have to return an error. It's
> the caller that needs to know the failure. The caller can't read read the
> syslog.
> 

OK, I will fix it in v2.


> > +static int fsl_pwm_enable_channel(struct pwm_chip *chip,
> > +			      struct pwm_device *pwm)
> > +{
> > +	int ret;
> > +	unsigned long reg;
> > +	struct fsl_pwm_chip *fpc;
> > +	struct pinctrl_state *pins_state;
> > +	const char *statename;
> > +
> > +	fpc = to_fsl_chip(chip);
> > +
> > +	if (WARN_ON(!test_bit(PWMF_REQUESTED, &pwm->flags)))
> > +		return -ESHUTDOWN;
> > +
> > +	statename = kasprintf(GFP_KERNEL, "en%d", pwm->hwpwm);
> > +	pins_state = pinctrl_lookup_state(fpc->pinctrl,
> > +			statename);
> > +	/* enable pins to be muxed in and configured */
> > +	if (!IS_ERR(pins_state)) {
> > +		ret = pinctrl_select_state(fpc->pinctrl, pins_state);
> > +		if (ret)
> > +			dev_warn(&fpc->pdev->dev,
> > +					"could not set default pins\n");
> 
> Why do you need to manipulate the pinctrl to en/disable a channel?
> 

This is because in Vybrid VF610 TOWER board, there are 4 leds, and each led's one point(diode's positive pole) is connected to 3.3V,
and the other point is connected to pwm's one channel. When the 4 pinctrls are configured as enable at the same time, 
the 4 pinctrls is low valtage, and the 4 leds will be lighted up as default, then when you enable/disable one led will effects others.

These pinctrls are belong to pwm, and I don't think led or other customer could control them directly.
So, here I authorize the 4 pinctrls to each channel controls.


> > +static ssize_t fsl_pwm_cpwm_store(struct device *dev,
> > +				  struct device_attribute *attr,
> > +				  const char *buf,
> > +				  size_t count)
> > +{
> > +	int ret;
> > +	unsigned int val;
> > +	struct fsl_pwm_chip *fpc;
> > +
> > +	fpc = dev_get_drvdata(dev);
> > +
> > +	ret = kstrtouint(buf, 0, &val);
> > +	if (ret)
> > +		return ret;
> > +
> > +	mutex_lock(&fpc->lock);
> > +	if (!!(val) != !!(fpc->cpwm)) {
> > +		fpc->cpwm = !!val;
> > +		fsl_updata_config(fpc, NULL);
> > +	}
> > +	mutex_unlock(&fpc->lock);
> > +
> > +	return count;
> > +}
> 
> What is this cpwm thingy?

Up-down counting mode:
CNTIN(a register) defines the starting value of the count and MOD(a register) defines the final value of the
count. The value of CNTIN is loaded into the FTM counter, and the counter increments
until the value of MOD is reached, at which point the counter is decremented until it
returns to the value of CNTIN and the up-down counting restarts.


> > +static int fsl_pwm_probe(struct platform_device *pdev) {
> > +	int ret = 0;
> > +	struct fsl_pwm_chip *fpc;
> > +	struct resource *res;
> > +
> > +	fpc = devm_kzalloc(&pdev->dev, sizeof(*fpc), GFP_KERNEL);
> > +	if (!fpc) {
> > +		dev_err(&pdev->dev,
> > +				"failed to allocate memory\n");
> 
> Drop this message. You'll never see it.

OK, I will drop it in v2.

> > +	fpc->chip.dev = &pdev->dev;
> > +	fpc->chip.ops = &fsl_pwm_ops;
> > +	fpc->chip.of_xlate = of_pwm_xlate_with_flags;
> > +	fpc->chip.of_pwm_n_cells = 3;
> > +	fpc->chip.base = -1;
> > +
> > +	ret = pwmchip_add(&fpc->chip);
> > +	if (ret < 0) {
> > +		dev_err(&pdev->dev,
> > +				"failed to add ftm0 pwm chip %d\n",
> > +				ret);
> > +		return ret;
> > +	}
> 
> You can only add the PWM when you grabbed all resources, not before this.
> 

Yeah, I will adjust it in v2.

> > +
> > +static int fsl_pwm_remove(struct platform_device *pdev) {
> > +	struct fsl_pwm_chip *fpc;
> > +
> > +	fpc = platform_get_drvdata(pdev);
> > +	if (fpc == NULL)
> > +		return -ENODEV;
> 
> This won't happen.
 
OK, I will drop it in v2.


Thanks very much.

---

Best Regards,
Xiubo Li





