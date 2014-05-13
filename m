Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759509AbaEMIfi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 04:35:38 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:45348 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759448AbaEMIeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 04:34:01 -0400
From: George Cherian <george.cherian@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <zonque@gmail.com>,
        George Cherian <george.cherian@ti.com>
Subject: [PATCH v3 5/5] usb: musb: dsps: Enable sw babble control for newer silicon
Date: Tue, 13 May 2014 14:01:45 +0530
Message-ID: <1399969905-3509-6-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1399969905-3509-1-git-send-email-george.cherian@ti.com>
References: <1399969905-3509-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Find whether we are running on newer silicon. The babble control
register reads 0x4 by default in newer silicon as opposed to 0
in old versions of AM335x. Based on this enable the sw babble
control logic.

Signed-off-by: George Cherian <george.cherian@ti.com>
---
 drivers/usb/musb/musb_dsps.c | 34 ++++++++++++++++++++++++++++------
 1 file changed, 28 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/musb/musb_dsps.c b/drivers/usb/musb/musb_dsps.c
index eb1985a..1ae6681 100644
--- a/drivers/usb/musb/musb_dsps.c
+++ b/drivers/usb/musb/musb_dsps.c
@@ -136,6 +136,7 @@ struct dsps_glue {
 	const struct dsps_musb_wrapper *wrp; /* wrapper register offsets */
 	struct timer_list timer;	/* otg_workaround timer */
 	unsigned long last_timer;    /* last timer data for each instance */
+	bool sw_babble_enabled;
 
 	struct dsps_context context;
 	struct debugfs_regset32 regset;
@@ -469,6 +470,16 @@ static int dsps_musb_init(struct musb *musb)
 	val &= ~(1 << wrp->otg_disable);
 	dsps_writel(musb->ctrl_base, wrp->phy_utmi, val);
 
+	/*
+	 *  Check whether the dsps version has babble control enabled.
+	 * In latest silicon revision the babble control logic is enabled.
+	 * If MUSB_BABBLE_CTL returns 0x4 then we have the babble control
+	 * logic enabled.
+	 */
+	val = dsps_readb(musb->mregs, MUSB_BABBLE_CTL);
+	if (val == MUSB_BABBLE_RCV_DISABLE)
+		glue->sw_babble_enabled = true;
+
 	ret = dsps_musb_dbg_init(musb, glue);
 	if (ret)
 		return ret;
@@ -591,14 +602,25 @@ static int dsps_musb_reset(struct musb *musb)
 	struct device *dev = musb->controller;
 	struct dsps_glue *glue = dev_get_drvdata(dev->parent);
 	const struct dsps_musb_wrapper *wrp = glue->wrp;
+	int session_restart = 0;
 
-	dsps_writel(musb->ctrl_base, wrp->control, (1 << wrp->reset));
-	usleep_range(100, 200);
-	usb_phy_shutdown(musb->xceiv);
-	usleep_range(100, 200);
-	usb_phy_init(musb->xceiv);
+	if (glue->sw_babble_enabled)
+		session_restart = sw_babble_control(musb);
+	/*
+	 * In case of new silicon version babble condition can be recovered
+	 * without resetting the MUSB. But for older silicon versions, MUSB
+	 * reset is needed
+	 */
+	if (session_restart || !glue->sw_babble_enabled) {
+		dsps_writel(musb->ctrl_base, wrp->control, (1 << wrp->reset));
+		usleep_range(100, 200);
+		usb_phy_shutdown(musb->xceiv);
+		usleep_range(100, 200);
+		usb_phy_init(musb->xceiv);
+		session_restart = 1;
+	}
 
-	return 0;
+	return !session_restart;
 }
 
 static struct musb_platform_ops dsps_ops = {
-- 
1.8.3.1

