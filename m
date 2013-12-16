Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176Ab3LPXG3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 18:06:29 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:28641 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995Ab3LPXG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 18:06:28 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 64.17.244.34
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18PnoToUvPZIIAXOMHRLAhF
Date: Mon, 16 Dec 2013 15:06:22 -0800
From: Tony Lindgren <tony@atomide.com>
To: Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Tomasz Figa <t.figa@samsung.com>, Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH] regulator: Start using standard gpios property and
 deprecate some custom properties
Message-ID: <20131216230622.GH26293@atomide.com>
References: <1386965234-26461-1-git-send-email-tony@atomide.com>
 <20131216183615.GK3185@sirena.org.uk>
 <20131216194023.GE26293@atomide.com>
 <20131216201102.GP3185@sirena.org.uk>
 <20131216210512.GF26293@atomide.com>
 <20131216214057.GG3185@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131216214057.GG3185@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mark Brown <broonie@kernel.org> [131216 13:42]:
> On Mon, Dec 16, 2013 at 01:05:13PM -0800, Tony Lindgren wrote:
> > * Mark Brown <broonie@kernel.org> [131216 12:12]:
> 
> > > This is the first time anyone's mentioned this so it probably isn't that
> > > serious an issue and bear in mind that the patch was also handling all
> > > the named GPIO specifiers too.
> 
> > I've certainly debugged this same exact issue twice already and that
> > probably means that same issue has been debugged tens or hundreds
> > of times by other people.
> 
> That surprises me to be honest, but then the fact that the convention
> was even defined surprises me.  Like I say you're the first person to
> mention it; I suspect you might write more DTs than most.

OK a limited patch for fixed regulator appended below to deal with the
above issue only.
 
> > Personally I don't see any value for a regulator describing the names of
> > the GPIOs in the binding, it's really up to the driver to make sense of
> > them. Especially if there are one or more similar GPIOs. We're not
> 
> Devices like PMICs frequently have a *lot* of possible pin functions
> some of which can get mapped onto GPIOs (in either direction), many of
> which are going to be fixed by system design and generally all muxed
> onto a much smaller set of physical pins.  If you try to specify those
> through an unnamed gpios property you end up with a very large array
> (say 30 elements, more wouldn't be too surprising) most of which will be
> empty.  That is not at all usable, it's error prone to write and very
> hard to read even with the preprocessor support that only got added
> quite recently.

That's why PMICs usually show up as GPIO controllers. And if a regulator
needs to use those GPIOs, it should most likely just use the standard
"gpios" property.
 
> > naming interrupts either.
> 
> There's typically a much more limited set of interrupts a device can
> have (and many of the more optional ones end up getting expressed via
> the GPIO binding since you also need to read the state to use them) so
> they don't run into the issue so much.

Hmm to me it seems that pretty much all of these should just use "gpios":

$ git grep -B2 -A1 of_get_named_gpio drivers/regulator
 
> > > In any case, the thing is that there's a difference between parsing both
> > > and deprecation - deprecation implies an intention to remove the old one
> > > which would just reintroduce the problem the other way around since
> > > people are likely to drop or forget the plural, use old DTs and so on.
> > > Adding a gpios property in parallel with plain gpio is fine and what I
> > > was mostly suggesting.
> 
> > Deprecation _may_ imply that it will get removed, but not always.
> > Naturally we're going to have to keep the old bindings in place since
> > they were merged. I can changed that to obsoleted if that's any better.
> 
> Yes, that's better.
> 
> > > Exactly, I think it's way more trouble than it's worth to try to change
> > > for named single element lists.  The standard property makes more sense.
> 
> > I don't think there should be any named GPIOs. If we want names, then
> > the GPIO usage should be possible to group quite easily rather than create
> > a new property for everything. Something like "enable-gpio" comes to mind.
> 
> I don't understand the difference between your suggestion and named
> GPIOs.

What I'm trying to say is let's not let drivers invent their random
*-gpio[s] property as those essentially creates new kernel ABIs that
we're stuck with.

Instead, let's try to use standard properties where possible like
"gpios" and "enable-gpios", "cs-gpios" and so on.

Regards,

Tony

8< ------------------------
From: Tony Lindgren <tony@atomide.com>
Date: Thu, 12 Dec 2013 16:21:52 -0800
Subject: [PATCH] regulator: Start using standard gpios property for fixed regulator

The fixed regulator has been using a custom "gpio" property instead of
standard "gpios" property which is confusing and can leave into silent bugs
with typos where the GPIO value is not changed for the regulator.

Fix the issue by trying to use "gpios" where possible in the drivers that
can already use it, and if that fails, then try to use the legacy custom
GPIO property.

Note that we cannot remove the existing legacy property, and don't need
to churn the .dts files for it. But we can start using the standard
"gpios" property for the new entries and update the existing entries
where suitable with other clean-up.

Cc: Tomasz Figa <t.figa@samsung.com>
Cc: Olof Johansson <olof@lixom.net>
Signed-off-by: Tony Lindgren <tony@atomide.com>

--- a/Documentation/devicetree/bindings/regulator/fixed-regulator.txt
+++ b/Documentation/devicetree/bindings/regulator/fixed-regulator.txt
@@ -4,7 +4,7 @@ Required properties:
 - compatible: Must be "regulator-fixed";
 
 Optional properties:
-- gpio: gpio to use for enable control
+- gpios: gpio to use for enable control
 - startup-delay-us: startup time in microseconds
 - enable-active-high: Polarity of GPIO is Active high
 If this property is missing, the default assumed is Active low.
@@ -12,6 +12,10 @@ If this property is missing, the default assumed is Active low.
   If this property is missing then default assumption is false.
 -vin-supply: Input supply name.
 
+Obsoleted properties:
+- gpio: Use the standard gpios property listed above instead of
+  this.
+
 Any property defined as part of the core regulator
 binding, defined in regulator.txt, can also be used.
 However a fixed voltage regulator is expected to have the
@@ -25,7 +29,7 @@ Example:
 		regulator-name = "fixed-supply";
 		regulator-min-microvolt = <1800000>;
 		regulator-max-microvolt = <1800000>;
-		gpio = <&gpio1 16 0>;
+		gpios = <&gpio1 16 0>;
 		startup-delay-us = <70000>;
 		enable-active-high;
 		regulator-boot-on;
--- a/drivers/regulator/fixed.c
+++ b/drivers/regulator/fixed.c
@@ -77,7 +77,9 @@ of_get_fixed_voltage_config(struct device *dev)
 	if (init_data->constraints.boot_on)
 		config->enabled_at_boot = true;
 
-	config->gpio = of_get_named_gpio(np, "gpio", 0);
+	config->gpio = of_get_gpio(np, 0);
+	if (!gpio_is_valid(config->gpio))
+		config->gpio = of_get_named_gpio(np, "gpio", 0);
 	/*
 	 * of_get_named_gpio() currently returns ENODEV rather than
 	 * EPROBE_DEFER. This code attempts to be compatible with both
