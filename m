Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963AbaG3Mnn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:43:43 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:36636 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752749AbaG3MPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:15:25 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "K. Y. Srinivasan" <kys@microsoft.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 15/94] Drivers: hv: util: Fix a bug in the KVP code
Date: Wed, 30 Jul 2014 14:14:04 +0200
Message-Id: <65769bee8f02c6f0d22211732030ae7c62358862.1406722270.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
References: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
In-Reply-To: <cover.1406722269.git.jslaby@suse.cz>
References: <cover.1406722269.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "K. Y. Srinivasan" <kys@microsoft.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 9bd2d0dfe4714dd5d7c09a93a5c9ea9e14ceb3fc upstream.

Add code to poll the channel since we process only one message
at a time and the host may not interrupt us. Also increase the
receive buffer size since some KVP messages are close to 8K bytes in size.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/hv/hv_kvp.c  | 14 ++++++++++++--
 drivers/hv/hv_util.c |  2 +-
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/hv/hv_kvp.c b/drivers/hv/hv_kvp.c
index 09988b289622..816782a65488 100644
--- a/drivers/hv/hv_kvp.c
+++ b/drivers/hv/hv_kvp.c
@@ -127,6 +127,15 @@ kvp_work_func(struct work_struct *dummy)
 	kvp_respond_to_host(NULL, HV_E_FAIL);
 }
 
+static void poll_channel(struct vmbus_channel *channel)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&channel->inbound_lock, flags);
+	hv_kvp_onchannelcallback(channel);
+	spin_unlock_irqrestore(&channel->inbound_lock, flags);
+}
+
 static int kvp_handle_handshake(struct hv_kvp_msg *msg)
 {
 	int ret = 1;
@@ -155,7 +164,7 @@ static int kvp_handle_handshake(struct hv_kvp_msg *msg)
 		kvp_register(dm_reg_value);
 		kvp_transaction.active = false;
 		if (kvp_transaction.kvp_context)
-			hv_kvp_onchannelcallback(kvp_transaction.kvp_context);
+			poll_channel(kvp_transaction.kvp_context);
 	}
 	return ret;
 }
@@ -568,6 +577,7 @@ response_done:
 
 	vmbus_sendpacket(channel, recv_buffer, buf_len, req_id,
 				VM_PKT_DATA_INBAND, 0);
+	poll_channel(channel);
 
 }
 
@@ -603,7 +613,7 @@ void hv_kvp_onchannelcallback(void *context)
 		return;
 	}
 
-	vmbus_recvpacket(channel, recv_buffer, PAGE_SIZE * 2, &recvlen,
+	vmbus_recvpacket(channel, recv_buffer, PAGE_SIZE * 4, &recvlen,
 			 &requestid);
 
 	if (recvlen > 0) {
diff --git a/drivers/hv/hv_util.c b/drivers/hv/hv_util.c
index 273e3ddb3a20..665b7dac6b7d 100644
--- a/drivers/hv/hv_util.c
+++ b/drivers/hv/hv_util.c
@@ -312,7 +312,7 @@ static int util_probe(struct hv_device *dev,
 		(struct hv_util_service *)dev_id->driver_data;
 	int ret;
 
-	srv->recv_buffer = kmalloc(PAGE_SIZE * 2, GFP_KERNEL);
+	srv->recv_buffer = kmalloc(PAGE_SIZE * 4, GFP_KERNEL);
 	if (!srv->recv_buffer)
 		return -ENOMEM;
 	if (srv->util_init) {
-- 
2.0.1

