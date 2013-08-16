Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757635Ab3HQA0W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 20:26:22 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:45995 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756777Ab3HQA0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 20:26:06 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: linux-kernel@vger.kernel.org
Cc: linux-ext4@vger.kernel.org, Dave Chinner <david@fromorbit.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Dave Hansen <dave.hansen@linux.intel.com>, xfs@oss.sgi.com,
        Jan Kara <jack@suse.cz>, Tim Chen <tim.c.chen@linux.intel.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v3 0/5] Rework mtime and ctime updates on mmaped
Date: Fri, 16 Aug 2013 16:22:07 -0700
Message-Id: <cover.1376679411.git.luto@amacapital.net>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Writes via mmap currently update mtime and ctime in ->page_mkwrite.
This hurts both throughput and latency.  In workloads that dirty a
large number of mmapped pages, ->page_mkwrite can be hot and
file_update_time is slow and scales poorly.  Updating timestamps can
also sleep, which hurts latency for real-time workloads.

This is also a correctness issue.  SuS says:

    The st_ctime and st_mtime fields of a file that is mapped with
    MAP_SHARED and PROT_WRITE, will be marked for update at some point
    in the interval between a write reference to the mapped region and
    the next call to msync() with MS_ASYNC or MS_SYNC for that portion
    of the file by any process. If there is no such call, these fields
    may be marked for update at any time after a write reference if
    the underlying file is modified as a result.

Currently, if the same mmapped page is written twice, the timestamp
may not be update at all after the second write, whereas SuS (and
anything using timestamps to invalidate caches, backup data, etc.)
would expect the timestamp to eventually be updated.

This patchset attempts to fix both issues at once.  It adds a new
address_space flag AS_CMTIME that is set atomically whenever the
system transfers a pte dirty bit to a struct page backed by the
address_space.  This can happen with various locks held and when low
on memory.

Later on, a new address_space op ->flush_cmtime is called at various
points at which a filesystem should update timestamps if the file was
previously modified through mmap.

The core changes have no effect on unmodified filesystems.  To opt in, a filesystem should implement ->flush_ctime (most likely by using generic_flush_cmtime) and should avoid updating timestamps in ->page_mkwrite.

I've converted ext4.  If it works well, it will be easy to convert all
the other filesystems.

Changes from v2:
 - The core code now interacts with filesystems only through
   address_space ops, so there should be fewer layering issues.
 - MS_ASYNC is handled correctly.

Changes from v1:
 - inode_update_time_writable now locks against the fs freezer.
 - Minor cleanups.
 - Major changelog improvements.

Andy Lutomirski (5):
  mm: Track mappings that have been written via ptes
  fs: Add inode_update_time_writable
  mm: Notify filesystems when it's time to apply a deferred cmtime
    update
  mm: Scan for dirty ptes and update cmtime on MS_ASYNC
  ext4: Defer mmap cmtime update until writeback

 fs/ext4/inode.c           |  4 ++-
 fs/inode.c                | 72 +++++++++++++++++++++++++++++++---------
 include/linux/fs.h        | 10 ++++++
 include/linux/pagemap.h   | 11 +++++++
 include/linux/writeback.h |  1 +
 mm/memory.c               |  7 +++-
 mm/mmap.c                 |  9 ++++-
 mm/msync.c                | 83 ++++++++++++++++++++++++++++++++++++++++-------
 mm/page-writeback.c       | 26 +++++++++++++++
 mm/rmap.c                 | 27 +++++++++++++--
 10 files changed, 219 insertions(+), 31 deletions(-)

-- 
1.8.3.1

