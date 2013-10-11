Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933308Ab3JKUUL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 16:20:11 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45969 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932218Ab3JKTku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:40:50 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Kent Overstreet <kmo@daterainc.com>,
        Gabriel de Perthuis <g2p.code@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 110/110] bcache: Fix a null ptr deref regression
Date: Fri, 11 Oct 2013 12:39:30 -0700
Message-Id: <20131011193819.774377331@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193807.584188672@linuxfoundation.org>
References: <20131011193807.584188672@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kent Overstreet <kmo@daterainc.com>

commit 2fe80d3bbf1c8bd9efc5b8154207c8dd104e7306 upstream.

Commit c0f04d88e46d ("bcache: Fix flushes in writeback mode") was fixing
a reported data corruption bug, but it seems some last minute
refactoring or rebasing introduced a null pointer deref.

Signed-off-by: Kent Overstreet <kmo@daterainc.com>
Reported-by: Gabriel de Perthuis <g2p.code@gmail.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/bcache/request.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -1055,6 +1055,7 @@ static void request_write(struct cached_
 	} else {
 		trace_bcache_writeback(s->orig_bio);
 		bch_writeback_add(dc, bio_sectors(bio));
+		s->op.cache_bio = bio;
 
 		if (bio->bi_rw & REQ_FLUSH) {
 			/* Also need to send a flush to the backing device */
@@ -1067,8 +1068,6 @@ static void request_write(struct cached_
 			flush->bi_private = cl;
 
 			closure_bio_submit(flush, cl, s->d);
-		} else {
-			s->op.cache_bio = bio;
 		}
 	}
 out:


