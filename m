Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180Ab3BCBVO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 20:21:14 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:37702 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492Ab3BCBVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 20:21:12 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, bfields@fieldses.org,
        skinsbursky@parallels.com, ebiederm@xmission.com, jmorris@namei.org,
        axboe@kernel.dk
Subject: [PATCHSET] idr: implement idr_alloc() and convert existing users
Date: Sat,  2 Feb 2013 17:20:01 -0800
Message-Id: <1359854463-2538-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

* Andrew, I think this one is best routed through -mm together with
  the previous series.  Please read on.

* Bruce, I couldn't convert nfsd.  Can you please help?  More on it
  later.

* Stanislav, Eric, James, can you please take a look at ipc/util.c
  conversion?  I moved allocation inside ipc_addid().  I *think* it's
  correct but I'm not too familiar with the code.

* Jens, 0006 is fix for block layer regarding devt allocation.  Given
  how long this has been broken unnoticed and how late we're in the
  release cycle, I think it would be better to route the fix with the
  rest and let it get backported through -stable later on.

Currently, idr interface is a pain in the ass to use.  It has a
mandatory pre-alloc mechanism which doesn't even guarantee the
following allocation wouldn't fail from memory shortage requiring its
users to loop on -EAGAIN.  Also, there's no way to specify upper
limit.  Combined, a user who wants allocate an ID with upper limit
ends up doing something like the following.

	do {
		if (!idr_pre_get(idr, GFP_KERNEL))
			return -ENOMEM;
		spin_lock(lock);
		ret = idr_get_new_above(idr, ptr, lower_limit, &id);
		if (!ret && id < upper_limit) {
			idr_remove(idr, id);
			ret = -ENOSPC;
		}
		spin_unlock(lock);
	} while (ret == -EAGAIN);

	if (ret)
		return ret;

which is just crazy.  Preloading is also very inefficient - each idr
ends up holding MAX_IDR_FREE idr_layers.  Even on a fairly small
machine (my x230) w/o anything too heavy going on, it ends up
allocating over 1200 idr_layers with three quarters of them unused.
This also makes it difficult to make each layer larger to reduce the
depth of idr trees.

This patchset implements a new set of allocation interface for idr.

 void idr_preload(gfp_t gfp_mask);
 void idr_preload_end(void);
 int idr_alloc(struct idr *idr, void *ptr, int start, int end, gfp_t gfp_mask);

idr_alloc() can be used w/o preloading if permissive enough @gfp_mask
can be used directly.  If not, preloading, which uses per-cpu layer
buffer, can be used.  Note that idr_preload() doesn't fail.  It simply
guarnatees that the following idr_alloc() would behave as if it were
called with @gfp_mask specified at preloading time.  The above example
with the old interface would become the following using the new
interface.

	idr_preload(GFP_KERNEL);
	spin_lock(lock);

	id = idr_alloc(idr, ptr, lower_limit, upper_limit, GFP_NOWAIT);

	spin_unlock(lock);
	idr_preload_end();
	if (id < 0)
		return id;

Which is simpler and less error-prone.  Also, there are many cases
where preloading isn't necessary (e.g. the section is protected by
outer mutex).  For those, idr_alloc() can be used by itself.

	id = idr_alloc(idr, ptr, lower_limit, upper_limit, GFP_KERNEL);
	if (id < 0)
		return id;

I converted all in-kernel users except nfsd and staging drivers.  nfsd
splits preloading and actual id allocation in a way that per-cpu
preloading can't be used.  I couldn't follow the control flow to
verify whether the current code is correct either.  I think the best
way would be allocating ID upfront without installing the handle and
then later using idr_replace() to install the pointer when the ID
actually gets used.  Bruce, would something like that be possible?

