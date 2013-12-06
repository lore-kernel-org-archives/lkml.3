Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161978Ab3LFNEf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:04:35 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44612 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161855Ab3LFNEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:04:30 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Felipe Balbi <balbi@ti.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 222/272] usb: musb: dsps: move try_idle to start hook
Date: Fri,  6 Dec 2013 12:58:31 +0000
Message-Id: <1386334761-25517-223-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

commit 8b9fcce2d88586b9a120ff3e039d8f42413f0bb0 upstream.

The timer is initialized right after musb is probed. There is actually
no need to have this timer running because _nothing_ will happen until
we have the gadget loaded. Also we need this timer only if we run in OTG
mode _and_ we need it also after the gadget has been replaced with
another one.

I've been looking at am35x.c, da8xx.c, omap2430.c, tusb6010.c. da8xx
seem to have the same problem as dsps and doing mostly the same thing.
tusb6010 seem to do something different and do some actual "idle / power
saving" work so I am not too comfortable to remove
musb_platform_try_idle() from musb_gadget_setup().

Therefore this patch does not start the timer if there is no gadget
active (which is at musb_gadget_setup() at time). In order to have the
timer active after the gadget is loaded it will be triggered from
dsps_musb_enable().

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Felipe Balbi <balbi@ti.com>
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/musb/musb_dsps.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/usb/musb/musb_dsps.c b/drivers/usb/musb/musb_dsps.c
index 5233804..f7623f1 100644
--- a/drivers/usb/musb/musb_dsps.c
+++ b/drivers/usb/musb/musb_dsps.c
@@ -139,6 +139,8 @@ static const resource_size_t dsps_control_module_phys[] = {
 #define USBPHY_OTGVDET_EN	(1 << 19)
 #define USBPHY_OTGSESSEND_EN	(1 << 20)
 
+static void dsps_musb_try_idle(struct musb *musb, unsigned long timeout);
+
 /**
  * musb_dsps_phy_control - phy on/off
  * @glue: struct dsps_glue *
@@ -188,6 +190,7 @@ static void dsps_musb_enable(struct musb *musb)
 	/* Force the DRVVBUS IRQ so we can start polling for ID change. */
 	dsps_writel(reg_base, wrp->coreintr_set,
 		    (1 << wrp->drvvbus) << wrp->usb_shift);
+	dsps_musb_try_idle(musb, 0);
 }
 
 /**
@@ -280,6 +283,9 @@ static void dsps_musb_try_idle(struct musb *musb, unsigned long timeout)
 		return;
 	}
 
+	if (!musb->g.dev.driver)
+		return;
+
 	if (time_after(glue->last_timer[pdev->id], timeout) &&
 				timer_pending(&glue->timer[pdev->id])) {
 		dev_dbg(musb->controller,
-- 
1.8.3.2

