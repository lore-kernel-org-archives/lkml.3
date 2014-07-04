Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669AbaGDQ16 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 12:27:58 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:42281 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbaGDQ14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 12:27:56 -0400
Date: Fri, 4 Jul 2014 18:27:47 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: Maxim Patlasov <MPatlasov@parallels.com>
Cc: fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Richard Sharpe <realrichardsharpe@gmail.com>
Subject: Re: [PATCH] fuse: avoid scheduling while atomic
Message-ID: <20140704162747.GA14059@tucsk.piliscsaba.szeredi.hu>
References: <20140625121652.1986.75599.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140625121652.1986.75599.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maxim, thanks for the patch.

Here's a reworked one.  While it looks a bit more complicated, its chances of
being (and remaining) correct are, I think, better, since the region surrounded
by kmap/kunmap_atomic is trivially non-sleeping.  This patch also removes more
lines than it adds, as an added bonus.

Please review and test if possible.

Thanks,
Miklos

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
