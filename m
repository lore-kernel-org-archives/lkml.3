Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935541Ab3DHJvg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 05:51:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42701 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935522Ab3DHJvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:51:33 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ming Lei <ming.lei@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 026/102] sysfs: handle failure path correctly for readdir()
Date: Mon,  8 Apr 2013 10:49:41 +0100
Message-Id: <1365414657-29191-27-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
References: <1365414657-29191-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.10 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@canonical.com>

commit e5110f411d2ee35bf8d202ccca2e89c633060dca upstream.

In case of 'if (filp->f_pos ==  0 or 1)' of sysfs_readdir(),
the failure from filldir() isn't handled, and the reference counter
of the sysfs_dirent object pointed by filp->private_data will be
released without clearing filp->private_data, so use after free
bug will be triggered later.

This patch returns immeadiately under the situation for fixing the bug,
and it is reasonable to return from readdir() when filldir() fails.

Reported-by: Dave Jones <davej@redhat.com>
Tested-by: Sasha Levin <levinsasha928@gmail.com>
Signed-off-by: Ming Lei <ming.lei@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/sysfs/dir.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 5a035b5..2ee0864 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -1021,6 +1021,8 @@ static int sysfs_readdir(struct file * filp, void * dirent, filldir_t filldir)
 		ino = parent_sd->s_ino;
 		if (filldir(dirent, ".", 1, filp->f_pos, ino, DT_DIR) == 0)
 			filp->f_pos++;
+		else
+			return 0;
 	}
 	if (filp->f_pos == 1) {
 		if (parent_sd->s_parent)
@@ -1029,6 +1031,8 @@ static int sysfs_readdir(struct file * filp, void * dirent, filldir_t filldir)
 			ino = parent_sd->s_ino;
 		if (filldir(dirent, "..", 2, filp->f_pos, ino, DT_DIR) == 0)
 			filp->f_pos++;
+		else
+			return 0;
 	}
 	mutex_lock(&sysfs_mutex);
 	for (pos = sysfs_dir_pos(ns, parent_sd, filp->f_pos, pos);
-- 
1.8.1.2

