Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080Ab3BFJbH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 04:31:07 -0500
Received: from smtp1.goneo.de ([212.90.139.80]:40669 "EHLO smtp1.goneo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751497Ab3BFJbB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 04:31:01 -0500
X-Spam-Flag: NO
X-Spam-Score: -2.73
From: Lars Poeschel <poeschel@lemonage.de>
To: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH RFC 1/1] gpio: mcp23s08: convert driver to DT
Date: Wed, 6 Feb 2013 10:31:04 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.0-4-amd64; KDE/4.8.4; x86_64; ; )
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Lars Poeschel <larsi@wh2.tu-dresden.de>, rob.herring@calxeda.com,
        rob@landley.net, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        spi-devel-general@lists.sourceforge.net, w.sang@pengutronix.de,
        ben-linux@fluff.org, linux-i2c@vger.kernel.org
References: <1359647903-15801-1-git-send-email-larsi@wh2.tu-dresden.de> <CACRpkda_HjzWNMD1H_a_fsWtbRWuTDsutS8kndb9jY31qf7Yyg@mail.gmail.com> <20130205142909.4F5B83E1265@localhost>
In-Reply-To: <20130205142909.4F5B83E1265@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201302061031.04264.poeschel@lemonage.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 February 2013 at 15:29:09, Grant Likely wrote:
> On Thu, 31 Jan 2013 21:51:36 +0100, Linus Walleij 
<linus.walleij@linaro.org> wrote:
> > On Thu, Jan 31, 2013 at 4:58 PM, Lars Poeschel <larsi@wh2.tu-dresden.de> 
wrote:
> > > --- /dev/null
> > > +++ b/Documentation/devicetree/bindings/gpio/gpio-mcp23s08.txt
> > > @@ -0,0 +1,27 @@
> > > +Microchip MCP2308/MCP23S08/MCP23017/MCP23S17 driver for
> > > +8-/16-bit I/O expander with serial interface (I2C/SPI)
> > > +
> > > +Required properties:
> > > +- compatible : Should be "mcp,mcp23s08-gpio", "mcp,mcp23s17-gpio",
> > > +                       "mcp,mcp23008-gpio" or "mcp,mcp23017-gpio"
> > > +- base : The first gpio number that should be assigned by this chip.
> > 
> > No. We do not tie the global GPIO numbers into the device tree.
> > 
> > In the DT GPIOs are referenced by ampersand <&gpio0 1 2>
> > notation referring to the instance, so as you realize DT itself
> > has no need for that number.
> > 
> > Further it is not OS-neutral.
> > 
> > You have to find another way to handle this in the driver code.
> > In worst case: use AUXDATA.
> 
> Hi Lars,
> 
> The trick is to declare the io expander to be a "gpio-controller" and
> use the #gpio-cells property to declare how many cells (32-bit numbers)
> are need to specify a single gpio line. Most gpio controllers use
> "gpio-cells=<2>"; The first cell is the *controller local* gpio
> number, and the second cell is used for flags. That way your gpio
> controller can be referenced by other nodes in the tree with a "gpios"
> property.
> 
> You can find lots of examples of this in the tree.

Linus, Grant, thanks for the explanations. I think I have catched where it 
should go.
The thing that confused me was, that the platform_data for the chip has a 
mandatory "base" member, that sets the linux global gpio number at which the 
chip should appear. A value of -1 for automatic assigning gpio number is not 
allowed, the chip will not probe.
I have to change the driver to allow at least this -1 as an additional value.
As Linus pointed out, it is not desirable to set the global gpio base number 
from device tree, right ? If I have 3 instances of this chips then, how can 
userspace sw distinguish then to which one it is talking ?

This is an example for a DT entry (for i2c version) of the chip as I am 
targetting it now:

gpiom1: gpio@20 {
	reg = <0x20>;
	compatible = "mcp,mcp23017-gpio";
	gpio-controller;
	#gpio-cells = <2>;
};

I am working on this but I have some strange issues with the driver 
probing/not probing and kernel debug output. I hope I will solve this today. 
I will send a new patch then.

Lars
