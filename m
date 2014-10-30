Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161160AbaJ3UBO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 16:01:14 -0400
Received: from mail-qg0-f74.google.com ([209.85.192.74]:37980 "EHLO
	mail-qg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933129AbaJ3UBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 16:01:12 -0400
From: Andrew Bresticker <abrestic@chromium.org>
To: Jassi Brar <jassisinghbrar@gmail.com>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Andrew Bresticker <abrestic@chromium.org>
Subject: [PATCH 2/2] mailbox: Don't unnecessarily re-arm the polling timer
Date: Thu, 30 Oct 2014 13:01:07 -0700
Message-Id: <1414699267-17970-2-git-send-email-abrestic@chromium.org>
X-Mailer: git-send-email 2.1.0.rc2.206.gedb03e5
In-Reply-To: <1414699267-17970-1-git-send-email-abrestic@chromium.org>
References: <1414699267-17970-1-git-send-email-abrestic@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

poll_txdone() will unconditionally re-arm the polling timer if there was
an active request, even if the active request completed and no other
requests were submitted.  This is fixed by:
 - only re-arming the timer if the controller reported that the current
   transmission has not completed, and,
 - moving the call to poll_txdone() into msg_submit() so that the
   controller gets polled (and the timer re-armed, if necessary) whenever
   a new message is submitted.

Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
---
 drivers/mailbox/mailbox.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/mailbox/mailbox.c b/drivers/mailbox/mailbox.c
index 5008028..26f74ad 100644
--- a/drivers/mailbox/mailbox.c
+++ b/drivers/mailbox/mailbox.c
@@ -28,6 +28,8 @@
 static LIST_HEAD(mbox_cons);
 static DEFINE_MUTEX(con_mutex);
 
+static void poll_txdone(unsigned long data);
+
 static int add_to_rbuf(struct mbox_chan *chan, void *mssg)
 {
 	int idx;
@@ -60,7 +62,7 @@ static void msg_submit(struct mbox_chan *chan)
 	unsigned count, idx;
 	unsigned long flags;
 	void *data;
-	int err;
+	int err = -EBUSY;
 
 	spin_lock_irqsave(&chan->lock, flags);
 
@@ -84,6 +86,9 @@ static void msg_submit(struct mbox_chan *chan)
 	}
 exit:
 	spin_unlock_irqrestore(&chan->lock, flags);
+
+	if (!err && chan->txdone_method == TXDONE_BY_POLL)
+		poll_txdone((unsigned long)chan->mbox);
 }
 
 static void tx_tick(struct mbox_chan *chan, int r)
@@ -117,10 +122,11 @@ static void poll_txdone(unsigned long data)
 		struct mbox_chan *chan = &mbox->chans[i];
 
 		if (chan->active_req && chan->cl) {
-			resched = true;
 			txdone = chan->mbox->ops->last_tx_done(chan);
 			if (txdone)
 				tx_tick(chan, 0);
+			else
+				resched = true;
 		}
 	}
 
@@ -252,9 +258,6 @@ int mbox_send_message(struct mbox_chan *chan, void *mssg)
 
 	msg_submit(chan);
 
-	if (chan->txdone_method	== TXDONE_BY_POLL)
-		poll_txdone((unsigned long)chan->mbox);
-
 	if (chan->cl->tx_block && chan->active_req) {
 		unsigned long wait;
 		int ret;
-- 
2.1.0.rc2.206.gedb03e5

