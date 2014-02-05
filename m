Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935AbaBEUT5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:19:57 -0500
Received: from mail.windriver.com ([147.11.1.11]:55523 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932366AbaBEUHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:07:44 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: "Theodore Ts'o" <tytso@mit.edu>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 182/213] ext4: avoid hang when mounting non-journal filesystems with orphan list
Date: Wed, 5 Feb 2014 15:02:17 -0500
Message-ID: <1391630568-49251-183-git-send-email-paul.gortmaker@windriver.com>
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

commit 0e9a9a1ad619e7e987815d20262d36a2f95717ca upstream.

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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/ext4/namei.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index d64e5f4f12ed..f501bdf9d4c1 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2081,7 +2081,8 @@ int ext4_orphan_del(handle_t *handle, struct inode *inode)
 	struct ext4_iloc iloc;
 	int err = 0;
 
-	if (!EXT4_SB(inode->i_sb)->s_journal)
+	if ((!EXT4_SB(inode->i_sb)->s_journal) &&
+	    !(EXT4_SB(inode->i_sb)->s_mount_state & EXT4_ORPHAN_FS))
 		return 0;
 
 	mutex_lock(&EXT4_SB(inode->i_sb)->s_orphan_lock);
-- 
1.8.5.2

