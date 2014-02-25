Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708AbaBYOZo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 09:25:44 -0500
Received: from mga09.intel.com ([134.134.136.24]:15951 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753366AbaBYOTN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 09:19:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,540,1389772800"; 
   d="scan'208";a="481478377"
From: Matthew Wilcox <matthew.r.wilcox@intel.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, willy@linux.intel.com
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: [PATCH v6 00/22] Support ext4 on NV-DIMMs
Date: Tue, 25 Feb 2014 09:18:16 -0500
Message-Id: <1393337918-28265-1-git-send-email-matthew.r.wilcox@intel.com>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

One of the primary uses for NV-DIMMs is to expose them as a block device
and use a filesystem to store files on the NV-DIMM.  While that works,
it currently wastes memory and CPU time buffering the files in the page
cache.  We have support in ext2 for bypassing the page cache, but it
has some races which are unfixable in the current design.  This series
of patches rewrite the underlying support, and add support for direct
access to ext4.

This iteration of the patchset renames the "XIP" support to "DAX".
This fixes the confusion between kernel XIP and filesystem XIP.  It's not
really about executing in-place; it's about direct access to memory-like
storage, bypassing the page cache.  DAX is TLA-compliant, retains the
exciting X, is pronouncable ("Dacks") and is not used elsewhere in
the kernel.  The only major use of DAX outside the kernel is the German
stock exchange, and I think that's pretty unlikely to cause confusion.

Patch 2 *still* wants careful review from the MM people.

I want to particularly credit Ross Zwisler for all the effort he's put
into tracking down bugs.

Testing
~~~~~~~

Seven xfstests still fail reliably with DAX that pass reliably without
DAX: ext4/301 generic/{075,091,112,127,223,263}

Two fail randomly for me whether DAX is enabled or not: generic/{299,300}

Eleven fail reliably without DAX: ext4/{302,303,304}
generic/{219,230,231,232,233,235,270} shared/218

Several are not run, because they need dm_flakey,
CONFIG_FAIL_MAKE_REQUEST, my 3GB ramdisk is too small, they're not
suitable for Linux or they're not suitable for ext4.  My current
score is 18/127 tests fail with -o dax and 11/127 without.

v6:
 - Fix compilation with CONFIG_FS_XIP=n (reported by Ross Zwisler)
 - Removed unused argument from xip_io (patch from Ross Zwisler)
 - Fixed buffer overrun in xip_io (original patch from Ross Zwisler)
 - Prevented reads past i_size (original patch from Ross Zwisler)
 - Fixed documentation errors (reported by Randy Dunlap)
 - Add handling of BH_New (reported by Dave Chinner)
 - Support the way ext4 reports holes (original patch from Ross Zwisler)
 - Zero the *end* of new blocks as well as the beginning (reported by Dave
   Chinner)
 - Rebased on top of 3.14-rc4 plus Kirill's cleanups of __do_fault() which
   are in linux-mm (http://marc.info/?l=linux-mm&m=139206489208546&w=2).
 - Renamed XIP to DAX
 - Fixed writev() so subsequent writes don't overwrite earlier writes
 - Remove code in ext4 to clear blocks in DAX files
 - Fixed dax_zero_page_range() to actually call memset

v5:
 - Improved documentation
 - Fixed a couple of warnings emitted by a newer version of gcc
 - Fixed a bug where we would read/write the wrong sector in xip_io for I/Os
   that were not aligned to PAGE_SIZE
 - Dropped PMD fault patch
 - Added support for unwritten extents


Matthew Wilcox (21):
  Fix XIP fault vs truncate race
  Allow page fault handlers to perform the COW
  axonram: Fix bug in direct_access
  Change direct_access calling convention
  Introduce IS_DAX(inode)
  Replace XIP read and write with DAX I/O
  Replace the XIP page fault handler with the DAX page fault handler
  Replace xip_truncate_page with dax_truncate_page
  Remove mm/filemap_xip.c
  Remove get_xip_mem
  Replace ext2_clear_xip_target with dax_clear_blocks
  ext2: Remove ext2_xip_verify_sb()
  ext2: Remove ext2_use_xip
  ext2: Remove xip.c and xip.h
  Remove CONFIG_EXT2_FS_XIP and rename CONFIG_FS_XIP to CONFIG_FS_DAX
  ext2: Remove ext2_aops_xip
  Get rid of most mentions of XIP in ext2
  xip: Add xip_zero_page_range
  ext4: Make ext4_block_zero_page_range static
  ext4: Fix typos
  dax: Add reporting of major faults

Ross Zwisler (1):
  ext4: Add DAX functionality

 Documentation/filesystems/Locking  |   3 -
 Documentation/filesystems/dax.txt  |  84 +++++++
 Documentation/filesystems/ext4.txt |   2 +
 Documentation/filesystems/xip.txt  |  68 ------
 arch/powerpc/sysdev/axonram.c      |   8 +-
 drivers/block/brd.c                |   8 +-
 drivers/s390/block/dcssblk.c       |  19 +-
 fs/Kconfig                         |  21 +-
 fs/Makefile                        |   1 +
 fs/dax.c                           | 451 ++++++++++++++++++++++++++++++++++
 fs/exofs/inode.c                   |   1 -
 fs/ext2/Kconfig                    |  11 -
 fs/ext2/Makefile                   |   1 -
 fs/ext2/ext2.h                     |   9 +-
 fs/ext2/file.c                     |  45 +++-
 fs/ext2/inode.c                    |  37 +--
 fs/ext2/namei.c                    |  13 +-
 fs/ext2/super.c                    |  48 ++--
 fs/ext2/xip.c                      |  91 -------
 fs/ext2/xip.h                      |  26 --
 fs/ext4/ext4.h                     |   8 +-
 fs/ext4/file.c                     |  53 +++-
 fs/ext4/indirect.c                 |  19 +-
 fs/ext4/inode.c                    |  94 +++++---
 fs/ext4/namei.c                    |  10 +-
 fs/ext4/super.c                    |  39 ++-
 fs/open.c                          |   5 +-
 include/linux/blkdev.h             |   4 +-
 include/linux/fs.h                 |  49 +++-
 include/linux/mm.h                 |   2 +
 mm/Makefile                        |   1 -
 mm/fadvise.c                       |   6 +-
 mm/filemap.c                       |   6 +-
 mm/filemap_xip.c                   | 483 -------------------------------------
 mm/madvise.c                       |   2 +-
 mm/memory.c                        |  44 +++-
 36 files changed, 911 insertions(+), 861 deletions(-)
 create mode 100644 Documentation/filesystems/dax.txt
 delete mode 100644 Documentation/filesystems/xip.txt
 create mode 100644 fs/dax.c
 delete mode 100644 fs/ext2/xip.c
 delete mode 100644 fs/ext2/xip.h
 delete mode 100644 mm/filemap_xip.c

-- 
1.8.5.3

