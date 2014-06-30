Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756450AbaF3MMY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:12:24 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:52001 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753465AbaF3LxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 07:53:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "K. Y. Srinivasan" <kys@microsoft.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 066/181] Drivers: hv: balloon: Ensure pressure reports are posted regularly
Date: Mon, 30 Jun 2014 13:51:27 +0200
Message-Id: <c609b95e06fd802d6172cc6ac7fd7275bda8eab4.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "K. Y. Srinivasan" <kys@microsoft.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit ae339336dc950b9b05e7ccd3565dd3e8781c06d9 upstream.

The current code posts periodic memory pressure status from a dedicated thread.
Under some conditions, especially when we are releasing a lot of memory into
the guest, we may not send timely pressure reports back to the host. Fix this
issue by reporting pressure in all contexts that can be active in this driver.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/hv/hv_balloon.c | 29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

diff --git a/drivers/hv/hv_balloon.c b/drivers/hv/hv_balloon.c
index 7e17a5495e02..393fd8a98735 100644
--- a/drivers/hv/hv_balloon.c
+++ b/drivers/hv/hv_balloon.c
@@ -19,6 +19,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/kernel.h>
+#include <linux/jiffies.h>
 #include <linux/mman.h>
 #include <linux/delay.h>
 #include <linux/init.h>
@@ -459,6 +460,11 @@ static bool do_hot_add;
  */
 static uint pressure_report_delay = 45;
 
+/*
+ * The last time we posted a pressure report to host.
+ */
+static unsigned long last_post_time;
+
 module_param(hot_add, bool, (S_IRUGO | S_IWUSR));
 MODULE_PARM_DESC(hot_add, "If set attempt memory hot_add");
 
@@ -542,6 +548,7 @@ struct hv_dynmem_device {
 
 static struct hv_dynmem_device dm_device;
 
+static void post_status(struct hv_dynmem_device *dm);
 #ifdef CONFIG_MEMORY_HOTPLUG
 
 static void hv_bring_pgs_online(unsigned long start_pfn, unsigned long size)
@@ -612,7 +619,7 @@ static void hv_mem_hot_add(unsigned long start, unsigned long size,
 		 * have not been "onlined" within the allowed time.
 		 */
 		wait_for_completion_timeout(&dm_device.ol_waitevent, 5*HZ);
-
+		post_status(&dm_device);
 	}
 
 	return;
@@ -951,11 +958,17 @@ static void post_status(struct hv_dynmem_device *dm)
 {
 	struct dm_status status;
 	struct sysinfo val;
+	unsigned long now = jiffies;
+	unsigned long last_post = last_post_time;
 
 	if (pressure_report_delay > 0) {
 		--pressure_report_delay;
 		return;
 	}
+
+	if (!time_after(now, (last_post_time + HZ)))
+		return;
+
 	si_meminfo(&val);
 	memset(&status, 0, sizeof(struct dm_status));
 	status.hdr.type = DM_STATUS_REPORT;
@@ -983,6 +996,14 @@ static void post_status(struct hv_dynmem_device *dm)
 	if (status.hdr.trans_id != atomic_read(&trans_id))
 		return;
 
+	/*
+	 * If the last post time that we sampled has changed,
+	 * we have raced, don't post the status.
+	 */
+	if (last_post != last_post_time)
+		return;
+
+	last_post_time = jiffies;
 	vmbus_sendpacket(dm->dev->channel, &status,
 				sizeof(struct dm_status),
 				(unsigned long)NULL,
@@ -1117,7 +1138,7 @@ static void balloon_up(struct work_struct *dummy)
 
 			if (ret == -EAGAIN)
 				msleep(20);
-
+			post_status(&dm_device);
 		} while (ret == -EAGAIN);
 
 		if (ret) {
@@ -1144,8 +1165,10 @@ static void balloon_down(struct hv_dynmem_device *dm,
 	struct dm_unballoon_response resp;
 	int i;
 
-	for (i = 0; i < range_count; i++)
+	for (i = 0; i < range_count; i++) {
 		free_balloon_pages(dm, &range_array[i]);
+		post_status(&dm_device);
+	}
 
 	if (req->more_pages == 1)
 		return;
-- 
2.0.0

