Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199AbaHAUxK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 16:53:10 -0400
Received: from mga01.intel.com ([192.55.52.88]:57668 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754825AbaHAUxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 16:53:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,782,1400050800"; 
   d="scan'208";a="578901042"
Message-ID: <1406926386.3198.6.camel@rzwisler-mobl1.amr.corp.intel.com>
Subject: Re: [PATCH v9 00/22] Support ext4 on NV-DIMMs
From: Ross Zwisler <ross.zwisler@linux.intel.com>
To: "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>,
        Boaz Harrosh <openosd@gmail.com>
Cc: linux-kernel@vger.kernel.org
Date: Fri, 01 Aug 2014 14:53:06 -0600
In-Reply-To: <cover.1406897885.git.willy@linux.intel.com>
References: <cover.1406897885.git.willy@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-08-01 at 09:27 -0400, Matthew Wilcox wrote:
> From: Matthew Wilcox <willy@linux.intel.com>
> 
> One of the primary uses for NV-DIMMs is to expose them as a block device
> and use a filesystem to store files on the NV-DIMM.  While that works,
> it currently wastes memory and CPU time buffering the files in the page
> cache.  We have support in ext2 for bypassing the page cache, but it
> has some races which are unfixable in the current design.  This series
> of patches rewrite the underlying support, and add support for direct
> access to ext4.
> 
> This iteration of the patchset rebases to 3.16-rc7 and makes substantial
> changes based on feedback from Jan Kara, Boaz Harrosh and Kirill Shutemov:
> 
>  - Fixes a double-unlock on i_mmap_mutex
>  - Switch the order of calling delete_from_page_cache() and
>    unmap_mapping_range() to match the truncate path
>  - Make dax_mkwrite a macro (Kirill)
>  - Drop vm_replace_mixed(); instead call unmap_mapping_range() before calling
>    vm_insert_mixed() (Kirill)
>  - Avoid lock inversion between i_mmap_mutex and transaction start (Jan)
>  - Move alignment & length checks into bdev_direct_access() (Boaz)
>  - Fix bugs in COW code; unfortunately this means reintroducing the knowledge
>    that the i_mmap_mutex protects PFNs to the core MM code.
> 
> Jan Kara (1):
>   ext4: Avoid lock inversion between i_mmap_mutex and transaction start
> 
> Matthew Wilcox (20):
>   axonram: Fix bug in direct_access
>   Change direct_access calling convention
>   Fix XIP fault vs truncate race
>   Allow page fault handlers to perform the COW
>   Introduce IS_DAX(inode)
>   Add copy_to_iter(), copy_from_iter() and iov_iter_zero()
>   Replace XIP read and write with DAX I/O
>   Replace ext2_clear_xip_target with dax_clear_blocks
>   Replace the XIP page fault handler with the DAX page fault handler
>   Replace xip_truncate_page with dax_truncate_page
>   Replace XIP documentation with DAX documentation
>   Remove get_xip_mem
>   ext2: Remove ext2_xip_verify_sb()
>   ext2: Remove ext2_use_xip
>   ext2: Remove xip.c and xip.h
>   Remove CONFIG_EXT2_FS_XIP and rename CONFIG_FS_XIP to CONFIG_FS_DAX
>   ext2: Remove ext2_aops_xip
>   Get rid of most mentions of XIP in ext2
>   xip: Add xip_zero_page_range
>   brd: Rename XIP to DAX
> 
> Ross Zwisler (1):
>   ext4: Add DAX functionality
> 
>  Documentation/filesystems/Locking  |   3 -
>  Documentation/filesystems/dax.txt  |  91 +++++++
>  Documentation/filesystems/ext4.txt |   2 +
>  Documentation/filesystems/xip.txt  |  68 ------
>  arch/powerpc/sysdev/axonram.c      |  19 +-
>  drivers/block/Kconfig              |  13 +-
>  drivers/block/brd.c                |  26 +-
>  drivers/s390/block/dcssblk.c       |  21 +-
>  fs/Kconfig                         |  21 +-
>  fs/Makefile                        |   1 +
>  fs/block_dev.c                     |  34 +++
>  fs/dax.c                           | 476 ++++++++++++++++++++++++++++++++++++
>  fs/exofs/inode.c                   |   1 -
>  fs/ext2/Kconfig                    |  11 -
>  fs/ext2/Makefile                   |   1 -
>  fs/ext2/ext2.h                     |  10 +-
>  fs/ext2/file.c                     |  45 +++-
>  fs/ext2/inode.c                    |  38 +--
>  fs/ext2/namei.c                    |  13 +-
>  fs/ext2/super.c                    |  53 ++--
>  fs/ext2/xip.c                      |  91 -------
>  fs/ext2/xip.h                      |  26 --
>  fs/ext4/ext4.h                     |   6 +
>  fs/ext4/file.c                     |  53 +++-
>  fs/ext4/indirect.c                 |  18 +-
>  fs/ext4/inode.c                    |  65 +++--
>  fs/ext4/namei.c                    |  10 +-
>  fs/ext4/super.c                    |  39 ++-
>  fs/open.c                          |   5 +-
>  include/linux/blkdev.h             |   6 +-
>  include/linux/fs.h                 |  49 +++-
>  include/linux/mm.h                 |   1 +
>  include/linux/uio.h                |   3 +
>  mm/Makefile                        |   1 -
>  mm/fadvise.c                       |   6 +-
>  mm/filemap.c                       |   6 +-
>  mm/filemap_xip.c                   | 483 -------------------------------------
>  mm/iov_iter.c                      | 237 ++++++++++++++++--
>  mm/madvise.c                       |   2 +-
>  mm/memory.c                        |  33 ++-
>  40 files changed, 1206 insertions(+), 881 deletions(-)
>  create mode 100644 Documentation/filesystems/dax.txt
>  delete mode 100644 Documentation/filesystems/xip.txt
>  create mode 100644 fs/dax.c
>  delete mode 100644 fs/ext2/xip.c
>  delete mode 100644 fs/ext2/xip.h
>  delete mode 100644 mm/filemap_xip.c

I've updated the master branch of PRD's GitHub repo
(https://github.com/01org/prd) so that it is Linus's tip + DAX v9 + PRD.

I've also added a patch to PRD to enable dynamic allocation of partition
numbers.

- Ross


