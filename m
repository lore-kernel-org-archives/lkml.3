Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964812Ab3IDPuq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 11:50:46 -0400
Received: from cobra.newdream.net ([66.33.216.30]:45929 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934808Ab3IDPuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 11:50:44 -0400
Date: Wed, 4 Sep 2013 08:50:43 -0700 (PDT)
From: Sage Weil <sage@inktank.com>
X-X-Sender: sage@cobra.newdream.net
To: torvalds@vger.kernel.org
cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        ceph-devel@vger.kernel.org
Subject: [GIT PULL] Ceph updates for 3.12 (part 1)
Message-ID: <alpine.DEB.2.00.1309032220020.4018@cobra.newdream.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull this first batch of Ceph updates for 3.12 from

  git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client.git for-linus

This first batch include several important RBD bug fixes (more coming in 
part 2), hole punch support, several different cleanups in the page cache 
interactions, improvements in the truncate code (new truncate mutex to 
avoid shenanigans with i_mutex), and a series of fixes in the synchronous 
striping read/write code.  On top of that is a random collection of small 
fixes all across the tree (error code checks and error path cleanup, 
obsolete wq flags, etc.).

A second batch of patches will include fscache support for Ceph (waiting 
on some dependent fixes in the fscache code and an ACK from David) and a 
second batch of RBD bug fixes that didn't get tested and reviewed in time 
for 3.11.  Hopefully later this week.

Thanks!
sage


----------------------------------------------------------------
Dan Carpenter (4):
      ceph: cleanup types in striped_read()
      libceph: fix error handling in handle_reply()
      libceph: potential NULL dereference in ceph_osdc_handle_map()
      libceph: create_singlethread_workqueue() doesn't return ERR_PTRs

Jingoo Han (1):
      block: rbd: use NULL instead of 0

Josh Durgin (3):
      rbd: fix I/O error propagation for reads
      rbd: fix buffer size for writes to images with snapshots
      rbd: fix null dereference in dout

Li Wang (2):
      ceph: punch hole support
      ceph: remove useless variable revoked_rdcache

Milosz Tanski (2):
      ceph: Remove bogus check in invalidatepage
      ceph: cleanup the logic in ceph_invalidatepage

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

Yan, Zheng (6):
      ceph: drop CAP_LINK_SHARED when sending "link" request to MDS
      ceph: wake up writer if vmtruncate work get blocked
      ceph: trim deleted inode
      ceph: fix freeing inode vs removing session caps race
      ceph: introduce i_truncate_mutex
      ceph: fix request max size

majianpeng (7):
      ceph: Don't forget the 'up_read(&osdc->map_sem)' if met error.
      libceph: unregister request in __map_request failed and nofail == false
      ceph: Don't use ceph-sync-mode for synchronous-fs.
      ceph: Add check returned value on func ceph_calc_ceph_pg.
      ceph: Move the place for EOLDSNAPC handle in ceph_aio_write to easily understand
      ceph: fix bugs about handling short-read for sync read mode.
      ceph: allow sync_read/write return partial successed size of read/write.

 drivers/block/rbd.c   |   36 ++++---
 fs/ceph/addr.c        |   76 +++++--------
 fs/ceph/caps.c        |   68 +++++++++---
 fs/ceph/dir.c         |    2 +
 fs/ceph/file.c        |  282 +++++++++++++++++++++++++++++++++++++++++--------
 fs/ceph/inode.c       |   40 +++++--
 fs/ceph/ioctl.c       |   12 ++-
 fs/ceph/mds_client.c  |   34 ++++++
 fs/ceph/super.h       |    3 +
 net/ceph/messenger.c  |    2 +-
 net/ceph/osd_client.c |   27 +++--
 net/ceph/osdmap.c     |    2 +-
 12 files changed, 438 insertions(+), 146 deletions(-)
