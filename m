Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180Ab3ENBXV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 21:23:21 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:43136 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755829Ab3ENBTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 21:19:19 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org
Cc: akpm@linux-foundation.org, Kent Overstreet <koverstreet@google.com>,
        Zach Brown <zab@redhat.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        Rusty Russell <rusty@rustcorp.com.au>, Jens Axboe <axboe@kernel.dk>,
        Asai Thambi S P <asamymuthupa@micron.com>,
        Selvan Mani <smani@micron.com>, Sam Bradshaw <sbradshaw@micron.com>,
        Jeff Moyer <jmoyer@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Benjamin LaHaise <bcrl@kvack.org>, "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 11/21] aio: Kill ki_dtor
Date: Mon, 13 May 2013 18:18:48 -0700
Message-Id: <1368494338-7069-12-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1368494338-7069-1-git-send-email-koverstreet@google.com>
References: <1368494338-7069-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sock_aio_dtor() is dead code - and stuff that does need to do cleanup
can simply do it before calling aio_complete().

Signed-off-by: Kent Overstreet <koverstreet@google.com>
Cc: Zach Brown <zab@redhat.com>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Asai Thambi S P <asamymuthupa@micron.com>
Cc: Selvan Mani <smani@micron.com>
Cc: Sam Bradshaw <sbradshaw@micron.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Benjamin LaHaise <bcrl@kvack.org>
Cc: Theodore Ts'o <tytso@mit.edu>
---
 fs/aio.c            |  2 --
 include/linux/aio.h |  1 -
 net/socket.c        | 13 ++-----------
 3 files changed, 2 insertions(+), 14 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 40781ff..7ce3cd8 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -619,8 +619,6 @@ static void kiocb_free(struct kiocb *req)
 		fput(req->ki_filp);
 	if (req->ki_eventfd != NULL)
 		eventfd_ctx_put(req->ki_eventfd);
-	if (req->ki_dtor)
-		req->ki_dtor(req);
 	kmem_cache_free(kiocb_cachep, req);
 }
 
diff --git a/include/linux/aio.h b/include/linux/aio.h
index c4f07ff..d9c92da 100644
--- a/include/linux/aio.h
+++ b/include/linux/aio.h
@@ -33,7 +33,6 @@ struct kiocb {
 	struct file		*ki_filp;
 	struct kioctx		*ki_ctx;	/* NULL for sync ops */
 	kiocb_cancel_fn		*ki_cancel;
-	void			(*ki_dtor)(struct kiocb *);
 	void			*private;
 
 	union {
diff --git a/net/socket.c b/net/socket.c
index bfe9fab..fc3bf4c 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -848,11 +848,6 @@ int kernel_recvmsg(struct socket *sock, struct msghdr *msg,
 }
 EXPORT_SYMBOL(kernel_recvmsg);
 
-static void sock_aio_dtor(struct kiocb *iocb)
-{
-	kfree(iocb->private);
-}
-
 static ssize_t sock_sendpage(struct file *file, struct page *page,
 			     int offset, size_t size, loff_t *ppos, int more)
 {
@@ -883,12 +878,8 @@ static ssize_t sock_splice_read(struct file *file, loff_t *ppos,
 static struct sock_iocb *alloc_sock_iocb(struct kiocb *iocb,
 					 struct sock_iocb *siocb)
 {
-	if (!is_sync_kiocb(iocb)) {
-		siocb = kmalloc(sizeof(*siocb), GFP_KERNEL);
-		if (!siocb)
-			return NULL;
-		iocb->ki_dtor = sock_aio_dtor;
-	}
+	if (!is_sync_kiocb(iocb))
+		BUG();
 
 	siocb->kiocb = iocb;
 	iocb->private = siocb;
-- 
1.8.2.1

