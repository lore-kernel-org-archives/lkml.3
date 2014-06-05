Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747AbaFERH3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 13:07:29 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:57377 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221AbaFERH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 13:07:26 -0400
Date: Thu, 5 Jun 2014 12:06:57 -0500
From: Nishanth Menon <nm@ti.com>
To: Grazvydas Ignotas <notasas@gmail.com>
CC: <dbaryshkov@gmail.com>, Tony Lindgren <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        <dwmw2@infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH V2 2/2] power: twl4030_charger: attempt to power off in
 case of critical events
Message-ID: <20140605170657.GA30245@kahuna>
References: <1401313610-14252-1-git-send-email-nm@ti.com>
 <1401313610-14252-3-git-send-email-nm@ti.com>
 <CANOLnOPb1xbqb5WXaK5-kdCezVuDhNxTtE5VV_MbCi4WTd2=oA@mail.gmail.com>
 <538F18B6.7070102@ti.com>
 <CANOLnOMbjpLd2mGcTRcR-+jcp80H1z7g4-eZ6yMJvovEB2__RQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANOLnOMbjpLd2mGcTRcR-+jcp80H1z7g4-eZ6yMJvovEB2__RQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01:30-20140605, Grazvydas Ignotas wrote:
> On Wed, Jun 4, 2014 at 4:01 PM, Nishanth Menon <nm@ti.com> wrote:
> > On 06/04/2014 05:04 AM, Grazvydas Ignotas wrote:
> >> On Thu, May 29, 2014 at 12:46 AM, Nishanth Menon <nm@ti.com> wrote:
> >>> Attempt to power off in case of critical events such as battery removal,
> >>> over voltage events.
> >>>
> >>> There is no guarentee that we'd be in a safe scenario here, but the very
> >>> least we can try to do is to power off the device to prevent damage to
> >>> the system instead of just printing a message and hoping for the best.
> >>
> >> At least "battery temperature out of range" does seem to happen quite
> >> often while charging on hot summer day. I'd prefer my pandora to not
> >> shutdown in such case, it could just stop charging instead.
> > Yeah, We could call
> >   twl4030_charger_enable_ac(false);
> >   twl4030_charger_enable_usb(bci, false);
> >
> > But then, is that sufficient?
> > From the TRM:
> > 7.5.8 Battery Temperature Out-of-Range Detection
> > Battery temperature out-of-range detection detects whether the battery
> > temperature is within a specific
> > range. Detection is possible for two temperature ranges. When the
> > battery temperature is not in the
> > 2–50°C range or is in the 3–43°C range, the TBATOR1 and TBATOR2 status
> > bits rise and an interrupt is
> > generated.
> > This MADC monitoring function can be enabled by writing to the
> > TBATOR1EN (BCIMFEN2[3]) and
> > TBATOR2EN (BCIMFEN2[1]) fields.
> >
> > Battery pack at high temperature is a risk, no? and it may not be just
> > charger that might be causing such a condition. Is'nt it safer to shut
> > the device down in such a case?
> 
> I don't know, so far nobody has complained about the battery exploding
> and anybody getting hurt, but it would make the device unusable for

Yeah - but this is not something we'd like to see, ever! Out side of
2-50C+ range, I'd think "cold climates" too and wonder about[1] style
experiences.. there are too many PR stories on the net which does not
let me do anything else in case of error notifications like this. As
you can guess, I'd want to be the last person responsible for a patch
that does not react to hardware event telling me "unsafe temperature"
and not taking drastic action that kernel lets me(not interested in
appearing in some court).

> people in hot climates. From what I remember the automatic charge is
> stopped automatically on this condition, as some people complained
> they couldn't charge their device and saw these messages in dmesg. I
> guess mainline could choose the safer option and shutdown, no strong
> opinion about this.

OK. Then, lets just stick to reasonable temperature ranges here and go
a little more conservative[shut down the chargers as well] as in the
following patch. Do ack if you are ok with the following.

[1] http://en.wikipedia.org/wiki/Lithium-ion_battery#Safety

8<--------------
>From daeac775473061c5f59d307a9500c688d9b6e87f Mon Sep 17 00:00:00 2001
From: Nishanth Menon <nm@ti.com>
Date: Wed, 28 May 2014 16:01:16 -0500
Subject: [PATCH V2] power: twl4030_charger: attempt to power off in case of
 critical events

Attempt to power off in case of critical events such as battery removal,
over voltage events.

There is no guarentee that we'd be in a safe scenario here, but the
very least we can try to do is to shut down the chargers and power off
the device to prevent damage to the system instead of just printing a
message and hoping for the best.

NOTE: twl4030 should attempt some form of recovery, but just depending
on that is never a safe alternative.

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 drivers/power/twl4030_charger.c |   30 +++++++++++++++++++++++++-----
 1 file changed, 25 insertions(+), 5 deletions(-)

diff --git a/drivers/power/twl4030_charger.c b/drivers/power/twl4030_charger.c
index 2598c58..6d92893 100644
--- a/drivers/power/twl4030_charger.c
+++ b/drivers/power/twl4030_charger.c
@@ -22,6 +22,7 @@
 #include <linux/power_supply.h>
 #include <linux/notifier.h>
 #include <linux/usb/otg.h>
+#include <linux/reboot.h>
 #include <linux/regulator/machine.h>
 
 #define TWL4030_BCIMSTATEC	0x02
@@ -332,6 +333,7 @@ static irqreturn_t twl4030_bci_interrupt(int irq, void *arg)
 	struct twl4030_bci *bci = arg;
 	u8 irqs1, irqs2;
 	int ret;
+	bool power_off = false;
 
 	ret = twl_i2c_read_u8(TWL4030_MODULE_INTERRUPTS, &irqs1,
 			      TWL4030_INTERRUPTS_BCIISR1A);
@@ -352,20 +354,38 @@ static irqreturn_t twl4030_bci_interrupt(int irq, void *arg)
 	}
 
 	/* various monitoring events, for now we just log them here */
-	if (irqs1 & (TWL4030_TBATOR2 | TWL4030_TBATOR1))
+	if (irqs1 & (TWL4030_TBATOR2 | TWL4030_TBATOR1)) {
 		dev_warn(bci->dev, "battery temperature out of range\n");
+		power_off = true;
+	}
 
-	if (irqs1 & TWL4030_BATSTS)
+	if (irqs1 & TWL4030_BATSTS) {
 		dev_crit(bci->dev, "battery disconnected\n");
+		power_off = true;
+	}
 
-	if (irqs2 & TWL4030_VBATOV)
+	if (irqs2 & TWL4030_VBATOV) {
 		dev_crit(bci->dev, "VBAT overvoltage\n");
+		power_off = true;
+	}
 
-	if (irqs2 & TWL4030_VBUSOV)
+	if (irqs2 & TWL4030_VBUSOV) {
 		dev_crit(bci->dev, "VBUS overvoltage\n");
+		power_off = true;
+	}
 
-	if (irqs2 & TWL4030_ACCHGOV)
+	if (irqs2 & TWL4030_ACCHGOV) {
 		dev_crit(bci->dev, "Ac charger overvoltage\n");
+		power_off = true;
+	}
+
+	/* Try to shutdown the system */
+	if (power_off) {
+		/* Disable chargers before shutting off */
+		twl4030_charger_enable_ac(false);
+		twl4030_charger_enable_usb(bci, false);
+		orderly_poweroff(true);
+	}
 
 	return IRQ_HANDLED;
 }
-- 
1.7.9.5

-- 
Regards,
Nishanth Menon
