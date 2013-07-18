Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757516Ab3GQXtk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 19:49:40 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:56620
	"EHLO p3plsmtps2ded03.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752625Ab3GQXtj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 19:49:39 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/1] Drivers: hv: balloon: Initialize the transaction ID just before sending the packet
Date: Wed, 17 Jul 2013 17:27:27 -0700
Message-Id: <1374107247-26249-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Each message sent from the guest carries with it a transaction ID.
Assign the transaction ID just before putting the message on the VMBUS.
This would help in debugging on the host side.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/hv/hv_balloon.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hv/hv_balloon.c b/drivers/hv/hv_balloon.c
index deb5c25..2d094cf 100644
--- a/drivers/hv/hv_balloon.c
+++ b/drivers/hv/hv_balloon.c
@@ -825,7 +825,6 @@ static void hot_add_req(struct work_struct *dummy)
 	memset(&resp, 0, sizeof(struct dm_hot_add_response));
 	resp.hdr.type = DM_MEM_HOT_ADD_RESPONSE;
 	resp.hdr.size = sizeof(struct dm_hot_add_response);
-	resp.hdr.trans_id = atomic_inc_return(&trans_id);
 
 #ifdef CONFIG_MEMORY_HOTPLUG
 	pg_start = dm->ha_wrk.ha_page_range.finfo.start_page;
@@ -887,6 +886,7 @@ static void hot_add_req(struct work_struct *dummy)
 		pr_info("Memory hot add failed\n");
 
 	dm->state = DM_INITIALIZED;
+	resp.hdr.trans_id = atomic_inc_return(&trans_id);
 	vmbus_sendpacket(dm->dev->channel, &resp,
 			sizeof(struct dm_hot_add_response),
 			(unsigned long)NULL,
@@ -1081,7 +1081,6 @@ static void balloon_up(struct work_struct *dummy)
 		bl_resp = (struct dm_balloon_response *)send_buffer;
 		memset(send_buffer, 0, PAGE_SIZE);
 		bl_resp->hdr.type = DM_BALLOON_RESPONSE;
-		bl_resp->hdr.trans_id = atomic_inc_return(&trans_id);
 		bl_resp->hdr.size = sizeof(struct dm_balloon_response);
 		bl_resp->more_pages = 1;
 
@@ -1109,6 +1108,7 @@ static void balloon_up(struct work_struct *dummy)
 		 */
 
 		do {
+			bl_resp->hdr.trans_id = atomic_inc_return(&trans_id);
 			ret = vmbus_sendpacket(dm_device.dev->channel,
 						bl_resp,
 						bl_resp->hdr.size,
-- 
1.7.4.1

