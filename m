Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044AbaEVGbj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 02:31:39 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:47158 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751417AbaEVGbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 02:31:35 -0400
From: George Cherian <george.cherian@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
CC: <gregkh@linuxfoundation.org>, <balbi@ti.com>, <zonque@gmail.com>,
        <b-liu@ti.com>, George Cherian <george.cherian@ti.com>
Subject: [PATCH v5 5/6] usb: musb: dsps: Add the sw_babble_control()
Date: Thu, 22 May 2014 11:59:40 +0530
Message-ID: <1400740181-31213-6-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1400740181-31213-1-git-send-email-george.cherian@ti.com>
References: <1400740181-31213-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add sw_babble_control() logic to differentiate between transient
babble and real babble condition. Also add the SW babble control
register definitions.

Babble control register logic is implemented in the latest
revision of AM335x.

Signed-off-by: George Cherian <george.cherian@ti.com>
---
 drivers/usb/musb/musb_dsps.c | 50 ++++++++++++++++++++++++++++++++++++++++++++
 drivers/usb/musb/musb_regs.h |  7 +++++++
 2 files changed, 57 insertions(+)

diff --git a/drivers/usb/musb/musb_dsps.c b/drivers/usb/musb/musb_dsps.c
index f6f3087..868caf8 100644
--- a/drivers/usb/musb/musb_dsps.c
+++ b/drivers/usb/musb/musb_dsps.c
@@ -536,6 +536,56 @@ static int dsps_musb_set_mode(struct musb *musb, u8 mode)
 	return 0;
 }
 
+static int sw_babble_control(struct musb *musb)
+{
+	int timeout = 10;
+	u8 babble_ctl, session_restart = 0;
+
+	babble_ctl = dsps_readb(musb->mregs, MUSB_BABBLE_CTL);
+	dev_dbg(musb->controller, "babble: MUSB_BABBLE_CTL value %x\n",
+		babble_ctl);
+	/*
+	 * check line monitor flag to check whether babble is
+	 * due to noise
+	 */
+	dev_dbg(musb->controller, "STUCK_J is %s\n",
+		babble_ctl & MUSB_BABBLE_STUCK_J ? "set" : "reset");
+
+	if (babble_ctl & MUSB_BABBLE_STUCK_J) {
+		/*
+		 * babble is due to noise, then set transmit idle (d7 bit)
+		 * to resume normal operation
+		 */
+		babble_ctl = dsps_readb(musb->mregs, MUSB_BABBLE_CTL);
+		babble_ctl |= MUSB_BABBLE_FORCE_TXIDLE;
+		dsps_writeb(musb->mregs, MUSB_BABBLE_CTL, babble_ctl);
+
+		/* wait till line monitor flag cleared */
+		dev_dbg(musb->controller, "Set TXIDLE, wait J to clear\n");
+		do {
+			babble_ctl = dsps_readb(musb->mregs, MUSB_BABBLE_CTL);
+			udelay(1);
+		} while ((babble_ctl & MUSB_BABBLE_STUCK_J) && timeout--);
+
+		/* check whether stuck_at_j bit cleared */
+		if (babble_ctl & MUSB_BABBLE_STUCK_J) {
+			/*
+			 * real babble condition is occured
+			 * restart the controller to start the
+			 * session again
+			 */
+			dev_dbg(musb->controller, "J not cleared, misc (%x)\n",
+				babble_ctl);
+			session_restart = 1;
+		}
+
+	} else {
+		session_restart = 1;
+	}
+
+	return session_restart;
+}
+
 static int dsps_musb_reset(struct musb *musb)
 {
 	struct device *dev = musb->controller;
diff --git a/drivers/usb/musb/musb_regs.h b/drivers/usb/musb/musb_regs.h
index 03f2655..b9bcda5 100644
--- a/drivers/usb/musb/musb_regs.h
+++ b/drivers/usb/musb/musb_regs.h
@@ -72,6 +72,12 @@
 #define MUSB_DEVCTL_HR		0x02
 #define MUSB_DEVCTL_SESSION	0x01
 
+/* BABBLE_CTL */
+#define MUSB_BABBLE_FORCE_TXIDLE	0x80
+#define MUSB_BABBLE_SW_SESSION_CTRL	0x40
+#define MUSB_BABBLE_STUCK_J		0x20
+#define MUSB_BABBLE_RCV_DISABLE		0x04
+
 /* MUSB ULPI VBUSCONTROL */
 #define MUSB_ULPI_USE_EXTVBUS	0x01
 #define MUSB_ULPI_USE_EXTVBUSIND 0x02
@@ -246,6 +252,7 @@
  */
 
 #define MUSB_DEVCTL		0x60	/* 8 bit */
+#define MUSB_BABBLE_CTL		0x61	/* 8 bit */
 
 /* These are always controlled through the INDEX register */
 #define MUSB_TXFIFOSZ		0x62	/* 8-bit (see masks) */
-- 
1.8.3.1

