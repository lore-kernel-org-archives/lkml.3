Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933253AbaKLBcw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:32:52 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59432 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933183AbaKLBcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:32:48 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 3.17 218/319] usb: musb: dsps: start OTG timer on resume again
Date: Wed, 12 Nov 2014 10:15:56 +0900
Message-Id: <20141112011028.853475809@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

commit 53185b3a441a6cc9bb3f57e924342d249138dcd6 upstream.

Commit 468bcc2a2ca ("usb: musb: dsps: kill OTG timer on suspend") stopped
the timer in suspend path but forgot the re-enable it in the resume
path. This patch fixes the behaviour.

Fixes 468bcc2a2ca "usb: musb: dsps: kill OTG timer on suspend"
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/musb/musb_dsps.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/musb/musb_dsps.c
+++ b/drivers/usb/musb/musb_dsps.c
@@ -896,7 +896,9 @@ static int dsps_resume(struct device *de
 	dsps_writel(mbase, wrp->mode, glue->context.mode);
 	dsps_writel(mbase, wrp->tx_mode, glue->context.tx_mode);
 	dsps_writel(mbase, wrp->rx_mode, glue->context.rx_mode);
-	setup_timer(&glue->timer, otg_timer, (unsigned long) musb);
+	if (musb->xceiv->state == OTG_STATE_B_IDLE &&
+	    musb->port_mode == MUSB_PORT_MODE_DUAL_ROLE)
+		mod_timer(&glue->timer, jiffies + wrp->poll_seconds * HZ);
 
 	return 0;
 }


