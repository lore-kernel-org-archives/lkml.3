Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932745Ab3FRLrJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 07:47:09 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56340 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932661Ab3FRLpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 07:45:34 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 92/93] ext4: lock i_mutex when truncating orphan inodes
Date: Tue, 18 Jun 2013 12:43:40 +0100
Message-Id: <1371555821-12820-93-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
References: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/ext4/super.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index df4b8db..89abdd7 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2208,7 +2208,9 @@ static void ext4_orphan_cleanup(struct super_block *sb,
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
1.8.1.2

