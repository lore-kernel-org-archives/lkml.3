Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933544Ab3CSRUG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 13:20:06 -0400
Received: from mail09.linbit.com ([212.69.161.110]:44642 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933296Ab3CSRRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 13:17:05 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, drbd-dev@lists.linbit.com,
        lars.ellenberg@linbit.com
Subject: [PATCH 08/18] drbd: drbd_al_being_io: short circuit to reduce latency
Date: Tue, 19 Mar 2013 18:16:49 +0100
Message-Id: <1363713419-17803-9-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1363713419-17803-1-git-send-email-philipp.reisner@linbit.com>
References: <1363713419-17803-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars Ellenberg <lars.ellenberg@linbit.com>

A request hitting an already "hot" extent should proceed right away,
even if some other requests need to wait for pending transactions.

Without that short-circuit, several simultaneous make_request contexts
race for committing the transaction, possibly penalizing the innocent.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_actlog.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/block/drbd/drbd_actlog.c b/drivers/block/drbd/drbd_actlog.c
index 82199d9..1d7244d 100644
--- a/drivers/block/drbd/drbd_actlog.c
+++ b/drivers/block/drbd/drbd_actlog.c
@@ -256,6 +256,7 @@ void drbd_al_begin_io(struct drbd_conf *mdev, struct drbd_interval *i, bool dele
 	unsigned first = i->sector >> (AL_EXTENT_SHIFT-9);
 	unsigned last = i->size == 0 ? first : (i->sector + (i->size >> 9) - 1) >> (AL_EXTENT_SHIFT-9);
 	unsigned enr;
+	bool need_transaction = false;
 	bool locked = false;
 
 	/* When called through generic_make_request(), we must delegate
@@ -273,8 +274,17 @@ void drbd_al_begin_io(struct drbd_conf *mdev, struct drbd_interval *i, bool dele
 	D_ASSERT(first <= last);
 	D_ASSERT(atomic_read(&mdev->local_cnt) > 0);
 
-	for (enr = first; enr <= last; enr++)
-		wait_event(mdev->al_wait, _al_get(mdev, enr) != NULL);
+	for (enr = first; enr <= last; enr++) {
+		struct lc_element *al_ext;
+		wait_event(mdev->al_wait, (al_ext = _al_get(mdev, enr)) != NULL);
+		if (al_ext->lc_number != enr)
+			need_transaction = true;
+	}
+
+	/* If *this* request was to an already active extent,
+	 * we're done, even if there are pending changes. */
+	if (!need_transaction)
+		return;
 
 	/* Serialize multiple transactions.
 	 * This uses test_and_set_bit, memory barrier is implicit.
-- 
1.7.9.5

