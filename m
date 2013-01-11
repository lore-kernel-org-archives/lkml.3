Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804Ab3AKKGp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 05:06:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53870 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754350Ab3AKKGo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 05:06:44 -0500
Date: Fri, 11 Jan 2013 10:06:39 +0000
From: Mel Gorman <mgorman@suse.de>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Tao Ma <boyu.mt@taobao.com>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ext4: Fix memory leak in ext4_init_new_dir
Message-ID: <20130111100639.GA3302@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit a774f9c2 "ext4: make ext4_init_dot_dotdot for inline dir usage"
is a preparation cleanup for later ext4 patches but there was a snag
when moving code to the newly created ext4_init_new_dir() function.
ext4_bread() is called twice but brelse() is only called one leading to a
memory leak. The user-visible effect is that after a compile-orientated
benchmark 0% of memory could be allocated as transparent huge pages.
This patch deletes the extra call and after it is applied, 76% of memory
could be allocated after the same test.

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 fs/ext4/namei.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 8990165..d068885 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2368,7 +2368,6 @@ static int ext4_init_new_dir(handle_t *handle, struct inode *dir,
 	}
 
 	inode->i_size = EXT4_I(inode)->i_disksize = blocksize;
-	dir_block = ext4_bread(handle, inode, 0, 1, &err);
 	if (!(dir_block = ext4_bread(handle, inode, 0, 1, &err))) {
 		if (!err) {
 			err = -EIO;
