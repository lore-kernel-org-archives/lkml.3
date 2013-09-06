Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751812Ab3IFUPT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 16:15:19 -0400
Received: from cobra.newdream.net ([66.33.216.30]:45181 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035Ab3IFUPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 16:15:15 -0400
Date: Fri, 6 Sep 2013 13:15:15 -0700 (PDT)
From: Sage Weil <sage@inktank.com>
X-X-Sender: sage@cobra.newdream.net
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: [GIT PULL] Ceph updates for 3.12 (take 2)
Message-ID: <alpine.DEB.2.00.1309061308030.4938@cobra.newdream.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following Ceph updates from

  git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git for-linus

This includes both the first pile of Ceph patches (which I sent to 
torvalds@vger, sigh) and a few new patches that add support for fscache 
for Ceph.  That includes a few fscache core fixes that David Howells asked 
go through the Ceph tree.  (Thanks go to Milosz Tanski for putting this 
feature together.)

This first batch of patches (included here) had (has) several important 
RBD bug fixes, hole punch support, several different cleanups in the page 
cache interactions, improvements in the truncate code (new truncate mutex 
to avoid shenanigans with i_mutex), and a series of fixes in the 
synchronous striping read/write code.  On top of that is a random 
collection of small fixes all across the tree (error code checks and error 
path cleanup, obsolete wq flags, etc.).

Thanks!
sage



----------------------------------------------------------------
Dan Carpenter (4):
      ceph: cleanup types in striped_read()
      libceph: fix error handling in handle_reply()
      libceph: potential NULL dereference in ceph_osdc_handle_map()
      libceph: create_singlethread_workqueue() doesn't return ERR_PTRs

David Howells (3):
      FS-Cache: Add interface to check consistency of a cached object
      CacheFiles: Implement interface to check cache consistency
      FS-Cache: Fix heading in documentation

Jingoo Han (1):
      block: rbd: use NULL instead of 0

Josh Durgin (3):
      rbd: fix I/O error propagation for reads
      rbd: fix buffer size for writes to images with snapshots
      rbd: fix null dereference in dout

Li Wang (2):
      ceph: punch hole support
      ceph: remove useless variable revoked_rdcache

Milosz Tanski (10):
      ceph: Remove bogus check in invalidatepage
      ceph: cleanup the logic in ceph_invalidatepage
      fscache: Netfs function for cleanup post readpages
      Merge tag 'fscache-fixes-for-ceph' into wip-fscache
      ceph: use fscache as a local presisent cache
      ceph: clean PgPrivate2 on returning from readpages
      ceph: ceph_readpage_to_fscache didn't check if marked
      ceph: page still marked private_2
      ceph: Do not do invalidate if the filesystem is mounted nofsc
      ceph: trivial buildbot warnings fix

Nathaniel Yazdani (1):
      ceph: fix null pointer dereference

Sage Weil (4):
      ceph: replace hold_mutex flag with goto
      Merge remote-tracking branch 'linus/master' into testing
      ceph: fix fallocate division
      libceph: use pg_num_mask instead of pgp_num_mask for pg.seed calc

Sha Zhengju (1):
      ceph: use vfs __set_page_dirty_nobuffers interface instead of doing it inside filesystem

Tejun Heo (1):
      ceph: WQ_NON_REENTRANT is meaningless and going away

Yan, Zheng (8):
      ceph: drop CAP_LINK_SHARED when sending "link" request to MDS
      ceph: wake up writer if vmtruncate work get blocked
      ceph: trim deleted inode
      ceph: fix freeing inode vs removing session caps race
      ceph: introduce i_truncate_mutex
      ceph: fix request max size
      ceph: remove ceph_lookup_inode()
      ceph: use d_invalidate() to invalidate aliases

majianpeng (7):
      ceph: Don't forget the 'up_read(&osdc->map_sem)' if met error.
      libceph: unregister request in __map_request failed and nofail == false
      ceph: Don't use ceph-sync-mode for synchronous-fs.
      ceph: Add check returned value on func ceph_calc_ceph_pg.
      ceph: Move the place for EOLDSNAPC handle in ceph_aio_write to easily understand
      ceph: fix bugs about handling short-read for sync read mode.
      ceph: allow sync_read/write return partial successed size of read/write.

 Documentation/filesystems/caching/backend-api.txt |   9 +
 Documentation/filesystems/caching/netfs-api.txt   |  37 +-
 drivers/block/rbd.c                               |  36 +-
 fs/cachefiles/interface.c                         |  26 ++
 fs/cachefiles/internal.h                          |   1 +
 fs/cachefiles/xattr.c                             |  36 ++
 fs/ceph/Kconfig                                   |   9 +
 fs/ceph/Makefile                                  |   1 +
 fs/ceph/addr.c                                    | 116 ++++---
 fs/ceph/cache.c                                   | 398 ++++++++++++++++++++++
 fs/ceph/cache.h                                   | 159 +++++++++
 fs/ceph/caps.c                                    |  87 ++++-
 fs/ceph/dir.c                                     |   2 +
 fs/ceph/file.c                                    | 299 +++++++++++++---
 fs/ceph/inode.c                                   |  46 ++-
 fs/ceph/ioctl.c                                   |  12 +-
 fs/ceph/mds_client.c                              |  34 ++
 fs/ceph/super.c                                   |  35 +-
 fs/ceph/super.h                                   |  17 +
 fs/fscache/cookie.c                               |  71 ++++
 fs/fscache/internal.h                             |   6 +
 fs/fscache/page.c                                 |  71 ++--
 include/linux/fscache-cache.h                     |   4 +
 include/linux/fscache.h                           |  42 +++
 net/ceph/messenger.c                              |   2 +-
 net/ceph/osd_client.c                             |  27 +-
 net/ceph/osdmap.c                                 |   2 +-
 27 files changed, 1396 insertions(+), 189 deletions(-)
 create mode 100644 fs/ceph/cache.c
 create mode 100644 fs/ceph/cache.h
