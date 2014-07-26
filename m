Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216AbaGZTNY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 15:13:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34331 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754064AbaGZTNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:13:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Richard Sharpe <realrichardsharpe@gmail.com>,
        Miklos Szeredi <mszeredi@suse.cz>
Subject: [PATCH 3.15 011/109] fuse: avoid scheduling while atomic
Date: Sat, 26 Jul 2014 12:01:33 -0700
Message-Id: <20140726190224.165608880@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <20140726190223.834037485@linuxfoundation.org>
References: <20140726190223.834037485@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miklos Szeredi <mszeredi@suse.cz>

commit c55a01d360afafcd52bc405c044a6ebf5de436d5 upstream.

As reported by Richard Sharpe, an attempt to use fuse_notify_inval_entry()
triggers complains about scheduling while atomic:

  BUG: scheduling while atomic: fuse.hf/13976/0x10000001

This happens because fuse_notify_inval_entry() attempts to allocate memory
with GFP_KERNEL, holding "struct fuse_copy_state" mapped by kmap_atomic().

Introduced by commit 58bda1da4b3c "fuse/dev: use atomic maps"

Fix by moving the map/unmap to just cover the actual memcpy operation.

Original patch from Maxim Patlasov <mpatlasov@parallels.com>

Reported-by: Richard Sharpe <realrichardsharpe@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/fuse/dev.c |   51 +++++++++++++++++++++++----------------------------
 1 file changed, 23 insertions(+), 28 deletions(-)

--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -643,9 +643,8 @@ struct fuse_copy_state {
 	unsigned long seglen;
 	unsigned long addr;
 	struct page *pg;
-	void *mapaddr;
-	void *buf;
 	unsigned len;
+	unsigned offset;
 	unsigned move_pages:1;
 };
 
@@ -666,23 +665,17 @@ static void fuse_copy_finish(struct fuse
 	if (cs->currbuf) {
 		struct pipe_buffer *buf = cs->currbuf;
 
-		if (!cs->write) {
-			kunmap_atomic(cs->mapaddr);
-		} else {
-			kunmap_atomic(cs->mapaddr);
+		if (cs->write)
 			buf->len = PAGE_SIZE - cs->len;
-		}
 		cs->currbuf = NULL;
-		cs->mapaddr = NULL;
-	} else if (cs->mapaddr) {
-		kunmap_atomic(cs->mapaddr);
+	} else if (cs->pg) {
 		if (cs->write) {
 			flush_dcache_page(cs->pg);
 			set_page_dirty_lock(cs->pg);
 		}
 		put_page(cs->pg);
-		cs->mapaddr = NULL;
 	}
+	cs->pg = NULL;
 }
 
 /*
@@ -691,7 +684,7 @@ static void fuse_copy_finish(struct fuse
  */
 static int fuse_copy_fill(struct fuse_copy_state *cs)
 {
-	unsigned long offset;
+	struct page *page;
 	int err;
 
 	unlock_request(cs->fc, cs->req);
@@ -706,14 +699,12 @@ static int fuse_copy_fill(struct fuse_co
 
 			BUG_ON(!cs->nr_segs);
 			cs->currbuf = buf;
-			cs->mapaddr = kmap_atomic(buf->page);
+			cs->pg = buf->page;
+			cs->offset = buf->offset;
 			cs->len = buf->len;
-			cs->buf = cs->mapaddr + buf->offset;
 			cs->pipebufs++;
 			cs->nr_segs--;
 		} else {
-			struct page *page;
-
 			if (cs->nr_segs == cs->pipe->buffers)
 				return -EIO;
 
@@ -726,8 +717,8 @@ static int fuse_copy_fill(struct fuse_co
 			buf->len = 0;
 
 			cs->currbuf = buf;
-			cs->mapaddr = kmap_atomic(page);
-			cs->buf = cs->mapaddr;
+			cs->pg = page;
+			cs->offset = 0;
 			cs->len = PAGE_SIZE;
 			cs->pipebufs++;
 			cs->nr_segs++;
@@ -740,14 +731,13 @@ static int fuse_copy_fill(struct fuse_co
 			cs->iov++;
 			cs->nr_segs--;
 		}
-		err = get_user_pages_fast(cs->addr, 1, cs->write, &cs->pg);
+		err = get_user_pages_fast(cs->addr, 1, cs->write, &page);
 		if (err < 0)
 			return err;
 		BUG_ON(err != 1);
-		offset = cs->addr % PAGE_SIZE;
-		cs->mapaddr = kmap_atomic(cs->pg);
-		cs->buf = cs->mapaddr + offset;
-		cs->len = min(PAGE_SIZE - offset, cs->seglen);
+		cs->pg = page;
+		cs->offset = cs->addr % PAGE_SIZE;
+		cs->len = min(PAGE_SIZE - cs->offset, cs->seglen);
 		cs->seglen -= cs->len;
 		cs->addr += cs->len;
 	}
@@ -760,15 +750,20 @@ static int fuse_copy_do(struct fuse_copy
 {
 	unsigned ncpy = min(*size, cs->len);
 	if (val) {
+		void *pgaddr = kmap_atomic(cs->pg);
+		void *buf = pgaddr + cs->offset;
+
 		if (cs->write)
-			memcpy(cs->buf, *val, ncpy);
+			memcpy(buf, *val, ncpy);
 		else
-			memcpy(*val, cs->buf, ncpy);
+			memcpy(*val, buf, ncpy);
+
+		kunmap_atomic(pgaddr);
 		*val += ncpy;
 	}
 	*size -= ncpy;
 	cs->len -= ncpy;
-	cs->buf += ncpy;
+	cs->offset += ncpy;
 	return ncpy;
 }
 
@@ -874,8 +869,8 @@ static int fuse_try_move_page(struct fus
 out_fallback_unlock:
 	unlock_page(newpage);
 out_fallback:
-	cs->mapaddr = kmap_atomic(buf->page);
-	cs->buf = cs->mapaddr + buf->offset;
+	cs->pg = buf->page;
+	cs->offset = buf->offset;
 
 	err = lock_request(cs->fc, cs->req);
 	if (err)


