Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753355Ab3AKNwJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 08:52:09 -0500
Received: from mail-bk0-f47.google.com ([209.85.214.47]:38099 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab3AKNwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 08:52:08 -0500
From: Alexandru Copot <alex.mihai.c@gmail.com>
To: rusty@rustcorp.com.au
Cc: mst@redhat.com, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, catalin.marinas@arm.com,
        Alexandru Copot <alex.mihai.c@gmail.com>,
        Daniel Baluta <dbaluta@ixiacom.com>
Subject: [PATCH] virtio: suppress kmemleak false positive
Date: Fri, 11 Jan 2013 15:51:43 +0200
Message-Id: <1357912303-17026-1-git-send-email-alex.mihai.c@gmail.com>
X-Mailer: git-send-email 1.8.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While doing simple IPv6 tests in KVM virtual machines,
(add an IPv6 address to eth0) kmemleak complains about
an unreferenced object:

unreferenced object 0xffff88001e804120 (size 32):
  comm "softirq", pid 0, jiffies 4294900928 (age 631.544s)
  hex dump (first 32 bytes):
    28 cb fd 1d 00 00 00 00 0c 00 00 00 01 00 01 00  (...............
    02 d0 83 1d 00 00 00 00 6e 00 00 00 00 00 00 00  ........n.......
  backtrace:
    [<ffffffff815ed721>] kmemleak_alloc+0x21/0x50
    [<ffffffff8111d0b0>] __kmalloc+0xe0/0x160
    [<ffffffff81362b7c>] virtqueue_add_buf+0x1fc/0x3d0
    [<ffffffff8140cbd3>] start_xmit+0x153/0x3a0
    [<ffffffff8150887e>] dev_hard_start_xmit+0x21e/0x470
    [<ffffffff815247ce>] sch_direct_xmit+0xfe/0x280
    [<ffffffff81509014>] dev_queue_xmit+0x1f4/0x5d0
    [<ffffffff81592e91>] ip6_finish_output2+0x101/0x450
    [<ffffffff81595ae8>] ip6_finish_output+0x98/0x200
    [<ffffffff81595ca1>] ip6_output+0x51/0x1b0
    [<ffffffff815b51af>] mld_sendpack+0x19f/0x360
    [<ffffffff815b59b4>] mld_ifc_timer_expire+0x194/0x290
    [<ffffffff8104b794>] call_timer_fn+0x74/0xf0
    [<ffffffff8104bb1b>] run_timer_softirq+0x18b/0x220
    [<ffffffff81045f81>] __do_softirq+0xe1/0x1c0
    [<ffffffff8160a4fc>] call_softirq+0x1c/0x30

Seems the function vring_add_indirect stores an array of
struct vring_desc by using virt_to_phys and kmemleak
doesn't track the pointer.

The following patch can fix this.

Signed-off-by: Alexandru Copot <alex.mihai.c@gmail.com>
CC: Daniel Baluta <dbaluta@ixiacom.com>
---
 drivers/virtio/virtio_ring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index ffd7e7d..e0b591b 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -23,6 +23,7 @@
 #include <linux/slab.h>
 #include <linux/module.h>
 #include <linux/hrtimer.h>
+#include <linux/kmemleak.h>
 
 /* virtio guest is communicating with a virtual "device" that actually runs on
  * a host processor.  Memory barriers are used to control SMP effects. */
@@ -140,6 +141,7 @@ static int vring_add_indirect(struct vring_virtqueue *vq,
 	desc = kmalloc((out + in) * sizeof(struct vring_desc), gfp);
 	if (!desc)
 		return -ENOMEM;
+	kmemleak_not_leak(desc);
 
 	/* Transfer entries from the sg list into the indirect page */
 	for (i = 0; i < out; i++) {
-- 
1.8.1

