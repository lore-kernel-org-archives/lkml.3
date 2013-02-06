Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757531Ab3BFTtX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 14:49:23 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:46653 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755031Ab3BFTtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 14:49:21 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCHSET] idr: deprecate idr_remova_all() and add idr_alloc()
Date: Wed,  6 Feb 2013 11:39:32 -0800
Message-Id: <1360179649-22465-1-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(If you're reading this patchset for the first time, this patchset is
 an effort to improve idr interface.  This posting is mostly for
 collecting and routing the patches towards -mm.  Please follow the
 link at the end for details on each patchset.)

Hello, Andrew.

This patchset is combination of the following three on top of
linux-next as of 20130204 (the one before idr_removal_all() got
included).

  [1] [PATCH] idr: fix a subtle bug in idr_get_next()
+ [2] [PATCHSET] idr: deprecate idr_remove_all()
+ [3] [PATCHSET] idr: implement idr_alloc() and convert existing users (w/ all updates)

Please note that we need the idr_get_next() fix before
idr_remove_all() deprecation.

The idr_alloc() part has all the posted updates rolled in and acks
added, and I think it's at least ready for testing.  Ah, right, I
skipped deprecation of idr_pre_get() and idr_get_new*() for now.  nfs
changes are being routed separately and we can do the deprecation
after after -rc1.

This patchset contains the following 77 patches.

 0001-idr-fix-a-subtle-bug-in-idr_get_next.patch
 0002-idr-make-idr_destroy-imply-idr_remove_all.patch
 0003-atm-nicstar-don-t-use-idr_remove_all.patch
 0004-block-loop-don-t-use-idr_remove_all.patch
 0005-firewire-don-t-use-idr_remove_all.patch
 0006-drm-don-t-use-idr_remove_all.patch
 0007-dm-don-t-use-idr_remove_all.patch
 0008-remoteproc-don-t-use-idr_remove_all.patch
 0009-rpmsg-don-t-use-idr_remove_all.patch
 0010-dlm-use-idr_for_each_entry-in-recover_idr_clear-erro.patch
 0011-dlm-don-t-use-idr_remove_all.patch
 0012-nfs-idr_destroy-no-longer-needs-idr_remove_all.patch
 0013-inotify-don-t-use-idr_remove_all.patch
 0014-cgroup-don-t-use-idr_remove_all.patch
 0015-idr-deprecate-idr_remove_all.patch
 0016-idr-cosmetic-updates-to-struct-initializer-definitio.patch
 0017-idr-relocate-idr_for_each_entry-and-reorganize-id-r-.patch
 0018-idr-remove-_idr_rc_to_errno-hack.patch
 0019-idr-refactor-idr_get_new_above.patch
 0020-idr-implement-idr_preload-_end-and-idr_alloc.patch
 0021-block-fix-synchronization-and-limit-check-in-blk_all.patch
 0022-block-convert-to-idr_alloc.patch
 0023-block-loop-convert-to-idr_alloc.patch
 0024-atm-nicstar-convert-to-idr_alloc.patch
 0025-drbd-convert-to-idr_alloc.patch
 0026-dca-convert-to-idr_alloc.patch
 0027-dmaengine-convert-to-idr_alloc.patch
 0028-firewire-add-minor-number-range-check-to-fw_device_i.patch
 0029-firewire-convert-to-idr_alloc.patch
 0030-gpio-convert-to-idr_alloc.patch
 0031-drm-convert-to-idr_alloc.patch
 0032-drm-exynos-convert-to-idr_alloc.patch
 0033-drm-i915-convert-to-idr_alloc.patch
 0034-drm-sis-convert-to-idr_alloc.patch
 0035-drm-via-convert-to-idr_alloc.patch
 0036-drm-vmwgfx-convert-to-idr_alloc.patch
 0037-i2c-convert-to-idr_alloc.patch
 0038-IB-core-convert-to-idr_alloc.patch
 0039-IB-amso1100-convert-to-idr_alloc.patch
 0040-IB-cxgb3-convert-to-idr_alloc.patch
 0041-IB-cxgb4-convert-to-idr_alloc.patch
 0042-IB-ehca-convert-to-idr_alloc.patch
 0043-IB-ipath-convert-to-idr_alloc.patch
 0044-IB-mlx4-convert-to-idr_alloc.patch
 0045-IB-ocrdma-convert-to-idr_alloc.patch
 0046-IB-qib-convert-to-idr_alloc.patch
 0047-dm-convert-to-idr_alloc.patch
 0048-memstick-convert-to-idr_alloc.patch
 0049-mfd-convert-to-idr_alloc.patch
 0050-misc-c2port-convert-to-idr_alloc.patch
 0051-misc-tifm_core-convert-to-idr_alloc.patch
 0052-mmc-convert-to-idr_alloc.patch
 0053-mtd-convert-to-idr_alloc.patch
 0054-macvtap-convert-to-idr_alloc.patch
 0055-ppp-convert-to-idr_alloc.patch
 0056-power-convert-to-idr_alloc.patch
 0057-pps-convert-to-idr_alloc.patch
 0058-remoteproc-convert-to-idr_alloc.patch
 0059-rpmsg-convert-to-idr_alloc.patch
 0060-scsi-bfa-convert-to-idr_alloc.patch
 0061-scsi-convert-to-idr_alloc.patch
 0062-target-iscsi-convert-to-idr_alloc.patch
 0063-scsi-lpfc-convert-to-idr_alloc.patch
 0064-thermal-convert-to-idr_alloc.patch
 0065-uio-convert-to-idr_alloc.patch
 0066-vfio-convert-to-idr_alloc.patch
 0067-dlm-convert-to-idr_alloc.patch
 0068-inotify-convert-to-idr_alloc.patch
 0069-ocfs2-convert-to-idr_alloc.patch
 0070-ipc-convert-to-idr_alloc.patch
 0071-cgroup-convert-to-idr_alloc.patch
 0072-events-convert-to-idr_alloc.patch
 0073-posix-timers-convert-to-idr_alloc.patch
 0074-net-9p-convert-to-idr_alloc.patch
 0075-mac80211-convert-to-idr_alloc.patch
 0076-sctp-convert-to-idr_alloc.patch
 0077-nfs4client-convert-to-idr_alloc.patch

