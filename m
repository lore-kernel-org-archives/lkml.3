Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342AbaKKLLD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:11:03 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57712 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754287AbaKKLK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:10:58 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Felipe Balbi <balbi@ti.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 122/170] usb: musb: dsps: start OTG timer on resume again
Date: Tue, 11 Nov 2014 11:08:01 +0000
Message-Id: <1415704129-12709-123-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

commit 53185b3a441a6cc9bb3f57e924342d249138dcd6 upstream.

Commit 468bcc2a2ca ("usb: musb: dsps: kill OTG timer on suspend") stopped
the timer in suspend path but forgot the re-enable it in the resume
path. This patch fixes the behaviour.

Fixes 468bcc2a2ca "usb: musb: dsps: kill OTG timer on suspend"
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/musb/musb_dsps.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/musb/musb_dsps.c b/drivers/usb/musb/musb_dsps.c
index 6983e805147b..302968bf592e 100644
--- a/drivers/usb/musb/musb_dsps.c
+++ b/drivers/usb/musb/musb_dsps.c
@@ -806,7 +806,9 @@ static int dsps_resume(struct device *dev)
 	dsps_writel(mbase, wrp->mode, glue->context.mode);
 	dsps_writel(mbase, wrp->tx_mode, glue->context.tx_mode);
 	dsps_writel(mbase, wrp->rx_mode, glue->context.rx_mode);
-	setup_timer(&glue->timer, otg_timer, (unsigned long) musb);
+	if (musb->xceiv->state == OTG_STATE_B_IDLE &&
+	    musb->port_mode == MUSB_PORT_MODE_DUAL_ROLE)
+		mod_timer(&glue->timer, jiffies + wrp->poll_seconds * HZ);
 
 	return 0;
 }
-- 
2.1.0

