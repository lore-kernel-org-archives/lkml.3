Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875Ab3FDXH6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 19:07:58 -0400
Received: from 1wt.eu ([62.212.114.60]:35541 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753014Ab3FDWmn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:42:43 -0400
Message-Id: <20130604172135.779070691@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:23:42 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: "Theodore Tso" <tytso@mit.edu>, Willy Tarreau <w@1wt.eu>
Subject: [ 132/184] ext4: avoid hang when mounting non-journal
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 filesystems with orphan list

From: Theodore Ts'o <tytso@mit.edu>

When trying to mount a file system which does not contain a journal,
but which does have a orphan list containing an inode which needs to
be truncated, the mount call with hang forever in
ext4_orphan_cleanup() because ext4_orphan_del() will return
immediately without removing the inode from the orphan list, leading
to an uninterruptible loop in kernel code which will busy out one of
the CPU's on the system.

This can be trivially reproduced by trying to mount the file system
found in tests/f_orphan_extents_inode/image.gz from the e2fsprogs
source tree.  If a malicious user were to put this on a USB stick, and
mount it on a Linux desktop which has automatic mounts enabled, this
could be considered a potential denial of service attack.  (Not a big
deal in practice, but professional paranoids worry about such things,
and have even been known to allocate CVE numbers for such problems.)

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
Cc: stable@vger.kernel.org
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 fs/ext4/namei.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 230bef5..3a1af19 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2082,7 +2082,8 @@ int ext4_orphan_del(handle_t *handle, struct inode *inode)
 	struct ext4_iloc iloc;
 	int err = 0;
 
-	if (!EXT4_SB(inode->i_sb)->s_journal)
+	if ((!EXT4_SB(inode->i_sb)->s_journal) &&
+	    !(EXT4_SB(inode->i_sb)->s_mount_state & EXT4_ORPHAN_FS))
 		return 0;
 
 	mutex_lock(&EXT4_SB(inode->i_sb)->s_orphan_lock);
-- 
1.7.12.2.21.g234cd45.dirty



