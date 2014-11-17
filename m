Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751779AbaKQIXs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 03:23:48 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:54047 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723AbaKQIXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 03:23:45 -0500
Date: Mon, 17 Nov 2014 09:23:37 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Vignesh R <vigneshr@ti.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jonathan Cameron <jic23@kernel.org>, Hartmut Knaack <knaack.h@gmx.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Samuel Ortiz <sameo@linux.intel.com>, Felipe Balbi <balbi@ti.com>,
        Brad Griffis <bgriffis@ti.com>,
        Sanjeev Sharma <sanjeev_sharma@mentor.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Jan Kardell <jan.kardell@telliq.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH v4 2/6] input: touchscreen: ti_am335x_tsc: Remove udelay
 in interrupt handler
Message-ID: <20141117082337.GA3946@localhost.localdomain>
References: <1415941651-28962-1-git-send-email-vigneshr@ti.com>
 <1415941651-28962-3-git-send-email-vigneshr@ti.com>
 <20141115192739.GA18766@localhost.localdomain>
 <54697919.5030302@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54697919.5030302@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 09:57:05AM +0530, Vignesh R wrote:
> My patches are based on v3.18rc2. I tested my patches on am335x-evm
> using tslib.

No beaglebone + cape testing?

> Please explain "touch is broken"? What is the behaviour of TSC?

With plain v3.17 plus your series, the cursor is almost never near the
pen. Mostly it jitters around the right hand edge.

My customer had already changed the step delay (I think by trial and
error, not sure) in order to get the cursor near the pen. I ported
this change onto your series (see patch, below), but still the pen up
event causes a huge cursor jump.

(Again, I did solve the pen up issue, but in a totally different
way. I never posted the fix, because I could not be sure that it would
work on a wide variety of boards.)

> Which ADC channels are being used for TSC?

&tscadc {
	status = "okay";
	tsc {
		ti,wires = <4>;
		ti,x-plate-resistance = <300>;
		ti,coordinate-readouts = <5>;
		ti,wire-config = <0x00 0x11 0x23 0x32>;
	};

	adc {
		ti,adc-channels = <5 6 7>;
	};
};

So for this particular design, your series really does not help, not
even a little. You did not test the series on many boards. I am
concerned that this series only works on the one board you did test,
and that it may break functionality on other people's boards.

Thanks,
Richard

---
diff --git a/drivers/input/touchscreen/ti_am335x_tsc.c b/drivers/input/touchscreen/ti_am335x_tsc.c
index b84493f..77a4883 100644
--- a/drivers/input/touchscreen/ti_am335x_tsc.c
+++ b/drivers/input/touchscreen/ti_am335x_tsc.c
@@ -148,7 +148,7 @@ static void titsc_step_config(struct titsc *ts_dev)
 	end_step = first_step + tsc_steps;
 	for (i = end_step - ts_dev->coordinate_readouts; i < end_step; i++) {
 		titsc_writel(ts_dev, REG_STEPCONFIG(i), config);
-		titsc_writel(ts_dev, REG_STEPDELAY(i), STEPCONFIG_OPENDLY);
+		titsc_writel(ts_dev, REG_STEPDELAY(i), STEPCONFIG_OPENDLY | STEPDELAY_SAMPLE(20));
 	}
 
 	config = 0;
@@ -172,7 +172,7 @@ static void titsc_step_config(struct titsc *ts_dev)
 	end_step = first_step + ts_dev->coordinate_readouts;
 	for (i = first_step; i < end_step; i++) {
 		titsc_writel(ts_dev, REG_STEPCONFIG(i), config);
-		titsc_writel(ts_dev, REG_STEPDELAY(i), STEPCONFIG_OPENDLY);
+		titsc_writel(ts_dev, REG_STEPDELAY(i), STEPCONFIG_OPENDLY | STEPDELAY_SAMPLE(20));
 	}
 
 	/* Make CHARGECONFIG same as IDLECONFIG */
@@ -188,13 +188,13 @@ static void titsc_step_config(struct titsc *ts_dev)
 			STEPCONFIG_INP(ts_dev->inp_xp);
 	titsc_writel(ts_dev, REG_STEPCONFIG(end_step), config);
 	titsc_writel(ts_dev, REG_STEPDELAY(end_step),
-			STEPCONFIG_OPENDLY);
+			STEPCONFIG_OPENDLY | STEPDELAY_SAMPLE(20));
 
 	end_step++;
 	config |= STEPCONFIG_INP(ts_dev->inp_yn);
 	titsc_writel(ts_dev, REG_STEPCONFIG(end_step), config);
 	titsc_writel(ts_dev, REG_STEPDELAY(end_step),
-			STEPCONFIG_OPENDLY);
+			STEPCONFIG_OPENDLY | STEPDELAY_SAMPLE(20));
 
 	/* The steps end ... end - readouts * 2 + 2 and bit 0 for TS_Charge */
 	stepenable = 1;
