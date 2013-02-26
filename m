Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760632Ab3B0AdC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 19:33:02 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42422 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933351Ab3BZX64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:58:56 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Tao Ma <boyu.mt@taobao.com>, "Theodore Tso" <tytso@mit.edu>,
        Jeff Mahoney <jeffm@suse.com>
Subject: [ 27/53] ext4: Free resources in some error path in ext4_fill_super
Date: Tue, 26 Feb 2013 15:57:56 -0800
Message-Id: <20130226235622.656780605@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235619.844721947@linuxfoundation.org>
References: <20130226235619.844721947@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tao Ma <boyu.mt@taobao.com>

commit dcf2d804ed6ffe5e942b909ed5e5b74628be6ee4 upstream.

Some of the error path in ext4_fill_super don't release the
resouces properly. So this patch just try to release them
in the right way.

Signed-off-by: Tao Ma <boyu.mt@taobao.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/super.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3681,22 +3681,19 @@ no_journal:
 	if (err) {
 		ext4_msg(sb, KERN_ERR, "failed to initialize mballoc (%d)",
 			 err);
-		goto failed_mount4;
+		goto failed_mount5;
 	}
 
 	err = ext4_register_li_request(sb, first_not_zeroed);
 	if (err)
-		goto failed_mount4;
+		goto failed_mount6;
 
 	sbi->s_kobj.kset = ext4_kset;
 	init_completion(&sbi->s_kobj_unregister);
 	err = kobject_init_and_add(&sbi->s_kobj, &ext4_ktype, NULL,
 				   "%s", sb->s_id);
-	if (err) {
-		ext4_mb_release(sb);
-		ext4_ext_release(sb);
-		goto failed_mount4;
-	};
+	if (err)
+		goto failed_mount7;
 
 	EXT4_SB(sb)->s_mount_state |= EXT4_ORPHAN_FS;
 	ext4_orphan_cleanup(sb, es);
@@ -3730,13 +3727,19 @@ cantfind_ext4:
 		ext4_msg(sb, KERN_ERR, "VFS: Can't find ext4 filesystem");
 	goto failed_mount;
 
+failed_mount7:
+	ext4_unregister_li_request(sb);
+failed_mount6:
+	ext4_ext_release(sb);
+failed_mount5:
+	ext4_mb_release(sb);
+	ext4_release_system_zone(sb);
 failed_mount4:
 	iput(root);
 	sb->s_root = NULL;
 	ext4_msg(sb, KERN_ERR, "mount failed");
 	destroy_workqueue(EXT4_SB(sb)->dio_unwritten_wq);
 failed_mount_wq:
-	ext4_release_system_zone(sb);
 	if (sbi->s_journal) {
 		jbd2_journal_destroy(sbi->s_journal);
 		sbi->s_journal = NULL;


