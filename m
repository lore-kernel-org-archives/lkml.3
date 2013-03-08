Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933583Ab3CHC1b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 21:27:31 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:45786 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933543Ab3CHC12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 21:27:28 -0500
From: Fabio Baltieri <fabio.baltieri@linaro.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, Fabio Baltieri <fabio.baltieri@linaro.org>
Subject: [PATCH v2 2/5] usb: musb: ux500: implement musb_set_vbus
Date: Fri,  8 Mar 2013 10:27:06 +0800
Message-Id: <1362709629-27238-3-git-send-email-fabio.baltieri@linaro.org>
X-Mailer: git-send-email 1.8.1.3
In-Reply-To: <1362709629-27238-1-git-send-email-fabio.baltieri@linaro.org>
References: <1362709629-27238-1-git-send-email-fabio.baltieri@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add ux500_musb_set_vbus() implementation for ux500.

This is based on the version originally developed inside ST-Ericsson.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
---
 drivers/usb/musb/ux500.c | 64 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/drivers/usb/musb/ux500.c b/drivers/usb/musb/ux500.c
index 13a3929..5b742ba 100644
--- a/drivers/usb/musb/ux500.c
+++ b/drivers/usb/musb/ux500.c
@@ -36,6 +36,68 @@ struct ux500_glue {
 };
 #define glue_to_musb(g)	platform_get_drvdata(g->musb)
 
+static void ux500_musb_set_vbus(struct musb *musb, int is_on)
+{
+	u8            devctl;
+	unsigned long timeout = jiffies + msecs_to_jiffies(1000);
+	/* HDRC controls CPEN, but beware current surges during device
+	 * connect.  They can trigger transient overcurrent conditions
+	 * that must be ignored.
+	 */
+
+	devctl = musb_readb(musb->mregs, MUSB_DEVCTL);
+
+	if (is_on) {
+		if (musb->xceiv->state == OTG_STATE_A_IDLE) {
+			/* start the session */
+			devctl |= MUSB_DEVCTL_SESSION;
+			musb_writeb(musb->mregs, MUSB_DEVCTL, devctl);
+			/*
+			 * Wait for the musb to set as A device to enable the
+			 * VBUS
+			 */
+			while (musb_readb(musb->mregs, MUSB_DEVCTL) & 0x80) {
+
+				if (time_after(jiffies, timeout)) {
+					dev_err(musb->controller,
+					"configured as A device timeout");
+					break;
+				}
+			}
+
+		} else {
+			musb->is_active = 1;
+			musb->xceiv->otg->default_a = 1;
+			musb->xceiv->state = OTG_STATE_A_WAIT_VRISE;
+			devctl |= MUSB_DEVCTL_SESSION;
+			MUSB_HST_MODE(musb);
+		}
+	} else {
+		musb->is_active = 0;
+
+		/* NOTE: we're skipping A_WAIT_VFALL -> A_IDLE and jumping
+		 * right to B_IDLE...
+		 */
+		musb->xceiv->otg->default_a = 0;
+		devctl &= ~MUSB_DEVCTL_SESSION;
+		MUSB_DEV_MODE(musb);
+	}
+	musb_writeb(musb->mregs, MUSB_DEVCTL, devctl);
+
+	/*
+	 * Devctl values will be updated after vbus goes below
+	 * session_valid. The time taken depends on the capacitance
+	 * on VBUS line. The max discharge time can be upto 1 sec
+	 * as per the spec. Typically on our platform, it is 200ms
+	 */
+	if (!is_on)
+		mdelay(200);
+
+	dev_dbg(musb->controller, "VBUS %s, devctl %02x\n",
+		otg_state_string(musb->xceiv->state),
+		musb_readb(musb->mregs, MUSB_DEVCTL));
+}
+
 static irqreturn_t ux500_musb_interrupt(int irq, void *__hci)
 {
 	unsigned long   flags;
@@ -79,6 +141,8 @@ static int ux500_musb_exit(struct musb *musb)
 static const struct musb_platform_ops ux500_ops = {
 	.init		= ux500_musb_init,
 	.exit		= ux500_musb_exit,
+
+	.set_vbus	= ux500_musb_set_vbus,
 };
 
 static int ux500_probe(struct platform_device *pdev)
-- 
1.8.1.3

