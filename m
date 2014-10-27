Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753045AbaJ0Msz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 08:48:55 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:57015 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbaJ0Msw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 08:48:52 -0400
Date: Mon, 27 Oct 2014 13:48:48 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-unionfs@vger.kernel.org
Subject: Re: [PATCH] ovl: fix check for cursor
Message-ID: <20141027124848.GB3021@tucsk.piliscsaba.szeredi.hu>
References: <20141027124315.GA3021@tucsk.piliscsaba.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141027124315.GA3021@tucsk.piliscsaba.szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

D'oh, I must remember to review own patches *before* sending them, not after...

Here's an updated one.

Thanks,
Miklos
---

Subject: ovl: fix check for cursor
From: Miklos Szeredi <mszeredi@suse.cz>

ovl_cache_entry.name is now an array not a pointer, so it makes no sense
test for it being NULL.

Detected by coverity.

Fixes: 68bf8611076a ("overlayfs: make ovl_cache_entry->name an array instead of pointer")
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/overlayfs/readdir.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -21,9 +21,10 @@ struct ovl_cache_entry {
 	unsigned int len;
 	unsigned int type;
 	u64 ino;
-	bool is_whiteout;
 	struct list_head l_node;
 	struct rb_node node;
+	bool is_whiteout;
+	bool is_cursor;
 	char name[];
 };
 
@@ -251,7 +252,7 @@ static int ovl_dir_mark_whiteouts(struct
 
 	mutex_lock(&dir->d_inode->i_mutex);
 	list_for_each_entry(p, rdd->list, l_node) {
-		if (!p->name)
+		if (p->is_cursor)
 			continue;
 
 		if (p->type != DT_CHR)
@@ -307,7 +308,6 @@ static inline int ovl_dir_read_merged(st
 	}
 out:
 	return err;
-
 }
 
 static void ovl_seek_cursor(struct ovl_dir_file *od, loff_t pos)
@@ -316,7 +316,7 @@ static void ovl_seek_cursor(struct ovl_d
 	loff_t off = 0;
 
 	list_for_each_entry(p, &od->cache->entries, l_node) {
-		if (!p->name)
+		if (p->is_cursor)
 			continue;
 		if (off >= pos)
 			break;
@@ -389,7 +389,7 @@ static int ovl_iterate(struct file *file
 
 		p = list_entry(od->cursor.l_node.next, struct ovl_cache_entry, l_node);
 		/* Skip cursors */
-		if (p->name) {
+		if (!p->is_cursor) {
 			if (!p->is_whiteout) {
 				if (!dir_emit(ctx, p->name, p->len, p->ino, p->type))
 					break;
@@ -518,6 +518,7 @@ static int ovl_dir_open(struct inode *in
 	od->realfile = realfile;
 	od->is_real = (type != OVL_PATH_MERGE);
 	od->is_upper = (type != OVL_PATH_LOWER);
+	od->cursor.is_cursor = true;
 	file->private_data = od;
 
 	return 0;
