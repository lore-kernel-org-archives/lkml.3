Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759114Ab3GRQHj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 12:07:39 -0400
Received: from mail.abilis.ch ([195.70.19.74]:27798 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758970Ab3GRQHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 12:07:37 -0400
Date: Thu, 18 Jul 2013 18:07:02 +0200
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
Message-ID: <20130718160700.GA14482@ab42.lan>
References: <1371547751-13873-2-git-send-email-christian.ruppert@abilis.com>
 <51C23222.2060906@wwwdotorg.org>
 <20130626115051.GC7095@ab42.lan>
 <51CB279A.1090404@wwwdotorg.org>
 <20130705094859.GA27196@ab42.lan>
 <51D71337.6030409@wwwdotorg.org>
 <20130708130222.GA6402@ab42.lan>
 <51DDB5B8.5060909@wwwdotorg.org>
 <20130716084755.GB10914@ab42.lan>
 <51E56EF3.5040506@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51E56EF3.5040506@wwwdotorg.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 10:04:03AM -0600, Stephen Warren wrote:
> On 07/16/2013 02:47 AM, Christian Ruppert wrote:
> > On Wed, Jul 10, 2013 at 01:27:52PM -0600, Stephen Warren wrote:
> >> On 07/08/2013 07:02 AM, Christian Ruppert wrote:
> >> ...
> >>> OK, a small drawing of our hardware should make this clear, let's take
> >>> an imaginary example of one port with 10 pins, one i2c interface, one
> >>> spi interface and one GPIO bank:
> >>>
> >>>               | mux N-1|
> >>>               +........+
> >>>               |        |  2
> >>>               |        +--/-- i2c
> >>>               |        |
> >>>            10 |        |  4
> >>>    Pins  --/--+ mux N  +--/-- spi
> >>>               |        |
> >>>               |        |  10
> >>>               |        +--/-- GPIO
> >>>               |        |
> >>>               +........+
> >>>               | mux N+1|
> >>>
> >>> This example shows the mux N inside the pin controller. It controls
> >>> all pins associated to port N through a single register value M. Let's
> >>> assume the pins are configured as follows in function of the register
> >>> value:
> >>>
> >>>  pin      M=0       M=1     M=2      M=3
> >>>   0      GPIO0   SPI_MISO  GPIO0   SPI_MISO
> >>>   1      GPIO1   SPI_MOSI  GPIO1   SPI_MOSI
> >>>   2      GPIO2    SPI_CK   GPIO2    SPI_CK
> >>>   3      GPIO3    SPI_CS   GPIO3    SPI_CS
> >>>   4      GPIO4    GPIO4    GPIO4    GPIO4
> >>>   5      GPIO5    GPIO5    GPIO5    GPIO5
> >>>   6      GPIO6    GPIO6    GPIO6    GPIO6
> >>>   7      GPIO7    GPIO7    GPIO7    GPIO7
> >>>   8      GPIO8    GPIO8   I2C_SDA  I2C_SDA
> >>>   9      GPIO9    GPIO9   I2C_SCL  I2C_SCL
> >>
> >>
> >> In that scenario, in the language of Linux's pinctrl subsystem, what you
> >> have is:
> >>
> >> 10 pins, named 0..9
> >> 1 pin group, named perhaps "mux N".
> >> 4 different functions; values M==0, 1, 2, 3.
> >>
> >>> We now have three pin groups defined, corresponding to the chip-side
> >>> ports of the pin controller:
> >>> GPIO = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9}
> >>> SPI  = {0, 1, 2, 3}
> >>> I2C  = {8, 9}
> >>
> >> You would usually only define pin groups for the pin/ball/package side
> >> of the pinmux HW. IIRC, you're also wanting to define pin groups for the
> >> intra-chip side of the pinmux HW. However, you're not muxing functions
> >> onto those pingroups; they're just there to help with naming the
> >> GPIO<->pinmux mapping. You only mux functions onto the pin/ball/package
> >> side pins/pingroups.
> > 
> > Well, the GPIO<->pinmux mapping is not the only reason for defining
> > these groups wrt. the chip-side of the pin controller. The other reasons
> > are:
> >   - Make different interfaces on the same MUX orthogonal wrt. each
> >     other, i.e. make it possible to request one independently of the
> >     other. In the example above, SPI and I2C can be requested completely
> >     independently and the pin controller driver decides which mode to
> >     use.
> 
> But the pinctrl subsystem and bindings don't have any concept of that;
> what gets requested is the pins on the chip, or the "outer" side of the
> pin controller. There's no concept of resource management for the
> "inside" of the pin controller.

