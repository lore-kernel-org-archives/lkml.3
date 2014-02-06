Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932724AbaBFNwW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 08:52:22 -0500
Received: from merlin.infradead.org ([205.233.59.134]:49156 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932669AbaBFNwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 08:52:18 -0500
Message-Id: <20140206134825.305510953@infradead.org>
User-Agent: quilt/0.60-1
Date: Thu, 06 Feb 2014 14:48:25 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org, mingo@kernel.org,
        will.deacon@arm.com, paulmck@linux.vnet.ibm.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: [RFC][PATCH 0/5] arch: atomic rework
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

A few too large patches here, mostly as RFC to see if we want to continue with
this before I sink more time into it. I hope they make it out to the lists.

This all started with me wanting to implement atomic_sub_release() for all
archs, but I got side-tracked a bit and it ended up cleaning up bits and
deleting almost 1400 lines of code.

Its been compiled on everything I have a compiler for, however frv and
tile are missing because they're special and I was tired.

---
 Documentation/atomic_ops.txt                      |   31 -
 Documentation/memory-barriers.txt                 |   44 -
 a/arch/arc/include/asm/barrier.h                  |   37 -
 a/arch/hexagon/include/asm/barrier.h              |   37 -
 arch/alpha/include/asm/atomic.h                   |  225 +++-----
 arch/alpha/include/asm/bitops.h                   |    3 
 arch/arc/include/asm/atomic.h                     |  198 ++-----
 arch/arc/include/asm/bitops.h                     |    5 
 arch/arm/include/asm/atomic.h                     |  301 ++++-------
 arch/arm/include/asm/barrier.h                    |    3 
 arch/arm/include/asm/bitops.h                     |    4 
 arch/arm64/include/asm/atomic.h                   |  212 +++-----
 arch/arm64/include/asm/barrier.h                  |    3 
 arch/arm64/include/asm/bitops.h                   |    9 
 arch/avr32/include/asm/atomic.h                   |   95 +--
 arch/avr32/include/asm/bitops.h                   |    9 
 arch/blackfin/include/asm/atomic.h                |    5 
 arch/blackfin/include/asm/barrier.h               |    3 
 arch/blackfin/include/asm/bitops.h                |   14 
 arch/blackfin/mach-common/smp.c                   |    2 
 arch/c6x/include/asm/bitops.h                     |    8 
 arch/cris/include/arch-v10/arch/system.h          |    2 
 arch/cris/include/asm/atomic.h                    |   66 +-
 arch/cris/include/asm/bitops.h                    |    9 
 arch/frv/include/asm/atomic.h                     |    7 
 arch/frv/include/asm/bitops.h                     |    6 
 arch/hexagon/include/asm/atomic.h                 |   74 +-
 arch/hexagon/include/asm/bitops.h                 |    4 
 arch/ia64/include/asm/atomic.h                    |  212 ++++----
 arch/ia64/include/asm/barrier.h                   |    3 
 arch/ia64/include/asm/bitops.h                    |    9 
 arch/ia64/include/uapi/asm/cmpxchg.h              |    9 
 arch/m32r/include/asm/atomic.h                    |  191 ++-----
 arch/m32r/include/asm/bitops.h                    |    6 
 arch/m32r/kernel/smp.c                            |    4 
 arch/m68k/include/asm/atomic.h                    |  130 +----
 arch/m68k/include/asm/bitops.h                    |    7 
 arch/metag/include/asm/atomic.h                   |    6 
 arch/metag/include/asm/atomic_lnkget.h            |  159 +-----
 arch/metag/include/asm/atomic_lock1.h             |  100 +--
 arch/metag/include/asm/barrier.h                  |    3 
 arch/metag/include/asm/bitops.h                   |    6 
 arch/mips/include/asm/atomic.h                    |  570 +++++++---------------
 arch/mips/include/asm/barrier.h                   |    3 
 arch/mips/include/asm/bitops.h                    |   11 
 arch/mips/kernel/irq.c                            |    4 
 arch/mn10300/include/asm/atomic.h                 |  199 +------
 arch/mn10300/include/asm/bitops.h                 |    4 
 arch/mn10300/mm/tlb-smp.c                         |    6 
 arch/openrisc/include/asm/bitops.h                |    9 
 arch/parisc/include/asm/atomic.h                  |  121 ++--
 arch/parisc/include/asm/bitops.h                  |    4 
 arch/powerpc/include/asm/atomic.h                 |  214 +++-----
 arch/powerpc/include/asm/barrier.h                |    3 
 arch/powerpc/include/asm/bitops.h                 |    6 
 arch/powerpc/kernel/crash.c                       |    2 
 arch/powerpc/kernel/misc_32.S                     |   19 
 arch/s390/include/asm/atomic.h                    |   93 ++-
 arch/s390/include/asm/barrier.h                   |    5 
 arch/s390/include/asm/bitops.h                    |    1 
 arch/s390/kernel/time.c                           |    4 
 arch/s390/kvm/diag.c                              |    2 
 arch/s390/kvm/intercept.c                         |    2 
 arch/s390/kvm/interrupt.c                         |   16 
 arch/s390/kvm/kvm-s390.c                          |   14 
 arch/s390/kvm/sigp.c                              |    6 
 arch/score/include/asm/bitops.h                   |    7 
 arch/sh/include/asm/atomic-grb.h                  |  164 +-----
 arch/sh/include/asm/atomic-irq.h                  |   88 +--
 arch/sh/include/asm/atomic-llsc.h                 |  135 +----
 arch/sh/include/asm/atomic.h                      |    6 
 arch/sh/include/asm/bitops.h                      |    7 
 arch/sparc/include/asm/atomic_32.h                |   30 -
 arch/sparc/include/asm/atomic_64.h                |   53 --
 arch/sparc/include/asm/barrier_32.h               |    1 
 arch/sparc/include/asm/barrier_64.h               |    3 
 arch/sparc/include/asm/bitops_32.h                |    4 
 arch/sparc/include/asm/bitops_64.h                |    4 
 arch/sparc/include/asm/processor.h                |    2 
 arch/sparc/kernel/smp_64.c                        |    2 
 arch/sparc/lib/atomic32.c                         |   28 -
 arch/sparc/lib/atomic_64.S                        |  167 ++----
 arch/sparc/lib/ksyms.c                            |   20 
 arch/tile/include/asm/atomic_32.h                 |   10 
 arch/tile/include/asm/atomic_64.h                 |    6 
 arch/tile/include/asm/barrier.h                   |   14 
 arch/tile/include/asm/bitops.h                    |    1 
 arch/tile/include/asm/bitops_32.h                 |    8 
 arch/tile/include/asm/bitops_64.h                 |    4 
 arch/x86/include/asm/atomic.h                     |   39 -
 arch/x86/include/asm/atomic64_32.h                |   20 
 arch/x86/include/asm/atomic64_64.h                |   22 
 arch/x86/include/asm/barrier.h                    |    4 
 arch/x86/include/asm/bitops.h                     |    6 
 arch/x86/include/asm/sync_bitops.h                |    2 
 arch/x86/kernel/apic/hw_nmi.c                     |    2 
 arch/xtensa/include/asm/atomic.h                  |  318 +++---------
 arch/xtensa/include/asm/bitops.h                  |    4 
 block/blk-iopoll.c                                |    4 
 crypto/chainiv.c                                  |    2 
 drivers/base/power/domain.c                       |    2 
 drivers/block/mtip32xx/mtip32xx.c                 |    4 
 drivers/cpuidle/coupled.c                         |    2 
 drivers/firewire/ohci.c                           |    2 
 drivers/gpu/drm/drm_irq.c                         |   10 
 drivers/gpu/drm/i915/i915_irq.c                   |    6 
 drivers/md/bcache/bcache.h                        |    2 
 drivers/md/bcache/closure.h                       |    2 
 drivers/md/dm-bufio.c                             |    8 
 drivers/md/dm-snap.c                              |    4 
 drivers/md/dm.c                                   |    2 
 drivers/md/raid5.c                                |    2 
 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c       |    6 
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c   |    6 
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c  |   34 -
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sp.c    |   26 -
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c |   12 
 drivers/net/ethernet/broadcom/cnic.c              |    8 
 drivers/net/ethernet/brocade/bna/bnad.c           |    6 
 drivers/net/ethernet/chelsio/cxgb/cxgb2.c         |    2 
 drivers/net/ethernet/chelsio/cxgb3/sge.c          |    6 
 drivers/net/ethernet/chelsio/cxgb4/sge.c          |    2 
 drivers/net/ethernet/chelsio/cxgb4vf/sge.c        |    2 
 drivers/net/ethernet/intel/i40e/i40e_main.c       |    2 
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c     |    4 
 drivers/net/wireless/ti/wlcore/main.c             |    2 
 drivers/pci/xen-pcifront.c                        |    4 
 drivers/s390/scsi/zfcp_aux.c                      |    2 
 drivers/s390/scsi/zfcp_erp.c                      |   68 +-
 drivers/s390/scsi/zfcp_fc.c                       |    8 
 drivers/s390/scsi/zfcp_fsf.c                      |   30 -
 drivers/s390/scsi/zfcp_qdio.c                     |   14 
 drivers/scsi/isci/remote_device.c                 |    2 
 drivers/target/loopback/tcm_loop.c                |    4 
 drivers/target/target_core_alua.c                 |   26 -
 drivers/target/target_core_device.c               |    6 
 drivers/target/target_core_iblock.c               |    2 
 drivers/target/target_core_pr.c                   |   56 +-
 drivers/target/target_core_transport.c            |   16 
 drivers/target/target_core_ua.c                   |   10 
 drivers/tty/n_tty.c                               |    2 
 drivers/tty/serial/mxs-auart.c                    |    4 
 drivers/usb/gadget/tcm_usb_gadget.c               |    4 
 drivers/usb/serial/usb_wwan.c                     |    2 
 drivers/vhost/scsi.c                              |    2 
 drivers/w1/w1_family.c                            |    4 
 drivers/xen/xen-pciback/pciback_ops.c             |    4 
 fs/btrfs/btrfs_inode.h                            |    2 
 fs/btrfs/extent_io.c                              |    2 
 fs/btrfs/inode.c                                  |    6 
 fs/buffer.c                                       |    2 
 fs/ext4/resize.c                                  |    2 
 fs/gfs2/glock.c                                   |    8 
 fs/gfs2/glops.c                                   |    2 
 fs/gfs2/lock_dlm.c                                |    4 
 fs/gfs2/recovery.c                                |    2 
 fs/gfs2/sys.c                                     |    4 
 fs/jbd2/commit.c                                  |    6 
 fs/nfs/dir.c                                      |   12 
 fs/nfs/inode.c                                    |    2 
 fs/nfs/nfs4filelayoutdev.c                        |    4 
 fs/nfs/nfs4state.c                                |    4 
 fs/nfs/pagelist.c                                 |    6 
 fs/nfs/pnfs.c                                     |    2 
 fs/nfs/pnfs.h                                     |    2 
 fs/nfs/write.c                                    |    4 
 fs/ubifs/lpt_commit.c                             |    4 
 fs/ubifs/tnc_commit.c                             |    4 
 include/asm-generic/atomic.h                      |  176 ++----
 include/asm-generic/atomic64.h                    |   17 
 include/asm-generic/barrier.h                     |    8 
 include/asm-generic/bitops.h                      |    8 
 include/asm-generic/bitops/atomic.h               |    2 
 include/asm-generic/bitops/lock.h                 |    2 
 include/linux/atomic.h                            |   13 
 include/linux/buffer_head.h                       |    2 
 include/linux/genhd.h                             |    2 
 include/linux/interrupt.h                         |    8 
 include/linux/netdevice.h                         |    2 
 include/linux/sched.h                             |    6 
 include/linux/sunrpc/sched.h                      |    8 
 include/linux/sunrpc/xprt.h                       |    8 
 include/linux/tracehook.h                         |    2 
 include/net/ip_vs.h                               |    4 
 kernel/debug/debug_core.c                         |    4 
 kernel/futex.c                                    |    2 
 kernel/kmod.c                                     |    2 
 kernel/rcu/tree.c                                 |   22 
 kernel/rcu/tree_plugin.h                          |    8 
 kernel/sched/cpupri.c                             |    6 
 kernel/sched/wait.c                               |    2 
 lib/atomic64.c                                    |   77 +-
 mm/backing-dev.c                                  |    2 
 mm/filemap.c                                      |    4 
 net/atm/pppoatm.c                                 |    2 
 net/bluetooth/hci_event.c                         |    4 
 net/core/dev.c                                    |    8 
 net/core/link_watch.c                             |    2 
 net/ipv4/inetpeer.c                               |    2 
 net/netfilter/nf_conntrack_core.c                 |    2 
 net/rds/ib_recv.c                                 |    4 
 net/rds/iw_recv.c                                 |    4 
 net/rds/send.c                                    |    6 
 net/rds/tcp_send.c                                |    2 
 net/sunrpc/auth.c                                 |    2 
 net/sunrpc/auth_gss/auth_gss.c                    |    2 
 net/sunrpc/backchannel_rqst.c                     |    4 
 net/sunrpc/xprt.c                                 |    4 
 net/sunrpc/xprtsock.c                             |   16 
 net/unix/af_unix.c                                |    2 
 sound/pci/bt87x.c                                 |    4 
 211 files changed, 2188 insertions(+), 3563 deletions(-)


