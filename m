Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757083Ab3IMPUY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 11:20:24 -0400
Received: from relay.parallels.com ([195.214.232.42]:38161 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756760Ab3IMPUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 11:20:22 -0400
Subject: [PATCH 2/2] fuse: fix fallocate vs. ftruncate race
To: miklos@szeredi.hu
From: Maxim Patlasov <MPatlasov@parallels.com>
Cc: fuse-devel@lists.sourceforge.net, bfoster@redhat.com,
        linux-kernel@vger.kernel.org, devel@openvz.org, xemul@parallels.com
Date: Fri, 13 Sep 2013 19:20:16 +0400
Message-ID: <20130913152002.11415.39610.stgit@dhcp-10-30-17-2.sw.ru>
In-Reply-To: <20130913151928.11415.44205.stgit@dhcp-10-30-17-2.sw.ru>
References: <20130913151928.11415.44205.stgit@dhcp-10-30-17-2.sw.ru>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A former patch introducing FUSE_I_SIZE_UNSTABLE flag provided detailed
description of races between ftruncate and anyone who can extend i_size:

> 1. As in the previous scenario fuse_dentry_revalidate() discovered that i_size
> changed (due to our own fuse_do_setattr()) and is going to call
> truncate_pagecache() for some  'new_size' it believes valid right now. But by
> the time that particular truncate_pagecache() is called ...
> 2. fuse_do_setattr() returns (either having called truncate_pagecache() or
> not -- it doesn't matter).
> 3. The file is extended either by write(2) or ftruncate(2) or fallocate(2).
> 4. mmap-ed write makes a page in the extended region dirty.

This patch adds necessary bits to fuse_file_fallocate() to protect from that
race.

Signed-off-by: Maxim Patlasov <mpatlasov@parallels.com>
---
 fs/fuse/file.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/fuse/file.c b/fs/fuse/file.c
index f9f07c4..4598345 100644
--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -2467,6 +2467,7 @@ static long fuse_file_fallocate(struct file *file, int mode, loff_t offset,
 {
 	struct fuse_file *ff = file->private_data;
 	struct inode *inode = file->f_inode;
+	struct fuse_inode *fi = get_fuse_inode(inode);
 	struct fuse_conn *fc = ff->fc;
 	struct fuse_req *req;
 	struct fuse_fallocate_in inarg = {
@@ -2495,6 +2496,9 @@ static long fuse_file_fallocate(struct file *file, int mode, loff_t offset,
 		}
 	}
 
+	if (!(mode & FALLOC_FL_KEEP_SIZE))
+		set_bit(FUSE_I_SIZE_UNSTABLE, &fi->state);
+
 	req = fuse_get_req_nopages(fc);
 	if (IS_ERR(req)) {
 		err = PTR_ERR(req);
@@ -2527,6 +2531,9 @@ static long fuse_file_fallocate(struct file *file, int mode, loff_t offset,
 	fuse_invalidate_attr(inode);
 
 out:
+	if (!(mode & FALLOC_FL_KEEP_SIZE))
+		clear_bit(FUSE_I_SIZE_UNSTABLE, &fi->state);
+
 	if (lock_inode)
 		mutex_unlock(&inode->i_mutex);
 

