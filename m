Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956AbaGGQIn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 12:08:43 -0400
Received: from mail-bl2lp0211.outbound.protection.outlook.com ([207.46.163.211]:30110
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751077AbaGGQIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 12:08:40 -0400
Date: Mon, 7 Jul 2014 09:08:21 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Linus Walleij <linus.walleij@linaro.org>
CC: Harini Katakam <harini.katakam@xilinx.com>,
        Alexandre Courbot <gnurou@gmail.com>,
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
        Harini Katakam <harinik@xilinx.com>
Subject: Re: [PATCH v2 1/2] gpio: Add driver for Zynq GPIO controller
References: <1403091577-10232-1-git-send-email-harinik@xilinx.com>
 <5cc8b89b-20ff-4fa9-92dd-bb2f6d3512d8@BY2FFO11FD030.protection.gbl>
 <CACRpkdb1M3-hrSKLKWz21LCJ1sMvsq5E-aqkpmVhy0NwOS5HhA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdb1M3-hrSKLKWz21LCJ1sMvsq5E-aqkpmVhy0NwOS5HhA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <d1af864d-bf78-48bb-a545-8de3f9def75f@BL2FFO11FD037.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(51914003)(24454002)(51704005)(377454003)(199002)(189002)(377424004)(76482001)(99396002)(31696002)(50986999)(76176999)(21056001)(54356999)(83506001)(74662001)(74502001)(19580395003)(31966008)(87936001)(83072002)(85852003)(23676002)(79102001)(47776003)(64706001)(20776003)(85182001)(46102001)(77982001)(92566001)(6806004)(92726001)(19580405001)(44976005)(74316001)(83322001)(86362001)(33646001)(85202003)(1496007)(85306003)(95666004)(104016002)(80022001)(77096002)(110136001)(81542001)(107046002)(81342001)(70736001)(53416004)(50466002)(4396001)(106466001)(102836001)(107986001)(23106004);DIR:OUT;SFP:;SCL:1;SRVR:BL2FFO11HUB016;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 02652BD10A
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Mon, 2014-07-07 at 04:51PM +0200, Linus Walleij wrote:
> On Wed, Jun 18, 2014 at 5:36 PM, Sören Brinkmann
> <soren.brinkmann@xilinx.com> wrote:
> 
> > I did some of the changes for this v2 and a few things are not clear to
> > me.
> >
> > The first is, how is userspace supposed to find the correct offset for a
> > GPIO pin.
> 
> The sysfs interface to GPIO is *NOT* *GOOD* this is universally
> agreed upon.
> 
> This needs someone to step in and provide a replacement, my preferred
> mechanism would be a /dev/gpiochip0/... hierarchy using char devices.
> 
> > E.g. let's say GPIO 10 of this SOC-internal GPIO controller is
> > something I want to control. So, I'd export GPIO (chip-base + 10). But
> > this chip-base seems pretty variable. v1 of this patch had it hardcoded
> > to 0, which resulted in a predictable offset, but apparently was utterly
> > wrong. Now I see an offset of 138 for this chip when using my config.
> > And when I use multi_v7_defconfig the offset is somewhere in the 800s,
> > IIRC. The best I found was the 'label' in the gpiochip's sysfs entry,
> > but documentation says that is not necessarily unique, and parsing labes
> > seems sub-optimal too.
> 
> You see. It is badly designed and needs to be rewritten.
> 
> It was merged into the kernel at a time when the GPIO subsystem
> was unmaintained, sadly.
> 
> > The second issue is a stack trace (below) I see when triggering
> > interrupts (e.g. echo rising > edge; and then pushing the connected
> > button). Looking at the stack trace, I don't see an obvious error (I
> > think I pretty much copied the IRQ registration from the gpio-pl061.c
> > driver you mentioned). Is this an issue in this driver or the core code?
> 
> Probably.
> 
> Using GPIOs for IRQs in userspace is an even worse idea than using
> GPIOs from userspace in general :-D
> 
> But before you add any hairy code in userspace, please have a look
> at Documentation/gpio/sysfs.txt:
> 
> "Note that standard kernel drivers exist for common "LEDs and Buttons"
>  GPIO tasks:  "leds-gpio" and "gpio_keys", respectively. Use those
>  instead of talking directly to the GPIOs; they integrate with kernel
>  frameworks better than your userspace code could."
> 
> So: what is the usecase for these GPIOs?

Yea, in this case it was a button. I have to look at these drivers. It's
very likely that they cover what I want. But this case is trivial. I
really don't do anything but enabling the IRQ by writing to the edge
attribute and press the push-button connected to that GPIO line.

But as a general note: I think we have quite some customers trying to do
GPIO in userspace. With Zynq's FPGA portion, a lot of things come down
to make signals accessible in Linux and a lot of people do not want or
need a full blown kernel driver and use GPIO. The request for 'how to
handle GPIO IRQs in userspace' is pretty common. Often this gets passed
on to UIO though.

Thanks for the answers.

	Sören

