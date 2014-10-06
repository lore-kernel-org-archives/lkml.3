Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455AbaJFLu1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 07:50:27 -0400
Received: from top.free-electrons.com ([176.31.233.9]:55162 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751407AbaJFLuX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 07:50:23 -0400
Date: Mon, 6 Oct 2014 13:50:09 +0200
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-pwm@vger.kernel.org, Rob Clark <robdclark@gmail.com>,
        linux-arm-kernel@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mark Yao <mark.yao@rock-chips.com>
Subject: Re: [PATCH v7 03/11] pwm: add support for atmel-hlcdc-pwm device
Message-ID: <20141006135009.6cd980a1@bbrezillon>
In-Reply-To: <20141006104634.GE25202@ulmo>
References: <1412175188-28278-1-git-send-email-boris.brezillon@free-electrons.com>
	<1412175188-28278-4-git-send-email-boris.brezillon@free-electrons.com>
	<20141006104634.GE25202@ulmo>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Oct 2014 12:46:35 +0200
Thierry Reding <thierry.reding@gmail.com> wrote:

> On Wed, Oct 01, 2014 at 04:53:00PM +0200, Boris Brezillon wrote:
> [...]
> > diff --git a/drivers/pwm/Kconfig b/drivers/pwm/Kconfig
> > index b800783..afb896b 100644
> > --- a/drivers/pwm/Kconfig
> > +++ b/drivers/pwm/Kconfig
> > @@ -50,6 +50,16 @@ config PWM_ATMEL
> >  	  To compile this driver as a module, choose M here: the module
> >  	  will be called pwm-atmel.
> >  
> > +config PWM_ATMEL_HLCDC_PWM
> > +	tristate "Atmel HLCDC PWM support"
> > +	select MFD_ATMEL_HLCDC
> > +	depends on OF
> 
> This isn't really necessary since MFD_ATMEL_HLCDC already depends on OF.
> 
> > diff --git a/drivers/pwm/pwm-atmel-hlcdc.c b/drivers/pwm/pwm-atmel-hlcdc.c
> [...]
> > new file mode 100644
> > index 0000000..0238f7a
> > --- /dev/null
> > +++ b/drivers/pwm/pwm-atmel-hlcdc.c
> > @@ -0,0 +1,229 @@
> > +/*
> > + * Copyright (C) 2014 Free Electrons
> > + * Copyright (C) 2014 Atmel
> > + *
> > + * Author: Boris BREZILLON <boris.brezillon@free-electrons.com>
> > + *
> > + * This program is free software; you can redistribute it and/or modify it
> > + * under the terms of the GNU General Public License version 2 as published by
> > + * the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope that it will be useful, but WITHOUT
> > + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> > + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> > + * more details.
> > + *
> > + * You should have received a copy of the GNU General Public License along with
> > + * this program.  If not, see <http://www.gnu.org/licenses/>.
> > + */
> > +
> > +#include <linux/clk.h>
> > +#include <linux/mfd/atmel-hlcdc.h>
> > +#include <linux/module.h>
> > +#include <linux/platform_device.h>
> > +#include <linux/pwm.h>
> > +#include <linux/regmap.h>
> > +
> > +#define ATMEL_HLCDC_PWMCVAL_MASK	GENMASK(15, 8)
> > +#define ATMEL_HLCDC_PWMCVAL(x)		((x << 8) & ATMEL_HLCDC_PWMCVAL_MASK)
> 
> You might want to use an extra pair of parentheses around the "x" above.
> 
> > +struct atmel_hlcdc_pwm_chip {
> 
> Can we make this...
> 
> > +	struct pwm_chip chip;
> > +	struct atmel_hlcdc *hlcdc;
> > +	struct clk *cur_clk;
> > +};
> > +
> > +static inline struct atmel_hlcdc_pwm_chip *
> > +pwm_chip_to_atmel_hlcdc_pwm_chip(struct pwm_chip *chip)
> 
> ... and this a little shorter? There is a lot of line-wrapping below
> only because this is very long. It seems like just dropping the
> pwm_chip_ prefix on this function would be enough to not exceed the
> 78/80 character limit.
> 
> > +{
> > +	return container_of(chip, struct atmel_hlcdc_pwm_chip, chip);
> > +}
> > +
> > +static int atmel_hlcdc_pwm_config(struct pwm_chip *c,
> > +				  struct pwm_device *pwm,
> > +				  int duty_ns, int period_ns)
> > +{
> > +	struct atmel_hlcdc_pwm_chip *chip =
> > +				pwm_chip_to_atmel_hlcdc_pwm_chip(c);
> > +	struct atmel_hlcdc *hlcdc = chip->hlcdc;
> > +	struct clk *new_clk = hlcdc->slow_clk;
> > +	u64 pwmcval = duty_ns * 256;
> > +	unsigned long clk_freq;
> > +	u64 clk_period_ns;
> > +	u32 pwmcfg;
> > +	int pres;
> > +
> > +	clk_freq = clk_get_rate(new_clk);
> > +	clk_period_ns = 1000000000;
> 
> NSEC_PER_SEC?
> 
> > +	clk_period_ns *= 256;
> 
> Perhaps collapse the above two in a single line:
> 
> 	clk_period_ns = NSEC_PER_SEC * 256;
> 
> ?
> 
> > +	do_div(clk_period_ns, clk_freq);
> > +
> > +	if (clk_period_ns > period_ns) {
> > +		new_clk = hlcdc->sys_clk;
> > +		clk_freq = clk_get_rate(new_clk);
> > +		clk_period_ns = 1000000000;
> > +		clk_period_ns *= 256;
> 
> Maybe:
> 
> 	clk_period_ns = NSEC_PER_SEC * 256;
> 
> ?
> 
> > +		do_div(clk_period_ns, clk_freq);
> > +	}
> > +
> > +	for (pres = 0; pres <= ATMEL_HLCDC_PWMPS_MAX; pres++) {
> > +		if ((clk_period_ns << pres) >= period_ns)
> > +			break;
> > +	}
> 
> Technically there's no need for the curly braces.
> 
> > +
> > +	if (pres > ATMEL_HLCDC_PWMPS_MAX)
> > +		return -EINVAL;
> 
> I think the condition above needs to be "pres == ATMEL_HLCDC_PWMPS_MAX",
> otherwise this will never be true.

Actually the previous loop is:

	for (pres = 0; pres *<=* ATMEL_HLCDC_PWMPS_MAX; pres++)

thus pres will be equal to ATMEL_HLCDC_PWMPS_MAX + 1 when no
appropriate prescaler is found.

> 
> > +
> > +	pwmcfg = ATMEL_HLCDC_PWMPS(pres);
> > +
> > +	if (new_clk != chip->cur_clk) {
> > +		u32 gencfg = 0;
> > +
> > +		clk_prepare_enable(new_clk);
> 
> This can fail so it needs error-checking.
> 
> > +		clk_disable_unprepare(chip->cur_clk);
> > +		chip->cur_clk = new_clk;
> > +
> > +		if (new_clk != hlcdc->slow_clk)
> > +			gencfg = ATMEL_HLCDC_CLKPWMSEL;
> 
> There are lots of negations here, which caused me to think that there
> was a third clock involved here, but it seems like new_clk can either be
> slow_clk or sys_clk.
> 
> Perhaps making this condition "new_clk == hlcdc->sys_clk" would improve
> clarity here. Maybe a comment somewhere would help?
> 
> > +		regmap_update_bits(hlcdc->regmap, ATMEL_HLCDC_CFG(0),
> > +				   ATMEL_HLCDC_CLKPWMSEL, gencfg);
> > +	}
> > +
> > +	do_div(pwmcval, period_ns);
> > +	if (pwmcval > 255)
> 
> The PWM core already makes sure that duty_ns <= period_ns, so pwmcval
> could be anywhere between 0 and 256 here. Where does the disconnect come
> from? Why not make pwmcval = duty_ns * 255 if that's the maximum?

Here is what the datasheet says:

"Due to the comparison mechanism, the output pulse has a width between
zero and 255 PWM counter cycles. Thus by adding a simple passive filter
outside the chip, an analog voltage between 0 and (255/256) × VDD can
be obtained (for the positive polarity case, or between (1/256) × VDD
and VDD for the negative polarity case). Other voltage values can be
obtained by adding active external circuitry."

Given this explanation we should divide by 256, but 256/256 is a
forbidden value, hence I just use the maximum available one (255) when
I'm asked to configure a duty cycle occupying the whole period.

> 
> > +		pwmcval = 255;
> > +
> > +	pwmcfg |= ATMEL_HLCDC_PWMCVAL(pwmcval);
> > +
> > +	regmap_update_bits(hlcdc->regmap, ATMEL_HLCDC_CFG(6),
> > +			   ATMEL_HLCDC_PWMCVAL_MASK | ATMEL_HLCDC_PWMPS_MASK,
> > +			   pwmcfg);
> > +
> > +	return 0;
> > +}
> > +
> > +static int atmel_hlcdc_pwm_set_polarity(struct pwm_chip *c,
> > +					struct pwm_device *pwm,
> > +					enum pwm_polarity polarity)
> > +{
> > +	struct atmel_hlcdc_pwm_chip *chip =
> > +				pwm_chip_to_atmel_hlcdc_pwm_chip(c);
> > +	struct atmel_hlcdc *hlcdc = chip->hlcdc;
> > +	u32 cfg = 0;
> > +
> > +	if (polarity == PWM_POLARITY_NORMAL)
> > +		cfg = ATMEL_HLCDC_PWMPOL;
> 
> That's strange. Inverse polarity is the default on this hardware?

Quote from the datasheet:

"
• PWMPOL: LCD Controller PWM Signal Polarity
This bit defines the polarity of the PWM output signal. If set to one,
the output pulses are high level (the output will be high when- ever
the value in the counter is less than the value CVAL) If set to zero,
the output pulses are low level.
"

My understanding is that ATMEL_HLCDC_PWMPOL should be set when using
normal polarity (and my tests confirm that it works as expected ;-)).


I'll address all other comments you made in this review.

Thanks,

Boris


-- 
Boris Brezillon, Free Electrons
Embedded Linux and Kernel engineering
http://free-electrons.com
