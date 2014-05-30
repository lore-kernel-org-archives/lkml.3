Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030227AbaE3UFU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 16:05:20 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:58009 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751687AbaE3UFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 16:05:16 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, joseph@codesourcery.com,
        john.stultz@linaro.org, hch@infradead.org, tglx@linutronix.de,
        geert@linux-m68k.org, lftan@altera.com, hpa@zytor.com,
        linux-fsdevel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org
Subject: [RFC 13/32] ext3: convert to struct inode_time
Date: Fri, 30 May 2014 22:01:37 +0200
Message-Id: <1401480116-1973111-14-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:KsBg1RqtWGcuF7ePO9nJjfv/iZruKjuMqSL8y+4WJ9A
 /jzmediKMU3qvrwuXzf59bXIndM/Xi3KF4JP/ogdFVINLqfuqT
 4DWCKF382MWxgvLncTnUabXiM7SoN7gT8DrqTw4wh+xoU6BE8B
 l3o/w7Feg9K6CRBT83S6yu6vBA6hm4eILv7OA6LvFT5Z3pndvZ
 cN4nMjF4pVM98Opu/4ub4LouNTip6E0eOILG08Pc+5JJifIs52
 vtq7j9XCLdzfTbAJw91n1/Z7Cq/7/vhlRvsBgn54fQLqWuF/ar
 PCHT9XsOVvFVxfQSN+XFYN5Asy9voR14Pi+uhL7O6k7Todm0jb
 Obzt7hm8yIPSMNRF0bbG96wINzDGlzwxsZvjUNSG5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ext3fs uses unsigned 32-bit seconds for inode timestamps, which will work
for the next 92 years, but the VFS uses struct timespec for timestamps,
which is only good until 2038 on 32-bit CPUs.

This gets us one small step closer to lifting the VFS limit by using
struct inode_time in ext3. The on-disk format limit is lifted in ext4,
which will work until 2514.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Jan Kara <jack@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: linux-ext4@vger.kernel.org
---
 fs/ext3/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ext3/inode.c b/fs/ext3/inode.c
index 4d32133..8b76f80 100644
--- a/fs/ext3/inode.c
+++ b/fs/ext3/inode.c
@@ -752,7 +752,7 @@ static int ext3_splice_branch(handle_t *handle, struct inode *inode,
 	struct ext3_block_alloc_info *block_i;
 	ext3_fsblk_t current_block;
 	struct ext3_inode_info *ei = EXT3_I(inode);
-	struct timespec now;
+	struct inode_time now;
 
 	block_i = ei->i_block_alloc_info;
 	/*
@@ -793,7 +793,7 @@ static int ext3_splice_branch(handle_t *handle, struct inode *inode,
 
 	/* We are done with atomic stuff, now do the rest of housekeeping */
 	now = CURRENT_TIME_SEC;
-	if (!timespec_equal(&inode->i_ctime, &now) || !where->bh) {
+	if (!inode_time_equal(&inode->i_ctime, &now) || !where->bh) {
 		inode->i_ctime = now;
 		ext3_mark_inode_dirty(handle, inode);
 	}
-- 
1.8.3.2

