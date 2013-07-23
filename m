Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755727Ab3GWIKS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 04:10:18 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:58825 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754321Ab3GWIJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 04:09:12 -0400
From: Tomasz Figa <tomasz.figa@gmail.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Mark Rutland <mark.rutland@arm.com>, Jonas Jensen <jonas.jensen@gmail.com>,
        "arm@kernel.org" <arm@kernel.org>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5] clk: add MOXA ART SoCs clock driver
Date: Tue, 23 Jul 2013 10:09:06 +0200
Message-ID: <2711657.Br6v071qBc@flatron>
User-Agent: KMail/4.10.5 (Linux/3.10.1-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <20130722092138.GB18731@e106331-lin.cambridge.arm.com>
References: <1374221278-18204-1-git-send-email-jonas.jensen@gmail.com> <1374221837-23773-1-git-send-email-jonas.jensen@gmail.com> <20130722092138.GB18731@e106331-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 of July 2013 10:21:38 Mark Rutland wrote:
> On Fri, Jul 19, 2013 at 09:17:17AM +0100, Jonas Jensen wrote:
> > This patch adds MOXA ART SoCs clock driver support.
> > 
> > Signed-off-by: Jonas Jensen <jonas.jensen@gmail.com>
> > ---
> > 
> > Notes:
> >     Changes since v4:
> >     
> >     1. remove unnecessary header includes
> >     
> >     Applies to next-20130716
> >  
> >  .../bindings/clock/moxa,moxart-core-clock.txt      | 23 ++++++++
> >  drivers/clk/Makefile                               |  1 +
> >  drivers/clk/clk-moxart.c                           | 69
> >  ++++++++++++++++++++++ 3 files changed, 93 insertions(+)
> >  create mode 100644
> >  Documentation/devicetree/bindings/clock/moxa,moxart-core-clock.txt
> >  create mode 100644 drivers/clk/clk-moxart.c
> > 
> > diff --git
> > a/Documentation/devicetree/bindings/clock/moxa,moxart-core-clock.txt
> > b/Documentation/devicetree/bindings/clock/moxa,moxart-core-clock.txt
> > new file mode 100644
> > index 0000000..528c8b0
> > --- /dev/null
> > +++
> > b/Documentation/devicetree/bindings/clock/moxa,moxart-core-clock.txt
> > @@ -0,0 +1,23 @@
> > +Device Tree Clock bindings for arch-moxart
> > +
> > +This binding uses the common clock binding[1].
> > +
> > +[1] Documentation/devicetree/bindings/clock/clock-bindings.txt
> > +
> > +MOXA ART SoCs allow to determine core clock frequencies by reading
> > +a register.
> > +
> > +Required properties:
> > +- compatible : Should be "moxa,moxart-core-clock"
> > +- #clock-cells : Should be 0
> > +- reg : Should contain registers location and length
> > +- clock-output-names : Should be "coreclk"
> > +
> > +For example:
> > +
> > +	coreclk: core-clock@98100000 {
> > +		compatible = "moxa,moxart-core-clock";
> > +		#clock-cells = <0>;
> > +		reg = <0x98100000 0x34>;
> > +		clock-output-names = "coreclk";
> > +	};
> > diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
> > index 4038c2b..933622f 100644
> > --- a/drivers/clk/Makefile
> > +++ b/drivers/clk/Makefile
> > @@ -11,6 +11,7 @@ obj-$(CONFIG_COMMON_CLK)	+= clk-composite.o
> > 
> >  # SoCs specific
> >  obj-$(CONFIG_ARCH_BCM2835)	+= clk-bcm2835.o
> > 
> > +obj-$(CONFIG_ARCH_MOXART)	+= clk-moxart.o
> > 
> >  obj-$(CONFIG_ARCH_NOMADIK)	+= clk-nomadik.o
> >  obj-$(CONFIG_ARCH_HIGHBANK)	+= clk-highbank.o
> >  obj-$(CONFIG_ARCH_NSPIRE)	+= clk-nspire.o
> > 
> > diff --git a/drivers/clk/clk-moxart.c b/drivers/clk/clk-moxart.c
> > new file mode 100644
> > index 0000000..5559371
> > --- /dev/null
> > +++ b/drivers/clk/clk-moxart.c
> > @@ -0,0 +1,69 @@
> > +/*
> > + * MOXA ART SoCs clock driver.
> > + *
> > + * Copyright (C) 2013 Jonas Jensen
> > + *
> > + * Jonas Jensen <jonas.jensen@gmail.com>
> > + *
> > + * This file is licensed under the terms of the GNU General Public
> > + * License version 2.  This program is licensed "as is" without any
> > + * warranty of any kind, whether express or implied.
> > + */
> > +
> > +#include <linux/clk-provider.h>
> > +#include <linux/io.h>
> > +#include <linux/of_address.h>
> > +#include <linux/clkdev.h>
> > +
> > +void __init moxart_of_clk_init(struct device_node *node)
> > +{
> > +	static void __iomem *base;
> > +	struct clk *clk;
> > +	unsigned long rate;
> > +	unsigned int mul, val, div;
> > +	const char *name;
> > +
> > +	base = of_iomap(node, 0);
> > +	if (IS_ERR(base))
> > +		panic("%s: of_iomap failed\n", node->full_name);
> 
> As far as I'm aware, of_iomap returns NULL, not an ERR_PTR value.
> 
> Also, is it necessary to panic() ? In v1 of the patch you used pr_err...

This is a good question in general, not only for this driver.

IMHO if you know early that something is really wrong, to the point that 
the system won't be able to work normally (and failing to initialize 
clocks looks like it) it is better to let the user/developer know that 
something is utterly wrong at this point without letting the system run 
for a bit more and fail anyway with a harder to track down error message.

It's not so obvious, though, what kinds of failure should be considered 
critical. IMHO any failure in low level initialization code, but this is 
debatable, I guess.

Best regards,
Tomasz

