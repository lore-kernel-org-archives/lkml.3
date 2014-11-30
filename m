Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751940AbaK3PJW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 10:09:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41866 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751679AbaK3PJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 10:09:20 -0500
Date: Sun, 30 Nov 2014 17:09:03 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Miller <davem@davemloft.net>, cornelia.huck@de.ibm.com,
        rusty@au1.ibm.com, nab@linux-iscsi.org, pbonzini@redhat.com,
        thuth@linux.vnet.ibm.com, dahi@linux.vnet.ibm.com
Subject: [PATCH v7 00/46] linux: towards virtio-1 guest support
Message-ID: <1417359787-10138-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David, assuming patches are acceptable, I'd like them all to be merged through
virtio or vhost trees to avoid dependency headaches.  Could you please ack
doing that for net related patches, especially these:
	  tun: move internal flag defines out of uapi
	  tun: drop most type defines
	  tun: add VNET_LE flag
	  tun: TUN_VNET_LE support, fix sparse warnings for virtio headers
	  macvtap: TUN_VNET_HDR support
	  vhost/scsi: partial virtio 1.0 support
	  af_packet: virtio 1.0 stubs

Alternatively, I can prepare a tree with virtio changes and merge
that into your net-next - if Rusty approves, or keeps
silence :)

Could you comment on this please?


Another revision of the patchset.
The changes are strictly cosmetic now so - there's a chance this is
the last revision.

Based on patches by Cornelia and others, but
with an API that should allow better static checking of code,
slightly more concervative changes in vring and drivers,
and compatibility for existing drivers so that
this series can be applied before all drivers are converted.

virtio net,blk and scsi drivers have been converted.
They now pass sparse without warnings.

net and blk patches have been tested on s390.
scsi patches pass sparse so they are most likely
ok too, but haven't been through testing yet -
they can be dropped from patchset if necessary.

Please review, and consider for 3.19

changes since v6:
	tun: move internal flag defines out of uapi
		document reasons for patch split
	macvtap: TUN_VNET_LE support
		fix patch subject
	virtio: add low-level APIs for feature bits
		fix comment in code s/set/clear/
		document reasons for names selected
	KVM: s390: enable virtio-ccw revision 1
		fix up comment
	virtio: use u32, not bitmap for features
		fix whitespace
	virtio_ccw: add support for 64 bit features
		tweak comment in code

	included reviewed-by tags by Cornelia David and Jason

Changes since v5:
	rewritten feature bit handling, based on suggestion by David:
	changes are now smaller and easier to review.
	new patch:
	  virtio: add low-level APIs for feature bits
	rewritten patches:
	  virtio: use u32, not bitmap for features
	  virtio: add support for 64 bit features.
	
Changes since v4:
	I have dropped 64 bit feature negotiation from
	most transports (except ccw).
	For symmetry, I split out ccw bits:
		  virtio: add support for 64 bit features.
			adds core and device support for 64 bit features
		  virtio_ccw: add support for 64 bit features.
			actually enables 64 bit features in ccw.
	detail below.

	this is still really a cosmetic change: just reordering/splitting
	patches, and dropping code changes that aren't needed.

	new patches:
	  mic_virtio: robust feature array size calculation
	  virtio: assert 32 bit features in transports

	addressed comments by Cornelia:
		      virtio: disable virtio 1.0 in transports:
			patch dropped
		      virtio: memory access APIs
			tweaked comments as suggested by Cornelia
		      virtio_config: endian conversion for v1.0
			dropped reviewed-by tags -
				they applied to a very old version of patch
		      virtio: set FEATURES_OK
			replaced printk by dev_err
		      virtio: add legacy feature table support
			comment changes suggested by Cornelia
		      virtio_blk: v1.0 support
			dropped reviewed-by tags -
				they applied to a very old version of patch
		      virtio_net: enable v1.0 support
			only write mac for legacy devices
		      vhost: add memory access wrappers
			move chunk to vhost: make features 64 bit
			better patch description
		      vhost: make features 64 bit
			moved this patch earlier in series
		      vhost/net: force len for TX to host endian
			better patch description
		      virtio_scsi: v1.0 support
			fix bug: use high level, not low level wrappers
			

	included reviewed-by tags for patches:
		KVM: s390 allow virtio_ccw status writes to fail
				added reviewed-by tag by Cornelia
		virtio_scsi: v1.0 support
		virtio_scsi: move to uapi
		virtio_scsi: export to userspace
		vhost/scsi: partial virtio 1.0 support
				added reviewed-by tag by Paolo

