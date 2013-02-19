Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934203Ab3BSSwU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 13:52:20 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54312 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933434Ab3BSSwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:52:17 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 35/81] nilfs2: fix fix very long mount time issue
Date: Tue, 19 Feb 2013 15:48:58 -0300
Message-Id: <1361299784-8830-36-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
References: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.6 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 fs/nilfs2/ioctl.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index 0b6387c..29990c9 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -666,8 +666,11 @@ static int nilfs_ioctl_clean_segments(struct inode *inode, struct file *filp,
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
-- 
1.7.9.5

