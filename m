Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273Ab3H0BO5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 21:14:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59538 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512Ab3H0BH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 21:07:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Vyacheslav Dubeyko <slava@dubeyko.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 55/74] nilfs2: fix issue with counting number of bio requests for BIO_EOPNOTSUPP error detection
Date: Mon, 26 Aug 2013 18:08:53 -0700
Message-Id: <20130827010435.757266752@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130827010424.535365435@linuxfoundation.org>
References: <20130827010424.535365435@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nilfs2/segbuf.c |    2 +-
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


