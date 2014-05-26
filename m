Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751357AbaEZEUI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 00:20:08 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:2058 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750914AbaEZEUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 00:20:06 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmhNAJO/glN5LL1sPGdsb2JhbABZgwdSgnGnUQ4BAQEGkFCHOgGBCRcDAQEBATg1giUBAQEDAQECJBMcIwULCAMVAwklDwUNBxEDBxoTiC4DCQcO0QUNhhoXFoU/hmeCFgeEQASVcoEga4F1ixiCHok8Ky+BAyQ
Date: Mon, 26 May 2014 14:19:58 +1000
From: Dave Chinner <david@fromorbit.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Plamen Petrov <plamen.sisi@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        xfs@oss.sgi.com
Subject: Re: [PATCH] do_mounts: try all available filesystems before panicking
Message-ID: <20140526041958.GV8554@dastard>
References: <1399314889-9829-1-git-send-email-plamen.sisi@gmail.com>
 <CA+55aFwxF2xnYerLdJZ2gQdZizK3953L16X5KkUAqD-YePausQ@mail.gmail.com>
 <20140526000813.GS8554@dastard>
 <20140526011904.GT8554@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140526011904.GT8554@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2014 at 11:19:04AM +1000, Dave Chinner wrote:
> On Mon, May 26, 2014 at 10:08:13AM +1000, Dave Chinner wrote:
> > On Sun, May 25, 2014 at 01:04:09PM -0700, Linus Torvalds wrote:
> > > On Mon, May 5, 2014 at 11:34 AM, Plamen Petrov <plamen.sisi@gmail.com> wrote:
> > > >
> > > > The story short: on systems with btrfs root I have a kernel .config with ext4,
> > > > xfs and btrfs built-in which works fine with 3.13.x, but 3.14.x panics. After
> > > > inserting some debug printks, I got this info from mount_block_root:
> > > >
> > > > ---> EACCESS=13, EINVAL=22, Available filesystems: ext3 ext2 ext4 fuseblk xfs btrfs
> > > > -----> Tried ext3, error code is -22.
> > > > -----> Tried ext2, error code is -22.
> > > > -----> Tried ext4, error code is -22.
> > > > -----> Tried fuseblk, error code is -22.
> > > > -----> Tried xfs, error code is -38.
> > > > VFS: Cannot open root device "sda2" or unknown-block(8,2): error -38
> > > > Please append a correct "root=" boot option; here are the available partitions:
> 
> BTW, This is the original thread with lots of triage in it:
> 
> http://www.spinics.net/lists/linux-btrfs/msg33455.html
> 
> But that doesn't reach any conclusion. I suspect that the
> change of btrfs init (from very early (@~1.8s into the boot) until a
> few milliseconds before the root mount is changing the order in
> which the filesystem type list is traversed by the mount, resulting
> in XFS being used to probe the device before btrfs.

On that point, on 3.15-rc6:

$ tail -1 /proc/filesystems
        btrfs
$

> Why XFS is seeing /dev/sda2 as containing an XFS filesystem is not
> yet clear, but perhaps once you've dumped the the first sector of
> the btrfs partition all will become clear....

No need, I found the regression. Plamen, can you please try the
patch below?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

xfs: xfs_readsb needs to check for magic numbers

From: Dave Chinner <dchinner@redhat.com>

Commit daba542 ("xfs: skip verification on initial "guess"
superblock read") dropped the use of a veridier for the initial
superblock read so we can probe the sector size of the filesystem
stored in the superblock. It, however, now fails to validate that
what was read initially is actually an XFS superblock and hence will
fail the sector size check and return ENOSYS.

This causes probe-based mounts to fail because it expects XFS to
return EINVAL when it doesn't recognise the superblock format.

cc: <stable@vger.kernel.org>
Reported-by: Plamen Petrov <plamen.sisi@gmail.com>
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_mount.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 8d1afb8..2409224 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -327,8 +327,19 @@ reread:
 	/*
 	 * Initialize the mount structure from the superblock.
 	 */
-	xfs_sb_from_disk(&mp->m_sb, XFS_BUF_TO_SBP(bp));
-	xfs_sb_quota_from_disk(&mp->m_sb);
+	xfs_sb_from_disk(sbp, XFS_BUF_TO_SBP(bp));
+	xfs_sb_quota_from_disk(sbp);
+
+	/*
+	 * If we haven't validated the superblock, do so now before we try
+	 * to check the sector size and reread the superblock appropriately.
+	 */
+	if (sbp->sb_magicnum != XFS_SB_MAGIC) {
+		if (loud)
+			xfs_warn(mp, "Invalid superblock magic number");
+		error = EINVAL;
+		goto release_buf;
+	}
 
 	/*
 	 * We must be able to do sector-sized and sector-aligned IO.
@@ -341,11 +352,11 @@ reread:
 		goto release_buf;
 	}
 
-	/*
-	 * Re-read the superblock so the buffer is correctly sized,
-	 * and properly verified.
-	 */
 	if (buf_ops == NULL) {
+		/*
+		 * Re-read the superblock so the buffer is correctly sized,
+		 * and properly verified.
+		 */
 		xfs_buf_relse(bp);
 		sector_size = sbp->sb_sectsize;
 		buf_ops = loud ? &xfs_sb_buf_ops : &xfs_sb_quiet_buf_ops;
