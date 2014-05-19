Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932133AbaESNlh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 09:41:37 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:39553 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754024AbaESNle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 09:41:34 -0400
From: George Cherian <george.cherian@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
CC: <gregkh@linuxfoundation.org>, <balbi@ti.com>, <zonque@gmail.com>,
        <b-liu@ti.com>, George Cherian <george.cherian@ti.com>
Subject: [PATCH v4 4/6] usb: musb: core: Convert the musb_platform_reset to have a return value.
Date: Mon, 19 May 2014 19:09:34 +0530
Message-ID: <1400506776-2816-5-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1400506776-2816-1-git-send-email-george.cherian@ti.com>
References: <1400506776-2816-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently musb_platform_reset() is only used by dsps.
In case of BABBLE interrupt for other platforms the  musb_platform_reset()
is a NOP. In such situations no need to re-initialize the endpoints.
Also in the latest silicon revision of AM335x, we do have a babble recovery
mechanism without resetting the IP block. In preperation to add that support
its better to have a rest_done return for  musb_platform_reset().

Signed-off-by: George Cherian <george.cherian@ti.com>
---
 drivers/usb/musb/musb_core.c | 38 +++++++++++++++++++++-----------------
 drivers/usb/musb/musb_core.h | 10 ++++++----
 drivers/usb/musb/musb_dsps.c |  3 ++-
 3 files changed, 29 insertions(+), 22 deletions(-)

diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
index 8920b80..1b0b85d 100644
--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -1755,28 +1755,32 @@ static void musb_irq_work(struct work_struct *data)
 static void musb_recover_work(struct work_struct *data)
 {
 	struct musb *musb = container_of(data, struct musb, recover_work.work);
-	int status;
+	int status, ret;
 
-	musb_platform_reset(musb);
+	ret  = musb_platform_reset(musb);
+	if (ret  < 0)
+		return;
 
-	usb_phy_vbus_off(musb->xceiv);
-	usleep_range(100, 200);
+	if (!ret) {
+		usb_phy_vbus_off(musb->xceiv);
+		usleep_range(100, 200);
 
-	usb_phy_vbus_on(musb->xceiv);
-	usleep_range(100, 200);
+		usb_phy_vbus_on(musb->xceiv);
+		usleep_range(100, 200);
 
-	/*
-	 * When a babble condition occurs, the musb controller removes the
-	 * session bit and the endpoint config is lost.
-	 */
-	if (musb->dyn_fifo)
-		status = ep_config_from_table(musb);
-	else
-		status = ep_config_from_hw(musb);
+		/*
+		 * When a babble condition occurs, the musb controller
+		 * removes the session bit and the endpoint config is lost.
+		 */
+		if (musb->dyn_fifo)
+			status = ep_config_from_table(musb);
+		else
+			status = ep_config_from_hw(musb);
 
-	/* start the session again */
-	if (status == 0)
-		musb_start(musb);
+		/* start the session again */
+		if (status == 0)
+			musb_start(musb);
+	}
 }
 
 /* --------------------------------------------------------------------------
diff --git a/drivers/usb/musb/musb_core.h b/drivers/usb/musb/musb_core.h
index 423cd00..3ccb428 100644
--- a/drivers/usb/musb/musb_core.h
+++ b/drivers/usb/musb/musb_core.h
@@ -192,7 +192,7 @@ struct musb_platform_ops {
 
 	int	(*set_mode)(struct musb *musb, u8 mode);
 	void	(*try_idle)(struct musb *musb, unsigned long timeout);
-	void	(*reset)(struct musb *musb);
+	int	(*reset)(struct musb *musb);
 
 	int	(*vbus_status)(struct musb *musb);
 	void	(*set_vbus)(struct musb *musb, int on);
@@ -554,10 +554,12 @@ static inline void musb_platform_try_idle(struct musb *musb,
 		musb->ops->try_idle(musb, timeout);
 }
 
-static inline void musb_platform_reset(struct musb *musb)
+static inline int  musb_platform_reset(struct musb *musb)
 {
-	if (musb->ops->reset)
-		musb->ops->reset(musb);
+	if (!musb->ops->reset)
+		return -EINVAL;
+
+	return musb->ops->reset(musb);
 }
 
 static inline int musb_platform_get_vbus_status(struct musb *musb)
diff --git a/drivers/usb/musb/musb_dsps.c b/drivers/usb/musb/musb_dsps.c
index 74c4193..f6f3087 100644
--- a/drivers/usb/musb/musb_dsps.c
+++ b/drivers/usb/musb/musb_dsps.c
@@ -536,7 +536,7 @@ static int dsps_musb_set_mode(struct musb *musb, u8 mode)
 	return 0;
 }
 
-static void dsps_musb_reset(struct musb *musb)
+static int dsps_musb_reset(struct musb *musb)
 {
 	struct device *dev = musb->controller;
 	struct dsps_glue *glue = dev_get_drvdata(dev->parent);
@@ -548,6 +548,7 @@ static void dsps_musb_reset(struct musb *musb)
 	usleep_range(100, 200);
 	usb_phy_init(musb->xceiv);
 
+	return 0;
 }
 
 static struct musb_platform_ops dsps_ops = {
-- 
1.8.3.1

