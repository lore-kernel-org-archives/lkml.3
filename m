Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751115AbaAXFo0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 00:44:26 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:58958 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750767AbaAXFoY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 00:44:24 -0500
Date: Fri, 24 Jan 2014 06:42:54 +0100
From: Lothar =?UTF-8?B?V2HDn21hbm4=?= <LW@KARO-electronics.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, Mark Rutland <mark.rutland@arm.com>,
        linux-pwm@vger.kernel.org, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Rob Landley <rob@landley.net>, Kumar Gala <galak@codeaurora.org>,
        Shawn Guo <shawn.guo@linaro.org>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] PWM: let of_xlate handlers check args count
Message-ID: <20140124064254.0369084d@ipc1.ka-ro>
In-Reply-To: <20140123173642.GZ15937@n2100.arm.linux.org.uk>
References: <20140123083714.3c6e86ae@ipc1.ka-ro>
	<1390467898-9216-1-git-send-email-s.hauer@pengutronix.de>
	<1390467898-9216-2-git-send-email-s.hauer@pengutronix.de>
	<20140123115632.6d3f1a58@ipc1.ka-ro>
	<20140123110444.GI16215@pengutronix.de>
	<20140123165349.GY15937@n2100.arm.linux.org.uk>
	<20140123173642.GZ15937@n2100.arm.linux.org.uk>
Organization: Ka-Ro electronics GmbH
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Russell King - ARM Linux wrote:
> On Thu, Jan 23, 2014 at 04:53:50PM +0000, Russell King - ARM Linux wrote:
> > On Thu, Jan 23, 2014 at 12:04:44PM +0100, Sascha Hauer wrote:
> > > On Thu, Jan 23, 2014 at 11:56:32AM +0100, Lothar Waßmann wrote:
> > > > Hi,
> > > > 
> > > > Sascha Hauer wrote:
> > > > > of_pwm_n_cells for the of_xlate handler is stored in struct pwm_chip,
> > > > > but it is only ever used by the of_xlate handler itsel. Remove
> > > > > of_pwm_n_cells from struct pwm_chip and let the handler do the argument
> > > > > count checking to simplify the code.
> > > > > 
> > > > This still does not make the PWM_POLARITY flag in the pwms node
> > > > optional as was the goal because of_parse_phandle_with_args() requires
> > > > at least #pwm-cells arguments in the node.
> > > > 
> > > > So, with a DT configuration like:
> > > > pwm0: pwm@0 {
> > > > 	#pwm-cells = <3>;
> > > > };
> > > > backlight {
> > > > 	pwms = <&pwm0 0 100000>;
> > > > };
> > > 
> > > We misunderstood each other. My goal was to allow the driver to also
> > > work with old devicetrees which specify #pwm-cells = <2>, not to allow
> > > inconsistent devicetrees like the snippet above.
> > 
> > In which case, the patch I've posted seems to do that job too... I'm
> > just about to test out the three-cell version.
> 
> Okay, this works, but there's a problem with pwm-leds.
> 
> When the duty cycle is set to zero (when you set the brightness to zero)
> pwm-leds decides to disable the PWM after configuring it.  This causes
> the PWM output to be driven low, causing the LED to go to maximum
> brightness.
> 
> So, using the inversion at PWM level doesn't work.
> 
The problem is that the driver calls pwm_disable() when the duty cycle is 0.
This sets the PWM output low independent from the output polarity setting.

> To make this work correctly, we really need pwm-leds to do the inversion
> rather than setting the inversion bit in hardware.
> 
The same holds for the pwm-backlight driver.

The easiest fix would be not to call pwm_disable() even for a zero duty
cycle.


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
