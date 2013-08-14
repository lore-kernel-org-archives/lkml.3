Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932465Ab3HNKh4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 06:37:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34536 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932449Ab3HNKhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 06:37:53 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stanislaw Gruszka <stf_xl@wp.pl>,
        "John W. Linville" <linville@tuxdriver.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 35/75] rt2x00: fix stop queue
Date: Wed, 14 Aug 2013 11:36:24 +0100
Message-Id: <1376476624-10011-36-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
References: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.19 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <stf_xl@wp.pl>

commit e2288b66fe7ff0288382b2af671b4da558b44472 upstream.

Since we clear QUEUE_STARTED in rt2x00queue_stop_queue(), following
call to rt2x00queue_pause_queue() reduce to noop, i.e we do not
stop queue in mac80211.

To fix that introduce rt2x00queue_pause_queue_nocheck() function,
which will stop queue in mac80211 directly.

Note that rt2x00_start_queue() explicitly set QUEUE_PAUSED bit.

Note also that reordering operations i.e. first call to
rt2x00queue_pause_queue() and then clear QUEUE_STARTED bit, will race
with rt2x00queue_unpause_queue(), so calling ieee80211_stop_queue()
directly is the only available solution to fix the problem without
major rework.

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/wireless/rt2x00/rt2x00queue.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 2fd8301..6d0c651 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -877,13 +877,8 @@ void rt2x00queue_index_inc(struct queue_entry *entry, enum queue_index index)
 	spin_unlock_irqrestore(&queue->index_lock, irqflags);
 }
 
-void rt2x00queue_pause_queue(struct data_queue *queue)
+void rt2x00queue_pause_queue_nocheck(struct data_queue *queue)
 {
-	if (!test_bit(DEVICE_STATE_PRESENT, &queue->rt2x00dev->flags) ||
-	    !test_bit(QUEUE_STARTED, &queue->flags) ||
-	    test_and_set_bit(QUEUE_PAUSED, &queue->flags))
-		return;
-
 	switch (queue->qid) {
 	case QID_AC_VO:
 	case QID_AC_VI:
@@ -899,6 +894,15 @@ void rt2x00queue_pause_queue(struct data_queue *queue)
 		break;
 	}
 }
+void rt2x00queue_pause_queue(struct data_queue *queue)
+{
+	if (!test_bit(DEVICE_STATE_PRESENT, &queue->rt2x00dev->flags) ||
+	    !test_bit(QUEUE_STARTED, &queue->flags) ||
+	    test_and_set_bit(QUEUE_PAUSED, &queue->flags))
+		return;
+
+	rt2x00queue_pause_queue_nocheck(queue);
+}
 EXPORT_SYMBOL_GPL(rt2x00queue_pause_queue);
 
 void rt2x00queue_unpause_queue(struct data_queue *queue)
@@ -960,7 +964,7 @@ void rt2x00queue_stop_queue(struct data_queue *queue)
 		return;
 	}
 
-	rt2x00queue_pause_queue(queue);
+	rt2x00queue_pause_queue_nocheck(queue);
 
 	queue->rt2x00dev->ops->lib->stop_queue(queue);
 
-- 
1.8.3.2

