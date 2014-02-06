Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211AbaBFLbY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 06:31:24 -0500
Received: from mail1.bemta14.messagelabs.com ([193.109.254.107]:51091 "EHLO
	mail1.bemta14.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755766AbaBFLbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 06:31:18 -0500
X-Env-Sender: Adam.Thomson.Opensource@diasemi.com
X-Msg-Ref: server-7.tower-194.messagelabs.com!1391686275!8430407!1
X-Originating-IP: [94.185.165.51]
X-StarScan-Received: 
X-StarScan-Version: 6.9.16; banners=-,-,-
X-VirusChecked: Checked
From: "Opensource [Adam Thomson]" <Adam.Thomson.Opensource@diasemi.com>
To: Mark Brown <broonie@kernel.org>,
        "Opensource [Adam Thomson]" <Adam.Thomson.Opensource@diasemi.com>
CC: Lee Jones <lee.jones@linaro.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Guenter Roeck <linux@roeck-us.net>
Subject: RE: [PATCH 4/8] regulator: da9055: Add DT support
Thread-Topic: [PATCH 4/8] regulator: da9055: Add DT support
Thread-Index: AQHPIqFBtwUyHGLBMUSnvfWEO0aAwpqoEsvQ
Date: Thu, 6 Feb 2014 11:31:13 +0000
Message-ID: <2E89032DDAA8B9408CB92943514A03376B7E1669@SW-EX-MBX02.diasemi.com>
References: <cover.1391614923.git.Adam.Thomson.Opensource@diasemi.com>
 <6d76ae40cd435eaae0323f3e806515130b06a376.1391614923.git.Adam.Thomson.Opensource@diasemi.com>
 <20140205183642.GH32298@sirena.org.uk>
In-Reply-To: <20140205183642.GH32298@sirena.org.uk>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.20.27.23]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s16BVUbg004632

On Wed, Feb 05, 2014 at 18:37:21PM +0000, Mark Brown wrote:

> On Wed, Feb 05, 2014 at 05:48:35PM +0000, Adam Thomson wrote:
> 
> > +#ifdef CONFIG_OF
> > +#include <linux/of.h>
> > +#include <linux/regulator/of_regulator.h>
> > +#endif /* CONFIG_OF */
> 
> Don't do ifdefs for includes like this, it's not worth it.

Fine. Seen examples of both in the kernel, but happy to remove it.

> 
> > +	for_each_child_of_node(nproot, np) {
> > +		if (!of_node_cmp(np->name,
> > +				 regulator->info->reg_desc.name)) {
> > +			config->init_data = of_get_regulator_init_data(
> > +				&pdev->dev, np);
> > +			config->of_node = np;
> > +			break;
> > +		}
> > +	}
> 
> I think you're looking for of_regulator_match() here.

Used another driver as an example for this, but if there's a better method
then I'm happy to use it. Will have a look.

> 
> >  	if (pdata && pdata->regulators)
> >  		config.init_data = pdata->regulators[pdev->id];
> > +	else {
> > +		ret = da9055_regulator_dt_init(pdev, regulator, &config);
> > +		if (ret < 0)
> > +			return ret;
> > +	}
> 
> Coding style, both sides of the if should have braces if one does.

Fine. Will update.

> 
> >  	/* Only LDO 5 and 6 has got the over current interrupt */
> >  	if (pdev->id == DA9055_ID_LDO5 || pdev->id ==  DA9055_ID_LDO6) {
> > -		irq = platform_get_irq_byname(pdev, "REGULATOR");
> > -		irq = regmap_irq_get_virq(da9055->irq_data, irq);
> > +		irq = regmap_irq_get_virq(da9055->irq_data,
> > +					  DA9055_IRQ_REGULATOR);
> 
> This seems like a bit of a step backwards - what happened in the MFD
> (and why didn't it update the users to avoid breaking bisection)?

I tested this on target, when doing tests for devicetree. What was happening was
that platform_get_irq_byname() was returning the VIRQ number already (368 in one
test case where onkey was being probed) rather than the local IRQ number for the
device (the resource information seemed to have been updated with the VIRQ
number instead of the local IRQ number). So when that was passed to
regmap_irq_get_virq() it would then return an incorrect IRQ number (0 in the
same scenario, when I enabled DEBUG in irqdomain.c, I would see the message
"error: hwirq 0x170 is too large for da9055_irq"). That incorrect irq was then
being passed to devm_request_threaded_irq() which subsequently failed. This is
why I made the change. Is it preferrable to use platform_get_irq_byname()
instead of regmap_irq_get_virq() as using them both doesn't seem to work, unless
I'm missing something fundamental here.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
