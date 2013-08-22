Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015Ab3HVQjo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 12:39:44 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:35958 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015Ab3HVQjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 12:39:42 -0400
From: Rupesh Gujare <rupesh.gujare@atmel.com>
To: <devel@linuxdriverproject.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gregkh@linuxfoundation.org>
Subject: [PATCH 4/4] staging: ozwpan: Create deferred work to destroy PD object.
Date: Thu, 22 Aug 2013 17:38:51 +0100
Message-ID: <1377189531-24950-4-git-send-email-rupesh.gujare@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1377189531-24950-1-git-send-email-rupesh.gujare@atmel.com>
References: <1377189531-24950-1-git-send-email-rupesh.gujare@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we call oz_pd_destroy() from softirq context, where we
try to destroy relevant data structures, as well we kill a tasklet
which always result in following kernel warning.

[12279.262194] Attempt to kill tasklet from interrupt
[12279.262202] Attempt to kill tasklet from interrupt

This patch defers deallocation of data structures to work queue.

Signed-off-by: Rupesh Gujare <rupesh.gujare@atmel.com>
---
 drivers/staging/ozwpan/ozpd.c |   28 +++++++++++++++++++++++-----
 drivers/staging/ozwpan/ozpd.h |    1 +
 2 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/ozwpan/ozpd.c b/drivers/staging/ozwpan/ozpd.c
index 2514d79..06004c8 100644
--- a/drivers/staging/ozwpan/ozpd.c
+++ b/drivers/staging/ozwpan/ozpd.c
@@ -204,18 +204,16 @@ struct oz_pd *oz_pd_alloc(const u8 *mac_addr)
 /*------------------------------------------------------------------------------
  * Context: softirq or process
  */
-void oz_pd_destroy(struct oz_pd *pd)
+void oz_pd_free(struct work_struct *work)
 {
 	struct list_head *e;
 	struct oz_tx_frame *f;
 	struct oz_isoc_stream *st;
 	struct oz_farewell *fwell;
+	struct oz_pd *pd;
 
 	oz_pd_dbg(pd, ON, "Destroying PD\n");
-	if (hrtimer_active(&pd->timeout))
-		hrtimer_cancel(&pd->timeout);
-	if (hrtimer_active(&pd->heartbeat))
-		hrtimer_cancel(&pd->heartbeat);
+	pd = container_of(work, struct oz_pd, workitem);
 	/*Disable timer tasklets*/
 	tasklet_kill(&pd->heartbeat_tasklet);
 	tasklet_kill(&pd->timeout_tasklet);
@@ -259,6 +257,26 @@ void oz_pd_destroy(struct oz_pd *pd)
 }
 
 /*------------------------------------------------------------------------------
+ * Context: softirq or Process
+ */
+void oz_pd_destroy(struct oz_pd *pd)
+{
+	int ret;
+
+	if (hrtimer_active(&pd->timeout))
+		hrtimer_cancel(&pd->timeout);
+	if (hrtimer_active(&pd->heartbeat))
+		hrtimer_cancel(&pd->heartbeat);
+
+	memset(&pd->workitem, 0, sizeof(pd->workitem));
+	INIT_WORK(&pd->workitem, oz_pd_free);
+	ret = schedule_work(&pd->workitem);
+
+	if (ret)
+		oz_pd_dbg(pd, ON, "failed to schedule workitem\n");
+}
+
+/*------------------------------------------------------------------------------
  * Context: softirq-serialized
  */
 int oz_services_start(struct oz_pd *pd, u16 apps, int resume)
diff --git a/drivers/staging/ozwpan/ozpd.h b/drivers/staging/ozwpan/ozpd.h
index 996ef65..12c7129 100644
--- a/drivers/staging/ozwpan/ozpd.h
+++ b/drivers/staging/ozwpan/ozpd.h
@@ -99,6 +99,7 @@ struct oz_pd {
 	u8      timeout_type;
 	struct tasklet_struct   heartbeat_tasklet;
 	struct tasklet_struct   timeout_tasklet;
+	struct work_struct workitem;
 };
 
 #define OZ_MAX_QUEUED_FRAMES	4
-- 
1.7.9.5

