Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933788AbaBDVHv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:07:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56404 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933535AbaBDVC6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:02:58 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        David Sterba <dsterba@suse.cz>, Josef Bacik <jbacik@fb.com>,
        Chris Mason <clm@fb.com>
Subject: [PATCH 3.10 102/104] btrfs: restrict snapshotting to own subvolumes
Date: Tue,  4 Feb 2014 13:02:45 -0800
Message-Id: <20140204210225.607872234@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204210222.731641778@linuxfoundation.org>
References: <20140204210222.731641778@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/btrfs/ioctl.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1528,6 +1528,12 @@ static noinline int btrfs_ioctl_snap_cre
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


