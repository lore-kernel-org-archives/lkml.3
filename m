Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757202AbaIIQUa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 12:20:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50614 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753111AbaIIQU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 12:20:28 -0400
From: Takashi Iwai <tiwai@suse.de>
To: linux-pcmcia@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] pcmcia: Add pcmcia_request_threaded_irq()
Date: Tue,  9 Sep 2014 18:20:21 +0200
Message-Id: <1410279621-13513-1-git-send-email-tiwai@suse.de>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow pcmcia drivers to use threaded irq handlers.  The existing
pcmcia_request_irq() helper is calling the new function just with
NULL thread_fn.

Signed-off-by: Takashi Iwai <tiwai@suse.de>
---

The threaded irq will be used by the rewrite of snd-vxpocket driver.

 drivers/pcmcia/pcmcia_resource.c | 11 ++++++-----
 include/pcmcia/ds.h              |  7 +++++--
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/pcmcia/pcmcia_resource.c b/drivers/pcmcia/pcmcia_resource.c
index e8c19def1b0f..5c2039125aff 100644
--- a/drivers/pcmcia/pcmcia_resource.c
+++ b/drivers/pcmcia/pcmcia_resource.c
@@ -695,22 +695,23 @@ EXPORT_SYMBOL(pcmcia_request_io);
  * call free_irq() themselfves, too. Also, only %IRQF_SHARED capable IRQ
  * handlers are allowed.
  */
-int __must_check pcmcia_request_irq(struct pcmcia_device *p_dev,
-				    irq_handler_t handler)
+int __must_check pcmcia_request_threaded_irq(struct pcmcia_device *p_dev,
+					     irq_handler_t handler,
+					     irq_handler_t thread_fn)
 {
 	int ret;
 
 	if (!p_dev->irq)
 		return -EINVAL;
 
-	ret = request_irq(p_dev->irq, handler, IRQF_SHARED,
-			p_dev->devname, p_dev->priv);
+	ret = request_threaded_irq(p_dev->irq, handler, thread_fn, IRQF_SHARED,
+				   p_dev->devname, p_dev->priv);
 	if (!ret)
 		p_dev->_irq = 1;
 
 	return ret;
 }
-EXPORT_SYMBOL(pcmcia_request_irq);
+EXPORT_SYMBOL(pcmcia_request_threaded_irq);
 
 
 /**
diff --git a/include/pcmcia/ds.h b/include/pcmcia/ds.h
index 2d56e428506c..6ff5524bec12 100644
--- a/include/pcmcia/ds.h
+++ b/include/pcmcia/ds.h
@@ -216,8 +216,11 @@ pcmcia_request_exclusive_irq(struct pcmcia_device *p_dev,
 	return __pcmcia_request_exclusive_irq(p_dev, handler);
 }
 
-int __must_check pcmcia_request_irq(struct pcmcia_device *p_dev,
-				irq_handler_t handler);
+int __must_check pcmcia_request_threaded_irq(struct pcmcia_device *p_dev,
+					     irq_handler_t handler,
+					     irq_handler_t thread_fn);
+#define pcmcia_request_irq(pdev, handler) \
+	pcmcia_request_threaded_irq(pdev, handler, NULL)
 
 int pcmcia_enable_device(struct pcmcia_device *p_dev);
 
-- 
2.1.0