This patchset contains the following 62 patches.

 0001-idr-cosmetic-updates-to-struct-initializer-definitio.patch
 0002-idr-relocate-idr_for_each_entry-and-reorganize-id-r-.patch
 0003-idr-remove-_idr_rc_to_errno-hack.patch
 0004-idr-refactor-idr_get_new_above.patch
 0005-idr-implement-idr_preload-_end-and-idr_alloc.patch
 0006-block-fix-synchronization-and-limit-check-in-blk_all.patch
 0007-block-convert-to-idr_alloc.patch
 0008-block-loop-convert-to-idr_alloc.patch
 0009-atm-nicstar-convert-to-idr_alloc.patch
 0010-drbd-convert-to-idr_alloc.patch
 0011-dca-convert-to-idr_alloc.patch
 0012-dmaengine-convert-to-idr_alloc.patch
 0013-firewire-convert-to-idr_alloc.patch
 0014-gpio-convert-to-idr_alloc.patch
 0015-drm-convert-to-idr_alloc.patch
 0016-drm-exynos-convert-to-idr_alloc.patch
 0017-drm-i915-convert-to-idr_alloc.patch
 0018-drm-sis-convert-to-idr_alloc.patch
 0019-drm-via-convert-to-idr_alloc.patch
 0020-drm-vmwgfx-convert-to-idr_alloc.patch
 0021-i2c-convert-to-idr_alloc.patch
 0022-infiniband-core-convert-to-idr_alloc.patch
 0023-infiniband-amso1100-convert-to-idr_alloc.patch
 0024-infiniband-cxgb3-convert-to-idr_alloc.patch
 0025-infiniband-cxgb4-convert-to-idr_alloc.patch
 0026-infiniband-ehca-convert-to-idr_alloc.patch
 0027-infiniband-ipath-convert-to-idr_alloc.patch
 0028-infiniband-mlx4-convert-to-idr_alloc.patch
 0029-infiniband-ocrdma-convert-to-idr_alloc.patch
 0030-infiniband-qib-convert-to-idr_alloc.patch
 0031-dm-convert-to-idr_alloc.patch
 0032-memstick-convert-to-idr_alloc.patch
 0033-mfd-convert-to-idr_alloc.patch
 0034-misc-c2port-convert-to-idr_alloc.patch
 0035-misc-tifm_core-convert-to-idr_alloc.patch
 0036-mmc-convert-to-idr_alloc.patch
 0037-mtd-convert-to-idr_alloc.patch
 0038-i2c-convert-to-idr_alloc.patch
 0039-ppp-convert-to-idr_alloc.patch
 0040-power-convert-to-idr_alloc.patch
 0041-pps-convert-to-idr_alloc.patch
 0042-remoteproc-convert-to-idr_alloc.patch
 0043-rpmsg-convert-to-idr_alloc.patch
 0044-scsi-bfa-convert-to-idr_alloc.patch
 0045-scsi-convert-to-idr_alloc.patch
 0046-target-iscsi-convert-to-idr_alloc.patch
 0047-scsi-lpfc-convert-to-idr_alloc.patch
 0048-thermal-convert-to-idr_alloc.patch
 0049-uio-convert-to-idr_alloc.patch
 0050-vfio-convert-to-idr_alloc.patch
 0051-dlm-convert-to-idr_alloc.patch
 0052-inotify-convert-to-idr_alloc.patch
 0053-ocfs2-convert-to-idr_alloc.patch
 0054-ipc-convert-to-idr_alloc.patch
 0055-cgroup-convert-to-idr_alloc.patch
 0056-events-convert-to-idr_alloc.patch
 0057-posix-timers-convert-to-idr_alloc.patch
 0058-net-9p-convert-to-idr_alloc.patch
 0059-mac80211-convert-to-idr_alloc.patch
 0060-sctp-convert-to-idr_alloc.patch
 0061-nfs4client-convert-to-idr_alloc.patch
 0062-idr-deprecate-idr_pre_get-and-idr_get_new-_above.patch

0001-0005 implement the new idr interface.  0006 is idr related block
fix.  0007-0061 convert in-kernel users to idr_alloc().  0062 marks
the old interface deprecated (note that this makes nfsd compilation
generates warning).

While I tried to be careful and reviewed the whole series a couple
times, my test coverage is unavoidably quite limited.  I don't think
fallouts would be too difficult to spot during testing.

This patchset is on top of

  [1] [PATCH] idr: fix a subtle bug in idr_get_next()
+ [2] [PATCHSET] idr: deprecate idr_remove_all()

and available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git convert-to-idr_alloc

