Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289Ab3LCVY1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 16:24:27 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:58978 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755265Ab3LCVYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 16:24:19 -0500
From: Kent Overstreet <kmo@daterainc.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, Kent Overstreet <kmo@daterainc.com>,
        Chris Mason <clm@fb.com>
Subject: [PATCH 2/2] block: fixup for generic bio chaining
Date: Tue,  3 Dec 2013 13:24:08 -0800
Message-Id: <1386105848-25660-3-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.4.4
In-Reply-To: <1386105848-25660-1-git-send-email-kmo@daterainc.com>
References: <1386105848-25660-1-git-send-email-kmo@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

btrfs bits got lost in the rebase

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Cc: Chris Mason <clm@fb.com>
---
 fs/btrfs/disk-io.c | 2 +-
 fs/btrfs/volumes.c | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 5a10c61..e71039e 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1692,7 +1692,7 @@ static void end_workqueue_fn(struct btrfs_work *work)
 	bio->bi_private = end_io_wq->private;
 	bio->bi_end_io = end_io_wq->end_io;
 	kfree(end_io_wq);
-	bio_endio(bio, error);
+	bio_endio_nodec(bio, error);
 }
 
 static int cleaner_kthread(void *arg)
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f2130de..37972d5 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5297,6 +5297,8 @@ static void btrfs_end_bio(struct bio *bio, int err)
 		if (!is_orig_bio) {
 			bio_put(bio);
 			bio = bbio->orig_bio;
+		} else {
+			atomic_inc(&bio->bi_remaining);
 		}
 		bio->bi_private = bbio->private;
 		bio->bi_end_io = bbio->end_io;
-- 
1.8.4.4

