Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154AbaIRMiK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 08:38:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55735 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751080AbaIRMiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 08:38:08 -0400
From: Amos Kong <akong@redhat.com>
To: virtualization@lists.linux-foundation.org
Cc: kvm@vger.kernel.org, herbert@gondor.apana.org.au, m@bues.ch,
        mpm@selenic.com, amit.shah@redhat.com, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/6] fix hw_random stuck
Date: Thu, 18 Sep 2014 20:37:41 +0800
Message-Id: <1411043867-21109-1-git-send-email-akong@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I hotunplug a busy virtio-rng device or try to access
hwrng attributes in non-smp guest, it gets stuck.

My original was pain, Rusty posted a real fix. This patchset
fixed two issue in v1, and tested by my 6+ cases.


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

 drivers/char/hw_random/core.c | 166 +++++++++++++++++++++++++++++-------------
 include/linux/hw_random.h     |   2 +
 2 files changed, 117 insertions(+), 51 deletions(-)

-- 
1.9.3

