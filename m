Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990AbaFXQUy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 12:20:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33102 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754304AbaFXPyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 11:54:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 3.14 47/68] Drivers: hv: balloon: Ensure pressure reports are posted regularly
Date: Tue, 24 Jun 2014 11:51:06 -0400
Message-Id: <20140624154726.061192069@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140624154723.907894814@linuxfoundation.org>
References: <20140624154723.907894814@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "K. Y. Srinivasan" <kys@microsoft.com>

commit ae339336dc950b9b05e7ccd3565dd3e8781c06d9 upstream.

The current code posts periodic memory pressure status from a dedicated thread.
Under some conditions, especially when we are releasing a lot of memory into
the guest, we may not send timely pressure reports back to the host. Fix this
issue by reporting pressure in all contexts that can be active in this driver.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hv/hv_balloon.c |   29 ++++++++++++++++++++++++++---
 1 file changed, 26 insertions(+), 3 deletions(-)

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
@@ -612,7 +619,7 @@ static void hv_mem_hot_add(unsigned long
 		 * have not been "onlined" within the allowed time.
 		 */
 		wait_for_completion_timeout(&dm_device.ol_waitevent, 5*HZ);
-
+		post_status(&dm_device);
 	}
 
 	return;
@@ -951,11 +958,17 @@ static void post_status(struct hv_dynmem
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
@@ -983,6 +996,14 @@ static void post_status(struct hv_dynmem
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
@@ -1117,7 +1138,7 @@ static void balloon_up(struct work_struc
 
 			if (ret == -EAGAIN)
 				msleep(20);
-
+			post_status(&dm_device);
 		} while (ret == -EAGAIN);
 
 		if (ret) {
@@ -1144,8 +1165,10 @@ static void balloon_down(struct hv_dynme
 	struct dm_unballoon_response resp;
 	int i;
 
-	for (i = 0; i < range_count; i++)
+	for (i = 0; i < range_count; i++) {
 		free_balloon_pages(dm, &range_array[i]);
+		post_status(&dm_device);
+	}
 
 	if (req->more_pages == 1)
 		return;


