Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293AbaHRJeQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 05:34:16 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42554 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213AbaHRJeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:34:09 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 031/137] Drivers: hv: util: Fix a bug in the KVP code
Date: Mon, 18 Aug 2014 10:31:32 +0100
Message-Id: <1408354398-10226-32-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
References: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "K. Y. Srinivasan" <kys@microsoft.com>

commit 9bd2d0dfe4714dd5d7c09a93a5c9ea9e14ceb3fc upstream.

Add code to poll the channel since we process only one message
at a time and the host may not interrupt us. Also increase the
receive buffer size since some KVP messages are close to 8K bytes in size.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ luis: backported to 3.11: used kys's backport for 3.15 ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/hv/hv_kvp.c  | 16 +++++++++++++---
 drivers/hv/hv_util.c |  2 +-
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/hv/hv_kvp.c b/drivers/hv/hv_kvp.c
index ed50e9e83c61..cf2bd4aeb404 100644
--- a/drivers/hv/hv_kvp.c
+++ b/drivers/hv/hv_kvp.c
@@ -111,6 +111,16 @@ kvp_work_func(struct work_struct *dummy)
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
+
 static int kvp_handle_handshake(struct hv_kvp_msg *msg)
 {
 	int ret = 1;
@@ -139,7 +149,7 @@ static int kvp_handle_handshake(struct hv_kvp_msg *msg)
 		kvp_register(dm_reg_value);
 		kvp_transaction.active = false;
 		if (kvp_transaction.kvp_context)
-			hv_kvp_onchannelcallback(kvp_transaction.kvp_context);
+			poll_channel(kvp_transaction.kvp_context);
 	}
 	return ret;
 }
@@ -552,7 +562,7 @@ response_done:
 
 	vmbus_sendpacket(channel, recv_buffer, buf_len, req_id,
 				VM_PKT_DATA_INBAND, 0);
-
+	poll_channel(channel);
 }
 
 /*
@@ -585,7 +595,7 @@ void hv_kvp_onchannelcallback(void *context)
 		return;
 	}
 
-	vmbus_recvpacket(channel, recv_buffer, PAGE_SIZE * 2, &recvlen,
+	vmbus_recvpacket(channel, recv_buffer, PAGE_SIZE * 4, &recvlen,
 			 &requestid);
 
 	if (recvlen > 0) {
diff --git a/drivers/hv/hv_util.c b/drivers/hv/hv_util.c
index 2f561c5dfe24..64c778f7756f 100644
--- a/drivers/hv/hv_util.c
+++ b/drivers/hv/hv_util.c
@@ -279,7 +279,7 @@ static int util_probe(struct hv_device *dev,
 		(struct hv_util_service *)dev_id->driver_data;
 	int ret;
 
-	srv->recv_buffer = kmalloc(PAGE_SIZE * 2, GFP_KERNEL);
+	srv->recv_buffer = kmalloc(PAGE_SIZE * 4, GFP_KERNEL);
 	if (!srv->recv_buffer)
 		return -ENOMEM;
 	if (srv->util_init) {
-- 
1.9.1