and is available in the following git branch.

 git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git convert-to-idr_alloc

diffstat follows.

 block/bsg.c                                |   26 --
 block/genhd.c                              |   22 --
 drivers/atm/nicstar.c                      |   25 --
 drivers/block/drbd/drbd_main.c             |   29 +-
 drivers/block/loop.c                       |   24 --
 drivers/dca/dca-sysfs.c                    |   23 --
 drivers/dma/dmaengine.c                    |   16 -
 drivers/firewire/core-cdev.c               |   20 -
 drivers/firewire/core-device.c             |    4 
 drivers/gpio/gpiolib.c                     |   11 -
 drivers/gpu/drm/drm_context.c              |   19 -
 drivers/gpu/drm/drm_crtc.c                 |   20 -
 drivers/gpu/drm/drm_drv.c                  |    1 
 drivers/gpu/drm/drm_gem.c                  |   37 +--
 drivers/gpu/drm/drm_stub.c                 |   19 -
 drivers/gpu/drm/exynos/exynos_drm_ipp.c    |   20 -
 drivers/gpu/drm/i915/i915_gem_context.c    |   21 --
 drivers/gpu/drm/sis/sis_drv.c              |    1 
 drivers/gpu/drm/sis/sis_mm.c               |   13 -
 drivers/gpu/drm/via/via_map.c              |    1 
 drivers/gpu/drm/via/via_mm.c               |   13 -
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c   |   17 -
 drivers/i2c/i2c-core.c                     |   45 ----
 drivers/infiniband/core/cm.c               |   22 +-
 drivers/infiniband/core/cma.c              |   24 --
 drivers/infiniband/core/sa_query.c         |   18 -
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
 drivers/md/dm.c                            |   55 +----
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
 drivers/remoteproc/remoteproc_core.c       |   11 -
 drivers/rpmsg/virtio_rpmsg_bus.c           |   31 +--
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
 drivers/vfio/vfio.c                        |   17 -
 fs/dlm/lock.c                              |   18 -
 fs/dlm/lockspace.c                         |    1 
 fs/dlm/recover.c                           |   52 ++---
 fs/nfs/client.c                            |    1 
 fs/nfs/nfs4client.c                        |   13 -
 fs/notify/inotify/inotify_fsnotify.c       |    1 
 fs/notify/inotify/inotify_user.c           |   24 +-
 fs/ocfs2/cluster/tcp.c                     |   32 +--
 include/linux/idr.h                        |  109 +++++++---
 ipc/util.c                                 |   30 --
 kernel/cgroup.c                            |   31 ---
 kernel/events/core.c                       |   10 
 kernel/posix-timers.c                      |   18 -
 lib/idr.c                                  |  298 ++++++++++++++++++++---------
 net/9p/util.c                              |   17 -
 net/mac80211/main.c                        |    2 
 net/mac80211/tx.c                          |   18 -
 net/sctp/associola.c                       |   31 +--
 84 files changed, 832 insertions(+), 1184 deletions(-)

Thanks.

--
tejun

[1] https://lkml.org/lkml/2013/2/2/145
[2] https://lkml.org/lkml/2013/1/25/759
[3] http://thread.gmane.org/gmane.linux.kernel/1434387