Changes since v3:
	- move virtio 1.0 feature bit out of transport bits:
	  for now it's managed by drivers
	- disable virtio 1.0 feature bit explicitly - for transports
	  that don't support it

Cornelia Huck (3):
  virtio: allow transports to get avail/used addresses
  KVM: s390: virtio-ccw revision 1 SET_VQ
  KVM: s390: enable virtio-ccw revision 1

Michael S. Tsirkin (42):
  virtio: add low-level APIs for feature bits
  virtio: use u32, not bitmap for features
  mic_virtio: robust feature array size calculation
  virtio: add support for 64 bit features.
  virtio: assert 32 bit features in transports
  virtio_ccw: add support for 64 bit features.
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
  vhost: make features 64 bit
  vhost: add memory access wrappers
  vhost/net: force len for TX to host endian
  vhost: virtio 1.0 endian-ness support
  vhost/net: virtio 1.0 byte swap
  vhost/net: larger header for virtio 1.0
  virtio_net: disable mac write for virtio 1.0
  vhost/net: enable virtio 1.0
  vhost/net: suppress compiler warning
  tun: move internal flag defines out of uapi
  tun: drop most type defines
  tun: add VNET_LE flag
  tun: TUN_VNET_LE support, fix sparse warnings for virtio headers
  macvtap: TUN_VNET_LE support
  virtio_scsi: v1.0 support
  virtio_scsi: move to uapi
  virtio_scsi: export to userspace
  vhost/scsi: partial virtio 1.0 support
  af_packet: virtio 1.0 stubs

Thomas Huth (1):
  KVM: s390: Set virtio-ccw transport revision

 drivers/vhost/vhost.h                  |  35 ++++++-
 include/linux/virtio.h                 |  10 +-
 include/linux/virtio_byteorder.h       |  59 +++++++++++
 include/linux/virtio_config.h          | 100 +++++++++++++++++--
 include/uapi/linux/if_tun.h            |  17 +---
 include/uapi/linux/virtio_blk.h        |  15 +--
 include/uapi/linux/virtio_config.h     |   5 +
 include/uapi/linux/virtio_net.h        |  15 +--
 include/uapi/linux/virtio_ring.h       |  45 ++++-----
 include/{ => uapi}/linux/virtio_scsi.h | 106 ++++++++++----------
 include/uapi/linux/virtio_types.h      |  46 +++++++++
 tools/virtio/linux/virtio.h            |  22 +----
 tools/virtio/linux/virtio_config.h     |   2 +-
 drivers/block/virtio_blk.c             |  75 ++++++++------
 drivers/char/virtio_console.c          |   2 +-
 drivers/lguest/lguest_device.c         |  13 ++-
 drivers/misc/mic/card/mic_virtio.c     |  10 +-
 drivers/net/macvtap.c                  |  68 ++++++++-----
 drivers/net/tun.c                      | 168 ++++++++++++++------------------
 drivers/net/virtio_net.c               | 162 ++++++++++++++++---------------
 drivers/remoteproc/remoteproc_virtio.c |   7 +-
 drivers/s390/kvm/kvm_virtio.c          |   7 +-
 drivers/s390/kvm/virtio_ccw.c          | 172 +++++++++++++++++++++++++++------
 drivers/scsi/virtio_scsi.c             |  51 ++++++----
 drivers/vhost/net.c                    |  28 +++---
 drivers/vhost/scsi.c                   |  22 +++--
 drivers/vhost/vhost.c                  |  93 +++++++++++-------
 drivers/virtio/virtio.c                |  74 ++++++++++----
 drivers/virtio/virtio_mmio.c           |  13 ++-
 drivers/virtio/virtio_pci.c            |   8 +-
 drivers/virtio/virtio_ring.c           | 107 +++++++++++---------
 net/packet/af_packet.c                 |  35 ++++---
 tools/virtio/virtio_test.c             |   5 +-
 tools/virtio/vringh_test.c             |  16 +--
 include/uapi/linux/Kbuild              |   2 +
 35 files changed, 1029 insertions(+), 586 deletions(-)
 create mode 100644 include/linux/virtio_byteorder.h
 rename include/{ => uapi}/linux/virtio_scsi.h (73%)
 create mode 100644 include/uapi/linux/virtio_types.h

-- 
MST

