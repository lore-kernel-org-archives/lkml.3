Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934223Ab3DKOVG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 10:21:06 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44694 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752302Ab3DKOVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 10:21:04 -0400
Date: Thu, 11 Apr 2013 15:21:00 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Kukjin Kim <kgene.kim@samsung.com>,
        Sangbeom Kim <sbkim73@samsung.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 2/2] mfd: wm8994: Add some OF properties
Message-ID: <20130411142100.GA24971@opensource.wolfsonmicro.com>
References: <1365604763-13122-1-git-send-email-broonie@opensource.wolfsonmicro.com> <1365604763-13122-2-git-send-email-broonie@opensource.wolfsonmicro.com> <5166BCCC.5020307@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5166BCCC.5020307@samsung.com>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 03:38:20PM +0200, Sylwester Nawrocki wrote:
> On 04/10/2013 04:39 PM, Mark Brown wrote:

> > Untested at present.

> I've tested it with wm1811 codec and found a few issues/things that are 
> a bit confusing to me.

Wasn't kidding about the lack of testing!

> > +  - AVDD2-supply, DBVDD1-supply, DBVDD2-supply, DBVDD3-supply, CPVDD-supply,
> > +    SPKVDD1-supply, SPKVDD2-supply : power supplies for the device, as covered

> These capitalized regulator supply names look like standard ones. Sorry, 
> I'm quite new to all this ASoC stuff. I was wondering, what about LDO1, LDO2
> regulators that are present in the wm1811 chip for instance ? Are those
> regulators supposed to be associated with some of the supply names above ?

> AFAICS LDO1, LDO2 need to be enabled before we can actually perform any I2C 
> communication.

Since all designs I've ever seen for this chip use the internal
regulators in a consistent fashion I've added support for setting up the
standard hookup by default so users don't need to specify this by hand
since that wound up being repetitive and boring.  This is in -next or

  git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git topic/wm8994

and should show up in v3.10.  The above list includes the supplies for
LDO1 and LDO2.  If someone wants to support other configurations the
binding can always be extended with optional properties.

> Besides that, I needed to specify following regulator supplies in order to
> to get the wm8994 codec successfully initialized:

>   DCVDD-supply
>   AVDD1-supply

> That might be something specific to the sound machine driver though, I'm not
> certain. 

No, it's not - it's the above regulator driver changes, those are the
supplies normally supplied by the internal regulators.

> > +  - micbias-cfg : Three MICBIAS register values for WM1811 or

> Aren't there just 2 MICBIAS registers ? At least I've found the wm8994 driver
> handles only 2 values.

That'll be a cut'n'paste.

> > +  - ldo1ena : GPIO specifier for control of LDO1ENA input to device.
> > +  - ldo2ena : GPIO specifier for control of LDO2ENA input to device.

> Hmm, don't we need to specify the constraints for the regulators as well ?
> AFAICS for wm8994 you choose not to specify functions of this MFD as child
> DT nodes.

For the DT bindings it seemed simplest to assume the default setup so
the regulator driver ought to just do the right thing.  If someone has
done something different then you're right and we need to add code for
this.

> > +  - ldoena-always-driven : If present LDOENA is always driven

> I suppose the custom properties should be prefixed with "wlf,".

Meh, yeah.  Will fix.

> > +	if (of_property_read_u32_array(np, "gpio-cfg", pdata->gpio_defaults,
> > +				       ARRAY_SIZE(pdata->gpio_defaults)) >= 0) {
> > +		for (i = 0; i < ARRAY_SIZE(pdata->gpio_defaults); i++) {
> > +			if (wm8994->pdata.gpio_defaults[i] == 0) {
> > +				pdata->gpio_defaults[i]
> > +					= WM8994_CONFIGURE_GPIO;

> Hmm, that's not obvious from the binding, that 0 is replaced with 0x10000
> by the implementation.

This is an implementation detail due to conversion to platform data.
Since the idiom for platform data is that zero does nothing for platform
data we made the user set an out of range bit (the registers are 16 bit)
to set zero, otherwise we left the value untouched.  The result is that
we rewrite to 0x10000 in the platform data which is then rewritten to
zero.

> > +			} else if (pdata->gpio_defaults[i] == 0xffffffff) {
> > +				pdata->gpio_defaults[i] = 0;
> > +			} else if (pdata->gpio_defaults[i] > 0xffff) {

> And this is not specified as an error condition at the binding. I expected
> in such case the default value of a register would be used.

Yes, bitrot due to cut'n'paste from two different sources.  Will fix.

> I guess you preferred it that way, rather than

> 	pdata->lineout1_diff = !of_property_read_bool(np, "lineout1-se");
> 	pdata->lineout2_diff = !of_property_read_bool(np, "lineout2-se");

> ?

Yes, I tend to prefer to write things out a bit more explicitly.
