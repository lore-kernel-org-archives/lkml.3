Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253AbaCaAFV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 20:05:21 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37332 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754425AbaC3Xmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:42:53 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David Sterba" <dsterba@suse.cz>,
        "Chris Mason" <clm@fb.com>, "Josef Bacik" <jbacik@fb.com>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.210796680@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 057/200] btrfs: restrict snapshotting to own subvolumes
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2:
 - Adjust context
 - Use the same cleanup code for success and error cases, as done
   upstream in commit ecd188159efa
   ('switch btrfs_ioctl_snap_create_transid() to fget_light()')]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -1327,12 +1327,17 @@ static noinline int btrfs_ioctl_snap_cre
 			printk(KERN_INFO "btrfs: Snapshot src from "
 			       "another FS\n");
 			ret = -EINVAL;
-			fput(src_file);
-			goto out;
+		} else if (!inode_owner_or_capable(src_inode)) {
+			/*
+			 * Subvolume creation is not restricted, but snapshots
+			 * are limited to own subvolumes only
+			 */
+			ret = -EPERM;
+		} else {
+			ret = btrfs_mksubvol(&file->f_path, name, namelen,
+					     BTRFS_I(src_inode)->root,
+					     transid, readonly);
 		}
-		ret = btrfs_mksubvol(&file->f_path, name, namelen,
-				     BTRFS_I(src_inode)->root,
-				     transid, readonly);
 		fput(src_file);
 	}
 out:

