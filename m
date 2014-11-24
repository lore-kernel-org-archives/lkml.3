Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632AbaKXLwq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 06:52:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60350 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752441AbaKXLwp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 06:52:45 -0500
Date: Mon, 24 Nov 2014 13:52:32 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>, cornelia.huck@de.ibm.com,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com
Subject: [PATCH v3 00/41] linux: towards virtio-1 guest support
Message-ID: <1416829787-14252-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on patches by Cornelia Rusty and others, but
with an API that should allow better static checking of code,
and slightly more concervative changes in vring,net and blk.

Based on patches by Cornelia and others, but
with an API that should allow better static checking of code,
slightly more concervative changes in vring and drivers,
and compatibility for existing drivers so that
this series be applied before all drivers are converted.

virtio net,blk and scsi drivers have been converted.
They now pass sparse without warnings.

net and blk patches have been tested on s390.
scsi patches pass sparse so they are most likely
ok too, but haven't been through testing yet -
they can be dropped from patchset if necessary.

Please review, and consider for 3.19

David, assuming patches are acceptable, I'd like them all to be merged through
virtio or vhost trees.  Could you please ack doing that for net related
patches?

Changes since v2:
	converted tun,macvtap and vhost net
	partially converted vhost scsi: it still lacks ANY_LAYOUT support
	Nicholas, any comments?

Cornelia Huck (3):
  virtio: allow transports to get avail/used addresses
  KVM: s390: virtio-ccw revision 1 SET_VQ
  KVM: s390: enable virtio-ccw revision 1

Michael S. Tsirkin (35):
  virtio: add virtio 1.0 feature bit
  virtio: memory access APIs
  virtio_ring: switch to new memory access APIs
  virtio_config: endian conversion for v1.0
  virtio: set FEATURES_OK
  virtio: simplify feature bit handling
  virtio: add legacy feature table support
  virtio_net: v1.0 endianness
  virtio_blk: v1.0 support
  KVM: s390 allow virtio_ccw status writes to fail
  virtio_blk: make serial attribute static
  virtio_blk: fix race at module removal
  virtio_net: pass vi around
  virtio_net: get rid of virtio_net_hdr/skb_vnet_hdr
  virtio_net: stricter short buffer length checks
  virtio_net: bigger header when VERSION_1 is set
  virtio_net: enable v1.0 support
  vhost: add memory access wrappers
  vhost/net: force len for TX to host endian
  vhost: virtio 1.0 endian-ness support
  vhost: make features 64 bit
  vhost/net: virtio 1.0 byte swap
  vhost/net: larger header for virtio 1.0
  vhost/net: enable virtio 1.0
  vhost/net: suppress compiler warning
  tun: move internal flag defines out of uapi
  tun: drop most type defines
  tun: add VNET_LE flag
  tun: TUN_VNET_LE support, fix sparse warnings for virtio headers
  macvtap: TUN_VNET_HDR support
  virtio_scsi: v1.0 support
  virtio_scsi: move to uapi
  virtio_scsi: export to userspace
  vhost/scsi: partial virtio 1.0 support
  af_packet: virtio 1.0 stubs

Rusty Russell (2):
  virtio: use u32, not bitmap for struct virtio_device's features
  virtio: add support for 64 bit features.

Thomas Huth (1):
  KVM: s390: Set virtio-ccw transport revision

 drivers/vhost/vhost.h                  |  35 ++++++-
 include/linux/virtio.h                 |  10 +-
 include/linux/virtio_byteorder.h       |  59 +++++++++++
 include/linux/virtio_config.h          |  49 ++++++++--
 include/uapi/linux/if_tun.h            |  17 +---
 include/uapi/linux/virtio_blk.h        |  15 +--
 include/uapi/linux/virtio_config.h     |   9 +-
 include/uapi/linux/virtio_net.h        |  15 +--
 include/uapi/linux/virtio_ring.h       |  45 ++++-----
 include/{ => uapi}/linux/virtio_scsi.h | 106 ++++++++++----------
 include/uapi/linux/virtio_types.h      |  48 +++++++++
 tools/virtio/linux/virtio.h            |  22 +----
 tools/virtio/linux/virtio_config.h     |   2 +-
 drivers/block/virtio_blk.c             |  75 ++++++++------
 drivers/char/virtio_console.c          |   2 +-
 drivers/lguest/lguest_device.c         |  16 +--
 drivers/net/macvtap.c                  |  68 ++++++++-----
 drivers/net/tun.c                      | 170 ++++++++++++++------------------
 drivers/net/virtio_net.c               | 159 +++++++++++++++---------------
 drivers/remoteproc/remoteproc_virtio.c |   7 +-
 drivers/s390/kvm/kvm_virtio.c          |  10 +-
 drivers/s390/kvm/virtio_ccw.c          | 172 +++++++++++++++++++++++++++------
 drivers/scsi/virtio_scsi.c             |  51 ++++++----
 drivers/vhost/net.c                    |  28 +++---
 drivers/vhost/scsi.c                   |  22 +++--
 drivers/vhost/vhost.c                  |  93 +++++++++++-------
 drivers/virtio/virtio.c                |  74 ++++++++++----
 drivers/virtio/virtio_mmio.c           |  20 ++--
 drivers/virtio/virtio_pci.c            |   8 +-
 drivers/virtio/virtio_ring.c           | 107 +++++++++++---------
 net/packet/af_packet.c                 |  35 ++++---
 tools/virtio/virtio_test.c             |   5 +-
 tools/virtio/vringh_test.c             |  16 +--
 include/uapi/linux/Kbuild              |   2 +
 34 files changed, 980 insertions(+), 592 deletions(-)
 create mode 100644 include/linux/virtio_byteorder.h
 rename include/{ => uapi}/linux/virtio_scsi.h (73%)
 create mode 100644 include/uapi/linux/virtio_types.h

-- 
MST

