Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838Ab3JWJJ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 05:09:59 -0400
Received: from mail09.linbit.com ([212.69.161.110]:48162 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593Ab3JWJJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 05:09:20 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Philipp Reisner <philipp.reisner@linbit.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: [PATCH 2/5] drbd: Fix an connection drop issue after enabling allow-two-primaries
Date: Wed, 23 Oct 2013 10:59:16 +0200
Message-Id: <1382518759-5467-3-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1382518759-5467-1-git-send-email-philipp.reisner@linbit.com>
References: <1382518759-5467-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since drbd-8.4.0 it is possible to change the allow-two-primaries
network option while the connection is established.

The sequence code used to partially order packets from the
data socket with packets from the meta-data socket, still assued
that the allow-two-primaries option is constant while the
connection is established.

I.e.
On a node that has the RESOLVE_CONFLICTS bits set, after enabling
allow-two-primaries, when receiving the next data packet it timed out
while waiting for the necessary packets on the data socket to arrive
(wait_for_and_update_peer_seq() function).

Fixed that by always tracking the sequence number, but only waiting
for it if allow-two-primaries is set.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_receiver.c |   39 +++++++++++++++---------------------
 1 file changed, 16 insertions(+), 23 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index cc29cd3..12c59eb 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -1890,29 +1890,11 @@ static u32 seq_max(u32 a, u32 b)
 	return seq_greater(a, b) ? a : b;
 }
 
-static bool need_peer_seq(struct drbd_conf *mdev)
-{
-	struct drbd_tconn *tconn = mdev->tconn;
-	int tp;
-
-	/*
-	 * We only need to keep track of the last packet_seq number of our peer
-	 * if we are in dual-primary mode and we have the resolve-conflicts flag set; see
-	 * handle_write_conflicts().
-	 */
-
-	rcu_read_lock();
-	tp = rcu_dereference(mdev->tconn->net_conf)->two_primaries;
-	rcu_read_unlock();
-
-	return tp && test_bit(RESOLVE_CONFLICTS, &tconn->flags);
-}
-
 static void update_peer_seq(struct drbd_conf *mdev, unsigned int peer_seq)
 {
 	unsigned int newest_peer_seq;
 
-	if (need_peer_seq(mdev)) {
+	if (test_bit(RESOLVE_CONFLICTS, &mdev->tconn->flags)) {
 		spin_lock(&mdev->peer_seq_lock);
 		newest_peer_seq = seq_max(mdev->peer_seq, peer_seq);
 		mdev->peer_seq = newest_peer_seq;
@@ -1972,22 +1954,31 @@ static int wait_for_and_update_peer_seq(struct drbd_conf *mdev, const u32 peer_s
 {
 	DEFINE_WAIT(wait);
 	long timeout;
-	int ret;
+	int ret = 0, tp;
 
-	if (!need_peer_seq(mdev))
+	if (!test_bit(RESOLVE_CONFLICTS, &mdev->tconn->flags))
 		return 0;
 
 	spin_lock(&mdev->peer_seq_lock);
 	for (;;) {
 		if (!seq_greater(peer_seq - 1, mdev->peer_seq)) {
 			mdev->peer_seq = seq_max(mdev->peer_seq, peer_seq);
-			ret = 0;
 			break;
 		}
+
 		if (signal_pending(current)) {
 			ret = -ERESTARTSYS;
 			break;
 		}
+
+		rcu_read_lock();
+		tp = rcu_dereference(mdev->tconn->net_conf)->two_primaries;
+		rcu_read_unlock();
+
+		if (!tp)
+			break;
+
+		/* Only need to wait if two_primaries is enabled */
 		prepare_to_wait(&mdev->seq_wait, &wait, TASK_INTERRUPTIBLE);
 		spin_unlock(&mdev->peer_seq_lock);
 		rcu_read_lock();
@@ -2228,8 +2219,10 @@ static int receive_Data(struct drbd_tconn *tconn, struct packet_info *pi)
 			}
 			goto out_interrupted;
 		}
-	} else
+	} else {
+		update_peer_seq(mdev, peer_seq);
 		spin_lock_irq(&mdev->tconn->req_lock);
+	}
 	list_add(&peer_req->w.list, &mdev->active_ee);
 	spin_unlock_irq(&mdev->tconn->req_lock);
 
-- 
1.7.9.5

