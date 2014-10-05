Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751774AbaJEQDV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2014 12:03:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32383 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751555AbaJEQDT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2014 12:03:19 -0400
Date: Sun, 5 Oct 2014 19:06:47 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org
Subject: [PATCH 00/16] virtio: fix spec compliance issues
Message-ID: <1412525038-15871-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty, I have a mind to send this patches for the next merge window.
Any input on this?


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

An error handling bugfix for virtio-net is also included.

2 is merely a theoretical race condition, but it seems important
to address to make sure that changes to address 3 do not introduce
instability.

Michael S. Tsirkin (16):
  virtio_pci: fix virtio spec compliance on restore
  virtio: unify config_changed handling
  virtio: refactor to use drv_to_virtio
  virtio-pci: move freeze/restore to virtio core
  virtio: defer config changed notifications
  virtio_blk: drop config_enable
  virtio-blk: drop config_mutex
  virtio_net: drop config_enable
  virtio-net: drop config_mutex
  virtio: add API to enable VQs early
  virtio_net: minor cleanup
  virtio_net: enable VQs early
  virtio_blk: enable VQs early
  virtio_console: enable VQs early
  9p/trans_virtio: enable VQs early
  virtio_net: fix use after free on allocation failure

 include/linux/virtio.h             | 14 ++++++
 include/linux/virtio_config.h      | 17 +++++++
 drivers/block/virtio_blk.c         | 27 ++---------
 drivers/char/virtio_console.c      |  2 +
 drivers/misc/mic/card/mic_virtio.c |  6 +--
 drivers/net/virtio_net.c           | 38 +++------------
 drivers/s390/kvm/kvm_virtio.c      |  9 +---
 drivers/s390/kvm/virtio_ccw.c      |  6 +--
 drivers/virtio/virtio.c            | 99 ++++++++++++++++++++++++++++++++++++++
 drivers/virtio/virtio_mmio.c       |  7 +--
 drivers/virtio/virtio_pci.c        | 33 ++-----------
 net/9p/trans_virtio.c              |  2 +
 12 files changed, 153 insertions(+), 107 deletions(-)

-- 
MST

