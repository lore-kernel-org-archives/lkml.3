Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756303Ab3ETLK4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 07:10:56 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56189 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756166Ab3ETKxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 06:53:13 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Philipp Reisner <philipp.reisner@linbit.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        Jens Axboe <axboe@kernel.dk>, Jonghwan Choi <jhbird.choi@samsung.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 057/115] drbd: fix for deadlock when using automatic split-brain-recovery
Date: Mon, 20 May 2013 11:50:57 +0100
Message-Id: <1369047116-9378-58-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
References: <1369047116-9378-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philipp Reisner <philipp.reisner@linbit.com>

commit 7c689e63a847316c1b2500f86891b0a574ce7e69 upstream.

With an automatic after split-brain recovery policy of
"after-sb-1pri call-pri-lost-after-sb",
when trying to drbd_set_role() to R_SECONDARY,
we run into a deadlock.

This was first recognized and supposedly fixed by
2009-06-10 "Fixed a deadlock when using automatic split brain recovery when both nodes are"
replacing drbd_set_role() with drbd_change_state() in that code-path,
but the first hunk of that patch forgets to remove the drbd_set_role().

We apparently only ever tested the "two primaries" case.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/block/drbd/drbd_receiver.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index ea4836e..e81cc53 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -2260,7 +2260,6 @@ static int drbd_asb_recover_1p(struct drbd_conf *mdev) __must_hold(local)
 		if (hg == -1 && mdev->state.role == R_PRIMARY) {
 			enum drbd_state_rv rv2;
 
-			drbd_set_role(mdev, R_SECONDARY, 0);
 			 /* drbd_change_state() does not sleep while in SS_IN_TRANSIENT_STATE,
 			  * we might be here in C_WF_REPORT_PARAMS which is transient.
 			  * we do not need to wait for the after state change work either. */
-- 
1.8.1.2

