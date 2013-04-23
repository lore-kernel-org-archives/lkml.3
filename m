Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916Ab3DWX1z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 19:27:55 -0400
Received: from mail.ispras.ru ([83.149.199.45]:51259 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752911Ab3DWX1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 19:27:53 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Henk de Groot <pe1dnn@amsat.org>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: [PATCH] staging: wlags49_h2: fix error handling in pcmcia probe function
Date: Tue, 23 Apr 2013 19:27:39 -0400
Message-Id: <1366759659-16047-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

wl_adapter_attach() ignores some important issues
such as register_netdev() failure. The patch fixes it.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/staging/wlags49_h2/wl_cs.c |   13 ++++++++-----
 drivers/staging/wlags49_h2/wl_cs.h |    4 ++--
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/wlags49_h2/wl_cs.c b/drivers/staging/wlags49_h2/wl_cs.c
index 7c7c77f..f9e5fd3 100644
--- a/drivers/staging/wlags49_h2/wl_cs.c
+++ b/drivers/staging/wlags49_h2/wl_cs.c
@@ -133,6 +133,7 @@ static int wl_adapter_attach(struct pcmcia_device *link)
 {
 	struct net_device   *dev;
 	struct wl_private   *lp;
+	int ret;
 	/*--------------------------------------------------------------------*/
 
 	DBG_FUNC("wl_adapter_attach");
@@ -154,10 +155,12 @@ static int wl_adapter_attach(struct pcmcia_device *link)
 	lp = wl_priv(dev);
 	lp->link = link;
 
-	wl_adapter_insert(link);
+	ret = wl_adapter_insert(link);
+	if (ret != 0)
+		wl_device_dealloc(dev);
 
 	DBG_LEAVE(DbgInfo);
-	return 0;
+	return ret;
 } /* wl_adapter_attach */
 /*============================================================================*/
 
@@ -224,7 +227,7 @@ static int wl_adapter_resume(struct pcmcia_device *link)
 	return 0;
 } /* wl_adapter_resume */
 
-void wl_adapter_insert(struct pcmcia_device *link)
+int wl_adapter_insert(struct pcmcia_device *link)
 {
 	struct net_device *dev;
 	int ret;
@@ -267,13 +270,13 @@ void wl_adapter_insert(struct pcmcia_device *link)
 		" %pM\n", dev->name, dev->base_addr, dev->irq, dev->dev_addr);
 
 	DBG_LEAVE(DbgInfo);
-	return;
+	return 0;
 
 failed:
 	wl_adapter_release(link);
 
 	DBG_LEAVE(DbgInfo);
-	return;
+	return ret;
 } /* wl_adapter_insert */
 /*============================================================================*/
 
diff --git a/drivers/staging/wlags49_h2/wl_cs.h b/drivers/staging/wlags49_h2/wl_cs.h
index a7ab579..081cc6f 100644
--- a/drivers/staging/wlags49_h2/wl_cs.h
+++ b/drivers/staging/wlags49_h2/wl_cs.h
@@ -65,10 +65,10 @@
 
 
 /*******************************************************************************
- *  function protoypes
+ *  function prototypes
  ******************************************************************************/
 
-void wl_adapter_insert(struct pcmcia_device *link);
+int wl_adapter_insert(struct pcmcia_device *link);
 
 void wl_adapter_release(struct pcmcia_device *link);
 
-- 
1.7.9.5

