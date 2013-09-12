Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220Ab3ILV5F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 17:57:05 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38342 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421Ab3ILV5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 17:57:01 -0400
Date: Thu, 12 Sep 2013 22:56:50 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Waiman Long <waiman.long@hp.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH 0/2 v2] dcache: get/release read lock in
 read_seqbegin_or_lock() & friend
Message-ID: <20130912215650.GQ13318@ZenIV.linux.org.uk>
References: <1378997735-22844-1-git-send-email-Waiman.Long@hp.com>
 <CA+55aFwsqHJE1D-z8_kU+1VEpUTB=EU57kqmKao580gYZVOjrw@mail.gmail.com>
 <CA+55aFy8Nq7yf9CJwFuyfSmkUzFKRHHOE6O8=4HjmaWpku3fhw@mail.gmail.com>
 <52320FA3.7000908@hp.com>
 <CA+55aFyvC=vKWn2-PBrfyFB9gS08DBUNwXvHhO6KaoLz=SJbMw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyvC=vKWn2-PBrfyFB9gS08DBUNwXvHhO6KaoLz=SJbMw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 12:04:56PM -0700, Linus Torvalds wrote:
> On Thu, Sep 12, 2013 at 12:01 PM, Waiman Long <waiman.long@hp.com> wrote:
> >
> > Yes, I think we can do something similar for this. I will take a look to see
> > how it can be fixed.
> 
> Actually, it was so trivial that I already did it, and only had one
> stupid brown-bag moment while doing so.
> 
> Now my threaded test-case spends most of its time allocating the
> temporary page for the result.
> 
> It's pushed out.
> 
> Btw, Al, I really want a pull request from you to fix the "returning
> to user space with semaphore held" thing. Or I'm going to apply the
> patch myself.  I'm on the road starting very early tomorrow morning,
> and I don't want to have that hanging over me..

Well...  The pull request contains quite a bit more than that - list_lru
pile, mostly.  Please, pull from the usual place -
git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus

Shortlog:
Al Viro (1):
      ... and fold the renamed __vfs_follow_link() into its only caller

Andrew Morton (2):
      xfs-convert-buftarg-lru-to-generic-code-fix
      xfs-convert-dquot-cache-lru-to-list_lru-fix

Christoph Hellwig (1):
      fs: remove vfs_follow_link

Dave Chinner (20):
      dcache: convert dentry_stat.nr_unused to per-cpu counters
      dentry: move to per-sb LRU locks
      dcache: remove dentries from LRU before putting on dispose list
      mm: new shrinker API
      shrinker: convert superblock shrinkers to new API
      list: add a new LRU list type
      inode: convert inode lru list to generic lru list code.
      dcache: convert to use new lru list infrastructure
      list_lru: per-node list infrastructure
      list_lru: fix broken LRU_RETRY behaviour
      shrinker: add node awareness
      fs: convert inode and dentry shrinking to be node aware
      xfs: convert buftarg LRU to generic code
      xfs: rework buffer dispose list tracking
      xfs: convert dquot cache lru to list_lru
      xfs: fix dquot isolation hang
      fs: convert fs shrinkers to new scan/count API
      drivers: convert shrinkers to new count/scan API
      shrinker: convert remaining shrinkers to count/scan API
      shrinker: Kill old ->shrink API.

Dave Jones (1):
      Add missing unlocks to error paths of mountpoint_last.

Glauber Costa (10):
      fs: bump inode and dentry counters to long
      super: fix calculation of shrinkable objects for small numbers
      inode: move inode to a different list inside lock
      list_lru: per-node API
      list_lru: remove special case function list_lru_dispose_all.
      vmscan: per-node deferred work
      i915: bail out earlier when shrinker cannot acquire mutex
      hugepage: convert huge zero page shrinker to new shrinker API
      list_lru: dynamically adjust node arrays
      super: fix for destroy lrus

