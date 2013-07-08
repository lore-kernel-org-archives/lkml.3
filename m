Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719Ab3GHND5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 09:03:57 -0400
Received: from mail.abilis.ch ([195.70.19.74]:24315 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751108Ab3GHND4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 09:03:56 -0400
Date: Mon, 8 Jul 2013 15:02:24 +0200
From: Christian Ruppert <christian.ruppert@abilis.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Patrice CHOTARD <patrice.chotard@st.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Sascha Leuenberger <sascha.leuenberger@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: Re: [PATCH 2/4] pinmux: Add TB10x pinmux driver
Message-ID: <20130708130222.GA6402@ab42.lan>
References: <20130618092516.GC18663@ab42.lan>
 <1371547751-13873-2-git-send-email-christian.ruppert@abilis.com>
 <51C23222.2060906@wwwdotorg.org>
 <20130626115051.GC7095@ab42.lan>
 <51CB279A.1090404@wwwdotorg.org>
 <20130705094859.GA27196@ab42.lan>
 <51D71337.6030409@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <51D71337.6030409@wwwdotorg.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 05, 2013 at 12:40:55PM -0600, Stephen Warren wrote:
> On 07/05/2013 03:49 AM, Christian Ruppert wrote:
> > On Wed, Jun 26, 2013 at 11:40:42AM -0600, Stephen Warren wrote:
> >> On 06/26/2013 05:50 AM, Christian Ruppert wrote:
> >>> On Wed, Jun 19, 2013 at 04:35:14PM -0600, Stephen Warren wrote:
> >>>> On 06/18/2013 03:29 AM, Christian Ruppert wrote:
> >> [...]
> >>>>> +Example
> >>>>> +-------
> >>>>> +
> >>>>> +iomux: iomux@FF10601c {
> >>>>> +	compatible = "abilis,tb10x-iomux";
> >>>>> +	reg = <0xFF10601c 0x4>;
> >>>>> +	pctl_gpio_a: pctl-gpio-a {
> >>>>> +		pingrp = "gpioa_pins";
> >>>>> +	};
> >>>>> +	pctl_uart0: pctl-uart0 {
> >>>>> +		pingrp = "uart0_pins";
> >>>>> +	};
> >>>>> +};
> >>>>
> >>>> The two nodes pctl-gpio-a and pctl-uart0 seem to be missing data. The
> >>>> idea here is that you define nodes that says:
> >>>>
> >>>> * This node applies to these pin(s)/group(s).
> >>>> * Select mux function X on those pins/groups and/or apply these pin
> >>>> configuration options to those pins/groups.
> >>>>
> >>>> The examples above don't include any mux/config options, nor does the
> >>>> binding say how to do specify them.
> >>>>
> >>>> The set of pin groups defined by this binding should correspond directly
> >>>> to the set of pin groups that actually exist in HW. So, if you have 3
> >>>> pin groups (A, B, C) in HW each of which has two mux functions (X, Y),
> >>>> your DT binding should define just 3 pin groups (A, B, C), not 6 (A_X,
> >>>> A_Y, B_X, B_Y, C_X, C_Y). In other words, the pin group name shouldn't
> >>>> imply the mux function.
> >>>
> >>> Can we consider it as agreed now that this implementation is acceptable
> >>> for the TB10x pin controller?
> >>
> >> There are two issues here:
> >>
> >> 1) What is a pin group:
> >>
> >> 1a) Must it solely represent a group of pins that actually exists in HW
> >> (e.g. it's an RTL port, or a set of pins all controlled at once by a
> >> single bit/field in a register)
> >>
> >> 1b) A SW-defined group of pins, simply because it's convenient to talk
> >> about that set of pins at once, even though HW doesn't impose that those
> >> pins are in a group in any way.
> >>
> >> Defining groups for either of those reasons is fine, although this is
> >> the area where my preference and LinusW's differ.
> >>
> >> 2) Can groups represent just a set of pins, or can it also imply that a
> >> particular mux function is selected on that group?
> >>
> >> I believe that both LinusW and I are in agreement that a group is simply
> >> a list/set/group of pins. You select mux functions onto groups. A
> >> groups's definition can't imply that a particular mux function is
> >> selected onto it.
> >>
> >> If we don't follow this rule, then you end up with a combinatorial
> >> explosion of groups; the cross-product of all possible groups of pins
> >> vs. the mux function to select on them, rather than simply having a list
> >> of groups of pins, which is a much smaller set/list.
> >>
> >> So, in the DT example above, I still believe that you need an extra
> >> property that defines which mux function to select onto the specified
> >> group. The group name can't imply this, so there needs to be some way of
> >> specifying it.
> > 
> > In your opinion, would something in the lines of
> > 
> > pctl_spi1: pctl-spi1 {
> > 	abilis,pingrp = "spi1";
> 
> So that defines a list of pins.
> 
> > 	abilis,ioport = <4>;   /* spi1 is routed to port4 inside the
> > 				pin controller */
> 
> I assume that defines the mux function value; the value that's
> programmed into the HW register to select which HW module's signals are
> routed out to the pins specified by abilis,pingrp.

No, it actually defines the mux inside the pin controller. 

> > 	abilis,ioconf = <1>;   /* spi1 is available in configuration 1
> > 				of that port. */
> 
> But I don't understand what that is. ...

This one defines the mux setting/configuration.

> ...
> > In future, this could even be extended to allow several alternative
> > configurations for a given function, e.g.
> > 
> > pctl_spi3: pctl-spi3 {
> > 	abilis,pingrp = "spi3";
> > 	abilis,ioport = <6>;
> > 	abilis,ioconf = <0 3>; /* spi3 is available in both
> > 				configurations 0 and 3. Depending on
> > 				what other functions are requested, the
> > 				pinctrl driver can choose either of the
> > 				two. */
> 
> ... especially if you're talking about "spi3 being available in multiple
> configurations". What's a configuration?

OK, a small drawing of our hardware should make this clear, let's take
an imaginary example of one port with 10 pins, one i2c interface, one
spi interface and one GPIO bank:

              | mux N-1|
              +........+
              |        |  2
              |        +--/-- i2c
              |        |
           10 |        |  4
   Pins  --/--+ mux N  +--/-- spi
              |        |
              |        |  10
              |        +--/-- GPIO
              |        |
              +........+
              | mux N+1|

This example shows the mux N inside the pin controller. It controls
all pins associated to port N through a single register value M. Let's
assume the pins are configured as follows in function of the register
value:

 pin      M=0       M=1     M=2      M=3
  0      GPIO0   SPI_MISO  GPIO0   SPI_MISO
  1      GPIO1   SPI_MOSI  GPIO1   SPI_MOSI
  2      GPIO2    SPI_CK   GPIO2    SPI_CK
  3      GPIO3    SPI_CS   GPIO3    SPI_CS
  4      GPIO4    GPIO4    GPIO4    GPIO4
  5      GPIO5    GPIO5    GPIO5    GPIO5
  6      GPIO6    GPIO6    GPIO6    GPIO6
  7      GPIO7    GPIO7    GPIO7    GPIO7
  8      GPIO8    GPIO8   I2C_SDA  I2C_SDA
  9      GPIO9    GPIO9   I2C_SCL  I2C_SCL

We now have three pin groups defined, corresponding to the chip-side
ports of the pin controller:
GPIO = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9}
SPI  = {0, 1, 2, 3}
I2C  = {8, 9}

abilis,pingrp now specifies one of the three pin groups. Note that I2C
       and SPI can be requested independently in a completely orthogonal
       manner: The information if I2C is reqired or not is confined to
       the I2C request and does not leak into the SPI request as would
       be the case if we configured the entire port at the same time.
abilis,ioport specifies N.
abilis,ioconf specifies M.

The above example would be described as follows:

portN_gpio: portN_gpio { // This is optional, GPIO mode is the default
	abilis,pingrp = "GPIO";
	abilis,ioport = <N>;
	abilis,ioconf = <0>;
};
portN_SPI: portN_SPI {
	abilis,pingrp = "GPIO";
	abilis,ioport = <N>;
	abilis,ioconf = <1 3>;
};
portN_I2C: portN_I2C {
	abilis,pingrp = "GPIO";
	abilis,ioport = <N>;
	abilis,ioconf = <2 3>;
};

/* ... */

spi {
	/* ... */
	pinctrl-names = "default";
	pinctrl-0 = <&portN_SPI>; /* No need to specify here if I2C is
	                             required as well */
};
i2c {
	/* ... */
	pinctrl-names = "default";
	pinctrl-0 = <&portN_I2C>; /* No need to specify here if SPI is
	                             required as well */
};

The choice between the actual mode to be applied is done inside the pin
controller driver and depends which of SPI and I2C are requested. Also,
in all cases, the pin controller is perfectly aware which of the pins
were previously requested for hardware interfaces and which are
available as GPIOs.  Interface - GPIO conflicts are thus easy to manage.

One could argue that the port to which a given interface is connected
(as well as the register values for which this interface is available)
are defined by the pin controller's internal wiring. This is why
abilis,ioport and abilis,ioconf were not part of the initial proposal. I
don't mind putting this information in the device tree, however, since
it is already part of our chip documentation.

Greetings,
  Christian

-- 
  Christian Ruppert              ,          <christian.ruppert@abilis.com>
                                /|
  Tel: +41/(0)22 816 19-42     //|                 3, Chemin du Pré-Fleuri
                             _// | bilis Systems   CH-1228 Plan-les-Ouates
