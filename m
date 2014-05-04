Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226AbaEDPly (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 11:41:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36160 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028AbaEDPlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:41:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 3.14 096/158] Drivers: hv: vmbus: Negotiate version 3.0 when running on ws2012r2 hosts
Date: Sun,  4 May 2014 11:40:05 -0400
Message-Id: <20140504154042.987742762@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154029.975081050@linuxfoundation.org>
References: <20140504154029.975081050@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "K. Y. Srinivasan" <kys@microsoft.com>

commit 03367ef5ea811475187a0732aada068919e14d61 upstream.

Only ws2012r2 hosts support the ability to reconnect to the host on VMBUS. This functionality
is needed by kexec in Linux. To use this functionality we need to negotiate version 3.0 of the
VMBUS protocol.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hv/connection.c |    5 ++++-
 include/linux/hyperv.h  |    4 +++-
 2 files changed, 7 insertions(+), 2 deletions(-)

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
@@ -77,7 +80,7 @@ static int vmbus_negotiate_version(struc
 	msg->interrupt_page = virt_to_phys(vmbus_connection.int_page);
 	msg->monitor_page1 = virt_to_phys(vmbus_connection.monitor_pages[0]);
 	msg->monitor_page2 = virt_to_phys(vmbus_connection.monitor_pages[1]);
-	if (version == VERSION_WIN8)
+	if (version == VERSION_WIN8_1)
 		msg->target_vcpu = hv_context.vp_index[smp_processor_id()];
 
 	/*
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -464,15 +464,17 @@ hv_get_ringbuffer_availbytes(struct hv_r
  * 0 . 13 (Windows Server 2008)
  * 1 . 1  (Windows 7)
  * 2 . 4  (Windows 8)
+ * 3 . 0  (Windows 8 R2)
  */
 
 #define VERSION_WS2008  ((0 << 16) | (13))
 #define VERSION_WIN7    ((1 << 16) | (1))
 #define VERSION_WIN8    ((2 << 16) | (4))
+#define VERSION_WIN8_1    ((3 << 16) | (0))
 
 #define VERSION_INVAL -1
 
-#define VERSION_CURRENT VERSION_WIN8
+#define VERSION_CURRENT VERSION_WIN8_1
 
 /* Make maximum size of pipe payload of 16K */
 #define MAX_PIPE_DATA_PAYLOAD		(sizeof(u8) * 16384)


