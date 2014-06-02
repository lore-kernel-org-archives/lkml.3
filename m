Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166AbaFBTbe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 15:31:34 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:1179 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751318AbaFBTbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 15:31:31 -0400
Date: Mon, 2 Jun 2014 13:31:43 -0600
From: Jens Axboe <axboe@fb.com>
To: <torvalds@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Block driver changes for 3.16
Message-ID: <20140602193143.GA8357@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-Originating-IP: [192.168.57.29]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-02_02:2014-06-02,2014-06-02,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 suspectscore=11 phishscore=0 adultscore=0 bulkscore=0 classifier=spam
 adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1406020246
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Now that the core bits are in, here's the pull request for the driver
related changes for 3.16. Nothing out of the ordinary here, mostly
business as usual. There are a few pulls of for-3.16/core into this
branch, which were done when the blk-mq was modified after the mtip32xx
conversion was put in. The pull request contains:

- skd and cciss converted to use pci_enable_msix_exact(). From Alexander
  Gordeev.

- A few mtip32xx fixes from Asai @ Micron.

- The conversion of mtip32xx from make_request_fn to blk-mq, and a later
  small fix for that conversion on quiescing for non-queued IO. From me.

- A fix for bsg to use an exported function to check whether this driver
  is request based or not. Needed updating for blk-mq, which is request
  based, but does not have a request_fn hook. From me.

- Small floppy bug fix from Jiri.

- A series of cleanups for the cdrom uniform layer from Joe Perches.
  Gets rid of various old ugly macros, making the code conform more to
  the modern coding style.

- A series of patches for drbd from the drbd crew (Lars Ellenberg and
  Philipp Reisner).

- A use-after-free fix for null_blk from Ming Lei.

- Also from Ming Lei is a performance patch for virtio-blk, which can
  net us a 3x win on kvm platforms where world notification is
  expensive.

- Ming Lei also fixed a stall issue in virtio-blk, due to a race between
  queue start/stop and resource limits.

- A small batch of fixes for xen-blk{back,front} from Olaf Hering and
  Valentin Priescu.


Please pull!


  git://git.kernel.dk/linux-block.git for-3.16/drivers


----------------------------------------------------------------
Alexander Gordeev (2):
      skd: Use pci_enable_msix_exact() instead of pci_enable_msix_range()
      cciss: Use pci_enable_msix_exact() instead of pci_enable_msix()

Asai Thambi S P (4):
      mtip32xx: Increase timeout for STANDBY IMMEDIATE command
      mtip32xx: Remove dfs_parent after pci unregister
      mtip32xx: Fix ERO and NoSnoop values in PCIe upstream on AMD systems
      mtip32xx: move error handling to service thread

Dan Carpenter (1):
      mtip32xx: blk_mq_init_queue() returns an ERR_PTR

Jens Axboe (7):
      bsg: update check for rq based driver for blk-mq
      mtip32xx: convert to use blk-mq
      mtip32xx: stop block hardware queues before quiescing IO
      Merge branch 'for-3.16/core' into for-3.16/drivers
      Merge branch 'for-3.16/core' into for-3.16/drivers
      Merge branch 'stable/for-jens-3.16' of git://git.kernel.org/.../xen/tip into for-3.16/drivers
      Merge branch 'for-3.16/core' into for-3.16/drivers

Jiri Kosina (1):
      floppy: do not corrupt bio.bi_flags when reading block 0

Joe Perches (12):
      cdrom: convert cdinfo to cd_dbg
      cdrom: Remove unused CHECKAUDIO macro
      cdrom: Remove obfuscating IOCTL_IN and IOCTL_OUT macros
      cdrom: Remove prototype for open_for_data
      cdrom: Remove unnecessary check_for_audio_disc prototype
      cdrom: Remove unnecessary sanitize_format prototype
      cdrom: Move mmc_ioctls above cdrom_ioctl to remove unnecessary prototype
      cdrom: Remove cdrom_get_last_written prototype
      cdrom: Remove cdrom_get_next_writeable prototype
      cdrom: Remove cdrom_count_tracks prototype
      cdrom: Remove unnecessary prototype for cdrom_mrw_exit
      cdrom: Remove unnecessary prototype for cdrom_get_disc_info

