Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404Ab3JCGR2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 02:17:28 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41538 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637Ab3JCGR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 02:17:27 -0400
Date: Thu, 03 Oct 2013 07:17:26 +0100
To: torvalds@linux-foundation.org
Subject: [PATCH 00/17] RCU vfsmounts
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <E1VRcE2-000865-71@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is an attempt to massage the things into shape where we wouldn't need
vfsmount_lock during rcu-mode pathwalk.  The actual deed is done in the
last patch.  Very, very light testing so far.

Review would be very welcome; the same goes for testing, but don't try
that on anything you can't afford buggered - it got *very* minimal
testing and if I had missed something (which is not unlikely), it might
corrupt data structures in very unpleasant ways.  You've been warned...

Notes:
	* vfsmount_lock is replaced with seqlock, a-la rename_lock.
On the normal rcuwalk it's not touched for write at all.  BTW, a side
benefit is that br_write_lock() used to be very costly on large boxen
(number of possible CPUs worth of spin_lock()); its replacement is
much cheaper.
	* We may walk into a filesystem being shut down.  First of all, we
take care to avoid grabbing any dentries in that case - the first thing we
do when leaving lazy mode is legitimize_mnt(), and if it succeeds we know
that fs isn't going away.
	* We also switch shrink_dcache_for_umount() to something resembling
the normal paths in shrink_dcache_parent() et.al., so lazy-walking into the
tree shouldn't cause any problems, provided that ->d_hash(), ->d_compare(),
->permission(..., MAY_EXEC | MAY_NOT_BLOCK), ->d_manage(..., true) and
->d_revalidate(..., LOOKUP_RCU | ...) do not depend on anything that might
be gone under us.  That part is dealt with by brute force - on the few
affected filesystems we simply do synchronize_rcu() in their ->kill_sb()
before freeing the stuff we might need.
	* legitimize_mnt() really needs to avoid stealing the final
mntput() from (non-lazy) umount(2) and such.  Done by combination of
marking known-to-have-no-other-references victims with MNT_SYNC_UMOUNT
at umount_tree() time, synchronize_rcu() in unlock_namespace() and
checking for MNT_SYNC_UMOUNT when legitimize_mnt() decides that it
got a hopeless bastard.  In that case we silently decrement vfsmount
refcount, instead of doing full-blown mntput().  Safe, since
unlock_namespace() after having that flag set couldn't have happened
before we entered rcu mode (we wouldn't have found any references
to that vfsmount in such case, since MNT_SYNC_UMOUNT is only set when we
know that no references outside of mount tree exist) and unlock_namespace()
won't progress to doing any mntput() until we leave rcu mode.  See
the last patch for details.
	* mntput_no_expire() got reorganized as well in the last patch;
under rcu_read_lock() we decrement the count, then check for ->mnt_ns
and bugger off if it's still set.  Otherwise grab mount_lock and
check the count for zero.  Since there might be several threads hitting
that (they decrement counter before grabbing the lock), we have the
first comer mark the victim doomed before dropping mount_lock and
proceeding with killing the sucker; actual freeing is done via
call_rcu(), so those who see it already marked that way can safely
drop mount_lock, do rcu_read_unlock() and be gone - the damn thing
won't be freed under them.

The last commit definitely needs a splitup; it's too big.

Shortlog:
Al Viro (17):
      initialize namespace_sem statically
      fs_is_visible only needs namespace_sem held shared
      dup_mnt_ns(): get rid of pointless grabbing of vfsmount_lock
      do_remount(): pull touch_mnt_namespace() up
      fold mntfree() into mntput_no_expire()
      fs/namespace.c: bury long-dead define
      finish_automount() doesn't need vfsmount_lock for removal from expiry list
      mnt_set_expiry() doesn't need vfsmount_lock
      fold dup_mnt_ns() into its only surviving caller
      namespace.c: get rid of mnt_ghosts
      don't bother with vfsmount_lock in mounts_poll()
      new helpers: lock_mount_hash/unlock_mount_hash
      isofs: don't pass dentry to isofs_hash{i,}_common()
      uninline destroy_super(), consolidate alloc_super()
      split __lookup_mnt() in two functions
      move taking vfsmount_lock down into prepend_path()
      RCU'd vfsmounts

Diffstat:
 fs/adfs/super.c       |    1 +
 fs/autofs4/inode.c    |    1 +
 fs/cifs/connect.c     |    1 +
 fs/dcache.c           |  221 +++++++++++++----------------
 fs/fat/inode.c        |    1 +
 fs/fuse/inode.c       |    1 +
 fs/hpfs/super.c       |    1 +
 fs/internal.h         |    4 -
 fs/isofs/inode.c      |   12 +-
 fs/mount.h            |   20 +++-
 fs/namei.c            |   87 +++++------
 fs/namespace.c        |  386 +++++++++++++++++++++++++------------------------
 fs/ncpfs/inode.c      |    1 +
 fs/pnode.c            |   13 +-
 fs/proc/root.c        |    1 +
 fs/proc_namespace.c   |    8 +-
 fs/super.c            |  206 +++++++++++---------------
 include/linux/mount.h |    2 +
 include/linux/namei.h |    2 +-
 19 files changed, 463 insertions(+), 506 deletions(-)

