Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932094AbaGORCx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 13:02:53 -0400
Received: from mail-wg0-f50.google.com ([74.125.82.50]:51301 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755793AbaGORCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 13:02:16 -0400
From: Sam Asadi <asadi.samuel@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "K. Y. Srinivasan" <kys@microsoft.com>, <stable@vger.kernel.org>,
        sam-the-6 <asadi.samuel@gmail.com>
Subject: [PATCH 56/94] Drivers: hv: util: Fix a bug in the KVP code
Date: Tue, 15 Jul 2014 20:01:11 +0300
Message-Id: <1405443709-15288-56-git-send-email-asadi.samuel@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
References: <1405443709-15288-1-git-send-email-asadi.samuel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "K. Y. Srinivasan" <kys@microsoft.com>

Add code to poll the channel since we process only one message
at a time and the host may not interrupt us. Also increase the
receive buffer size since some KVP messages are close to 8K bytes in size.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: sam-the-6 <asadi.samuel@gmail.com>
---
 drivers/hv/hv_kvp.c  |   17 ++++++++++++++---
 drivers/hv/hv_util.c |    2 +-
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/hv/hv_kvp.c b/drivers/hv/hv_kvp.c
index ea85253..521c146 100644
--- a/drivers/hv/hv_kvp.c
+++ b/drivers/hv/hv_kvp.c
@@ -127,6 +127,17 @@ kvp_work_func(struct work_struct *dummy)
 	kvp_respond_to_host(NULL, HV_E_FAIL);
 }
 
+static void poll_channel(struct vmbus_channel *channel)
+{
+	if (channel->target_cpu != smp_processor_id())
+		smp_call_function_single(channel->target_cpu,
+					 hv_kvp_onchannelcallback,
+					 channel, true);
+	else
+		hv_kvp_onchannelcallback(channel);
+}
+
+
 static int kvp_handle_handshake(struct hv_kvp_msg *msg)
 {
 	int ret = 1;
@@ -155,7 +166,7 @@ static int kvp_handle_handshake(struct hv_kvp_msg *msg)
 		kvp_register(dm_reg_value);
 		kvp_transaction.active = false;
 		if (kvp_transaction.kvp_context)
-			hv_kvp_onchannelcallback(kvp_transaction.kvp_context);
+			poll_channel(kvp_transaction.kvp_context);
 	}
 	return ret;
 }
@@ -568,7 +579,7 @@ response_done:
 
 	vmbus_sendpacket(channel, recv_buffer, buf_len, req_id,
 				VM_PKT_DATA_INBAND, 0);
-
+	poll_channel(channel);
 }
 
 /*
@@ -603,7 +614,7 @@ void hv_kvp_onchannelcallback(void *context)
 		return;
 	}
 
-	vmbus_recvpacket(channel, recv_buffer, PAGE_SIZE * 2, &recvlen,
+	vmbus_recvpacket(channel, recv_buffer, PAGE_SIZE * 4, &recvlen,
 			 &requestid);
 
 	if (recvlen > 0) {
diff --git a/drivers/hv/hv_util.c b/drivers/hv/hv_util.c
index dd76180..3b9c9ef 100644
--- a/drivers/hv/hv_util.c
+++ b/drivers/hv/hv_util.c
@@ -319,7 +319,7 @@ static int util_probe(struct hv_device *dev,
 		(struct hv_util_service *)dev_id->driver_data;
 	int ret;
 
-	srv->recv_buffer = kmalloc(PAGE_SIZE * 2, GFP_KERNEL);
+	srv->recv_buffer = kmalloc(PAGE_SIZE * 4, GFP_KERNEL);
 	if (!srv->recv_buffer)
 		return -ENOMEM;
 	if (srv->util_init) {
-- 
1.7.10.4

