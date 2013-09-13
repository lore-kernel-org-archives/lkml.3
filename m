Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503Ab3IMSey (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 14:34:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37229 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754591Ab3IMSdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 14:33:18 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: kys@microsoft.com, haiyangz@microsoft.com
Cc: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 07/13] hv: make "monitor_pages" a "real" pointer array
Date: Fri, 13 Sep 2013 11:32:55 -0700
Message-Id: <1379097181-23407-8-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <1379097181-23407-1-git-send-email-gregkh@linuxfoundation.org>
References: <1379097181-23407-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

monitor_pages was a void pointer, containing an unknown number of arrays that
we just "knew" were a child and parent array of a specific size.  Instead of
that implicit knowledge, let's make them a real pointer, allowing us to have
type safety, and a semblance of sane addressing schemes.

Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hv/channel.c      | 10 ++++------
 drivers/hv/connection.c   | 21 ++++++++++-----------
 drivers/hv/hyperv_vmbus.h |  2 +-
 3 files changed, 15 insertions(+), 18 deletions(-)

diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
index dde30b48..04bf0656 100644
--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -47,8 +47,8 @@ static void vmbus_setevent(struct vmbus_channel *channel)
 			(unsigned long *) vmbus_connection.send_int_page +
 			(channel->offermsg.child_relid >> 5));
 
-		monitorpage = vmbus_connection.monitor_pages;
-		monitorpage++; /* Get the child to parent monitor page */
+		/* Get the child to parent monitor page */
+		monitorpage = vmbus_connection.monitor_pages[1];
 
 		sync_set_bit(channel->monitor_bit,
 			(unsigned long *)&monitorpage->trigger_group
@@ -69,8 +69,7 @@ void vmbus_get_debug_info(struct vmbus_channel *channel,
 	u8 monitor_group = (u8)channel->offermsg.monitorid / 32;
 	u8 monitor_offset = (u8)channel->offermsg.monitorid % 32;
 
-	monitorpage = (struct hv_monitor_page *)vmbus_connection.monitor_pages;
-
+	monitorpage = vmbus_connection.monitor_pages[0];
 	debuginfo->servermonitor_pending =
 			monitorpage->trigger_group[monitor_group].pending;
 	debuginfo->servermonitor_latency =
@@ -79,8 +78,7 @@ void vmbus_get_debug_info(struct vmbus_channel *channel,
 			monitorpage->parameter[monitor_group]
 					[monitor_offset].connectionid.u.id;
 
-	monitorpage++;
-
+	monitorpage = vmbus_connection.monitor_pages[1];
 	debuginfo->clientmonitor_pending =
 			monitorpage->trigger_group[monitor_group].pending;
 	debuginfo->clientmonitor_latency =
diff --git a/drivers/hv/connection.c b/drivers/hv/connection.c
index 8f4743ab..4faea979 100644
--- a/drivers/hv/connection.c
+++ b/drivers/hv/connection.c
@@ -76,10 +76,8 @@ static int vmbus_negotiate_version(struct vmbus_channel_msginfo *msginfo,
 	msg->header.msgtype = CHANNELMSG_INITIATE_CONTACT;
 	msg->vmbus_version_requested = version;
 	msg->interrupt_page = virt_to_phys(vmbus_connection.int_page);
-	msg->monitor_page1 = virt_to_phys(vmbus_connection.monitor_pages);
-	msg->monitor_page2 = virt_to_phys(
-			(void *)((unsigned long)vmbus_connection.monitor_pages +
-				 PAGE_SIZE));
+	msg->monitor_page1 = virt_to_phys(vmbus_connection.monitor_pages[0]);
+	msg->monitor_page2 = virt_to_phys(vmbus_connection.monitor_pages[1]);
 
 	/*
 	 * Add to list before we send the request since we may
@@ -169,9 +167,10 @@ int vmbus_connect(void)
 	 * Setup the monitor notification facility. The 1st page for
 	 * parent->child and the 2nd page for child->parent
 	 */
-	vmbus_connection.monitor_pages =
-	(void *)__get_free_pages((GFP_KERNEL|__GFP_ZERO), 1);
-	if (vmbus_connection.monitor_pages == NULL) {
+	vmbus_connection.monitor_pages[0] = (void *)__get_free_pages((GFP_KERNEL|__GFP_ZERO), 0);
+	vmbus_connection.monitor_pages[1] = (void *)__get_free_pages((GFP_KERNEL|__GFP_ZERO), 0);
+	if ((vmbus_connection.monitor_pages[0] == NULL) ||
+	    (vmbus_connection.monitor_pages[1] == NULL)) {
 		ret = -ENOMEM;
 		goto cleanup;
 	}
@@ -229,10 +228,10 @@ cleanup:
 		vmbus_connection.int_page = NULL;
 	}
 
-	if (vmbus_connection.monitor_pages) {
-		free_pages((unsigned long)vmbus_connection.monitor_pages, 1);
-		vmbus_connection.monitor_pages = NULL;
-	}
+	free_pages((unsigned long)vmbus_connection.monitor_pages[0], 1);
+	free_pages((unsigned long)vmbus_connection.monitor_pages[1], 1);
+	vmbus_connection.monitor_pages[0] = NULL;
+	vmbus_connection.monitor_pages[1] = NULL;
 
 	kfree(msginfo);
 
diff --git a/drivers/hv/hyperv_vmbus.h b/drivers/hv/hyperv_vmbus.h
index d84918fe..d58c22ff 100644
--- a/drivers/hv/hyperv_vmbus.h
+++ b/drivers/hv/hyperv_vmbus.h
@@ -612,7 +612,7 @@ struct vmbus_connection {
 	 * 2 pages - 1st page for parent->child notification and 2nd
 	 * is child->parent notification
 	 */
-	void *monitor_pages;
+	struct hv_monitor_page *monitor_pages[2];
 	struct list_head chn_msg_list;
 	spinlock_t channelmsg_lock;
 
-- 
1.8.4.3.gca3854a

