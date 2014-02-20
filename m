Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756332AbaBUAFb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 19:05:31 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46211 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932190AbaBTXxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 18:53:53 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 3.13 65/99] Drivers: hv: vmbus: Specify the target CPU that should receive notification
Date: Thu, 20 Feb 2014 15:53:00 -0800
Message-Id: <20140220235120.092245388@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140220235118.191692546@linuxfoundation.org>
References: <20140220235118.191692546@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "K. Y. Srinivasan" <kys@microsoft.com>

commit e28bab4828354583bb66ac09021ca69b341a7db4 upstream.

During the initial VMBUS connect phase, starting with WS2012 R2, we should
specify the VPCU in the guest that should receive the notification. Fix this
issue. This fix is required to properly connect to the host in the kexeced
kernel.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hv/connection.c |    2 ++
 include/linux/hyperv.h  |    2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -78,6 +78,8 @@ static int vmbus_negotiate_version(struc
 	msg->interrupt_page = virt_to_phys(vmbus_connection.int_page);
 	msg->monitor_page1 = virt_to_phys(vmbus_connection.monitor_pages[0]);
 	msg->monitor_page2 = virt_to_phys(vmbus_connection.monitor_pages[1]);
+	if (version == VERSION_WIN8)
+		msg->target_vcpu = hv_context.vp_index[smp_processor_id()];
 
 	/*
 	 * Add to list before we send the request since we may
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


