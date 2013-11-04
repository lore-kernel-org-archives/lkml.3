Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286Ab3KDX1E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 18:27:04 -0500
Received: from gloria.sntech.de ([95.129.55.99]:39237 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752187Ab3KDX1B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 18:27:01 -0500
From: Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
To: Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH 3/4] ARM: pinctrl: Add Broadcom Capri pinctrl driver
Date: Tue, 5 Nov 2013 00:26:55 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.0-2-amd64; KDE/4.8.4; x86_64; ; )
Cc: Sherman Yin <syin@broadcom.com>, Laxman Dewangan <ldewangan@nvidia.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Christian Daudt <bcm@fixthebug.org>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "bcm-kernel-feedback-list" <bcm-kernel-feedback-list@broadcom.com>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>,
        Matt Porter <matt.porter@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
References: <1380846199-12829-1-git-send-email-syin@broadcom.com> <051069C10411E24D9749790C498526FA1BE0B7D7@SJEXCHMB12.corp.ad.broadcom.com> <CACRpkdYSLxp2M4HghcUdjEYGh-UQ+DaiCGp6yee+Qds6DR9poA@mail.gmail.com>
In-Reply-To: <CACRpkdYSLxp2M4HghcUdjEYGh-UQ+DaiCGp6yee+Qds6DR9poA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201311050026.56321.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 4. November 2013, 13:24:10 schrieb Linus Walleij:
> > In my driver, I have the "one entry per pin" support for all my
> > properties instead of just the function property, like the "drive_str"
> > property below:
> > 
> > +               grp_1 {
> > +                       brcm,pins       = "pin1", "pin2", "pin3";
> > +                       brcm,function   = "alt1", "alt2", "alt1";
> > +                       brcm,drive_str  = <2 4 6>;
> > +                       brcm,slew       = <1>;
> > +               };
>
> On Sat, Oct 26, 2013 at 12:48 AM, Sherman Yin <syin@broadcom.com> wrote:
> > I thought that would be convenient and allow users to group pins together
> > based on functionality and without the restriction that the pins must
> > have the same properties.
> > Do you think that's a good idea and are there
> > plans to support that in the generic pinconfig?  If so, I can look into
> > porting my implementation to pinconf-generic.c - but first I have to
> > figure out how some of the properties would work if more than one value
> > could be specified (eg. "bias-disable" which takes no values)
> 
> Hm I don't quite get it I think. It depends on the old bindings still
> working and full compatibility with old device trees. It might be a bit
> confusing.
> 
> I need help from Heiko on this I think.

I remember we had a discussion about how things like bias-disable explicitly 
shouldn't have a value, when they are represented in the list-format:

		pcfg_pull_none: pcfg_pull_none {
			bias-disable;
		};

so a bias-disable = <1> was explicitly "forbidden" [for a lack of a better 
word]. And it was similar for other options, the parameter not meant to be 
indicating if they are active but really only setting the "strength" or so.

But how to represent this in the list variant above, I don't know.

Having a brcm,bias-disable = <0>, <1>, ... thus looks wrong and also does not 
seem to scale well to all the possible options (bias-* and the others).

Having a brcm,bias = <x>, <y>, <z>, ... with constants denoting pull-up, -
down, disable, etc might be possible, but I'm missing the electrical 
engineering knowledge on the possibility of those bias-things being combined.



For example on my rockchip-pinctrl driver, the pins also do not need to have 
the same configuration to be grouped together - inspired at the time by the 
format the at91 driver uses. Here each pin forms a tuple instead of being 
identified by an index. In it the basic function is set directly and then 
references a predefined list of pinctrl options.


		pcfg_pull_none: pcfg_pull_none {
			bias-disable;
		};

		uart0 {
			uart0_xfer: uart0-xfer {
				rockchip,pins = <RK_GPIO1 0 RK_FUNC_1 &pcfg_pull_none>,
							 <RK_GPIO1 1 RK_FUNC_1 &pcfg_pull_none>;
			};

...
		};



A switch to something like to following would also be a possibility:

	pcfg1: pcfg1 {
		bias-disable;
		slew-rate = <1>;
	};

	pcfg2: pcfg2 {
		drive-strength = <2>;
	};

	grp_1 {
		brcm,pins       = "pin1", "pin2", "pin3";
		brcm,function   = "alt1", "alt2", "alt1";
		brcm,pinconf = <&pcfg1>, <&pcfg2>
	};



So far my unsorted thoughts [and recoverable memory] on this :-)
Heiko
