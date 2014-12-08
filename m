Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283AbaLHIvi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 03:51:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33175 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753136AbaLHIvf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 03:51:35 -0500
From: Amos Kong <akong@redhat.com>
To: linux-crypto@vger.kernel.org
Cc: virtualization@lists.linux-foundation.org, herbert@gondor.apana.org.au,
        rusty@rustcorp.com.au, kvm@vger.kernel.org, m@bues.ch, mpm@selenic.com,
        amit.shah@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH v5 REPOST 0/6] fix hw_random stuck
Date: Mon,  8 Dec 2014 16:50:34 +0800
Message-Id: <1418028640-4891-1-git-send-email-akong@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I hotunplug a busy virtio-rng device or try to access
hwrng attributes in non-smp guest, it gets stuck.

My hotplug tests:

| test 0:
|   hotunplug rng device from qemu monitor
|
| test 1:
|   guest) # dd if=/dev/hwrng of=/dev/null &
|   hotunplug rng device from qemu monitor
|
| test 2:
|   guest) # dd if=/dev/random of=/dev/null &
|   hotunplug rng device from qemu monitor
|
| test 4:
|   guest) # dd if=/dev/hwrng of=/dev/null &
|   cat /sys/devices/virtual/misc/hw_random/rng_*
|
| test 5:
|   guest) # dd if=/dev/hwrng of=/dev/null
|   cancel dd process after 10 seconds
|   guest) # dd if=/dev/hwrng of=/dev/null &
|   hotunplug rng device from qemu monitor
|
| test 6:
|   use a fifo as rng backend, execute test 0 ~ 5 with no input of fifo

V5: reset cleanup_done flag, drop redundant init of reference count, use
    compiler barrier to prevent recording.
V4: update patch 4 to fix corrupt, decrease last reference for triggering
    the cleanup, fix unregister race pointed by Herbert
V3: initialize kref to 1
V2: added patch 2 to fix a deadlock, update current patch 3 to fix reference
    counting issue

Amos Kong (1):
  hw_random: move some code out mutex_lock for avoiding underlying
    deadlock

Rusty Russell (5):
  hw_random: place mutex around read functions and buffers.
  hw_random: use reference counts on each struct hwrng.
  hw_random: fix unregister race.
  hw_random: don't double-check old_rng.
  hw_random: don't init list element we're about to add to list.

 drivers/char/hw_random/core.c | 173 ++++++++++++++++++++++++++++++------------
 include/linux/hw_random.h     |   3 +
 2 files changed, 126 insertions(+), 50 deletions(-)

-- 
1.9.3

