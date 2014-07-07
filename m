Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024AbaGGRds (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 13:33:48 -0400
Received: from mail-by2lp0242.outbound.protection.outlook.com ([207.46.163.242]:25778
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751478AbaGGRdp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 13:33:45 -0400
Date: Mon, 7 Jul 2014 10:33:38 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Harini Katakam <harinik@xilinx.com>, Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Michal Simek <michal.simek@xilinx.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Harini Katakam <harinikatakamlinux@gmail.com>,
        Harini Katakam <harini.katakam@xilinx.com>
Subject: Re: [PATCH v2 1/2] gpio: Add driver for Zynq GPIO controller
References: <1403091577-10232-1-git-send-email-harinik@xilinx.com>
 <CACRpkdbc=NDmmjLi_FKvXaQ7H6gY+xHWso=Vi=tgubME4JUfyg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdbc=NDmmjLi_FKvXaQ7H6gY+xHWso=Vi=tgubME4JUfyg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <eded8c93-3961-4153-9c0d-8bb427fd8230@BL2FFO11FD050.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(24454002)(199002)(189002)(51444003)(51704005)(377454003)(377424004)(81342001)(64706001)(33646001)(79102001)(47776003)(76482001)(44976005)(74316001)(19580395003)(19580405001)(83322001)(50466002)(31696002)(86362001)(4396001)(6806004)(46102001)(31966008)(74662001)(74502001)(81542001)(70736001)(20776003)(77982001)(80022001)(85182001)(85306003)(92726001)(107046002)(106466001)(92566001)(77096002)(83506001)(1496007)(83072002)(85852003)(85202003)(102836001)(104016002)(54356999)(87936001)(23676002)(95666004)(50986999)(76176999)(99396002)(21056001)(53416004)(110136001)(107986001)(23106004);DIR:OUT;SFP:;SCL:1;SRVR:BL2FFO11HUB042;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02652BD10A
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-07-07 at 04:45PM +0200, Linus Walleij wrote:
> On Wed, Jun 18, 2014 at 1:39 PM, Harini Katakam <harinik@xilinx.com> wrote:
> 
> > From: Harini Katakam <harini.katakam@xilinx.com>
> >
> > Add support for GPIO controller used by Xilinx Zynq.
> >
> > Signed-off-by: Harini Katakam <harinik@xilinx.com>
> > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> > ---
> >
> > v2 changes:
> >  - convert to pm_runtime_force_(suspend|resume)
> >  - add pm_runtime_set_active in probe()
> >  - also (un)prepare clocks when they are dis-/enabled
> >  - add some missing calls to pm_runtime_get()
> >  - use pm_runtime_put() instead of sync variant
> >  - remove gpio chip in driver remove()
> >  - remove redundant type casts
> >  - directly use IO helpers
> >  - use BIT macro to set/clear bits
> >  - migrate to GPIOLIB_IRQCHIP
> 
> This is a great improvement! Only small stuff remains.
> 
> > +#include <linux/bitops.h>
> > +#include <linux/clk.h>
> > +#include <linux/gpio.h>
> 
> This should be:
> #include <linux/gpio/driver.h>
> 
> If that doesn't work ... why?
Works just fine.

> 
> > +/**
> > + * struct zynq_gpio - gpio device private data structure
> > + * @chip:      instance of the gpio_chip
> > + * @base_addr: base address of the GPIO device
> > + * @irq:       irq associated with the controller
> > + * @clk:       clock resource for this controller
> > + */
> > +struct zynq_gpio {
> > +       struct gpio_chip chip;
> > +       void __iomem *base_addr;
> > +       int irq;
> 
> Why is irq kept around in this struct? It looks like it could just
> be a local variable in probe()?
You're right.

I think that were both part of the legacy in this driver.

	Sören

