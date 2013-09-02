Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758135Ab3IBDdt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Sep 2013 23:33:49 -0400
Received: from mail-db9lp0250.outbound.messaging.microsoft.com ([213.199.154.250]:6336
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755458Ab3IBDdq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Sep 2013 23:33:46 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(z551biz1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz2dh2a8h839h8e2h8e3h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5hbe9i1155h)
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
Subject: RE: [PATCHv2 1/4] pwm: Add Freescale FTM PWM driver support
Thread-Topic: [PATCHv2 1/4] pwm: Add Freescale FTM PWM driver support
Thread-Index: AQHOpWawpFOEIhAI/kueoxNTb0lp2ZmuB6eAgAO48QA=
Date: Mon, 2 Sep 2013 03:33:37 +0000
Message-ID: <1DD289F6464F0949A2FCA5AA6DC23F827F785F@039-SN2MPN1-011.039d.mgd.msft.net>
References: <1377856132-11290-1-git-send-email-Li.Xiubo@freescale.com>
 <1377856132-11290-2-git-send-email-Li.Xiubo@freescale.com>
 <20130830174909.GF30088@pengutronix.de>
In-Reply-To: <20130830174909.GF30088@pengutronix.de>
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


> > +static void fsl_pwm_free(struct pwm_chip *chip, struct pwm_device
> > +*pwm) {
> > +	struct fsl_pwm_chip *fpc;
> > +	struct fsl_pwm_data *pwm_data;
> > +
> > +	fpc = to_fsl_chip(chip);
> > +
> > +	pwm_data = pwm_get_chip_data(pwm);
> > +	if (!pwm_data)
> > +		return;
> 
> THis check seems unnecessary.
> 

But if do not check it here, I must check it in the following code.

> > +
> > +	if (pwm_data->available != FSL_AVAILABLE)
> > +		return;
> > +

So the ' struct fsl_pwm_data' may be removed in the future.

> 
> > +
> > +
> > +	pwm_data->period_cycles = period_cycles;
> > +	pwm_data->duty_cycles = duty_cycles;
> 
> These fields are set but never read. Please drop them.
> 
> If you drop the 'available' field also the you can drop chip_data
> completely.
> 

I think I may move the 'available' field to the PWM driver data struct.

> > +
> > +	writel(FTMCnSC_MSB | FTMCnSC_ELSB, fpc->base + FTM_CSC(pwm->hwpwm));
> > +
> > +	writel(0xF0, fpc->base + FTM_OUTMASK);
> > +	writel(0x0F, fpc->base + FTM_OUTINIT);
> > +	writel(FTM_CNTIN_VAL, fpc->base + FTM_CNTIN);
> > +
> > +	writel(period_cycles + cntin - 1, fpc->base + FTM_MOD);
> > +	writel(duty_cycles + cntin, fpc->base + FTM_CV(pwm->hwpwm));
> > +
> > +	return 0;
> > +}
> > +
> > +static int fsl_pwm_set_polarity(struct pwm_chip *chip, struct
> pwm_device *pwm,
> > +				enum pwm_polarity polarity)
> > +{
> > +	unsigned long reg;
> > +	struct fsl_pwm_data *pwm_data;
> > +	struct fsl_pwm_chip *fpc;
> > +
> > +	fpc = to_fsl_chip(chip);
> > +
> > +	pwm_data = pwm_get_chip_data(pwm);
> > +	if (!pwm_data)
> > +		return -EINVAL;
> > +
> > +	if (pwm_data->available != FSL_AVAILABLE)
> > +		return -EINVAL;
> > +
> > +	reg = readl(fpc->base + FTM_POL);
> > +	reg &= ~BIT(pwm->hwpwm);
> 
> Either drop this line...
> 

This is just for unmasking this bit field.
Here it's not needed, so I will revise it.

> > +	if (polarity == PWM_POLARITY_INVERSED)
> > +		reg |= BIT(pwm->hwpwm);
> > +	else
> > +		reg &= ~BIT(pwm->hwpwm);
> 
> ...or this one
> 

> > +static int fsl_pwm_enable(struct pwm_chip *chip, struct pwm_device
> > +*pwm) {
> > +	int ret;
> > +	struct fsl_pwm_chip *fpc;
> > +	struct pinctrl_state *pins_state;
> > +	struct fsl_pwm_data *pwm_data;
> > +	const char *statename;
> > +
> > +	fpc = to_fsl_chip(chip);
> > +
> > +	pwm_data = pwm_get_chip_data(pwm);
> > +	if (!pwm_data)
> > +		return -EINVAL;
> > +
> > +	if (pwm_data->available != FSL_AVAILABLE)
> > +		return -EINVAL;
> > +
> > +	statename = kasprintf(GFP_KERNEL, "ch%d-active", pwm->hwpwm);
> 
> You loose memory here and in fsl_pwm_disable aswell.
> 

Yes, I will revise it.

> > +	pins_state = pinctrl_lookup_state(fpc->pinctrl,
> > +			statename);
> > +	/* enable pins to be muxed in and configured */
> > +	if (!IS_ERR(pins_state)) {
> > +		ret = pinctrl_select_state(fpc->pinctrl, pins_state);
> > +		if (ret)
> > +			dev_warn(chip->dev, "could not set default pins\n");
> > +	} else
> > +		dev_warn(chip->dev, "could not get default pinstate\n");
> 
> Either it's ok to do without pinctrl or it's not ok, so either return an
> error or drop the warnings. Polluting the kernel log with such messages
> from a frequently called function is not a good idea.
> 

Well, I will just print out some error logs and return the error.

--
Best Regards.
Xiubo

