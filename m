Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933782AbaGPMyZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 08:54:25 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:48742 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933721AbaGPMyW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 08:54:22 -0400
From: George Cherian <george.cherian@ti.com>
To: <linux-usb@vger.kernel.org>, <balbi@ti.com>, <b-liu@ti.com>
CC: <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        George Cherian <george.cherian@ti.com>
Subject: [PATCH v7 3/4] usb: musb: core: Convert the musb_platform_reset to have a return value.
Date: Wed, 16 Jul 2014 18:22:11 +0530
Message-ID: <1405515132-17618-4-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1405515132-17618-1-git-send-email-george.cherian@ti.com>
References: <1405515132-17618-1-git-send-email-george.cherian@ti.com>
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
Tested-by: Bin Liu <b-liu@ti.com>
---
 drivers/usb/musb/musb_core.c | 10 ++++++----
 drivers/usb/musb/musb_core.h | 10 ++++++----
 drivers/usb/musb/musb_dsps.c |  3 ++-
 3 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
index c0ce09f..b841ee0 100644
--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -1753,9 +1753,11 @@ static void musb_irq_work(struct work_struct *data)
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
@@ -1764,8 +1766,8 @@ static void musb_recover_work(struct work_struct *data)
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
index b29f59f..53a4351 100644
--- a/drivers/usb/musb/musb_dsps.c
+++ b/drivers/usb/musb/musb_dsps.c
@@ -544,7 +544,7 @@ static int dsps_musb_set_mode(struct musb *musb, u8 mode)
 	return 0;
 }
 
-static void dsps_musb_reset(struct musb *musb)
+static int dsps_musb_reset(struct musb *musb)
 {
 	struct device *dev = musb->controller;
 	struct dsps_glue *glue = dev_get_drvdata(dev->parent);
@@ -556,6 +556,7 @@ static void dsps_musb_reset(struct musb *musb)
 	usleep_range(100, 200);
 	usb_phy_init(musb->xceiv);
 
+	return 0;
 }
 
 static struct musb_platform_ops dsps_ops = {
-- 
1.8.3.1