Excluding idr.[hc], which should become smaller once we remove the old
interface, this conversion sheds 482 lines across the kernel.
diffstat follows.

 block/bsg.c                                |   26 --
 block/genhd.c                              |   22 --
 drivers/atm/nicstar.c                      |   27 +-
 drivers/block/drbd/drbd_main.c             |   29 +-
 drivers/block/loop.c                       |   23 --
 drivers/dca/dca-sysfs.c                    |   23 --
 drivers/dma/dmaengine.c                    |   16 -
 drivers/firewire/core-cdev.c               |   16 -
 drivers/firewire/core-device.c             |    5 
 drivers/gpio/gpiolib.c                     |   11 -
 drivers/gpu/drm/drm_context.c              |   17 -
 drivers/gpu/drm/drm_crtc.c                 |   15 -
 drivers/gpu/drm/drm_gem.c                  |   35 +--
 drivers/gpu/drm/drm_stub.c                 |   19 -
 drivers/gpu/drm/exynos/exynos_drm_ipp.c    |   16 -
 drivers/gpu/drm/i915/i915_gem_context.c    |   21 --
 drivers/gpu/drm/sis/sis_mm.c               |   13 -
 drivers/gpu/drm/via/via_mm.c               |   13 -
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c   |   17 -
 drivers/i2c/i2c-core.c                     |   45 ----
 drivers/infiniband/core/cm.c               |   22 +-
 drivers/infiniband/core/cma.c              |   24 --
 drivers/infiniband/core/sa_query.c         |   15 -
 drivers/infiniband/core/ucm.c              |   16 -
 drivers/infiniband/core/ucma.c             |   32 ---
 drivers/infiniband/core/uverbs_cmd.c       |   17 -
 drivers/infiniband/hw/amso1100/c2_qp.c     |   19 +
 drivers/infiniband/hw/cxgb3/iwch.h         |   24 +-
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h     |   27 +-
 drivers/infiniband/hw/ehca/ehca_cq.c       |   27 --
 drivers/infiniband/hw/ehca/ehca_qp.c       |   34 +--
 drivers/infiniband/hw/ipath/ipath_driver.c |   16 -
 drivers/infiniband/hw/mlx4/cm.c            |   32 +--
 drivers/infiniband/hw/ocrdma/ocrdma_main.c |   14 -
 drivers/infiniband/hw/qib/qib_init.c       |   21 --
 drivers/md/dm.c                            |   54 +----
 drivers/memstick/core/memstick.c           |   21 --
 drivers/memstick/core/mspro_block.c        |   17 -
 drivers/mfd/rtsx_pcr.c                     |   13 -
 drivers/misc/c2port/core.c                 |   22 --
 drivers/misc/tifm_core.c                   |   11 -
 drivers/mmc/core/host.c                    |   11 -
 drivers/mtd/mtdcore.c                      |    9 
 drivers/net/macvtap.c                      |   21 --
 drivers/net/ppp/ppp_generic.c              |   33 ---
 drivers/power/bq2415x_charger.c            |   11 -
 drivers/power/bq27x00_battery.c            |    9 
 drivers/power/ds2782_battery.c             |    9 
 drivers/pps/kapi.c                         |    2 
 drivers/pps/pps.c                          |   36 +--
 drivers/remoteproc/remoteproc_core.c       |   10 
 drivers/rpmsg/virtio_rpmsg_bus.c           |   30 +-
 drivers/scsi/bfa/bfad_im.c                 |   15 -
 drivers/scsi/ch.c                          |   21 --
 drivers/scsi/lpfc/lpfc_init.c              |   12 -
 drivers/scsi/sg.c                          |   43 +---
 drivers/scsi/st.c                          |   27 --
 drivers/target/iscsi/iscsi_target.c        |   15 -
 drivers/target/iscsi/iscsi_target_login.c  |   15 -
 drivers/thermal/cpu_cooling.c              |   17 -
 drivers/thermal/thermal_sys.c              |   17 -
 drivers/uio/uio.c                          |   19 -
 drivers/vfio/vfio.c                        |   18 -
 fs/dlm/lock.c                              |   18 -
 fs/dlm/recover.c                           |   27 +-
 fs/nfs/nfs4client.c                        |   13 -
 fs/notify/inotify/inotify_user.c           |   24 +-
 fs/ocfs2/cluster/tcp.c                     |   32 +--
 include/linux/idr.h                        |  135 +++++++++----
 ipc/util.c                                 |   30 --
 kernel/cgroup.c                            |   27 --
 kernel/events/core.c                       |   10 
 kernel/posix-timers.c                      |   18 -
 lib/idr.c                                  |  291 ++++++++++++++++++-----------
 net/9p/util.c                              |   17 -
 net/mac80211/main.c                        |    2 
 net/mac80211/tx.c                          |   18 -
 net/sctp/associola.c                       |   27 +-
 78 files changed, 816 insertions(+), 1160 deletions(-)

--
tejun

[1] https://lkml.org/lkml/2013/2/2/145
[2] https://lkml.org/lkml/2013/1/25/759
