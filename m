Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509Ab3C0NNU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 09:13:20 -0400
Received: from mail09.linbit.com ([212.69.161.110]:44310 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093Ab3C0NJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 09:09:21 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com, Philipp Reisner <philipp.reisner@linbit.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: [PATCH 07/17] drbd: fix spurious warning about bitmap being locked from detach
Date: Wed, 27 Mar 2013 14:08:39 +0100
Message-Id: <1364389729-17559-8-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364389729-17559-1-git-send-email-philipp.reisner@linbit.com>
References: <1364389729-17559-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduced in drbd: always write bitmap on detach,
the bitmap bulk writeout on detach was indicating
it expected exclusive bitmap access.

Where I meant to say: expect no more modifications,
but testing/counting is still allowed.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_main.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index a150b59..67d2bb3 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -3412,8 +3412,12 @@ static int w_go_diskless(struct drbd_work *w, int unused)
 	 * end up here after a failed attach, before ldev was even assigned.
 	 */
 	if (mdev->bitmap && mdev->ldev) {
+		/* An interrupted resync or similar is allowed to recounts bits
+		 * while we detach.
+		 * Any modifications would not be expected anymore, though.
+		 */
 		if (drbd_bitmap_io_from_worker(mdev, drbd_bm_write,
-					"detach", BM_LOCKED_MASK)) {
+					"detach", BM_LOCKED_TEST_ALLOWED)) {
 			if (test_bit(WAS_READ_ERROR, &mdev->flags)) {
 				drbd_md_set_flag(mdev, MDF_FULL_SYNC);
 				drbd_md_sync(mdev);
-- 
1.7.9.5

