Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597AbbALLop (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 06:44:45 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:42046 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466AbbALLon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 06:44:43 -0500
From: Dongsu Park <dongsu.park@profitbricks.com>
To: linux-kernel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, Kent Overstreet <kmo@daterainc.com>,
        Jens Axboe <axboe@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org,
        Dongsu Park <dongsu.park@profitbricks.com>
Subject: [PATCH v2 6/7] fs: make _submit_bh consistent with generic bio chaining
Date: Mon, 12 Jan 2015 12:44:03 +0100
Message-Id: <962e0fd9683e2d523cadf8036769dfbaf3b21e77.1421052656.git.dongsu.park@profitbricks.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <9ef99a9bae03003ae7b2fff1bf942e63aff6e45a.1421052656.git.dongsu.park@profitbricks.com>
References: <cover.1421052656.git.dongsu.park@profitbricks.com>
 <19cceed4e701430bfb307301a38cdf8d40fbfcac.1421052656.git.dongsu.park@profitbricks.com>
 <0bdbbd2ef9d449be2d00e01ca7dc7f101b6cfb88.1421052656.git.dongsu.park@profitbricks.com>
 <0117035a25929ae97e2039edc895f582d53cf217.1421052656.git.dongsu.park@profitbricks.com>
 <63ea4e86f2a06cbe273692932bdf2499fef01644.1421052656.git.dongsu.park@profitbricks.com>
 <9ef99a9bae03003ae7b2fff1bf942e63aff6e45a.1421052656.git.dongsu.park@profitbricks.com>
In-Reply-To: <cover.1421052656.git.dongsu.park@profitbricks.com>
References: <cover.1421052656.git.dongsu.park@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kent Overstreet <kmo@daterainc.com>

Make _submit_bh() handle refcounting by increasing bio->bi_remaining,
followed by bio_endio(). Since bio chaining was introduced with
196d38bccfcf ("block: Generic bio chaining"), refcounting should be
done on bi_remaining instead of ancient bio_cnt. Doing that, calling
convention can be consistent with the immutable biovecs API.

Cc: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Kent Overstreet <kmo@daterainc.com>
[dpark: add more description in commit message]
Signed-off-by: Dongsu Park <dongsu.park@profitbricks.com>
---
 fs/buffer.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 20805db..dbe5699 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -3041,13 +3041,13 @@ int _submit_bh(int rw, struct buffer_head *bh, unsigned long bio_flags)
 	if (buffer_prio(bh))
 		rw |= REQ_PRIO;
 
-	bio_get(bio);
+	atomic_inc(&bio->bi_remaining);
 	submit_bio(rw, bio);
 
 	if (bio_flagged(bio, BIO_EOPNOTSUPP))
 		ret = -EOPNOTSUPP;
 
-	bio_put(bio);
+	bio_endio(bio, 0);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(_submit_bh);
-- 
2.1.0

