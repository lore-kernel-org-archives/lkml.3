Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462AbbAPNqL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 08:46:11 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36359 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751733AbbAPNqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 08:46:08 -0500
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>, devel@linuxdriverproject.org
Cc: Haiyang Zhang <haiyangz@microsoft.com>, linux-kernel@vger.kernel.org,
        Dexuan Cui <decui@microsoft.com>, Jason Wang <jasowang@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH] Drivers: hv: vmbus: serialize Offer and Rescind offer processing
Date: Fri, 16 Jan 2015 14:45:58 +0100
Message-Id: <1421415958-19015-1-git-send-email-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 4b2f9abea52a ("staging: hv: convert channel_mgmt.c to not call
osd_schedule_callback")' was written under an assumption that we never receive
Rescind offer while we're still processing the initial Offer request. However,
the issue we fixed in 04a258c162a8 could be caused by this assumption not
always being true.

In particular, we need to protect against the following:
1) Receiving a Rescind offer after we do queue_work() for processing an Offer
   request and before we actually enter vmbus_process_offer(). work.func points
   to vmbus_process_offer() at this moment and in vmbus_onoffer_rescind() we do
   another queue_work() without a check so we'll enter vmbus_process_offer()
   twice.
2) Receiving a Rescind offer after we enter vmbus_process_offer() and
   especially after we set >state = CHANNEL_OPEN_STATE. Many things can go
   wrong in that case, e.g. we can call free_channel() while we're still using
   it.

Implement the required protection by changing work->func at the very end of
vmbus_process_offer() and checking work->func in vmbus_onoffer_rescind().
pr_warn here serves only one purpose, it shows us the collision between
Offer and Rescind offer actually happened. In case the assumption in
4b2f9abea52af3 was right and such collision is impossible this commit changes
nothing.

I also fix one additional issue with this patch: vmbus_device_create() result
is not being checked in vmbus_process_offer() and it can fail if kzalloc()
fails.

Reported-by: Jason Wang <jasowang@redhat.com>
Suggested-by: Radim Krčmář <rkrcmar@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 drivers/hv/channel_mgmt.c | 33 +++++++++++++++++++++++----------
 1 file changed, 23 insertions(+), 10 deletions(-)

diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
index 2c59f03..0bd2a21 100644
--- a/drivers/hv/channel_mgmt.c
+++ b/drivers/hv/channel_mgmt.c
@@ -279,9 +279,6 @@ static void vmbus_process_offer(struct work_struct *work)
 	int ret;
 	unsigned long flags;
 
-	/* The next possible work is rescind handling */
-	INIT_WORK(&newchannel->work, vmbus_process_rescind_offer);
-
 	/* Make sure this is a new offer */
 	spin_lock_irqsave(&vmbus_connection.channel_lock, flags);
 
@@ -340,12 +337,9 @@ static void vmbus_process_offer(struct work_struct *work)
 			newchannel->state = CHANNEL_OPEN_STATE;
 			if (channel->sc_creation_callback != NULL)
 				channel->sc_creation_callback(newchannel);
-
-			return;
+			goto out;
 		}
-
-		free_channel(newchannel);
-		return;
+		goto error;
 	}
 
 	/*
@@ -365,6 +359,9 @@ static void vmbus_process_offer(struct work_struct *work)
 		&newchannel->offermsg.offer.if_instance,
 		newchannel);
 
+	if (!newchannel->device_obj)
+		goto error;
+
 	/*
 	 * Add the new device to the bus. This will kick off device-driver
 	 * binding which eventually invokes the device driver's AddDevice()
@@ -379,9 +376,16 @@ static void vmbus_process_offer(struct work_struct *work)
 		list_del(&newchannel->listentry);
 		spin_unlock_irqrestore(&vmbus_connection.channel_lock, flags);
 		kfree(newchannel->device_obj);
-
-		free_channel(newchannel);
+		goto error;
 	}
+out:
+	/* The next possible work is rescind handling */
+	INIT_WORK(&newchannel->work, vmbus_process_rescind_offer);
+	return;
+
+error:
+	free_channel(newchannel);
+	return;
 }
 
 enum {
@@ -524,6 +528,15 @@ static void vmbus_onoffer_rescind(struct vmbus_channel_message_header *hdr)
 		/* Just return here, no channel found */
 		return;
 
+	if (channel->work.func != vmbus_process_rescind_offer) {
+		/*
+		 * We're still processing offer request rescind offer can't be
+		 * processed safely. This should not normally happen.
+		 */
+		pr_warn("Got Rescind offer during Offer processing!\n");
+		return;
+	}
+
 	channel->rescind = true;
 
 	/* work is initialized for vmbus_process_rescind_offer() from
-- 
1.9.3

