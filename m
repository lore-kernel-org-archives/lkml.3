Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053AbaDDAIl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 20:08:41 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:39473
	"EHLO p3plsmtps2ded03.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753758AbaDDAIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 20:08:40 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, <stable@vger.kernel.org>,
        "[3.9+]"@linuxonhyperv.com
Subject: [PATCH 1/1] Drivers: hv: vmbus: Negotiate version 3.0 when running on ws2012r2 hosts
Date: Thu,  3 Apr 2014 18:02:45 -0700
Message-Id: <1396573365-11898-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only ws2012r2 hosts support the ability to reconnect to the host on VMBUS. This functionality
is needed by kexec in Linux. To use this functionality we need to negotiate version 3.0 of the
VMBUS protocol.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Cc: <stable@vger.kernel.org>        [3.9+]
---
 drivers/hv/connection.c |    5 ++++-
 include/linux/hyperv.h  |    4 +++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
index f2d7bf9..2e7801a 100644
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
@@ -77,7 +80,7 @@ static int vmbus_negotiate_version(struct vmbus_channel_msginfo *msginfo,
 	msg->interrupt_page = virt_to_phys(vmbus_connection.int_page);
 	msg->monitor_page1 = virt_to_phys(vmbus_connection.monitor_pages[0]);
 	msg->monitor_page2 = virt_to_phys(vmbus_connection.monitor_pages[1]);
-	if (version == VERSION_WIN8)
+	if (version == VERSION_WIN8_1)
 		msg->target_vcpu = hv_context.vp_index[smp_processor_id()];
 
 	/*
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index ab7359f..2d7b4f1 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -147,15 +147,17 @@ hv_get_ringbuffer_availbytes(struct hv_ring_buffer_info *rbi,
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
1.7.4.1

