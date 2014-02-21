Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933404AbaBUNdG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 08:33:06 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47124 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932440AbaBUMvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:51:03 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 081/121] Drivers: hv: vmbus: Specify the target CPU that should receive notification
Date: Fri, 21 Feb 2014 12:48:25 +0000
Message-Id: <1392986945-9693-82-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
References: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "K. Y. Srinivasan" <kys@microsoft.com>

commit e28bab4828354583bb66ac09021ca69b341a7db4 upstream.

During the initial VMBUS connect phase, starting with WS2012 R2, we should
specify the VPCU in the guest that should receive the notification. Fix this
issue. This fix is required to properly connect to the host in the kexeced
kernel.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/hv/connection.c | 2 ++
 include/linux/hyperv.h  | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
index ec3b8cd..0742931 100644
--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -80,6 +80,8 @@ static int vmbus_negotiate_version(struct vmbus_channel_msginfo *msginfo,
 	msg->monitor_page2 = virt_to_phys(
 			(void *)((unsigned long)vmbus_connection.monitor_pages +
 				 PAGE_SIZE));
+	if (version == VERSION_WIN8)
+		msg->target_vcpu = hv_context.vp_index[smp_processor_id()];
 
 	/*
 	 * Add to list before we send the request since we may
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index fae8bac..e0e64d1 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -894,7 +894,7 @@ struct vmbus_channel_relid_released {
 struct vmbus_channel_initiate_contact {
 	struct vmbus_channel_message_header header;
 	u32 vmbus_version_requested;
-	u32 padding2;
+	u32 target_vcpu; /* The VCPU the host should respond to */
 	u64 interrupt_page;
 	u64 monitor_page1;
 	u64 monitor_page2;
-- 
1.9.0