Lars Ellenberg (15):
      drbd: fix stalled resync detection in /proc/drbd
      drbd: resync: fix too large bursts for very slow rates
      drbd: fix potential distributed deadlock during verify or resync
      drbd: don't let application IO pre-empt resync too often
      drbd: perpare for genetlink parallel_ops
      drbd: allow parallel promote/demote actions
      drbd: prepare receiving side for REQ_DISCARD
      drbd: prepare sending side for REQ_DISCARD
      drbd: Enable QUEUE_FLAG_DISCARD only if the peer can recieve P_TRIM
      drbd: fix a race between start_resync and send_and_submit
      drbd: keep max-bio size during detach/attach on disconnected primary
      drbd: add back some fairness to AL transactions
      drbd: always implicitly close last epoch when idle
      drbd: evaluate disk and network timeout on different requests
      drbd: use list_first_entry_or_null in first_peer_device/first_connection

Ming Lei (3):
      block: null_blk: fix use after free
      virtio_blk: fix race between start and stop queue
      block: virtio_blk: don't hold spin lock during world switch

Olaf Hering (3):
      xen-blkfront: remove type check from blkfront_setup_discard
      xen/blkback: disable discard feature if requested by toolstack
      xen blkif.h: fix comment typo in discard-alignment

Philipp Reisner (9):
      drbd: Break a deadlock while concurrent fencing and establishing a connection
      drbd: Leave IO suspended if the fence handler find the peer primary
      drbd: Remove drbd_wrappers.h
      drbd: Allow online layout change of AL while peer is not connected
      drbd: Do not BUG() when connection breaks in a special way
      drbd: Fix a hole in the challange-response connection authentication
      drbd: use blk_set_stacking_limits()
      drbd: Test cstate while holding req_lock
      drbd: Allow attaching of a newly created device to any backing device

Valentin Priescu (1):
      xen-blkback: defer freeing blkif to avoid blocking xenwatch

 block/bsg.c                        |    2 +-
 drivers/block/cciss.c              |    6 +-
 drivers/block/drbd/drbd_actlog.c   |   23 +-
 drivers/block/drbd/drbd_int.h      |   92 ++-
 drivers/block/drbd/drbd_main.c     |   28 +-
 drivers/block/drbd/drbd_nl.c       |  485 ++++++++-----
 drivers/block/drbd/drbd_nla.c      |    1 -
 drivers/block/drbd/drbd_proc.c     |    2 +-
 drivers/block/drbd/drbd_protocol.h |   12 +
 drivers/block/drbd/drbd_receiver.c |  196 ++++--
 drivers/block/drbd/drbd_req.c      |   74 +-
 drivers/block/drbd/drbd_req.h      |    6 +-
 drivers/block/drbd/drbd_state.c    |   38 +-
 drivers/block/drbd/drbd_worker.c   |  107 +--
 drivers/block/drbd/drbd_wrappers.h |   54 --
 drivers/block/floppy.c             |    2 +-
 drivers/block/mtip32xx/mtip32xx.c  | 1087 ++++++++++++-----------------
 drivers/block/mtip32xx/mtip32xx.h  |   32 +-
 drivers/block/null_blk.c           |    2 +-
 drivers/block/skd_main.c           |    7 +-
 drivers/block/virtio_blk.c         |   13 +-
 drivers/block/xen-blkback/common.h |    4 +-
 drivers/block/xen-blkback/xenbus.c |   53 +-
 drivers/block/xen-blkfront.c       |   40 +-
 drivers/cdrom/cdrom.c              | 1357 ++++++++++++++++++------------------
 include/linux/blkdev.h             |    9 +
 include/xen/interface/io/blkif.h   |    2 +-
 27 files changed, 1906 insertions(+), 1828 deletions(-)
 delete mode 100644 drivers/block/drbd/drbd_wrappers.h

-- 
Jens Axboe

