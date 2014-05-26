Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047AbaEZJVy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 05:21:54 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:56637 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751882AbaEZJVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 05:21:52 -0400
From: George Cherian <george.cherian@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
CC: <gregkh@linuxfoundation.org>, <balbi@ti.com>, <zonque@gmail.com>,
        <b-liu@ti.com>, George Cherian <george.cherian@ti.com>
Subject: [PATCH v6 2/5] usb: musb: core: Convert babble recover work to delayed work
Date: Mon, 26 May 2014 14:50:09 +0530
Message-ID: <1401096012-6895-3-git-send-email-george.cherian@ti.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1401096012-6895-1-git-send-email-george.cherian@ti.com>
References: <1401096012-6895-1-git-send-email-george.cherian@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During babble condition both first disconnect of devices are
initiated. Make sure MUSB controller is reset and re-initialized
after all disconnects.

To acheive this schedule a delayed work for babble recovery.

While at that convert udelay to usleep_range.
Refer Documentation/timers/timers-howto.txt

Signed-off-by: George Cherian <george.cherian@ti.com>
---
 drivers/usb/musb/musb_core.c | 15 ++++++++-------
 drivers/usb/musb/musb_core.h |  2 +-
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
index 0ad9551..c0ce09f 100644
--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -850,7 +850,8 @@ b_host:
 
 	/* handle babble condition */
 	if (int_usb & MUSB_INTR_BABBLE && is_host_active(musb))
-		schedule_work(&musb->recover_work);
+		schedule_delayed_work(&musb->recover_work,
+				      msecs_to_jiffies(100));
 
 #if 0
 /* REVISIT ... this would be for multiplexing periodic endpoints, or
@@ -1751,16 +1752,16 @@ static void musb_irq_work(struct work_struct *data)
 /* Recover from babble interrupt conditions */
 static void musb_recover_work(struct work_struct *data)
 {
-	struct musb *musb = container_of(data, struct musb, recover_work);
+	struct musb *musb = container_of(data, struct musb, recover_work.work);
 	int status;
 
 	musb_platform_reset(musb);
 
 	usb_phy_vbus_off(musb->xceiv);
-	udelay(100);
+	usleep_range(100, 200);
 
 	usb_phy_vbus_on(musb->xceiv);
-	udelay(100);
+	usleep_range(100, 200);
 
 	/*
 	 * When a babble condition occurs, the musb controller removes the
@@ -1943,7 +1944,7 @@ musb_init_controller(struct device *dev, int nIrq, void __iomem *ctrl)
 
 	/* Init IRQ workqueue before request_irq */
 	INIT_WORK(&musb->irq_work, musb_irq_work);
-	INIT_WORK(&musb->recover_work, musb_recover_work);
+	INIT_DELAYED_WORK(&musb->recover_work, musb_recover_work);
 	INIT_DELAYED_WORK(&musb->deassert_reset_work, musb_deassert_reset);
 	INIT_DELAYED_WORK(&musb->finish_resume_work, musb_host_finish_resume);
 
@@ -2039,7 +2040,7 @@ fail4:
 
 fail3:
 	cancel_work_sync(&musb->irq_work);
-	cancel_work_sync(&musb->recover_work);
+	cancel_delayed_work_sync(&musb->recover_work);
 	cancel_delayed_work_sync(&musb->finish_resume_work);
 	cancel_delayed_work_sync(&musb->deassert_reset_work);
 	if (musb->dma_controller)
@@ -2105,7 +2106,7 @@ static int musb_remove(struct platform_device *pdev)
 		dma_controller_destroy(musb->dma_controller);
 
 	cancel_work_sync(&musb->irq_work);
-	cancel_work_sync(&musb->recover_work);
+	cancel_delayed_work_sync(&musb->recover_work);
 	cancel_delayed_work_sync(&musb->finish_resume_work);
 	cancel_delayed_work_sync(&musb->deassert_reset_work);
 	musb_free(musb);
diff --git a/drivers/usb/musb/musb_core.h b/drivers/usb/musb/musb_core.h
index d155a15..9241025 100644
--- a/drivers/usb/musb/musb_core.h
+++ b/drivers/usb/musb/musb_core.h
@@ -297,7 +297,7 @@ struct musb {
 
 	irqreturn_t		(*isr)(int, void *);
 	struct work_struct	irq_work;
-	struct work_struct	recover_work;
+	struct delayed_work	recover_work;
 	struct delayed_work	deassert_reset_work;
 	struct delayed_work	finish_resume_work;
 	u16			hwvers;
-- 
1.8.3.1

