Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761391AbaEMKoE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 06:44:04 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60751 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760017AbaEMJ2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:28:55 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "K. Y. Srinivasan" <kys@microsoft.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 005/182] Drivers: hv: vmbus: Negotiate version 3.0 when running on ws2012r2 hosts
Date: Tue, 13 May 2014 11:25:57 +0200
Message-Id: <f3e8f7ea9fb40f351db80d5fde83a318f084a365.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "K. Y. Srinivasan" <kys@microsoft.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 03367ef5ea811475187a0732aada068919e14d61 upstream.

Only ws2012r2 hosts support the ability to reconnect to the host on VMBUS.
This functionality is needed by kexec in Linux. To use this functionality
we need to negotiate version 3.0 of the VMBUS protocol.

This patch has been backported to apply against the 3.12 stable tree.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Cc: <stable@vger.kernel.org>        [3.9+]
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/hv/connection.c | 6 ++++++
 include/linux/hyperv.h  | 7 +++++--
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
index 13c23a4789de..b2ee81e19b59 100644
--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -55,6 +55,9 @@ static __u32 vmbus_get_next_version(__u32 current_version)
 	case (VERSION_WIN8):
 		return VERSION_WIN7;
 
+	case (VERSION_WIN8_1):
+		return VERSION_WIN8;
+
 	case (VERSION_WS2008):
 	default:
 		return VERSION_INVAL;
@@ -80,6 +83,9 @@ static int vmbus_negotiate_version(struct vmbus_channel_msginfo *msginfo,
 			(void *)((unsigned long)vmbus_connection.monitor_pages +
 				 PAGE_SIZE));
 
+	if (version == VERSION_WIN8_1)
+		msg->target_vcpu = hv_context.vp_index[smp_processor_id()];
+
 	/*
 	 * Add to list before we send the request since we may
 	 * receive the response before returning from this routine
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index d98503bde7e9..b6043a0c629f 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -473,15 +473,18 @@ hv_get_ringbuffer_availbytes(struct hv_ring_buffer_info *rbi,
  * 0 . 13 (Windows Server 2008)
  * 1 . 1  (Windows 7)
  * 2 . 4  (Windows 8)
+ * 3 . 0  (Windows 8 R2)
  */
 
 #define VERSION_WS2008  ((0 << 16) | (13))
 #define VERSION_WIN7    ((1 << 16) | (1))
 #define VERSION_WIN8    ((2 << 16) | (4))
+#define VERSION_WIN8_1    ((3 << 16) | (0))
+
 
 #define VERSION_INVAL -1
 
-#define VERSION_CURRENT VERSION_WIN8
+#define VERSION_CURRENT VERSION_WIN8_1
 
 /* Make maximum size of pipe payload of 16K */
 #define MAX_PIPE_DATA_PAYLOAD		(sizeof(u8) * 16384)
@@ -884,7 +887,7 @@ struct vmbus_channel_relid_released {
 struct vmbus_channel_initiate_contact {
 	struct vmbus_channel_message_header header;
 	u32 vmbus_version_requested;
-	u32 padding2;
+	u32 target_vcpu; /* The VCPU the host should respond to */
 	u64 interrupt_page;
 	u64 monitor_page1;
 	u64 monitor_page2;
-- 
1.9.3

