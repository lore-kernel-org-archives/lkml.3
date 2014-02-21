Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932948AbaBUM7r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 07:59:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47230 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932518AbaBUMv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 07:51:29 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jens Axboe <axboe@fb.com>, Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 100/121] block: add cond_resched() to potentially long running ioctl discard loop
Date: Fri, 21 Feb 2014 12:48:44 +0000
Message-Id: <1392986945-9693-101-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
References: <1392986945-9693-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@fb.com>

commit c8123f8c9cb517403b51aa41c3c46ff5e10b2c17 upstream.

When mkfs issues a full device discard and the device only
supports discards of a smallish size, we can loop in
blkdev_issue_discard() for a long time. If preempt isn't enabled,
this can turn into a softlock situation and the kernel will
start complaining.

Add an explicit cond_resched() at the end of the loop to avoid
that.

Signed-off-by: Jens Axboe <axboe@fb.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 block/blk-lib.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index d6f50d5..9a32f58 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -121,6 +121,14 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 
 		atomic_inc(&bb.done);
 		submit_bio(type, bio);
+
+		/*
+		 * We can loop for a long time in here, if someone does
+		 * full device discards (like mkfs). Be nice and allow
+		 * us to schedule out to avoid softlocking if preempt
+		 * is disabled.
+		 */
+		cond_resched();
 	}
 	blk_finish_plug(&plug);
 
-- 
1.9.0

