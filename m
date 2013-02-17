Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753739Ab3BQVDK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 16:03:10 -0500
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:59327
	"EHLO p3plsmtps2ded03.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753221Ab3BQVDG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 16:03:06 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 3/3] Drivers: hv: balloon: Execute hot-add code in a separate context
Date: Sun, 17 Feb 2013 13:31:26 -0800
Message-Id: <1361136686-31020-3-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1361136686-31020-1-git-send-email-kys@microsoft.com>
References: <1361136655-30979-1-git-send-email-kys@microsoft.com>
 <1361136686-31020-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Execute the hot-add operation in a separate work context.
This allows us to decouple the pressure reporting activity from the
"hot-add" activity.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/hv/hv_balloon.c |   40 ++++++++++++++++++++++------------------
 1 files changed, 22 insertions(+), 18 deletions(-)

diff --git a/drivers/hv/hv_balloon.c b/drivers/hv/hv_balloon.c
index 860e176..225a1fe 100644
--- a/drivers/hv/hv_balloon.c
+++ b/drivers/hv/hv_balloon.c
@@ -417,6 +417,11 @@ struct balloon_state {
 	struct work_struct wrk;
 };
 
+struct hot_add_wrk {
+	union dm_mem_page_range ha_page_range;
+	struct work_struct wrk;
+};
+
 static bool hot_add;
 static bool do_hot_add;
 /*
@@ -470,6 +475,11 @@ struct hv_dynmem_device {
 	struct balloon_state balloon_wrk;
 
 	/*
+	 * State to execute the "hot-add" operation.
+	 */
+	struct hot_add_wrk ha_wrk;
+
+	/*
 	 * This thread handles hot-add
 	 * requests from the host as well as notifying
 	 * the host with regards to memory pressure in
@@ -487,7 +497,7 @@ struct hv_dynmem_device {
 
 static struct hv_dynmem_device dm_device;
 
-static void hot_add_req(struct hv_dynmem_device *dm, struct dm_hot_add *msg)
+static void hot_add_req(struct work_struct *dummy)
 {
 
 	struct dm_hot_add_response resp;
@@ -510,8 +520,8 @@ static void hot_add_req(struct hv_dynmem_device *dm, struct dm_hot_add *msg)
 	resp.page_count = 0;
 	resp.result = 0;
 
-	dm->state = DM_INITIALIZED;
-	vmbus_sendpacket(dm->dev->channel, &resp,
+	dm_device.state = DM_INITIALIZED;
+	vmbus_sendpacket(dm_device.dev->channel, &resp,
 			sizeof(struct dm_hot_add_response),
 			(unsigned long)NULL,
 			VM_PKT_DATA_INBAND, 0);
@@ -772,7 +782,6 @@ static int dm_thread_func(void *dm_dev)
 {
 	struct hv_dynmem_device *dm = dm_dev;
 	int t;
-	unsigned long  scan_start;
 
 	while (!kthread_should_stop()) {
 		t = wait_for_completion_timeout(&dm_device.config_event, 1*HZ);
@@ -784,19 +793,6 @@ static int dm_thread_func(void *dm_dev)
 		if (t == 0)
 			post_status(dm);
 
-		scan_start = jiffies;
-		switch (dm->state) {
-
-		case DM_HOT_ADD:
-			hot_add_req(dm, (struct dm_hot_add *)recv_buffer);
-			break;
-		default:
-			break;
-		}
-
-		if (!time_in_range(jiffies, scan_start, scan_start + HZ))
-			post_status(dm);
-
 	}
 
 	return 0;
@@ -870,6 +866,8 @@ static void balloon_onchannelcallback(void *context)
 	struct dm_header *dm_hdr;
 	struct hv_dynmem_device *dm = hv_get_drvdata(dev);
 	struct dm_balloon *bal_msg;
+	struct dm_hot_add *ha_msg;
+	union dm_mem_page_range *ha_pg_range;
 
 	memset(recv_buffer, 0, sizeof(recv_buffer));
 	vmbus_recvpacket(dev->channel, recv_buffer,
@@ -906,8 +904,13 @@ static void balloon_onchannelcallback(void *context)
 			break;
 
 		case DM_MEM_HOT_ADD_REQUEST:
+			if (dm->state == DM_HOT_ADD)
+				pr_warn("Currently hot-adding\n");
 			dm->state = DM_HOT_ADD;
-			complete(&dm->config_event);
+			ha_msg = (struct dm_hot_add *)recv_buffer;
+			ha_pg_range = &ha_msg->range;
+			dm_device.ha_wrk.ha_page_range = *ha_pg_range;
+			schedule_work(&dm_device.ha_wrk.wrk);
 			break;
 
 		case DM_INFO_MESSAGE:
@@ -951,6 +954,7 @@ static int balloon_probe(struct hv_device *dev,
 	init_completion(&dm_device.host_event);
 	init_completion(&dm_device.config_event);
 	INIT_WORK(&dm_device.balloon_wrk.wrk, balloon_up);
+	INIT_WORK(&dm_device.ha_wrk.wrk, hot_add_req);
 
 	dm_device.thread =
 		 kthread_run(dm_thread_func, &dm_device, "hv_balloon");
-- 
1.7.4.1

