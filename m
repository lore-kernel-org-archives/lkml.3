Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758650Ab3JKTix (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 15:38:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45434 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758376Ab3JKThc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:37:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Theodore Tso" <tytso@mit.edu>, Zheng Liu <wenqing.lz@taobao.com>,
        Jan Kara <jack@suse.cz>
Subject: [ 48/48] ext4: avoid hang when mounting non-journal filesystems with orphan list
Date: Fri, 11 Oct 2013 12:36:55 -0700
Message-Id: <20131011193642.442583175@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193637.253208688@linuxfoundation.org>
References: <20131011193637.253208688@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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

-js: This is a fix for CVE-2013-2015.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Reviewed-by: Zheng Liu <wenqing.lz@taobao.com>
Acked-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/namei.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -2054,7 +2054,8 @@ int ext4_orphan_del(handle_t *handle, st
 	int err = 0;
 
 	/* ext4_handle_valid() assumes a valid handle_t pointer */
-	if (handle && !ext4_handle_valid(handle))
+	if (handle && !ext4_handle_valid(handle) &&
+	    !(EXT4_SB(inode->i_sb)->s_mount_state & EXT4_ORPHAN_FS))
 		return 0;
 
 	mutex_lock(&EXT4_SB(inode->i_sb)->s_orphan_lock);


