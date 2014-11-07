Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331AbaKGWHo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 17:07:44 -0500
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:52185 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752886AbaKGWHm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 17:07:42 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aho5ABxCXVR5LbBUPGdsb2JhbABbgw5UWYc9sEwBAQEBAQEGk0GBZYVsBAKBHBcBAQEBAQYBAQEBODuEQxwjGCQ0BSUDBy2IQM9xGIYgilmEUgWGN5BEhEqCVIEzEoM8iiqLPykvgksBAQE
Date: Sat, 8 Nov 2014 09:07:31 +1100
From: Dave Chinner <david@fromorbit.com>
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: [GIT PULL] xfs: fixes for 3.18-rc3
Message-ID: <20141107220731.GK23575@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Can you please pull from the tag listed below? This update fixes
a warning in the new pagecache_isize_extended() and updates some
related comments, another fix for zero-range misbehaviour, and an
unforntuately large set of fixes for regressions in the bulkstat
code.

The bulkstat fixes are large but necessary.  I wouldn't normally
push such a rework for a -rcX update, but right now xfsdump can
silently create incomplete dumps on 3.17 and it's possible that
even xfsrestore won't notice that the dumps were incomplete. Hence
we need to get this update into 3.17-stable kernels ASAP.

In more detail, the refactoring work I committed in 3.17 has exposed
a major hole in our QA coverage. With both xfsdump (the major user
of bulkstat) and xfsrestore silently ignoring missing files in the
dump/restore process, incomplete dumps were going unnoticed if they
were being triggered. Many of the dump/restore filesets were so
small that they didn't evenhave a chance of triggering the loop
iteration bugs we introduced in 3.17, so we didn't exercise the code
sufficiently, either.

We have already taken steps to improve QA coverage in xfstests to
avoid this happening again, and I've done a lot of manual
verification of dump/restore on very large data sets (tens of
millions of inodes) of the past week to verify this patch set
results in bulkstat behaving the same way as it does on 3.16.

Unfortunately, the fixes are not exactly simple - in tracking down
the problem historic API warts were discovered (e.g xfsdump has been
working around a 20 year old bug in the bulkstat API for the past 10
years) and so that complicated the process of diagnosing and fixing
the problems. i.e. we had to fix bugs in the code as well as
discover and re-introduce the userspace visible API bugs that we
unwittingly "fixed" in 3.17 that xfsdump relied on to work
correctly.

-Dave.

The following changes since commit cac7f2429872d3733dc3f9915857b1691da2eb2f:

  Linux 3.18-rc2 (2014-10-26 16:48:41 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs tags/xfs-for-linus-3.18-rc3

for you to fetch changes up to 002758992693ae63c04122603ea9261a0a58d728:

  xfs: track bulkstat progress by agino (2014-11-07 08:33:52 +1100)

----------------------------------------------------------------
xfs: fixes for v3.18-rc3

This update fixes:

- incorrect warnings about i_mutex locking in
  pagecache_isize_extended() and updates comments to match expected
  locking
- another zero-range bug fix for stray file size updates
- a bunch of fixes for regression in the bulkstat code introduced in
  3.17.

----------------------------------------------------------------
Brian Foster (1):
      xfs: rework zero range to prevent invalid i_size updates

Dave Chinner (7):
      xfs: bulkstat doesn't release AGI buffer on error
      xfs: bulkstat btree walk doesn't terminate
      xfs: bulkstat chunk formatting cursor is broken
      xfs: bulkstat chunk-formatter has issues
      xfs: bulkstat main loop logic is a mess
      xfs: bulkstat error handling is broken
      xfs: track bulkstat progress by agino

Jan Kara (3):
      xfs: Check error during inode btree iteration in xfs_bulkstat()
      mm: Remove false WARN_ON from pagecache_isize_extended()
      mm: Fix comment before truncate_setsize()

 fs/xfs/xfs_bmap_util.c |   72 ++++----------
 fs/xfs/xfs_itable.c    |  250 +++++++++++++++++++++++-------------------------
 fs/xfs/xfs_itable.h    |   16 ----
 mm/truncate.c          |    6 +-
 4 files changed, 145 insertions(+), 199 deletions(-)
-- 
Dave Chinner
david@fromorbit.com