Peng Tao (4):
      staging/lustre/ldlm: convert to shrinkers to count/scan API
      staging/lustre/obdclass: convert lu_object shrinker to count/scan API
      staging/lustre/ptlrpc: convert to new shrinker API
      staging/lustre/libcfs: cleanup linux-mem.h

Diffstat:
 Documentation/filesystems/porting                  |    4 +
 arch/x86/kvm/mmu.c                                 |   25 ++-
 drivers/gpu/drm/i915/i915_dma.c                    |    4 +-
 drivers/gpu/drm/i915/i915_gem.c                    |   82 ++++--
 drivers/gpu/drm/ttm/ttm_page_alloc.c               |   44 ++-
 drivers/gpu/drm/ttm/ttm_page_alloc_dma.c           |   51 +++--
 drivers/md/bcache/btree.c                          |   43 ++--
 drivers/md/bcache/sysfs.c                          |    2 +-
 drivers/md/dm-bufio.c                              |   64 +++--
 drivers/staging/android/ashmem.c                   |   44 ++-
 drivers/staging/android/lowmemorykiller.c          |   43 ++--
 .../lustre/include/linux/libcfs/linux/linux-mem.h  |   38 ---
 drivers/staging/lustre/lustre/ldlm/ldlm_pool.c     |  148 ++++++-----
 drivers/staging/lustre/lustre/obdclass/lu_object.c |   98 ++++---
 drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c    |   76 +++---
 fs/dcache.c                                        |  278 ++++++++++++-------
 fs/drop_caches.c                                   |    1 +
 fs/ext4/extents_status.c                           |   33 ++-
 fs/gfs2/glock.c                                    |   30 ++-
 fs/gfs2/main.c                                     |    3 +-
 fs/gfs2/quota.c                                    |   18 +-
 fs/gfs2/quota.h                                    |    6 +-
 fs/inode.c                                         |  193 ++++++--------
 fs/internal.h                                      |    6 +-
 fs/mbcache.c                                       |   49 ++--
 fs/namei.c                                         |   49 ++--
 fs/nfs/dir.c                                       |   16 +-
 fs/nfs/internal.h                                  |    6 +-
 fs/nfs/super.c                                     |    3 +-
 fs/nfsd/nfscache.c                                 |   32 ++-
 fs/quota/dquot.c                                   |   34 +--
 fs/super.c                                         |  111 +++++---
 fs/ubifs/shrinker.c                                |   29 ++-
 fs/ubifs/super.c                                   |    3 +-
 fs/ubifs/ubifs.h                                   |    5 +-
 fs/xfs/xfs_buf.c                                   |  253 +++++++++--------
 fs/xfs/xfs_buf.h                                   |   17 +-
 fs/xfs/xfs_dquot.c                                 |    7 +-
 fs/xfs/xfs_icache.c                                |    4 +-
 fs/xfs/xfs_icache.h                                |    2 +-
 fs/xfs/xfs_qm.c                                    |  287 ++++++++++---------
 fs/xfs/xfs_qm.h                                    |    4 +-
 fs/xfs/xfs_super.c                                 |   12 +-
 include/linux/dcache.h                             |   14 +-
 include/linux/fs.h                                 |   26 +-
 include/linux/list_lru.h                           |  131 +++++++++
 include/linux/shrinker.h                           |   54 +++-
 include/trace/events/vmscan.h                      |    4 +-
 include/uapi/linux/fs.h                            |    6 +-
 kernel/sysctl.c                                    |    6 +-
 mm/Makefile                                        |    2 +-
 mm/huge_memory.c                                   |   17 +-
 mm/list_lru.c                                      |  139 ++++++++++
 mm/memory-failure.c                                |    2 +
 mm/vmscan.c                                        |  241 ++++++++++-------
 net/sunrpc/auth.c                                  |   41 ++-
 56 files changed, 1778 insertions(+), 1162 deletions(-)
 create mode 100644 include/linux/list_lru.h
 create mode 100644 mm/list_lru.c
