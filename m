Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858AbaIGQXV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 12:23:21 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:44979
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752538AbaIGQW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 12:22:29 -0400
X-IronPort-AV: E=Sophos;i="5.04,483,1406584800"; 
   d="scan'208";a="78047705"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: kernel-janitors@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        "Dilger, Andreas" <andreas.dilger@intel.com>,
        "Drokin, Oleg" <oleg.drokin@intel.com>, Peng Tao <bergwolf@gmail.com>
Subject: [PATCH 4/7] staging: lustre: lvfs: expand the GOTO macro
Date: Sun,  7 Sep 2014 18:18:32 +0200
Message-Id: <1410106715-9573-4-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
identifier lbl;
identifier rc;
constant c;
@@

- GOTO(lbl,\(rc\|c\));
+ goto lbl;

@@
identifier lbl;
expression rc;
@@

- GOTO(lbl,rc);
+ rc;
+ goto lbl;
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/staging/lustre/lustre/lvfs/lvfs_linux.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/lustre/lustre/lvfs/lvfs_linux.c b/drivers/staging/lustre/lustre/lvfs/lvfs_linux.c
index eea0b2c..d9209b9 100644
--- a/drivers/staging/lustre/lustre/lvfs/lvfs_linux.c
+++ b/drivers/staging/lustre/lustre/lvfs/lvfs_linux.c
@@ -215,12 +215,16 @@ int lustre_rename(struct dentry *dir, struct vfsmount *mnt,
 	if (IS_ERR(dchild_old))
 		return PTR_ERR(dchild_old);
 
-	if (!dchild_old->d_inode)
-		GOTO(put_old, err = -ENOENT);
+	if (!dchild_old->d_inode) {
+		err = -ENOENT;
+		goto put_old;
+	}
 
 	dchild_new = ll_lookup_one_len(newname, dir, strlen(newname));
-	if (IS_ERR(dchild_new))
-		GOTO(put_old, err = PTR_ERR(dchild_new));
+	if (IS_ERR(dchild_new)) {
+		err = PTR_ERR(dchild_new);
+		goto put_old;
+	}
 
 	err = ll_vfs_rename(dir->d_inode, dchild_old, mnt,
 			    dir->d_inode, dchild_new, mnt);
