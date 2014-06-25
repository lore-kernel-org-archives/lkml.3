Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756617AbaFYMRe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 08:17:34 -0400
Received: from relay.parallels.com ([195.214.232.42]:49608 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756455AbaFYMRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 08:17:31 -0400
Subject: [PATCH] fuse: avoid scheduling while atomic
To: miklos@szeredi.hu
From: Maxim Patlasov <MPatlasov@parallels.com>
Cc: fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Date: Wed, 25 Jun 2014 16:17:29 +0400
Message-ID: <20140625121652.1986.75599.stgit@localhost.localdomain>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As reported by Richard Sharpe, an attempt to use fuse_notify_inval_entry()
triggers complains about scheduling while atomic:

> Jun 23 11:53:24 localhost kernel: BUG: scheduling while atomic:
fuse.hf/13976/0x10000001

This happens because fuse_notify_inval_entry() attempts to allocate memory
with GFP_KERNEL, holding "struct fuse_copy_state" mapped by kmap_atomic().

The patch fixes the problem for fuse_notify_inval_entry() and other notifiers
by unmapping fuse_copy_state before allocations and remapping it again
afterwards.

Reported-by: Richard Sharpe <realrichardsharpe@gmail.com>
Signed-off-by: Maxim Patlasov <mpatlasov@parallels.com>
---
 fs/fuse/dev.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 098f97b..502aa1d 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -755,6 +755,22 @@ static int fuse_copy_fill(struct fuse_copy_state *cs)
 	return lock_request(cs->fc, cs->req);
 }
 
+static void fuse_copy_unmap(struct fuse_copy_state *cs)
+{
+	cs->buf = (void *)(cs->buf - cs->mapaddr);
+	kunmap_atomic(cs->mapaddr);
+}
+
+static void fuse_copy_remap(struct fuse_copy_state *cs)
+{
+	if (cs->currbuf)
+		cs->mapaddr = kmap_atomic(cs->currbuf->page);
+	else
+		cs->mapaddr = kmap_atomic(cs->pg);
+
+	cs->buf = (unsigned long)cs->buf + cs->mapaddr;
+}
+
 /* Do as much copy to/from userspace buffer as we can */
 static int fuse_copy_do(struct fuse_copy_state *cs, void **val, unsigned *size)
 {
@@ -1431,7 +1447,9 @@ static int fuse_notify_inval_entry(struct fuse_conn *fc, unsigned int size,
 	char *buf;
 	struct qstr name;
 
+	fuse_copy_unmap(cs);
 	buf = kzalloc(FUSE_NAME_MAX + 1, GFP_KERNEL);
+	fuse_copy_remap(cs);
 	if (!buf)
 		goto err;
 
@@ -1482,7 +1500,9 @@ static int fuse_notify_delete(struct fuse_conn *fc, unsigned int size,
 	char *buf;
 	struct qstr name;
 
+	fuse_copy_unmap(cs);
 	buf = kzalloc(FUSE_NAME_MAX + 1, GFP_KERNEL);
+	fuse_copy_remap(cs);
 	if (!buf)
 		goto err;
 
@@ -1554,6 +1574,7 @@ static int fuse_notify_store(struct fuse_conn *fc, unsigned int size,
 
 	nodeid = outarg.nodeid;
 
+	fuse_copy_unmap(cs);
 	down_read(&fc->killsb);
 
 	err = -ENOENT;
@@ -1586,7 +1607,9 @@ static int fuse_notify_store(struct fuse_conn *fc, unsigned int size,
 			goto out_iput;
 
 		this_num = min_t(unsigned, num, PAGE_CACHE_SIZE - offset);
+		fuse_copy_remap(cs);
 		err = fuse_copy_page(cs, &page, offset, this_num, 0);
+		fuse_copy_unmap(cs);
 		if (!err && offset == 0 &&
 		    (this_num == PAGE_CACHE_SIZE || file_size == end))
 			SetPageUptodate(page);
@@ -1607,6 +1630,7 @@ out_iput:
 	iput(inode);
 out_up_killsb:
 	up_read(&fc->killsb);
+	fuse_copy_remap(cs);
 out_finish:
 	fuse_copy_finish(cs);
 	return err;

