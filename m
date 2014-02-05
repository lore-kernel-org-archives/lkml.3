Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370AbaBEUIL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:08:11 -0500
Received: from mail.windriver.com ([147.11.1.11]:55488 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755253AbaBEUHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:07:40 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: "Theodore Ts'o" <tytso@mit.edu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 178/213] ext4: lock i_mutex when truncating orphan inodes
Date: Wed, 5 Feb 2014 15:02:13 -0500
Message-ID: <1391630568-49251-179-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
References: <1391630568-49251-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 721e3eba21e43532e438652dd8f1fcdfce3187e7 upstream.

Commit c278531d39 added a warning when ext4_flush_unwritten_io() is
called without i_mutex being taken.  It had previously not been taken
during orphan cleanup since races weren't possible at that point in
the mount process, but as a result of this c278531d39, we will now see
a kernel WARN_ON in this case.  Take the i_mutex in
ext4_orphan_cleanup() to suppress this warning.

Reported-by: Alexander Beregalov <a.beregalov@gmail.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/ext4/super.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 6928d5ad2c0d..90906948e242 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2028,7 +2028,9 @@ static void ext4_orphan_cleanup(struct super_block *sb,
 				__func__, inode->i_ino, inode->i_size);
 			jbd_debug(2, "truncating inode %lu to %lld bytes\n",
 				  inode->i_ino, inode->i_size);
+			mutex_lock(&inode->i_mutex);
 			ext4_truncate(inode);
+			mutex_unlock(&inode->i_mutex);
 			nr_truncates++;
 		} else {
 			ext4_msg(sb, KERN_DEBUG,
-- 
1.8.5.2

