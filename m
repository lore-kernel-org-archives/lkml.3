Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966081Ab3E2NHN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 09:07:13 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:59134 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966065Ab3E2NHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 09:07:10 -0400
From: Ravi Babu <ravibabu@ti.com>
To: <linux-usb@vger.kernel.org>
CC: <balbi@ti.com>, <linux-kernel@vger.kernel.org>,
        Ravi Babu <ravibabu@ti.com>
Subject: [PATCH v1 1/3] usb: musb: core: added musb_restart() API to handle babble condition
Date: Wed, 29 May 2013 18:37:02 +0530
Message-ID: <1369832824-29071-2-git-send-email-ravibabu@ti.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1369832824-29071-1-git-send-email-ravibabu@ti.com>
References: <1369832824-29071-1-git-send-email-ravibabu@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added musb_restart() API, used for restart of the musb controller by
the glue layer, when there is babble condition occured on the bus.

During babble condition, the musb controller will remove the session
and no longer in host-mode. As part of recovery this API can be used
to restart the musb controller.

Signed-off-by: Ravi Babu <ravibabu@ti.com>
---
 drivers/usb/musb/musb_core.c |   24 ++++++++++++++++++++++++
 drivers/usb/musb/musb_core.h |    1 +
 2 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
index 37a261a..ab6fa39 100644
--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -1373,6 +1373,30 @@ static int ep_config_from_hw(struct musb *musb)
 	return 0;
 }
 
+/*
+ * musb_restart - restarts musb controller
+ * @param musb the controller
+ */
+int musb_restart(struct musb *musb)
+{
+	int status = 0;
+
+	/* during babble condition the musb controller removes the
+	 * session bit and the fifo table initialized value get changed
+	 */
+	if (musb->dyn_fifo)
+		status = ep_config_from_table(musb);
+	else
+		status = ep_config_from_hw(musb);
+
+	/* starts session */
+	if (!status)
+		musb_start(musb);
+
+	return status;
+}
+EXPORT_SYMBOL_GPL(musb_restart);
+
 enum { MUSB_CONTROLLER_MHDRC, MUSB_CONTROLLER_HDRC, };
 
 /* Initialize MUSB (M)HDRC part of the USB hardware subsystem;
diff --git a/drivers/usb/musb/musb_core.h b/drivers/usb/musb/musb_core.h
index 7fb4819..f96e899 100644
--- a/drivers/usb/musb/musb_core.h
+++ b/drivers/usb/musb/musb_core.h
@@ -522,6 +522,7 @@ extern const char musb_driver_name[];
 
 extern void musb_start(struct musb *musb);
 extern void musb_stop(struct musb *musb);
+extern int musb_restart(struct musb *musb);
 
 extern void musb_write_fifo(struct musb_hw_ep *ep, u16 len, const u8 *src);
 extern void musb_read_fifo(struct musb_hw_ep *ep, u16 len, u8 *dst);
-- 
1.7.0.4

