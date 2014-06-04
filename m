Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138AbaFDXYN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 19:24:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40890 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072AbaFDXYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:24:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 3.10 061/103] Drivers: hv: vmbus: Negotiate version 3.0 when running on ws2012r2 hosts
Date: Wed,  4 Jun 2014 16:25:24 -0700
Message-Id: <20140604232548.811993279@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232546.704156131@linuxfoundation.org>
References: <20140604232546.704156131@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "K. Y. Srinivasan" <kys@microsoft.com>

commit 03367ef5ea811475187a0732aada068919e14d61 upstream.

Only ws2012r2 hosts support the ability to reconnect to the host on VMBUS. This functionality
is needed by kexec in Linux. To use this functionality we need to negotiate version 3.0 of the
VMBUS protocol.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/hv/connection.c |    6 ++++++
 include/linux/hyperv.h  |    7 +++++--
 2 files changed, 11 insertions(+), 2 deletions(-)

--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -55,6 +55,9 @@ static __u32 vmbus_get_next_version(__u3
 	case (VERSION_WIN8):
 		return VERSION_WIN7;
 
+	case (VERSION_WIN8_1):
+		return VERSION_WIN8;
+
 	case (VERSION_WS2008):
 	default:
 		return VERSION_INVAL;
@@ -80,6 +83,9 @@ static int vmbus_negotiate_version(struc
 			(void *)((unsigned long)vmbus_connection.monitor_pages +
 				 PAGE_SIZE));
 
+	if (version == VERSION_WIN8_1)
+		msg->target_vcpu = hv_context.vp_index[smp_processor_id()];
+
 	/*
 	 * Add to list before we send the request since we may
 	 * receive the response before returning from this routine
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -483,15 +483,18 @@ hv_get_ringbuffer_availbytes(struct hv_r
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
@@ -894,7 +897,7 @@ struct vmbus_channel_relid_released {
 struct vmbus_channel_initiate_contact {
 	struct vmbus_channel_message_header header;
 	u32 vmbus_version_requested;
-	u32 padding2;
+	u32 target_vcpu; /* The VCPU the host should respond to */
 	u64 interrupt_page;
 	u64 monitor_page1;
 	u64 monitor_page2;


