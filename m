Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733Ab3ALPlf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2013 10:41:35 -0500
Received: from oproxy13-pub.unifiedlayer.com ([69.89.16.30]:39681 "HELO
	oproxy13-pub.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753416Ab3ALPle (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2013 10:41:34 -0500
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Sat, 12 Jan 2013 10:41:34 EST
Message-ID: <1358004888.2130.18.camel@slavad-ubuntu-12.04>
Subject: [PATCH] nilfs2: fix very long mount time issue
From: Vyacheslav Dubeyko <slava@dubeyko.com>
To: =?UTF-8?Q?=D0=A1=D0=B5=D1=80=D0=B3=D0=B5=D0=B9_?=
	 =?UTF-8?Q?=D0=90=D0=BB=D0=B5=D0=BA=D1=81=D0=B0=D0=BD=D0=B4=D1=80=D0=BE?=
	 =?UTF-8?Q?=D0=B2?= <splavgm@gmail.com>,
        Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>,
        linux-nilfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Date: Sat, 12 Jan 2013 19:34:48 +0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Identified-User: {2172:host202.hostmonster.com:dubeykoc:dubeyko.com} {sentby:smtp auth 46.39.244.28 authed with slava@dubeyko.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: [PATCH] nilfs2: fix very long mount time issue

DESCRIPTION:
It exists situation when GC can work in background alone without any other filesystem activity during significant time. The nilfs_clean_segments() method calls nilfs_segctor_construct() that updates superblocks in the case of NILFS_SC_SUPER_ROOT and THE_NILFS_DISCONTINUED flags are set. But when GC is working alone the nilfs_clean_segments() is called with unset THE_NILFS_DISCONTINUED flag. As a result, the update of superblocks doesn't occurred all this time and in the case of SPOR superblocks keep very old values of last super root placement.

SYMPTOMS:
Trying to mount a NILFS2 volume after SPOR in such environment ends with very long mounting time (it can achieve about several hours in some cases).

REPRODUCING PATH:
1. It needs to use external USB HDD, disable automount and doesn't make any additional filesystem activity on the NILFS2 volume.
2. Generate temporary file with size about 100 - 500 GB (for example, dd if=/dev/zero of=<file_name> bs=1073741824 count=200). The size of file defines duration of GC working.
3. Then it needs to delete file.
4. Start GC manually by means of command "nilfs-clean -p 0". When you start GC by means of such way then, at the end, superblocks is updated by once. So, for simulation of SPOR, it needs to wait sometime (15 - 40 minutes) and simply switch off USB HDD manually.
5. Switch on USB HDD again and try to mount NILFS2 volume. As a result, NILFS2 volume will mount during very long time.

REPRODUCIBILITY: 100%

FIX:
This patch adds checking that superblocks need to update and set THE_NILFS_DISCONTINUED flag before nilfs_clean_segments() call.

Reported-by: Sergey Alexandrov <splavgm@gmail.com>
Signed-off-by: Vyacheslav Dubeyko <slava@dubeyko.com>
Tested-by: Vyacheslav Dubeyko <slava@dubeyko.com>
---
 fs/nilfs2/ioctl.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index fdb1807..f385935 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -664,8 +664,11 @@ static int nilfs_ioctl_clean_segments(struct inode *inode, struct file *filp,
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



