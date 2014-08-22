Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932718AbaHVQji (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 12:39:38 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:31380 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932362AbaHVQjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 12:39:23 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 99.127.230.128
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/pbnA14xFRBiwGmEyOqpOX
Date: Fri, 22 Aug 2014 09:39:18 -0700
From: Tony Lindgren <tony@atomide.com>
To: Grazvydas Ignotas <notasas@gmail.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>, Felipe Balbi <balbi@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] usb: phy: twl4030-usb: Fix lost interrupts after ID pin
 goes down
Message-ID: <20140822163918.GG10066@atomide.com>
References: <20140821164803.GB10066@atomide.com>
 <CANOLnOM_5VXDAstbQN45wRyYq9k26PWM0z9uZ+C2VmhOqzCuEw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANOLnOM_5VXDAstbQN45wRyYq9k26PWM0z9uZ+C2VmhOqzCuEw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

* Grazvydas Ignotas <notasas@gmail.com> [140822 06:21]:
> Hi,
> 
> On Thu, Aug 21, 2014 at 7:48 PM, Tony Lindgren <tony@atomide.com> wrote:
> > Commit 249751f22380 ("usb: phy: twl4030-usb: poll for ID disconnect")
> > added twl4030_id_workaround_work() to deal with lost interrupts
> > after ID pin goes down. However, this currently only works for the
> > insertion. The PHY interrupts are not working after disconnecting
> > an USB-A device from the board, and the deeper idle states for
> > omap are blocked as the USB controller stays busy.
> >
> > The issue can be solved by calling delayed work from twl4030_usb_irq()
> > when ID pin is down and the PHY is not asleep like we already do
> > in twl4030_id_workaround_work().
> 
> The way it is supposed to work is that after plugging in the cable
> twl4030_phy_power_on() sees ID_GROUND and kicks off id_workaround_work
> every second. When cable is unplugged, twl4030_id_workaround_work()
> sees changes in STS_HW_CONDITIONS register and triggers events.
> Doesn't that work for you, why do you need to trigger it from
> twl4030_usb_irq() too?

Not any longer because we are currently call schedule_delayed_work()
only from twl4030_phy_power_on(). That function got renamed, it used
to be twl4030_phy_resume() before the generic phy framework
changes.

So looking at the v3.12 code, you're right, it seems to behave as
you describe. That however changed with the generic phy framework
changes for v3.13, and looks like the correct breaking commit is
f1ddc24c9e33 ("usb: phy: twl4030-usb: remove *set_suspend* and
*phy_init* ops") instead.

So it won't currently work after unplugging and replugging as all
connect and disconnect interrupts go unnoticed after ID_GROUND.
So we need to poll whenever ID_GROUND and PHY is not asleep.

> > But as both twl4030_usb_irq() and twl4030_id_workaround_work()
> > already do pretty much the same thing, let's call twl4030_usb_irq()
> > from twl4030_id_workaround_work() instead of adding some more
> > duplicate code.
> 
> The difference is the sysfs_notify() call, so now every time
> id_workaround_work triggers (around once per second while the cable is
> plugged) userspace will now get useless uevent. Haven't actually
> checked if it really happens though, so I might be wrong.

Good point. That can be avoided by doing calling it only if we have
an irq and not from delayed work. Updated patch below, I've updated
the description for the proper regression causing commit and
added a check when to call the sysfs_notify. Kept Felipe's ack,
hope that works.

Regards,

Tony

8< ---------------------
From: Tony Lindgren <tony@atomide.com>
Date: Thu, 21 Aug 2014 08:59:43 -0700
Subject: [PATCH] usb: phy: twl4030-usb: Fix lost interrupts after ID pin goes down

Commit 249751f22380 ("usb: phy: twl4030-usb: poll for ID disconnect")
added twl4030_id_workaround_work() to deal with lost interrupts
after ID pin goes down. Looks like commit f1ddc24c9e33 ("usb: phy:
twl4030-usb: remove *set_suspend* and *phy_init* ops") changed
things around for the generic phy framework, and delayed work no
longer got called except initially during boot.

The PHY connect and disconnect interrupts for twl4030-usb are not
working after disconnecting a USB-A cable from the board, and the
deeper idle states for omap are blocked as the USB controller
stays busy.

The issue can be solved by calling delayed work from twl4030_usb_irq()
when ID pin is down and the PHY is not asleep like we already do
in twl4030_id_workaround_work().

But as both twl4030_usb_irq() and twl4030_id_workaround_work()
already do pretty much the same thing, let's call twl4030_usb_irq()
from twl4030_id_workaround_work() instead of adding some more
duplicate code. We also must call sysfs_notify() only when we have
an interrupt and not from the delayed work as notified by
Grazvydas Ignotas <notasas@gmail.com>.

Fixes: f1ddc24c9e33 ("usb: phy: twl4030-usb: remove *set_suspend* and *phy_init* ops")
Cc: stable@vger.kernel.org # v3.13+
Acked-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>

--- a/drivers/phy/phy-twl4030-usb.c
+++ b/drivers/phy/phy-twl4030-usb.c
@@ -560,7 +560,15 @@ static irqreturn_t twl4030_usb_irq(int irq, void *_twl)
 		 */
 		omap_musb_mailbox(status);
 	}
-	sysfs_notify(&twl->dev->kobj, NULL, "vbus");
+
+	/* don't schedule during sleep - irq works right then */
+	if (status == OMAP_MUSB_ID_GROUND && !twl->asleep) {
+		cancel_delayed_work(&twl->id_workaround_work);
+		schedule_delayed_work(&twl->id_workaround_work, HZ);
+	}
+
+	if (irq)
+		sysfs_notify(&twl->dev->kobj, NULL, "vbus");
 
 	return IRQ_HANDLED;
 }
@@ -569,29 +577,8 @@ static void twl4030_id_workaround_work(struct work_struct *work)
 {
 	struct twl4030_usb *twl = container_of(work, struct twl4030_usb,
 		id_workaround_work.work);
-	enum omap_musb_vbus_id_status status;
-	bool status_changed = false;
-
-	status = twl4030_usb_linkstat(twl);
-
-	spin_lock_irq(&twl->lock);
-	if (status >= 0 && status != twl->linkstat) {
-		twl->linkstat = status;
-		status_changed = true;
-	}
-	spin_unlock_irq(&twl->lock);
-
-	if (status_changed) {
-		dev_dbg(twl->dev, "handle missing status change to %d\n",
-				status);
-		omap_musb_mailbox(status);
-	}
 
-	/* don't schedule during sleep - irq works right then */
-	if (status == OMAP_MUSB_ID_GROUND && !twl->asleep) {
-		cancel_delayed_work(&twl->id_workaround_work);
-		schedule_delayed_work(&twl->id_workaround_work, HZ);
-	}
+	twl4030_usb_irq(0, twl);
 }
 
 static int twl4030_phy_init(struct phy *phy)
