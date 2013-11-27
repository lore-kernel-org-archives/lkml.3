Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758937Ab3K0BAc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:00:32 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39639 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758835Ab3K0A7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:59:49 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 3.12 109/116] usb: musb: dsps: redo the otg timer
Date: Tue, 26 Nov 2013 16:58:02 -0800
Message-Id: <20131127005744.450248290@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005736.915454872@linuxfoundation.org>
References: <20131127005736.915454872@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

commit 0f901c980110cd69b63670096465b35377e73b1c upstream.

According to the comments, we rely on the OTG timer because the core
does not expose some important OTG details. So far this is all I
know. After playing with OTG I stumbled over a problem:
musb is recognized as a B-device without a problem. Whenever a cable is
plugged, the VBUS rises, musb recognizes this as a starting session,
sets the MUSB_DEVCTL_SESSION bit by itself and a RESET interrupt occurs,
the session starts. Good.
After a disconnect, the timer is started and re-starts itself because
it remains in B_IDLE with the BDEVICE set. I didn't figure the the
reason or the need for it. Nothing changes here except for OTG state
from B to A device if the BDEVICE bit disappears. This doesn't make much
sense to me because nothing happens after this. _IF_ we receive an
interrupt before the state change then we may act on wrong condition.
Plugging a B-device (and letting MUSB act as host) doesn't work here.
The reason seems to be that the MUSB tries to start a session, it fails
and then it removes the bit. So we never start as a host.

This patch sets the MUSB_DEVCTL_SESSION bit in the IDLE state so musb
can try to establish a session as host. After the bit is set, musb tries
to start a session and if it fails it clears the bit. Therefore it will
try over and over again until a session either as host or as device is
established.

The readout of the MUSB_DEVCTL register after the removal the
MUSB_DEVCTL_SESSION (in A_WAIT_BCON) has been removed because it did not
contain the BDEVICE bit set (in the second read) leading to A_IDLE. After
plugging a host musb assumed that it is also a host and complained about
a missing reset. However a third read of the register has has the BDEVICE
bit set so it seems that it is not stable.
This mostly what da8xx.c is doing except that we set the timer also
after A_WAIT_BCON so the session bit can be triggered.

Whit this change I was able to keep am335x-evm in OTG mode and plug in
either a HOST or a DEVICE and in a random order and the device was
recognized.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/musb/musb_dsps.c |   20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

--- a/drivers/usb/musb/musb_dsps.c
+++ b/drivers/usb/musb/musb_dsps.c
@@ -173,6 +173,7 @@ static void otg_timer(unsigned long _mus
 	const struct dsps_musb_wrapper *wrp = glue->wrp;
 	u8 devctl;
 	unsigned long flags;
+	int skip_session = 0;
 
 	/*
 	 * We poll because DSPS IP's won't expose several OTG-critical
@@ -185,10 +186,12 @@ static void otg_timer(unsigned long _mus
 	spin_lock_irqsave(&musb->lock, flags);
 	switch (musb->xceiv->state) {
 	case OTG_STATE_A_WAIT_BCON:
-		devctl &= ~MUSB_DEVCTL_SESSION;
-		dsps_writeb(musb->mregs, MUSB_DEVCTL, devctl);
+		dsps_writeb(musb->mregs, MUSB_DEVCTL, 0);
+		skip_session = 1;
+		/* fall */
 
-		devctl = dsps_readb(musb->mregs, MUSB_DEVCTL);
+	case OTG_STATE_A_IDLE:
+	case OTG_STATE_B_IDLE:
 		if (devctl & MUSB_DEVCTL_BDEVICE) {
 			musb->xceiv->state = OTG_STATE_B_IDLE;
 			MUSB_DEV_MODE(musb);
@@ -196,20 +199,15 @@ static void otg_timer(unsigned long _mus
 			musb->xceiv->state = OTG_STATE_A_IDLE;
 			MUSB_HST_MODE(musb);
 		}
+		if (!(devctl & MUSB_DEVCTL_SESSION) && !skip_session)
+			dsps_writeb(mregs, MUSB_DEVCTL, MUSB_DEVCTL_SESSION);
+		mod_timer(&glue->timer, jiffies + wrp->poll_seconds * HZ);
 		break;
 	case OTG_STATE_A_WAIT_VFALL:
 		musb->xceiv->state = OTG_STATE_A_WAIT_VRISE;
 		dsps_writel(musb->ctrl_base, wrp->coreintr_set,
 			    MUSB_INTR_VBUSERROR << wrp->usb_shift);
 		break;
-	case OTG_STATE_B_IDLE:
-		devctl = dsps_readb(mregs, MUSB_DEVCTL);
-		if (devctl & MUSB_DEVCTL_BDEVICE)
-			mod_timer(&glue->timer,
-					jiffies + wrp->poll_seconds * HZ);
-		else
-			musb->xceiv->state = OTG_STATE_A_IDLE;
-		break;
 	default:
 		break;
 	}


