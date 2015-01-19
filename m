Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425AbbASQ42 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 11:56:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46551 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751614AbbASQ41 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 11:56:27 -0500
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>, devel@linuxdriverproject.org
Cc: Haiyang Zhang <haiyangz@microsoft.com>, linux-kernel@vger.kernel.org,
        Dexuan Cui <decui@microsoft.com>, Jason Wang <jasowang@redhat.com>,
        =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH v2 3/3] Drivers: hv: vmbus: serialize Offer and Rescind offer
Date: Mon, 19 Jan 2015 17:56:13 +0100
Message-Id: <1421686573-12771-4-git-send-email-vkuznets@redhat.com>
In-Reply-To: <1421686573-12771-1-git-send-email-vkuznets@redhat.com>
References: <1421686573-12771-1-git-send-email-vkuznets@redhat.com>
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
vmbus_process_offer() and checking work->func in vmbus_onoffer_rescind(). In
case we receive rescind offer during or before vmbus_process_offer() is done
we set rescind flag to true and we check it at the end of vmbus_process_offer()
so such offer will not get lost.

Suggested-by: Radim Krčmář <rkrcmar@redhat.com>
Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 drivers/hv/channel_mgmt.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
index c526ed2..512b74a 100644
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
 
@@ -383,6 +380,13 @@ static void vmbus_process_offer(struct work_struct *work)
 		goto error;
 	}
 out:
+	spin_lock_irqsave(&newchannel->lock, flags);
+	/* The next possible work is rescind handling */
+	INIT_WORK(&newchannel->work, vmbus_process_rescind_offer);
+	/* Check if rescind offer was already received */
+	if (newchannel->rescind)
+		queue_work(newchannel->controlwq, &newchannel->work);
+	spin_unlock_irqrestore(&newchannel->lock, flags);
 	return;
 error:
 	free_channel(newchannel);
@@ -520,6 +524,7 @@ static void vmbus_onoffer_rescind(struct vmbus_channel_message_header *hdr)
 {
 	struct vmbus_channel_rescind_offer *rescind;
 	struct vmbus_channel *channel;
+	unsigned long flags;
 
 	rescind = (struct vmbus_channel_rescind_offer *)hdr;
 	channel = relid2channel(rescind->child_relid);
@@ -528,11 +533,21 @@ static void vmbus_onoffer_rescind(struct vmbus_channel_message_header *hdr)
 		/* Just return here, no channel found */
 		return;
 
+	spin_lock_irqsave(&channel->lock, flags);
 	channel->rescind = true;
+	if (channel->work.func != vmbus_process_rescind_offer)
+		/*
+		 * We're still processing offer request, postponing rescind
+		 * offer processing. It will be done when vmbus_process_offer()
+		 * is done as it checks rescind flag.
+		 */
+		goto out;
 
 	/* work is initialized for vmbus_process_rescind_offer() from
 	 * vmbus_process_offer() where the channel got created */
 	queue_work(channel->controlwq, &channel->work);
+out:
+	spin_unlock_irqrestore(&channel->lock, flags);
 }
 
 /*
-- 
1.9.3

