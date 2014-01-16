Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751648AbaAPAXw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 19:23:52 -0500
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:38200
	"EHLO p3plsmtps2ded03.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750900AbaAPAXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 19:23:50 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, <stable@vger.kernel.org>,
        "[3.9+]"@linuxonhyperv.com
Subject: [PATCH 1/1] Drivers: hv: vmbus: Specify the target CPU that should receive notification
Date: Wed, 15 Jan 2014 17:12:58 -0800
Message-Id: <1389834778-15872-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During the initial VMBUS connect phase, starting with WS2012 R2, we should
specify the VPCU in the guest that should receive the notification. Fix this
issue. This fix is required to properly connect to the host in the kexeced
kernel.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Cc: <stable@vger.kernel.org>        [3.9+]
---
 drivers/hv/connection.c |    2 ++
 include/linux/hyperv.h  |    2 +-
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
index af6edf9..855bbda 100644
--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -78,6 +78,8 @@ static int vmbus_negotiate_version(struct vmbus_channel_msginfo *msginfo,
 	msg->interrupt_page = virt_to_phys(vmbus_connection.int_page);
 	msg->monitor_page1 = virt_to_phys(vmbus_connection.monitor_pages[0]);
 	msg->monitor_page2 = virt_to_phys(vmbus_connection.monitor_pages[1]);
+	if (version == VERSION_WIN8)
+		msg->target_vcpu = hv_context.vp_index[smp_processor_id()];
 
 	/*
 	 * Add to list before we send the request since we may
diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
index 15da677..344883d 100644
--- a/include/linux/hyperv.h
+++ b/include/linux/hyperv.h
@@ -875,7 +875,7 @@ struct vmbus_channel_relid_released {
 struct vmbus_channel_initiate_contact {
 	struct vmbus_channel_message_header header;
 	u32 vmbus_version_requested;
-	u32 padding2;
+	u32 target_vcpu; /* The VCPU the host should respond to */
 	u64 interrupt_page;
 	u64 monitor_page1;
 	u64 monitor_page2;
-- 
1.7.4.1

