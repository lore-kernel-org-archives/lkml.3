Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752217AbaJHF5G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 01:57:06 -0400
Received: from mail.kernel.org ([198.145.19.201]:53118 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750705AbaJHF5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 01:57:04 -0400
Date: Tue, 7 Oct 2014 22:57:18 -0700
From: Jaegeuk Kim <jaegeuk@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux FS Dev Mailing List <linux-fsdevel@vger.kernel.org>,
        Linux F2FS Dev Mailing List 
	<linux-f2fs-devel@lists.sourceforge.net>
Subject: [GIT PULL] f2fs updates for v3.18
Message-ID: <20141008055718.GA68158@jaegeuk-mac02.hsd1.ca.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This patch-set introduces a couple of new features such as large sector size,
FITRIM, and atomic/volatile writes.
Several patches enhance power-off recovery and checkpoint routines.
The fsck.f2fs starts to support fixing corrupted partitions with recovery hints
provided by this patch-set.

Thank you very much.

The following changes since commit 70c8038dd698b44daf7c8fc7e2eca142bec694c4:

  Merge tag 'for-f2fs-3.17-rc4' of git://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs (2014-09-03 10:10:28 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs.git tags/f2fs-for-3.18

for you to fetch changes up to 02a1335f25a386db9afc68f8315162f862aac93f:

  f2fs: support volatile operations for transient data (2014-10-07 11:54:41 -0700)

----------------------------------------------------------------
f2fs updates for v3.18

This series includes patches to:
 o retain some recovery information for fsck.f2fs
 o enhance checkpoint speed
 o enhance flush command management
 o bug fix for lseek
 o tune in-place-update policies
 o enhance roll-forward speed
 o revisit all the roll-forward and fsync rules
 o support large sector size
 o support FITRIM
 o support atomic and volatile writes

And several clean-ups and bug fixes are included.

----------------------------------------------------------------
Chao Yu (7):
      f2fs: remove unneeded sit_i in macro SIT_BLOCK_OFFSET/START_SEGNO
      f2fs: refactor flush_sit_entries codes for reducing SIT writes
      f2fs: fix to truncate blocks past EOF in ->setattr
      f2fs: support large sector size
      f2fs: skip punching hole in special condition
      f2fs: fix to clean previous mount option when remount_fs
      f2fs: fix to search whole dirty segmap when get_victim

Dan Carpenter (1):
      f2fs: potential shift wrapping buf in f2fs_trim_fs()

Gu Zheng (1):
      f2fs: use lock-less list(llist) to simplify the flush cmd management

Huang Ying (3):
      f2fs: avoid node page to be written twice in gc_node_segment
      f2fs: use nm_i->next_scan_nid as default for next_free_nid
      f2fs: fix a race condition in next_free_nid

Jaegeuk Kim (30):
      f2fs: introduce F2FS_I_SB, F2FS_M_SB, and F2FS_P_SB
      f2fs: retain inconsistency information to initiate fsck.f2fs
      f2fs: need fsck.f2fs when f2fs_bug_on is triggered
      f2fs: add BUG cases to initiate fsck.f2fs
      f2fs: handle bug cases by letting fsck.f2fs initiate
      f2fs: need fsck.f2fs if the recovery was failed
      f2fs: fix negative value for lseek offset
      f2fs: remove lengthy inode->i_ino
      f2fs: expand counting dirty pages in the inode page cache
      f2fs: give an option to enable in-place-updates during fsync to users
      f2fs: fix double lock for inode page during roll-foward recovery
      f2fs: use meta_inode cache to improve roll-forward speed
      f2fs: introduce a flag to represent each nat entry information
      f2fs: fix conditions to remain recovery information in f2fs_sync_file
      f2fs: fix roll-forward missing scenarios
      f2fs: do not skip latest inode information
      f2fs: remove redundant operation during roll-forward recovery
      f2fs: use MAX_BIO_BLOCKS(sbi)
      f2fs: update i_size when __allocate_data_block
      f2fs: change the ipu_policy option to enable combinations
      f2fs: use more free segments until SSR is activated
      f2fs: introduce cp_control structure
      f2fs: introduce FITRIM in f2fs_ioctl
      f2fs: refactor flush_nat_entries to remove costly reorganizing ops
      f2fs: check the use of macros on block counts and addresses
      f2fs: call f2fs_unlock_op after error was handled
      f2fs: clean up f2fs_ioctl functions
      f2fs: remove unused return value
      f2fs: support atomic writes
      f2fs: support volatile operations for transient data

 Documentation/ABI/testing/sysfs-fs-f2fs |   7 +
 Documentation/filesystems/f2fs.txt      |  13 +-
 fs/f2fs/checkpoint.c                    |  97 +++---
 fs/f2fs/data.c                          |  69 +++--
 fs/f2fs/debug.c                         |  20 +-
 fs/f2fs/dir.c                           |  19 +-
 fs/f2fs/f2fs.h                          | 163 +++++++---
 fs/f2fs/file.c                          | 257 ++++++++++++----
 fs/f2fs/gc.c                            |  26 +-
 fs/f2fs/inline.c                        |  20 +-
 fs/f2fs/inode.c                         |  37 ++-
 fs/f2fs/namei.c                         |  53 ++--
 fs/f2fs/node.c                          | 460 ++++++++++++++--------------
 fs/f2fs/node.h                          |  60 ++--
 fs/f2fs/recovery.c                      | 191 +++++++-----
 fs/f2fs/segment.c                       | 520 +++++++++++++++++++++++---------
 fs/f2fs/segment.h                       | 160 ++++++----
 fs/f2fs/super.c                         |  47 ++-
 fs/f2fs/xattr.c                         |   8 +-
 include/linux/f2fs_fs.h                 |   6 +-
 include/trace/events/f2fs.h             |  16 +-
 21 files changed, 1453 insertions(+), 796 deletions(-)

