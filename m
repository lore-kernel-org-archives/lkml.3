Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727AbaH2A0U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 20:26:20 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:51980
	"EHLO p3plsmtps2ded02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751200AbaH2A0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 20:26:18 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com, sitsofe@gmail.com, decui@microsoft.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 2/2] Drivers: hv: vmbus: Properly protect calls to smp_processor_id()
Date: Thu, 28 Aug 2014 18:29:53 -0700
Message-Id: <1409275793-28511-2-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1409275793-28511-1-git-send-email-kys@microsoft.com>
References: <1409275773-28472-1-git-send-email-kys@microsoft.com>
 <1409275793-28511-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disable preemption when sampling current processor ID when preemption
is otherwise possible.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/hv/channel.c      |    7 +++++--
 drivers/hv/channel_mgmt.c |   21 +++++++++++++++------
 2 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
index 19bad59..433f72a 100644
--- a/drivers/hv/channel.c
+++ b/drivers/hv/channel.c
@@ -486,11 +486,14 @@ static int vmbus_close_internal(struct vmbus_channel *channel)
 	channel->state = CHANNEL_OPEN_STATE;
 	channel->sc_creation_callback = NULL;
 	/* Stop callback and cancel the timer asap */
-	if (channel->target_cpu != smp_processor_id())
+	if (channel->target_cpu != get_cpu()) {
+		put_cpu();
 		smp_call_function_single(channel->target_cpu, reset_channel_cb,
 					 channel, true);
-	else
+	} else {
 		reset_channel_cb(channel);
+		put_cpu();
+	}
 
 	/* Send a closing message */
 
diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
index ed9350d..a2d1a96 100644
--- a/drivers/hv/channel_mgmt.c
+++ b/drivers/hv/channel_mgmt.c
@@ -224,11 +224,14 @@ static void vmbus_process_rescind_offer(struct work_struct *work)
 	msg.header.msgtype = CHANNELMSG_RELID_RELEASED;
 	vmbus_post_msg(&msg, sizeof(struct vmbus_channel_relid_released));
 
-	if (channel->target_cpu != smp_processor_id())
+	if (channel->target_cpu != get_cpu()) {
+		put_cpu();
 		smp_call_function_single(channel->target_cpu,
 					 percpu_channel_deq, channel, true);
-	else
+	} else {
 		percpu_channel_deq(channel);
+		put_cpu();
+	}
 
 	if (channel->primary_channel == NULL) {
 		spin_lock_irqsave(&vmbus_connection.channel_lock, flags);
@@ -294,12 +297,15 @@ static void vmbus_process_offer(struct work_struct *work)
 	spin_unlock_irqrestore(&vmbus_connection.channel_lock, flags);
 
 	if (enq) {
-		if (newchannel->target_cpu != smp_processor_id())
+		if (newchannel->target_cpu != get_cpu()) {
+			put_cpu();
 			smp_call_function_single(newchannel->target_cpu,
 						 percpu_channel_enq,
 						 newchannel, true);
-		else
+		} else {
 			percpu_channel_enq(newchannel);
+			put_cpu();
+		}
 	}
 	if (!fnew) {
 		/*
@@ -314,12 +320,15 @@ static void vmbus_process_offer(struct work_struct *work)
 			list_add_tail(&newchannel->sc_list, &channel->sc_list);
 			spin_unlock_irqrestore(&channel->sc_lock, flags);
 
-			if (newchannel->target_cpu != smp_processor_id())
+			if (newchannel->target_cpu != get_cpu()) {
+				put_cpu();
 				smp_call_function_single(newchannel->target_cpu,
 							 percpu_channel_enq,
 							 newchannel, true);
-			else
+			} else {
 				percpu_channel_enq(newchannel);
+				put_cpu();
+			}
 
 			newchannel->state = CHANNEL_OPEN_STATE;
 			if (channel->sc_creation_callback != NULL)
-- 
1.7.4.1

