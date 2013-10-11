Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962Ab3JKAc7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 20:32:59 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:51236 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173Ab3JKAc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 20:32:56 -0400
From: Kent Overstreet <kmo@daterainc.com>
To: torvalds@linux-foundation.org, axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        Kent Overstreet <kmo@daterainc.com>
Subject: [PATCH] bcache: Fix a null ptr deref regression
Date: Thu, 10 Oct 2013 17:31:15 -0700
Message-Id: <1381451475-24551-2-git-send-email-kmo@daterainc.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1381451475-24551-1-git-send-email-kmo@daterainc.com>
References: <1381451475-24551-1-git-send-email-kmo@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

c0f04d8 was fixing a reported data corruption bug, but it seems some
last minute refactoring or rebasing introduced a null pointer deref.

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Cc: linux-stable <stable@vger.kernel.org> # >= v3.10
Reported-by: Gabriel de Perthuis <g2p.code@gmail.com>
---
 drivers/md/bcache/request.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index 71eb233..b6a74bc 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -996,6 +996,7 @@ static void request_write(struct cached_dev *dc, struct search *s)
 		closure_bio_submit(bio, cl, s->d);
 	} else {
 		bch_writeback_add(dc);
+		s->op.cache_bio = bio;
 
 		if (bio->bi_rw & REQ_FLUSH) {
 			/* Also need to send a flush to the backing device */
@@ -1008,8 +1009,6 @@ static void request_write(struct cached_dev *dc, struct search *s)
 			flush->bi_private = cl;
 
 			closure_bio_submit(flush, cl, s->d);
-		} else {
-			s->op.cache_bio = bio;
 		}
 	}
 out:
-- 
1.8.4.rc3

