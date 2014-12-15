Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751512AbaLOGY1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 01:24:27 -0500
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:39659
	"EHLO p3plsmtps2ded03.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750801AbaLOGYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 01:24:24 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 1/1] Drivers: hv: vmbus: Use get_cpu() to get the current CPU
Date: Sun, 14 Dec 2014 23:34:51 -0800
Message-Id: <1418628891-31546-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace calls for smp_processor_id() to get_cpu() to get the CPU ID of
the current CPU. In these instances, there is no correctness issue with
regards to preemption, we just need the current CPU ID.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/hv/channel_mgmt.c |    4 +++-
 drivers/hv/connection.c   |    6 ++++--
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
index d36ce68..a205246 100644
--- a/drivers/hv/channel_mgmt.c
+++ b/drivers/hv/channel_mgmt.c
@@ -813,7 +813,7 @@ cleanup:
 struct vmbus_channel *vmbus_get_outgoing_channel(struct vmbus_channel *primary)
 {
 	struct list_head *cur, *tmp;
-	int cur_cpu = hv_context.vp_index[smp_processor_id()];
+	int cur_cpu;
 	struct vmbus_channel *cur_channel;
 	struct vmbus_channel *outgoing_channel = primary;
 	int cpu_distance, new_cpu_distance;
@@ -821,6 +821,8 @@ struct vmbus_channel *vmbus_get_outgoing_channel(struct vmbus_channel *primary)
 	if (list_empty(&primary->sc_list))
 		return outgoing_channel;
 
+	cur_cpu = hv_context.vp_index[get_cpu()];
+	put_cpu();
 	list_for_each_safe(cur, tmp, &primary->sc_list) {
 		cur_channel = list_entry(cur, struct vmbus_channel, sc_list);
 		if (cur_channel->state != CHANNEL_OPENED_STATE)
diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
index e206619..a63a795 100644
--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -80,8 +80,10 @@ static int vmbus_negotiate_version(struct vmbus_channel_msginfo *msginfo,
 	msg->interrupt_page = virt_to_phys(vmbus_connection.int_page);
 	msg->monitor_page1 = virt_to_phys(vmbus_connection.monitor_pages[0]);
 	msg->monitor_page2 = virt_to_phys(vmbus_connection.monitor_pages[1]);
-	if (version == VERSION_WIN8_1)
-		msg->target_vcpu = hv_context.vp_index[smp_processor_id()];
+	if (version == VERSION_WIN8_1) {
+		msg->target_vcpu = hv_context.vp_index[get_cpu()];
+		put_cpu();
+	}
 
 	/*
 	 * Add to list before we send the request since we may
-- 
1.7.4.1

