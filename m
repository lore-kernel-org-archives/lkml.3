Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116Ab3JaTib (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 15:38:31 -0400
Received: from dkim1.fusionio.com ([66.114.96.53]:39119 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769Ab3JaTi1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 15:38:27 -0400
X-ASG-Debug-ID: 1383248306-03d6a54d19a7540001-xx1T2L
X-Barracuda-Envelope-From: clmason@fusionio.com
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: Chris Mason <chris.mason@fusionio.com>
CC: <linux-kernel@vger.kernel.org>, <dm-devel@redhat.com>,
        <linux-fsdevel@vger.kernel.org>, Neil Brown <neilb@suse.de>,
        Christoph Hellwig <hch@infradead.org>
User-Agent: alot/0.3.4
To: Kent Overstreet <kmo@daterainc.com>, Jens Axboe <axboe@kernel.dk>
Message-ID: <20131031193820.10239.79827@localhost.localdomain>
Subject: [PATCH] Btrfs: update bi_remaining to relfect our bio endio chaining
Date: Thu, 31 Oct 2013 15:38:20 -0400
X-ASG-Orig-Subj: [PATCH] Btrfs: update bi_remaining to relfect our bio endio chaining
X-Originating-IP: [10.101.1.160]
X-Barracuda-Connect: cas1.int.fusionio.com[10.101.1.40]
X-Barracuda-Start-Time: 1383248306
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.141940
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Btrfs is sometimes calling bio_endio twice on the same bio while
we chain things.  This makes sure we don't trip over new assertions in
fs/bio.c

Signed-off-by: Chris Mason <chris.mason@fusionio.com>

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index 7fcac70..5b30360 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -2289,6 +2289,10 @@ static void btrfsic_bio_end_io(struct bio *bp, int bio_error_status)
 		block = next_block;
 	} while (NULL != block);
 
+	/*
+	 * since we're not using bio_endio here, we don't need to worry about
+	 * the remaining count
+	 */
 	bp->bi_end_io(bp, bio_error_status);
 }
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 62176ad..786ddac 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1684,7 +1684,7 @@ static void end_workqueue_fn(struct btrfs_work *work)
 	bio->bi_private = end_io_wq->private;
 	bio->bi_end_io = end_io_wq->end_io;
 	kfree(end_io_wq);
-	bio_endio(bio, error);
+	bio_endio_nodec(bio, error);
 }
 
 static int cleaner_kthread(void *arg)
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index ef48947..a31448f 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5284,9 +5284,17 @@ static void btrfs_end_bio(struct bio *bio, int err)
 		}
 	}
 
-	if (bio == bbio->orig_bio)
+	if (bio == bbio->orig_bio) {
 		is_orig_bio = 1;
 
+		/*
+		 * eventually we will call the bi_endio for the original bio,
+		 * make sure that we've properly bumped bi_remaining to reflect
+		 * our chain of endios here
+		 */
+		atomic_inc(&bio->bi_remaining);
+	}
+
 	if (atomic_dec_and_test(&bbio->stripes_pending)) {
 		if (!is_orig_bio) {
 			bio_put(bio);
