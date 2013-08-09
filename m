Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030426Ab3HICMM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 22:12:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55768 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967640Ab3HIB7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 21:59:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stanislaw Gruszka <stf_xl@wp.pl>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 056/102] rt2x00: fix stop queue
Date: Thu,  8 Aug 2013 18:57:32 -0700
Message-Id: <20130809015023.304451868@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130809015010.208118575@linuxfoundation.org>
References: <20130809015010.208118575@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rt2x00/rt2x00queue.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -936,13 +936,8 @@ void rt2x00queue_index_inc(struct queue_
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
@@ -958,6 +953,15 @@ void rt2x00queue_pause_queue(struct data
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
@@ -1019,7 +1023,7 @@ void rt2x00queue_stop_queue(struct data_
 		return;
 	}
 
-	rt2x00queue_pause_queue(queue);
+	rt2x00queue_pause_queue_nocheck(queue);
 
 	queue->rt2x00dev->ops->lib->stop_queue(queue);
 


