Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603AbaJLLnU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 07:43:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36521 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752470AbaJLLnO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 07:43:14 -0400
Date: Sun, 12 Oct 2014 14:46:08 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, linux-scsi@vger.kernel.org,
        linux-s390@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
        netdev@vger.kernel.org, kvm@vger.kernel.org,
        Amit Shah <amit.shah@redhat.com>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v3 00/25] virtio: fix spec compliance issues
Message-ID: <1413114332-626-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty, please review this, and consider for this merge window.

This fixes the following virtio spec compliance issues:
1. on restore, drivers use device before setting ACKNOWLEDGE and DRIVER bits
2. on probe, drivers aren't prepared to handle config interrupts
   arriving before probe returns
3. on probe, drivers use device before DRIVER_OK it set

Note that 1 is a clear violation of virtio spec 0.9 and 1.0,
so I am proposing the fix for stable. OTOH 2 is against 1.0 rules but
is a known documented bug in many drivers, so let's fix it going
forward, but it does not seem to be worth it to backport
the changes.

An error handling bugfix for virtio-net and a fix for a
theoretical race condition in virtio scsi is also included.

2 is merely a theoretical race condition, but it seems important
to address to make sure that changes to address 3 do not introduce
instability.

I also included patch to drop scan callback use from virtio
scsi: using this callback creates asymmetry between probe
and resume, and we actually had to add code comments so
people can figure out the flow. Code flow becomes clearer
with the new API.

After this change, the only user of the scan callback is virtio rng.
It's possible to modify it trivially and then drop scan callback
from core, but I'm rather inclined to look at ways to
make some rng core changes so that we don't need to
have so many variables tracking device state.
So this is deferred for now.

Michael S. Tsirkin (24):
  virtio_pci: fix virtio spec compliance on restore
  virtio: unify config_changed handling
  virtio-pci: move freeze/restore to virtio core
  virtio: defer config changed notifications
  virtio_blk: drop config_enable
  virtio-blk: drop config_mutex
  virtio_net: drop config_enable
  virtio-net: drop config_mutex
  virtio_net: minor cleanup
  virtio: add API to enable VQs early
  virtio_net: enable VQs early
  virtio_blk: enable VQs early
  virtio_console: enable VQs early
  9p/trans_virtio: enable VQs early
  virtio_net: fix use after free on allocation failure
  virtio_scsi: move kick event out from virtscsi_init
  virtio_blk: enable VQs early on restore
  virtio_scsi: enable VQs early on restore
  virtio_console: enable VQs early on restore
  virtio_net: enable VQs early on restore
  virtio_scsi: fix race on device removal
  virtio_balloon: enable VQs early on restore
  virtio_scsi: drop scan callback
  virtio-rng: refactor probe error handling

Paolo Bonzini (1):
  virito_scsi: use freezable WQ for events

 include/linux/virtio.h              |  14 +++++
 include/linux/virtio_config.h       |  17 ++++++
 drivers/block/virtio_blk.c          |  40 ++++----------
 drivers/char/hw_random/virtio-rng.c |  15 +++---
 drivers/char/virtio_console.c       |   4 ++
 drivers/misc/mic/card/mic_virtio.c  |   6 +--
 drivers/net/virtio_net.c            |  44 +++++-----------
 drivers/s390/kvm/kvm_virtio.c       |   9 +---
 drivers/s390/kvm/virtio_ccw.c       |   6 +--
 drivers/scsi/virtio_scsi.c          |  42 +++++++++------
 drivers/virtio/virtio.c             | 102 ++++++++++++++++++++++++++++++++++++
 drivers/virtio/virtio_balloon.c     |   2 +
 drivers/virtio/virtio_mmio.c        |   7 +--
 drivers/virtio/virtio_pci.c         |  33 ++----------
 net/9p/trans_virtio.c               |   2 +
 15 files changed, 206 insertions(+), 137 deletions(-)

-- 
MST

