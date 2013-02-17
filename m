Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753836Ab3BQVDL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 16:03:11 -0500
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:56642
	"EHLO p3plsmtps2ded01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753449Ab3BQVDG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 16:03:06 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 2/3] Drivers: hv: balloon: Execute balloon inflation in a separate context
Date: Sun, 17 Feb 2013 13:31:25 -0800
Message-Id: <1361136686-31020-2-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1361136686-31020-1-git-send-email-kys@microsoft.com>
References: <1361136655-30979-1-git-send-email-kys@microsoft.com>
 <1361136686-31020-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Execute the balloon inflation operation in a separate work context.
This allows us to decouple the pressure reporting activity from the
ballooning activity. Testing has shown that this decoupling makes the
guest more reponsive.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/hv/hv_balloon.c |   34 ++++++++++++++++++++++++----------
 1 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/drivers/hv/hv_balloon.c b/drivers/hv/hv_balloon.c
index 3787321..860e176 100644
--- a/drivers/hv/hv_balloon.c
+++ b/drivers/hv/hv_balloon.c
@@ -412,6 +412,11 @@ struct dm_info_msg {
  * End protocol definitions.
  */
 
+struct balloon_state {
+	__u32 num_pages;
+	struct work_struct wrk;
+};
+
 static bool hot_add;
 static bool do_hot_add;
 /*
@@ -429,6 +434,7 @@ static atomic_t trans_id = ATOMIC_INIT(0);
 
 static int dm_ring_size = (5 * PAGE_SIZE);
 
+
 /*
  * Driver specific state.
  */
@@ -459,7 +465,12 @@ struct hv_dynmem_device {
 	unsigned int num_pages_ballooned;
 
 	/*
-	 * This thread handles both balloon/hot-add
+	 * State to manage the ballooning (up) operation.
+	 */
+	struct balloon_state balloon_wrk;
+
+	/*
+	 * This thread handles hot-add
 	 * requests from the host as well as notifying
 	 * the host with regards to memory pressure in
 	 * the guest.
@@ -657,9 +668,9 @@ static int  alloc_balloon_pages(struct hv_dynmem_device *dm, int num_pages,
 
 
 
-static void balloon_up(struct hv_dynmem_device *dm, struct dm_balloon *req)
+static void balloon_up(struct work_struct *dummy)
 {
-	int num_pages = req->num_pages;
+	int num_pages = dm_device.balloon_wrk.num_pages;
 	int num_ballooned = 0;
 	struct dm_balloon_response *bl_resp;
 	int alloc_unit;
@@ -684,14 +695,14 @@ static void balloon_up(struct hv_dynmem_device *dm, struct dm_balloon *req)
 
 
 		num_pages -= num_ballooned;
-		num_ballooned = alloc_balloon_pages(dm, num_pages,
+		num_ballooned = alloc_balloon_pages(&dm_device, num_pages,
 						bl_resp, alloc_unit,
 						 &alloc_error);
 
 		if ((alloc_error) || (num_ballooned == num_pages)) {
 			bl_resp->more_pages = 0;
 			done = true;
-			dm->state = DM_INITIALIZED;
+			dm_device.state = DM_INITIALIZED;
 		}
 
 		/*
@@ -719,7 +730,7 @@ static void balloon_up(struct hv_dynmem_device *dm, struct dm_balloon *req)
 			pr_info("Balloon response failed\n");
 
 			for (i = 0; i < bl_resp->range_count; i++)
-				free_balloon_pages(dm,
+				free_balloon_pages(&dm_device,
 						 &bl_resp->range_array[i]);
 
 			done = true;
@@ -775,9 +786,6 @@ static int dm_thread_func(void *dm_dev)
 
 		scan_start = jiffies;
 		switch (dm->state) {
-		case DM_BALLOON_UP:
-			balloon_up(dm, (struct dm_balloon *)recv_buffer);
-			break;
 
 		case DM_HOT_ADD:
 			hot_add_req(dm, (struct dm_hot_add *)recv_buffer);
@@ -861,6 +869,7 @@ static void balloon_onchannelcallback(void *context)
 	struct dm_message *dm_msg;
 	struct dm_header *dm_hdr;
 	struct hv_dynmem_device *dm = hv_get_drvdata(dev);
+	struct dm_balloon *bal_msg;
 
 	memset(recv_buffer, 0, sizeof(recv_buffer));
 	vmbus_recvpacket(dev->channel, recv_buffer,
@@ -882,8 +891,12 @@ static void balloon_onchannelcallback(void *context)
 			break;
 
 		case DM_BALLOON_REQUEST:
+			if (dm->state == DM_BALLOON_UP)
+				pr_warn("Currently ballooning\n");
+			bal_msg = (struct dm_balloon *)recv_buffer;
 			dm->state = DM_BALLOON_UP;
-			complete(&dm->config_event);
+			dm_device.balloon_wrk.num_pages = bal_msg->num_pages;
+			schedule_work(&dm_device.balloon_wrk.wrk);
 			break;
 
 		case DM_UNBALLOON_REQUEST:
@@ -937,6 +950,7 @@ static int balloon_probe(struct hv_device *dev,
 	dm_device.next_version = DYNMEM_PROTOCOL_VERSION_WIN7;
 	init_completion(&dm_device.host_event);
 	init_completion(&dm_device.config_event);
+	INIT_WORK(&dm_device.balloon_wrk.wrk, balloon_up);
 
 	dm_device.thread =
 		 kthread_run(dm_thread_func, &dm_device, "hv_balloon");
-- 
1.7.4.1

