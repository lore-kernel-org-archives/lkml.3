Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422746Ab3BHBGB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 20:06:01 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41969 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932216Ab3BHA6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 19:58:08 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sergey Alexandrov <splavgm@gmail.com>,
        Vyacheslav Dubeyko <slava@dubeyko.com>,
        Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 10/26] nilfs2: fix fix very long mount time issue
Date: Thu,  7 Feb 2013 16:57:38 -0800
Message-Id: <20130208004629.018301602@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130208004627.258272404@linuxfoundation.org>
References: <20130208004627.258272404@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vyacheslav Dubeyko <slava@dubeyko.com>

commit a9bae189542e71f91e61a4428adf6e5a7dfe8063 upstream.

There exists a situation when GC can work in background alone without
any other filesystem activity during significant time.

The nilfs_clean_segments() method calls nilfs_segctor_construct() that
updates superblocks in the case of NILFS_SC_SUPER_ROOT and
THE_NILFS_DISCONTINUED flags are set.  But when GC is working alone the
nilfs_clean_segments() is called with unset THE_NILFS_DISCONTINUED flag.
As a result, the update of superblocks doesn't occurred all this time
and in the case of SPOR superblocks keep very old values of last super
root placement.

SYMPTOMS:

Trying to mount a NILFS2 volume after SPOR in such environment ends with
very long mounting time (it can achieve about several hours in some
cases).

REPRODUCING PATH:

1. It needs to use external USB HDD, disable automount and doesn't
   make any additional filesystem activity on the NILFS2 volume.

2. Generate temporary file with size about 100 - 500 GB (for example,
   dd if=/dev/zero of=<file_name> bs=1073741824 count=200).  The size of
   file defines duration of GC working.

3. Then it needs to delete file.

4. Start GC manually by means of command "nilfs-clean -p 0".  When you
   start GC by means of such way then, at the end, superblocks is updated
   by once.  So, for simulation of SPOR, it needs to wait sometime (15 -
   40 minutes) and simply switch off USB HDD manually.

5. Switch on USB HDD again and try to mount NILFS2 volume.  As a
   result, NILFS2 volume will mount during very long time.

REPRODUCIBILITY: 100%

FIX:

This patch adds checking that superblocks need to update and set
THE_NILFS_DISCONTINUED flag before nilfs_clean_segments() call.

Reported-by: Sergey Alexandrov <splavgm@gmail.com>
Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Tested-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Acked-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Tested-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nilfs2/ioctl.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -666,8 +666,11 @@ static int nilfs_ioctl_clean_segments(st
 	if (ret < 0)
 		printk(KERN_ERR "NILFS: GC failed during preparation: "
 			"cannot read source blocks: err=%d\n", ret);
-	else
+	else {
+		if (nilfs_sb_need_update(nilfs))
+			set_nilfs_discontinued(nilfs);
 		ret = nilfs_clean_segments(inode->i_sb, argv, kbufs);
+	}
 
 	nilfs_remove_all_gcinodes(nilfs);
 	clear_nilfs_gc_running(nilfs);


