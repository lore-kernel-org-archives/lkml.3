Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933586Ab3FSACl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 20:02:41 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:40278 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932644Ab3FSACj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 20:02:39 -0400
From: Kent Overstreet <koverstreet@google.com>
To: akpm@linux-foundation.org, tj@kernel.org, axboe@kernel.dk,
        nab@linux-iscsi.org, bcrl@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] lib/idr.c rewrite, percpu ida/tag allocator
Date: Tue, 18 Jun 2013 17:02:20 -0700
Message-Id: <1371600150-23557-1-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the second iteration of patches 1-4 - there's only been a few
trivial bugfixes for those.

The rest is the idr rewrite - I reimplemented it on top of the new ida
implementation and the existing radix tree implementation.

Patch series is available in my git repo:
git://evilpiepirate.org/~kent/linux-bcache.git idr

 arch/powerpc/mm/icswx_pid.c                   |   36 +-
 arch/powerpc/mm/mmu_context_hash64.c          |   28 +-
 block/blk-core.c                              |    4 +-
 block/blk-sysfs.c                             |    2 +-
 block/bsg.c                                   |    2 +-
 block/genhd.c                                 |    2 +-
 drivers/atm/nicstar.c                         |    4 +-
 drivers/base/platform.c                       |    6 +-
 drivers/base/soc.c                            |   18 +-
 drivers/block/drbd/drbd_main.c                |    6 +-
 drivers/block/drbd/drbd_nl.c                  |    2 +-
 drivers/block/loop.c                          |    4 +-
 drivers/block/mtip32xx/mtip32xx.c             |   24 +-
 drivers/block/nvme-core.c                     |   33 +-
 drivers/block/rsxx/core.c                     |   21 +-
 drivers/block/virtio_blk.c                    |    6 +-
 drivers/dca/dca-sysfs.c                       |   18 +-
 drivers/dma/dmaengine.c                       |    2 +-
 drivers/firewire/core-cdev.c                  |    5 +-
 drivers/firewire/core-device.c                |    2 +-
 drivers/gpio/gpiolib.c                        |    2 +-
 drivers/gpu/drm/drm_context.c                 |    2 +-
 drivers/gpu/drm/drm_crtc.c                    |    2 +-
 drivers/gpu/drm/drm_gem.c                     |    8 +-
 drivers/gpu/drm/drm_stub.c                    |    2 +-
 drivers/gpu/drm/exynos/exynos_drm_ipp.c       |    2 +-
 drivers/gpu/drm/i915/i915_gem_context.c       |    2 +-
 drivers/gpu/drm/qxl/qxl_cmd.c                 |    4 +-
 drivers/gpu/drm/qxl/qxl_drv.h                 |    1 -
 drivers/gpu/drm/qxl/qxl_kms.c                 |    1 -
 drivers/gpu/drm/qxl/qxl_release.c             |   19 +-
 drivers/gpu/drm/sis/sis_mm.c                  |    2 +-
 drivers/gpu/drm/via/via_mm.c                  |    2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_gmrid_manager.c |   31 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c      |    4 +-
 drivers/hwmon/hwmon.c                         |    6 +-
 drivers/hwmon/ibmaem.c                        |   10 +-
 drivers/i2c/i2c-core.c                        |    4 +-
 drivers/iio/industrialio-core.c               |    4 +-
 drivers/iio/industrialio-trigger.c            |    6 +-
 drivers/infiniband/core/cm.c                  |    7 +-
 drivers/infiniband/core/cma.c                 |    2 +-
 drivers/infiniband/core/sa_query.c            |    4 +-
 drivers/infiniband/core/ucm.c                 |    2 +-
 drivers/infiniband/core/ucma.c                |    4 +-
 drivers/infiniband/core/uverbs_cmd.c          |    4 +-
 drivers/infiniband/hw/amso1100/c2.h           |    1 -
 drivers/infiniband/hw/amso1100/c2_qp.c        |   20 +-
 drivers/infiniband/hw/cxgb3/iwch.h            |    4 +-
 drivers/infiniband/hw/cxgb4/iw_cxgb4.h        |    4 +-
 drivers/infiniband/hw/ehca/ehca_cq.c          |    4 +-
 drivers/infiniband/hw/ehca/ehca_qp.c          |    4 +-
 drivers/infiniband/hw/ipath/ipath_driver.c    |    4 +-
 drivers/infiniband/hw/mlx4/cm.c               |    2 +-
 drivers/infiniband/hw/ocrdma/ocrdma_main.c    |    2 +-
 drivers/infiniband/hw/qib/qib_init.c          |    4 +-
 drivers/input/input.c                         |    6 +-
 drivers/iommu/iommu.c                         |   18 +-
 drivers/ipack/ipack.c                         |    4 +-
 drivers/md/dm.c                               |   22 +-
 drivers/memstick/core/memstick.c              |   17 +-
 drivers/memstick/core/mspro_block.c           |    2 +-
 drivers/mfd/rtsx_pcr.c                        |   13 +-
 drivers/misc/c2port/core.c                    |   11 +-
 drivers/misc/cb710/core.c                     |   19 +-
 drivers/misc/tifm_core.c                      |   15 +-
 drivers/mmc/core/host.c                       |   13 +-
 drivers/mtd/mtdcore.c                         |    4 +-
 drivers/net/macvtap.c                         |    2 +-
 drivers/net/ppp/ppp_generic.c                 |    4 +-
 drivers/power/bq2415x_charger.c               |    2 +-
 drivers/power/bq27x00_battery.c               |    2 +-
 drivers/power/ds2782_battery.c                |    2 +-
 drivers/pps/kapi.c                            |    2 +-
 drivers/pps/pps.c                             |    4 +-
 drivers/ptp/ptp_clock.c                       |    4 +-
 drivers/remoteproc/remoteproc_core.c          |    8 +-
 drivers/rpmsg/virtio_rpmsg_bus.c              |    4 +-
 drivers/rtc/class.c                           |    6 +-
 drivers/scsi/bfa/bfad_im.c                    |    2 +-
 drivers/scsi/ch.c                             |   14 +-
 drivers/scsi/lpfc/lpfc_init.c                 |    2 +-
 drivers/scsi/osd/osd_uld.c                    |    9 +-
 drivers/scsi/scsi_transport_iscsi.c           |    6 +-
 drivers/scsi/sd.c                             |   19 +-
 drivers/scsi/sg.c                             |    4 +-
 drivers/scsi/st.c                             |   13 +-
 drivers/staging/tidspbridge/rmgr/drv.c        |    4 +-
 drivers/staging/zcache/ramster/tcp.c          |    2 +-
 drivers/target/iscsi/iscsi_target.c           |   17 +-
 drivers/target/iscsi/iscsi_target.h           |    1 -
 drivers/target/iscsi/iscsi_target_login.c     |   12 +-
 drivers/thermal/cpu_cooling.c                 |    2 +-
 drivers/thermal/thermal_core.c                |    2 +-
 drivers/uio/uio.c                             |    2 +-
 drivers/usb/chipidea/core.c                   |    6 +-
 drivers/vfio/vfio.c                           |    2 +-
 drivers/virtio/virtio.c                       |    4 +-
 drivers/w1/slaves/w1_ds2760.c                 |    6 +-
 drivers/w1/slaves/w1_ds2780.c                 |    6 +-
 drivers/w1/slaves/w1_ds2781.c                 |    6 +-
 drivers/watchdog/watchdog_core.c              |   12 +-
 fs/devpts/inode.c                             |   24 +-
 fs/dlm/lock.c                                 |    4 +-
 fs/dlm/recover.c                              |    4 +-
 fs/namespace.c                                |   49 +-
 fs/nfs/nfs4client.c                           |    4 +-
 fs/nfs/nfs4state.c                            |   33 +-
 fs/notify/inotify/inotify_user.c              |    2 +-
 fs/ocfs2/cluster/tcp.c                        |    2 +-
 fs/proc/generic.c                             |   29 +-
 fs/super.c                                    |   37 +-
 fs/sysfs/dir.c                                |   20 +-
 include/linux/cgroup.h                        |    1 -
 include/linux/idr.h                           |  358 +++--
 include/net/sctp/sctp.h                       |    1 -
 init/main.c                                   |    1 -
 ipc/util.c                                    |    6 +-
 kernel/cgroup.c                               |   42 +-
 kernel/events/core.c                          |    2 +-
 kernel/workqueue.c                            |   17 +-
 lib/idr.c                                     | 1794 ++++++++++++-------------
 mm/memcontrol.c                               |    6 +-
 net/9p/util.c                                 |   15 +-
 net/bluetooth/hci_core.c                      |    8 +-
 net/core/net_namespace.c                      |   15 +-
 net/mac80211/tx.c                             |    2 +-
 net/nfc/core.c                                |    4 +-
 net/sctp/associola.c                          |   14 +-
 net/sctp/protocol.c                           |    1 -
 net/sctp/socket.c                             |    2 -
 131 files changed, 1371 insertions(+), 1874 deletions(-)
