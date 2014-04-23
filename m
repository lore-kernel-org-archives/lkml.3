Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757622AbaDWT6Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 15:58:16 -0400
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:58763
	"EHLO p3plsmtps2ded01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751182AbaDWT6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 15:58:13 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, stable@vger.kernel.org
Subject: [PATCH 1/1] Drivers: hv: balloon: Ensure pressure reports are posted regularly
Date: Wed, 23 Apr 2014 13:53:39 -0700
Message-Id: <1398286419-14872-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current code posts periodic memory pressure status from a dedicated thread.
Under some conditions, especially when we are releasing a lot of memory into
the guest, we may not send timely pressure reports back to the host. Fix this
issue by reporting pressure in all contexts that can be active in this driver.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Cc: stable@vger.kernel.org
---
 drivers/hv/hv_balloon.c |   29 ++++++++++++++++++++++++++---
 1 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/drivers/hv/hv_balloon.c b/drivers/hv/hv_balloon.c
index 7e6d78d..5e90c5d 100644
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
1.7.4.1

