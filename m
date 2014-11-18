Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020AbaKRLdD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 06:33:03 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50015 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933AbaKRLdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 06:33:00 -0500
Date: Tue, 18 Nov 2014 12:32:56 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>, pali.rohar@gmail.com, sre@debian.org,
        sre@ring0.de, kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, freemangordon@abv.bg, bcousson@baylibre.com,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        devicetree@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [RFC] adp1653: Add device tree bindings for LED controller
Message-ID: <20141118113256.GA10022@amd>
References: <20141116075928.GA9763@amd>
 <20141117145857.GO8907@valkosipuli.retiisi.org.uk>
 <546AFEA5.9020000@samsung.com>
 <20141118084603.GC4059@amd>
 <546B19C8.2090008@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <546B19C8.2090008@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> >>I've already submitted a patch [1] that updates leds common bindings.
> >>I hasn't been merged yet, as the related LED Flash class patch [2]
> >>still needs some indicator leds related discussion [3].
> >>
> >>I think this is a good moment to discuss the flash related led common
> >>bindings.
> >
> >Part of problem is that adp1653 is not regarded as "LED" device by
> >current kernel driver.
> 
> It doesn't prevent us from keeping the flash devices related
> DT bindings unified across kernel subsystems. The DT bindings
> docs for the adp1653 could just provide a reference to the
> led/common.txt bindings. In the future, when LED Flash
> class will be merged, all the V4L2 Flash drivers might be
> moved to the LED subsystem to gain the LED subsystem support.

Yeah, that makses sense.

> >@@ -19,5 +30,10 @@ Examples:
> >  system-status {
> >  	       label = "Status";
> >  	       linux,default-trigger = "heartbeat";
> >+	       iout-torch = <500 500>;
> >+	       iout-flash = <1000 1000>;
> >+	       iout-indicator = <100 100>;
> >+	       flash-timeout = <1000>;
> >+
> >	...
> >  };
> >
> >I don't get it; system-status describes single LED, why are iout-torch
> >(and friends) arrays of two?
> 
> Some devices can control more than one led. The array is for such
> purposes. The system-status should be probably renamed to
> something more generic for both common leds and flash leds,
> e.g. system-led.

No, sorry. The Documentation/devicetree/bindings/leds/common.txt
describes binding for _one LED_. Yes, your device can have two leds,
so your devices should have two such blocks in the device tree... Each
led should have its own label and default trigger, for example. And I
guess flash-timeout be per-LED, too.

Would it make sense to include "-uA" and "-usec" suffixes in the dt
property names?

> >Also, at least on adp1653, these are actually two leds -- white and
> >red. Torch and flash is white led, indicator is red led.
> 
> Then you should define three properties:
> 
> iout-torch = <[uA]>;
> iout-flash = <[uA]>;
> iout-indicator = <[uA]>;
> 
> iout-torch and iout-flash properties would determine the current
> for the white led in the torch and flash modes respectively and
> the iout-indicator property would determine the current for
> the indicator led.

Yes, that would work. I have used

+               max-flash-timeout-usec = <500000>;
+               max-flash-intensity-uA     = <320000>;
+               max-torch-intensity-uA     =  <50000>;
+               max-indicator-intensity-uA =  <17500>;

. Which is pretty similar. (Actually, maybe the longer property names
are easier to understand for more people?) (And yes, I should probably
separate red and white led into separate groups).

> >>[2] http://www.spinics.net/lists/linux-media/msg83100.html
> >>[3] http://www.spinics.net/lists/linux-leds/msg02472.html
> >
> >What device are you using for testing? Can you cc me on future
> >patches?
> 
> I am using max77693 [1] and aat1290 [2]. OK, I will add you on cc.

Thanks for cc and thanks for links!

I see max77693 has two different "white" leds, aat1290 has one "white"
led, and neither of them has secondary red led for indication?

> The v4l2-flash sub-device registers with v4l2-async API
> in a media device. Exemplary support for v4l2-flash
> sub-devices is added to the exynos4-is driver in the patch [5].

Thanks for the links. It seems that aside from moving adp1653 driver
to device tree, it should be moved to the LED framework, but that's a
topic for another patch.

Best regards,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
