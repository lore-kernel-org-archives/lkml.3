Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751444Ab3FNJNT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 05:13:19 -0400
Received: from mail.abilis.ch ([195.70.19.74]:29500 "EHLO mail.abilis.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751030Ab3FNJNQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 05:13:16 -0400
Date: Fri, 14 Jun 2013 11:12:43 +0200
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
Message-ID: <20130614091241.GA23745@ab42.lan>
References: <CACRpkdY9F0cUaRfGJnHJW=2dYf_yKkr3M8Kh+_e6XQhh1WBoUA@mail.gmail.com>
 <1371128132-18266-2-git-send-email-christian.ruppert@abilis.com>
 <51BA3BC1.3090109@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <51BA3BC1.3090109@wwwdotorg.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 13, 2013 at 03:38:09PM -0600, Stephen Warren wrote:
> On 06/13/2013 06:55 AM, Christian Ruppert wrote:
> > This patch adds the infrastructure required to register non-linear gpio
> > ranges through gpiolib and the standard GPIO device tree bindings.
> 
> That's not exactly true. The existing gpio-ranges property already
> allows non-linear ranges to be represented quite easily; each entry in
> the gpio-ranges list is <gpio-base> <pinctrl-base> <count>, so you can
> piece together any mapping you want.

You're right, my description is somewhat imprecise here.

> The potential advantage of this patch is that the pinctrl-side of the
> mapping can be a group name rather than pin IDs, which might reduce the
> size of the mapping list if you have an extremely sparse or non-linear
> mapping /and/ parts of that mapping just happen to align with the pin
> groups in the pin controller HW, since each entry in the gpio-ranges
> property can be sparse/non-linear, rather than being a small linear
> chunk of the mapping.

Pin controller authors have the freedom to define pin groups just for
the purpose of "predefining" the pinctrl side of GPIO ranges. For
example, the pinctrl driver from the original patch in this discussion
has different types of pin groups treated differently by the driver's
internal logic.

> As an aside, for Tegra I solved this differently: In the pinctrl driver,
> I simply defined the pin IDs to exactly match the GPIO IDs in order, so
> the mapping is 100% linear. Of course, this only works if your pinctrl
> HW documentation doesn't define any kind of numbering/ordering for your
> pins, so you can pick any order you want for the pinctrl binding/driver.
> This was true for Tegra20, since the HW only used groups for muxing.
> Given more recent Tegra SoCs have moved to per-pin muxing, that might
> not have been the best decision though, since now the HW registers at
> least do have a defined ordering/ID for each pin. If only we'd started
> with Tegra30 support not Tegra20:-)

My motivation of this patch is exactly the same problem put differently:
Confine the pin numbering (or what could be called a pin data base) to
the pin controller and free it from external constraints (which can be
gpio-ranges consecutiveness, customer documentation coherency or
whatever).

> > diff --git a/Documentation/devicetree/bindings/gpio/gpio.txt b/Documentation/devicetree/bindings/gpio/gpio.txt
> 
> > +In addition, named groups of pins can be mapped to pin groups of a given
> > +pin controller:
> > +
> > +	gpio_pio_g: gpio-controller@1480 {
> > +		#gpio-cells = <2>;
> > +		compatible = "fsl,qe-pario-bank-e", "fsl,qe-pario-bank";
> > +		reg = <0x1480 0x18>;
> > +		gpio-controller;
> > +		gpio-pingrps = <&pinctrl1 0>, <&pinctrl2 3>;
> > +		gpio-pingrp-names = "pctl1_gpio_g", "pctl2_gpio_g";
> 
> A few thoughts here:
> 
> "gpio-pingrps" doesn't sound very similar to the existing "gpio-ranges".
> Can we make their equivalent purpose more obvious by renaming this
> "gpio-group-ranges"?
> 
> I'm not actually even sure we need a new property for this, except for
> the string group names. We could fold the new gpio-pingrps into the
> existing gpio-ranges, whose entries have the format:
> 
> <gpio-base> <pinctrl-base> <count>
> 
> ... by saying that if count==0, it means to use a group name instead of
> a pinctrl-base value. We can insist that pinctrl-base==0 in this case
> too. If we go made, count==0 could mean "special" and pinctrl-base==0
> could mean "by pinctrl group name", and other values of pinctrl-base
> could be added later to mean other things!
> 
> gpio-ranges =
> 	<&pinctrl1 0 20 10>, /* Existing numeric style */
> 	<&pinctrl2 10 0 0>,  /* Count==0, so group name style */
> 	<&pinctrl1 0 20 10>, /* Existing numeric style */
> gpio-ranges-group-names =
> 	"",    /* No group name required for entry 0 */
> 	"gr1", /* Group name for entry 1 */
> 	"";    /* No group name required for entry 2 */
> 
> Does this seem better?

I had a similar hesitation when implementing this and found the
gpio-ranges-contains-everything approach slightly confusing. On the
other hand I think it is more elegant to have only one property (plus
the strings). I didn't reach a clear conclusion and I'll happily follow
the advice of people having more device-tree experience than myself.
Just tell me if you prefer to rename the gpio-pingrps or merge
everything into gpio-ranges.

> > +		gpio-pingrp-names = "pctl1_gpio_g", "pctl2_gpio_g";
> 
> I'm slightly worried that those example group names appear to be
> globally scoped. I would hope the group names are interpreted
> relative-to or within the pin controller that they are associated with.

They are relative to the pin controller that they are associated with.

> I wouldn't expect the pin controllers to include their own name in the
> names of the pin groups they expose. In other words, I'd expect that
> example to be more like:
> 
> > +		gpio-pingrp-names = "foo", "bar";

OK, I'll change that in the doc.

> > +The pinctrl node must have a "#gpio-pingrp-cells" property set to one to
> > +define the number of arguments to pass with the phandle.
> 
> This shouldn't be required.
> 
> Such properties are useful when one node references a second node, and
> that second node dictates the format of the reference. However, that is
> not the case here; the definition of gpio-pingrp-names itself always
> dictates its format entirely, and hence the value #gpio-pingrp-cells
> must always be 1, and hence there is no point requiring any referenced
> node to include this property.

This is a residue from my hesitation between a single gpio-ranges
property and the proposed format: My alternative idea was that a pin
controller either provides pin numbers or named gpio ranges and that
#gpio-range-cells defines which (3 for pin numbers, 1 for named ranges).
Your proposal with the 0s is probably more flexible for future
extensions.

> I realize this issue was inherited from the existing gpio-ranges
> documentation/implementation, but I've posted patches to solve that,
> triggered by thinking about this patch:
> 
> https://lists.ozlabs.org/pipermail/devicetree-discuss/2013-June/035462.html
> (the rest of the series will make it more clear, i.e. the new of_ API)
> 
> > +Both methods can be combined in the same GPIO controller, e.g.
> 
> In the proposal I have above, combining the mechanisms is slightly more
> cohesive, I think.

I agree. Shall I go for the combined gpio-ranges then?

Greetings,
  Christian

-- 
  Christian Ruppert              ,          <christian.ruppert@abilis.com>
                                /|
  Tel: +41/(0)22 816 19-42     //|                 3, Chemin du Pré-Fleuri
                             _// | bilis Systems   CH-1228 Plan-les-Ouates
