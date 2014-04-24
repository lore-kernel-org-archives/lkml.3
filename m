Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932092AbaDXI4g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 04:56:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47113 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754767AbaDXI4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 04:56:22 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 169/182] Drivers: hv: vmbus: Negotiate version 3.0 when running on ws2012r2 hosts
Date: Thu, 24 Apr 2014 09:51:34 +0100
Message-Id: <1398329507-5911-170-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
References: <1398329507-5911-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "K. Y. Srinivasan" <kys@microsoft.com>

commit 03367ef5ea811475187a0732aada068919e14d61 upstream.

Only ws2012r2 hosts support the ability to reconnect to the host on VMBUS. This functionality
is needed by kexec in Linux. To use this functionality we need to negotiate version 3.0 of the
VMBUS protocol.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/hv/connection.c | 5 ++++-
 include/linux/hyperv.h  | 4 +++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
index bf07435..8e8522d 100644
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
@@ -79,7 +82,7 @@ static int vmbus_negotiate_version(struct vmbus_channel_msginfo *msginfo,
 	msg->monitor_page2 = virt_to_phys(
 			(void *)((unsigned long)vmbus_connection.monitor_pages +
 				 PAGE_SIZE));
-	if (version == VERSION_WIN8)
+	if (version == VERSION_WIN8_1)
 		msg->target_vcpu = hv_context.vp_index[smp_processor_id()];
 
 	/*
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index e0e64d1..204eca1 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -483,15 +483,17 @@ hv_get_ringbuffer_availbytes(struct hv_ring_buffer_info *rbi,
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
-- 
1.9.1

