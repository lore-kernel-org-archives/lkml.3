Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932325Ab3AOWb7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:31:59 -0500
Received: from mail.kernel.org ([198.145.19.201]:42444 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758352Ab3AOWb4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:31:56 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        "Theodore Tso" <tytso@mit.edu>, Zheng Liu <wenqing.lz@taobao.com>
Subject: [ 114/221] ext4: avoid hang when mounting non-journal filesystems with orphan list
Date: Tue, 15 Jan 2013 10:50:41 -0800
Message-Id: <20130115185006.264443151@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Theodore Ts'o <tytso@mit.edu>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/namei.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2498,7 +2498,8 @@ int ext4_orphan_del(handle_t *handle, st
 	struct ext4_iloc iloc;
 	int err = 0;
 
-	if (!EXT4_SB(inode->i_sb)->s_journal)
+	if ((!EXT4_SB(inode->i_sb)->s_journal) &&
+	    !(EXT4_SB(inode->i_sb)->s_mount_state & EXT4_ORPHAN_FS))
 		return 0;
 
 	mutex_lock(&EXT4_SB(inode->i_sb)->s_orphan_lock);


