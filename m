Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296Ab3IKFef (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 01:34:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11316 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754589Ab3IKE5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:19 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=x_LwLvsJzxIA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=KzPW0c6KSQgA:10 a=VwQbUJbxAAAA:8 a=vmLDa1wCAAAA:8 a=VGudI7f2HUwHKj7Dtk0A:9 a=gv_BBZfBKR8A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042916.152895257@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:29:30 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Stanislaw Gruszka <stf_xl@wp.pl>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [143/251] rt2x00: fix stop queue
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0143-rt2x00-fix-stop-queue.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <stf_xl@wp.pl>

[ Upstream commit e2288b66fe7ff0288382b2af671b4da558b44472 ]

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

Cc: stable@vger.kernel.org
Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/wireless/rt2x00/rt2x00queue.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index f7e74a0..cff62c0 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -875,13 +875,8 @@ void rt2x00queue_index_inc(struct queue_entry *entry, enum queue_index index)
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
@@ -897,6 +892,15 @@ void rt2x00queue_pause_queue(struct data_queue *queue)
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
@@ -958,7 +962,7 @@ void rt2x00queue_stop_queue(struct data_queue *queue)
 		return;
 	}
 
-	rt2x00queue_pause_queue(queue);
+	rt2x00queue_pause_queue_nocheck(queue);
 
 	queue->rt2x00dev->ops->lib->stop_queue(queue);
 
-- 
1.7.10.4


