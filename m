Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759121Ab3IHDTi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 23:19:38 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56210 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756541Ab3IHDSp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 23:18:45 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Ryusuke Konishi" <konishi.ryusuke@lab.ntt.co.jp>,
        "Dan Carpenter" <dan.carpenter@oracle.com>,
        "Vyacheslav Dubeyko" <slava@dubeyko.com>
Date: Sun, 08 Sep 2013 03:52:01 +0100
Message-ID: <lsq.1378608721.460181979@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [088/121] nilfs2: fix issue with counting number of bio requests
 for BIO_EOPNOTSUPP error detection
In-Reply-To: <lsq.1378608720.401499712@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.51-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Vyacheslav Dubeyko <slava@dubeyko.com>

commit 4bf93b50fd04118ac7f33a3c2b8a0a1f9fa80bc9 upstream.

Fix the issue with improper counting number of flying bio requests for
BIO_EOPNOTSUPP error detection case.

The sb_nbio must be incremented exactly the same number of times as
complete() function was called (or will be called) because
nilfs_segbuf_wait() will call wail_for_completion() for the number of
times set to sb_nbio:

  do {
      wait_for_completion(&segbuf->sb_bio_event);
  } while (--segbuf->sb_nbio > 0);

Two functions complete() and wait_for_completion() must be called the
same number of times for the same sb_bio_event.  Otherwise,
wait_for_completion() will hang or leak.

Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Tested-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/nilfs2/segbuf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/nilfs2/segbuf.c
+++ b/fs/nilfs2/segbuf.c
@@ -376,12 +376,12 @@ static int nilfs_segbuf_submit_bio(struc
 	bio->bi_private = segbuf;
 	bio_get(bio);
 	submit_bio(mode, bio);
+	segbuf->sb_nbio++;
 	if (bio_flagged(bio, BIO_EOPNOTSUPP)) {
 		bio_put(bio);
 		err = -EOPNOTSUPP;
 		goto failed;
 	}
-	segbuf->sb_nbio++;
 	bio_put(bio);
 
 	wi->bio = NULL;

