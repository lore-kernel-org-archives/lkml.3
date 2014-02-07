Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204AbaBGMLj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 07:11:39 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42299 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920AbaBGLvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:51:55 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Sterba <dsterba@suse.cz>, Josef Bacik <jbacik@fb.com>,
        Chris Mason <clm@fb.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 184/233] btrfs: restrict snapshotting to own subvolumes
Date: Fri,  7 Feb 2014 11:46:43 +0000
Message-Id: <1391773652-25214-185-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Sterba <dsterba@suse.cz>

commit d024206133ce21936b3d5780359afc00247655b7 upstream.

Currently, any user can snapshot any subvolume if the path is accessible and
thus indirectly create and keep files he does not own under his direcotries.
This is not possible with traditional directories.

In security context, a user can snapshot root filesystem and pin any
potentially buggy binaries, even if the updates are applied.

All the snapshots are visible to the administrator, so it's possible to
verify if there are suspicious snapshots.

Another more practical problem is that any user can pin the space used
by eg. root and cause ENOSPC.

Original report:
https://bugs.launchpad.net/ubuntu/+source/apparmor/+bug/484786

Signed-off-by: David Sterba <dsterba@suse.cz>
Signed-off-by: Josef Bacik <jbacik@fb.com>
Signed-off-by: Chris Mason <clm@fb.com>
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/btrfs/ioctl.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 6074a8e..6752118 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1534,6 +1534,12 @@ static noinline int btrfs_ioctl_snap_create_transid(struct file *file,
 			printk(KERN_INFO "btrfs: Snapshot src from "
 			       "another FS\n");
 			ret = -EINVAL;
+		} else if (!inode_owner_or_capable(src_inode)) {
+			/*
+			 * Subvolume creation is not restricted, but snapshots
+			 * are limited to own subvolumes only
+			 */
+			ret = -EPERM;
 		} else {
 			ret = btrfs_mksubvol(&file->f_path, name, namelen,
 					     BTRFS_I(src_inode)->root,
-- 
1.8.3.2

