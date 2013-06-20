Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965541Ab3FTL5r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 07:57:47 -0400
Received: from mail.abilis.ch ([195.70.19.74]:12128 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965039Ab3FTL5p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 07:57:45 -0400
Date: Thu, 20 Jun 2013 13:57:10 +0200
From: Christian Ruppert <christian.ruppert@abilis.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Patrice CHOTARD <patrice.chotard@st.com>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Sascha Leuenberger <sascha.leuenberger@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: Re: [PATCH 2/2] Make non-linear GPIO ranges accesible from gpiolib
Message-ID: <20130620115710.GB942@ab42.lan>
References: <CACRpkdY9F0cUaRfGJnHJW=2dYf_yKkr3M8Kh+_e6XQhh1WBoUA@mail.gmail.com>
 <1371128132-18266-2-git-send-email-christian.ruppert@abilis.com>
 <51BA3BC1.3090109@wwwdotorg.org>
 <20130614091241.GA23745@ab42.lan>
 <51C1F42E.5090107@wwwdotorg.org>
 <51C1F82C.4020502@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <51C1F82C.4020502@wwwdotorg.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Stephen,

On Wed, Jun 19, 2013 at 12:27:56PM -0600, Stephen Warren wrote:
> On 06/19/2013 12:10 PM, Stephen Warren wrote:
> > On 06/14/2013 03:12 AM, Christian Ruppert wrote:
> >> On Thu, Jun 13, 2013 at 03:38:09PM -0600, Stephen Warren wrote:
> >>> On 06/13/2013 06:55 AM, Christian Ruppert wrote:
> [...]
> >>> The potential advantage of this patch is that the pinctrl-side of the
> >>> mapping can be a group name rather than pin IDs, which might reduce the
> >>> size of the mapping list if you have an extremely sparse or non-linear
> >>> mapping /and/ parts of that mapping just happen to align with the pin
> >>> groups in the pin controller HW, since each entry in the gpio-ranges
> >>> property can be sparse/non-linear, rather than being a small linear
> >>> chunk of the mapping.
> >>
> >> Pin controller authors have the freedom to define pin groups just for
> >> the purpose of "predefining" the pinctrl side of GPIO ranges.
> > 
> > Hmm. I suppose that's true. I'm not sure how enthusiastic I am about
> > doing this though... The reason I'm unsure is because it starts using
> > pin groups from something other than groups of pins in HW that are all
> > affected by the same mux or config bits in a register, and starts using
> > pin groups for something else; GPIO<->pinmux pins mapping. Perhaps it's
> > OK though, considering the other abuses of pin groups that are already
> > present, such as using pin groups to represent default/common uses of
> > groups of pins that don't actually exist in HW.

The reason for these "abuses" might just be that every company (or maybe
even hardware team) has a different understanding of how pin muxing
should be implemented in hardware. There are probably as many different
pin muxing architectures out there as companies (maybe even more).
Finding a "one size fits all"-approach to this is extremely difficult
and driver authors adapt the kernel infrastructure as well as they can
to the hardware they have. As an example, see below for a fundamental
cultural difference between your hardware/integration team and ours.

> I've realized what I don't like about this.
> 
> Pin groups are supposed to be something that represents some property of
> the pinctrl HW itself. So, if you have register "X" bits 3-0 that define
> the mux function for pins 8, 9, 10, and 11, then there really is a pin
> group that exists in HW, and that pin group will still exist with that
> same definition no matter what SoC you put the pinctrl HW into. If this
> changes, it's not the same pinctrl HW module.

Let me see if I get this right (Let's take the example in the section
"What is pinmuxing" of Documentation/pinctrl.txt in Linux-3.10-rc6 which
is similar to TB10x):
If I understand you correctly, you define two pin groups in this
example: 
gpr1 = {A5, A6, A7, A8, B5};
grp2 = {A1, B1, C1, D1, E1, F1, G1, G2, G3, G4, H1};

grp1 has three configurations: allgpio, i2c and spi
grp2 has five configurations: allgpio, mmc2, mmc2_spi, mmc4, mmc4_spi, mmc8

Let's assume that unused pins are automatically configured as GPIOs in
each configuration. The pin controller thus requires a second list of
pins (for each of the modes), defining for which pins in each group it
can grant gpio_requests in a given mode. Furthermore, the mmc node will
have to "know" if mode "mmc2" or "mmc2_spi" must be selected for a given
setup, making the thing somewhat unorthogonal.

When writing our pinctrl driver, my understanding was slightly
different: I define seven pin groups:
spi1 = {A5, A6, A7, A8};
i2c = {A5, B5};
mmc2 = {A1, B1};
mmc4 = {A1, B1, C1, D1};
mmc8 = {A1, B1, C1, D1, E1, F1, G1, H1};
spi2 = {G1, G2, G3, G4};
gpios = {A1, A5, A6, A7, A8, B1, B5, C1, D1, E1, F1, G1, G2, G3, G4, H1};

Now each peripheral can individually request the pins it requires,
independently of the others. Conflicts (e.g. between spi1 and i2c or
between mmc4 and the GPIO at D1) are managed by the program logic in the
pin controller. The advantages are the following:
 . The pin controller knows implicitly which pins are used for what and
   can easily grant or refuse pin and GPIO requests.
 . Conceptually, GPIO requests are now the same as any other
   configuration request.
 . The information of whether SPI2 is active or not is associated to
   spi2 and spi2 only. mmc does not need to know.
 . Implementation details of the pin controller hardware (which are the
   ports, which configuration to apply to a port to obtain a certain
   function) are confined in the pin controller driver.

> However, the connectivity between GPIO HW module "pins" (i.e. the GPIOs)
> and pinctrl HW module "pins" (inputs to mux functions) is something that
> only exists at the top-level of the SoC; outside the GPIO HW module
> itself, and outside the pinctrl HW module itself.

Well, in the case TB10x, GPIO pins are just the same as any other pins:
They go through the pin controller all the same and there is really
nothing that distinguishes them from, say, the mmc port in the example
above - which can also be mapped either partially or completely. There's
no bypassing of the pin controller going on at the top level or such.

And honestly: Have you ever seen a pin controller in which not only the
program logic but also the pin data base can be reused from one SOC to
another? At least I haven't. On the other hand, For all Abilis chips,
the program logic (the actual C functions) of the TB10x pinctrl could be
reused with very minor modifications. It would be easy to extend the
logic to a generic "Abilis pin controller" where all that needs to be
changed in function of the "compatible" string is the pointer to the pin
database.

> In other words, you could have the exact same GPIO and pinctrl HW
> modules instantiated into two different SoCs, but with completely
> different mapping of GPIO IDs to pinctrl pin IDs.

Well, you could very well conect a 4 bit mmc port instead of an spi in
the above example without changing one thing in the pin controller or
the mmc block...

> As such, it isn't even generally possible for the pinctrl HW module to
> define pin groups that describe the mapping, because the mapping is not
> a property of the pinctrl HW module, and hence should not be defined,
> even partially, by the pinctrl HW module's driver.

This is clearly implementation dependent. In the case of our chips, the
opposite is actually the case:

Your remark seems to reflect one of the following two hardware
architectures:

                                                     +- SPI
                 Physical pins --- GPIO --- pinctrl -+- I2C
                                                     +- mmc


                                +- GPIO
                 Physical pins -+           +- SPI
                                +- pinctrl -+- I2C
                                            +- mmc
TB10x hardware architecture:

                                            +- SPI
                 Physical pins --- pinctrl -+- I2C
                                            +- mmc
                                            +- GPIO

> In a similar fashion,
> the DT binding for the pinctrl HW module should describe only the HW
> module itself, and not the mapping/interaction with the outside world.
> In other words, the DT binding for the pinctrl HW module also can't
> define the names of any pin groups used in the GPIO<->pinctrl mapping,
> for the same reasons.

Except if this mapping is done _inside_ the pin controller, see above.

> As such, I'm not sure that I conceptually agree with this patch series.
> 
> Sure, it may make the gpio-ranges property more compact in some
> (unusual?) non-linear cases. However, it's representing things
> semantically incorrectly.

Is it really in the TB10x case?
To me it looks actually semantically more correct.

> So, I'd like to question the motivation for using names here again.
> Presumably the SoC vendor will write the gpio-ranges property for each
> SoC, and put that into the SoC's .dtsi file. As such, no customer is
> ever going to have to care about the property or its contents. So, I
> don't really see how this helps you with your issue re: wanting to hide
> details of multiple different ball-out options on similar SoCs, since
> even with a manually-written purely numeric gpio-ranges property, all
> that information is already essentially hidden; it's something that will
> be written once, and then never looked at.

Well, in the case of TB10x we are the SOC vendor and it was decided that
all dts and dtsi files we publish are customer-facing data and must thus
be coherent with the data sheet.

Greetings,
  Christian

-- 
  Christian Ruppert              ,          <christian.ruppert@abilis.com>
                                /|
  Tel: +41/(0)22 816 19-42     //|                 3, Chemin du Pré-Fleuri
                             _// | bilis Systems   CH-1228 Plan-les-Ouates
