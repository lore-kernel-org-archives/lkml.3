Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753915Ab3C0NJX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 09:09:23 -0400
Received: from mail09.linbit.com ([212.69.161.110]:44229 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab3C0NJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 09:09:19 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com, Philipp Reisner <philipp.reisner@linbit.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: [PATCH 03/17] drbd: abort start of resync early, if it raced with connection breakage
Date: Wed, 27 Mar 2013 14:08:35 +0100
Message-Id: <1364389729-17559-4-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364389729-17559-1-git-send-email-philipp.reisner@linbit.com>
References: <1364389729-17559-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've seen a spurious full resync, because a connection breakage
raced with drbd_start_resync(, C_SYNC_TARGET),
and the resulting state change request intended to start the resync
ended up looking like a local invalidate.

Fix:
Double check the state inside the lock,
and don't even request that state change,
if we had connection or IO problems.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_worker.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index f41e224..7f51f88 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -1653,7 +1653,9 @@ void drbd_start_resync(struct drbd_conf *mdev, enum drbd_conns side)
 	clear_bit(B_RS_H_DONE, &mdev->flags);
 
 	write_lock_irq(&global_state_lock);
-	if (!get_ldev_if_state(mdev, D_NEGOTIATING)) {
+	/* Did some connection breakage or IO error race with us? */
+	if (mdev->state.conn < C_CONNECTED
+	|| !get_ldev_if_state(mdev, D_NEGOTIATING)) {
 		write_unlock_irq(&global_state_lock);
 		mutex_unlock(mdev->state_mutex);
 		return;
-- 
1.7.9.5

