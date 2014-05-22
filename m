Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751970AbaEVGbe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 02:31:34 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:39634 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbaEVGbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 02:31:32 -0400
From: George Cherian <george.cherian@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
CC: <gregkh@linuxfoundation.org>, <balbi@ti.com>, <zonque@gmail.com>,
        <b-liu@ti.com>, George Cherian <george.cherian@ti.com>
Subject: [PATCH v5 4/6] usb: musb: core: Convert the musb_platform_reset to have a return value.
Date: Thu, 22 May 2014 11:59:39 +0530
Message-ID: <1400740181-31213-5-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1400740181-31213-1-git-send-email-george.cherian@ti.com>
References: <1400740181-31213-1-git-send-email-george.cherian@ti.com>
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
 drivers/usb/musb/musb_core.c | 10 ++++++----
 drivers/usb/musb/musb_core.h | 10 ++++++----
 drivers/usb/musb/musb_dsps.c |  3 ++-
 3 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
index 8920b80..7c6836cc 100644
--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -1755,9 +1755,11 @@ static void musb_irq_work(struct work_struct *data)
 static void musb_recover_work(struct work_struct *data)
 {
 	struct musb *musb = container_of(data, struct musb, recover_work.work);
-	int status;
+	int status, ret;
 
-	musb_platform_reset(musb);
+	ret  = musb_platform_reset(musb);
+	if (ret)
+		return;
 
 	usb_phy_vbus_off(musb->xceiv);
 	usleep_range(100, 200);
@@ -1766,8 +1768,8 @@ static void musb_recover_work(struct work_struct *data)
 	usleep_range(100, 200);
 
 	/*
-	 * When a babble condition occurs, the musb controller removes the
-	 * session bit and the endpoint config is lost.
+	 * When a babble condition occurs, the musb controller
+	 * removes the session bit and the endpoint config is lost.
 	 */
 	if (musb->dyn_fifo)
 		status = ep_config_from_table(musb);
diff --git a/drivers/usb/musb/musb_core.h b/drivers/usb/musb/musb_core.h
index 9241025..414e57a 100644
--- a/drivers/usb/musb/musb_core.h
+++ b/drivers/usb/musb/musb_core.h
@@ -192,7 +192,7 @@ struct musb_platform_ops {
 
 	int	(*set_mode)(struct musb *musb, u8 mode);
 	void	(*try_idle)(struct musb *musb, unsigned long timeout);
-	void	(*reset)(struct musb *musb);
+	int	(*reset)(struct musb *musb);
 
 	int	(*vbus_status)(struct musb *musb);
 	void	(*set_vbus)(struct musb *musb, int on);
@@ -555,10 +555,12 @@ static inline void musb_platform_try_idle(struct musb *musb,
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