Well, perhaps my definition of "inside"/"outside" pins was not quite
clear: The pin groups define the set of (kernel internal) pin numbers of
"outside" pins which are used by pin controller to map a given
interface. Inside pins are not numbered and the inside interfaces are
only used to determine which outside pins are part of the same group
(namely those for which the pin controller hardware provides a mux
connection to the same inside interface):

                       4
                4  /|--/-- SPI
   PINS[0..3] --/--||  4
                   \|--/-- GPIO[0..3]

                   4
   PINS[4..7] -----/------ GPIO[4..7]

                       2
                2  /|--/-- I2C
   PINS[8..9] --/--||  2
                   \|--/-- GPIO[8..9]

Pins 0..3 are in the SPI group because on the "inside" they can be muxed
to the SPI interface.
Pins 8..9 are in the I2C group because on the "inside" they can be muxed
to the I2C interface.
Pins 0..9 are in the GPIO group because on the "inside" they can be
muxed to the GPIO controller.

All pin numbers are relative to the "outside", however, or conflict
management would not be possible. I hope this is more understandable
than my previous explanations.
Both muxes are controlled by the same register. In our overly simplistic
example this is not strictly necessary but in reality you might have pin
conflicts between the different interfaces.

> >   - Make pin allocation more fine-grained (in the example above, only
> >     pins 0-4 are "allocated" in case SPI is requested). This makes
> >     GPIO<->interface pin conflict management more natural.
> 
> I think you'd want to either:
> 
> a) Just deal with this in the driver; it knows the HW, and it knows
> which mux function is selected for each mux, and hence knows exactly
> which pins can be requested as GPIOs for each combination, and can
> therefore allow/disallow any GPIO request or mux function change.

This is actually what is implemented today.
1) Functional conflicts inside the pin controller hardware are managed
   by the driver:
    . Conflicts between interfaces and GPIOs: As LinusW said in a
      previous mail there are cases (not in TB10x but in other chips)
      where it is possible to enable GPIO and another interface on the
      same pin at the same time. In TB10x this is not possible and the
      driver prevents that.
    . Conflicts in which (non-GPIO) interfaces don't share pins but are
      nevertheless interdependent, e.g. because they share the same
      configuration register. The pinctrl core does not know about this
      type of constraints.

2) Pure pin conflicts are managed by the pinctrl core:
    . Conflicts between different interfaces which use the same pin.
    . GPIO conflicts (the same GPIO cannot be requested twice etc.)

> b) Extend the pinctrl core to know about this explicitly, and pass
> information to the pinctrl core. Presumably, for each combination of
> (pingroup, mux function), you'd need a list or bitmask indicating which
> pins within the pingroup are actually used. Then, the pinctrl core can
> perform all the validation. If you do this, you don't need to invent new
> pinctrl groups in order to try and shoe-horn this into pinctrl.

After the discussion we had so far I'm not so sure if extending the
pinctrl system with this kind of features is a very good idea. In
pinctrl systems many constraints are chip-specific (or at least pin
controller specific) and I don't think it would be a good idea to imply
a given pin controller model for all drivers which use this framework.

In my opinion, the current system is flexible enough to implement
different pin controller models and as the proposed driver shows,
integration/extension of the pinctrl core mechanisms with
driver-specific mechanisms to reflect a specific hardware is quite
straight forward.

The only thing I could think of adding to the core is a way to query if
a given pin is already allocated as GPIO and/or "normal" pin to make
GPIO/interface conflict management easier but I guess that's not what
you mean?

Greetings,
  Christian
