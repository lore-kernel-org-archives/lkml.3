Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024Ab3FYOuQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 10:50:16 -0400
Received: from mail09.linbit.com ([212.69.161.110]:50484 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401Ab3FYOuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 10:50:13 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 1/6] drbd: Do not sleep inside rcu
Date: Tue, 25 Jun 2013 16:50:03 +0200
Message-Id: <1372171808-30515-2-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1372171808-30515-1-git-send-email-philipp.reisner@linbit.com>
References: <1372171808-30515-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Andreas Gruenbacher <agruen@linbit.com>
---
 drivers/block/drbd/drbd_receiver.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 4222aff..adee58e 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -1039,6 +1039,8 @@ randomize:
 	rcu_read_lock();
 	idr_for_each_entry(&tconn->volumes, mdev, vnr) {
 		kref_get(&mdev->kref);
+		rcu_read_unlock();
+
 		/* Prevent a race between resync-handshake and
 		 * being promoted to Primary.
 		 *
@@ -1049,8 +1051,6 @@ randomize:
 		mutex_lock(mdev->state_mutex);
 		mutex_unlock(mdev->state_mutex);
 
-		rcu_read_unlock();
-
 		if (discard_my_data)
 			set_bit(DISCARD_MY_DATA, &mdev->flags);
 		else
-- 
1.7.9.5

