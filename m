Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720Ab3BQW5V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 17:57:21 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45853 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755119Ab3BQWzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 17:55:48 -0500
Message-Id: <20130217225004.683794512@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Feb 2013 22:50:27 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org,
        =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [ 26/66] virtio_console: Dont access uninitialized data.
In-Reply-To: <20130217225001.621306883@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sjur Brændeland <sjur.brandeland@stericsson.com>

commit aded024a12b32fc1ed9a80639681daae2d07ec25 upstream.

Don't access uninitialized work-queue when removing device.
The work queue is initialized only if the device multi-queue.
So don't call cancel_work unless this is a multi-queue device.

This fixes the following panic:

Kernel panic - not syncing: BUG!
Call Trace:
62031b28:  [<6026085d>] panic+0x16b/0x2d3
62031b30:  [<6004ef5e>] flush_work+0x0/0x1d7
62031b60:  [<602606f2>] panic+0x0/0x2d3
62031b68:  [<600333b0>] memcpy+0x0/0x140
62031b80:  [<6002d58a>] unblock_signals+0x0/0x84
62031ba0:  [<602609c5>] printk+0x0/0xa0
62031bd8:  [<60264e51>] __mutex_unlock_slowpath+0x13d/0x148
62031c10:  [<6004ef5e>] flush_work+0x0/0x1d7
62031c18:  [<60050234>] try_to_grab_pending+0x0/0x17e
62031c38:  [<6004e984>] get_work_gcwq+0x71/0x8f
62031c48:  [<60050539>] __cancel_work_timer+0x5b/0x115
62031c78:  [<628acc85>] unplug_port+0x0/0x191 [virtio_console]
62031c98:  [<6005061c>] cancel_work_sync+0x12/0x14
62031ca8:  [<628ace96>] virtcons_remove+0x80/0x15c [virtio_console]
62031ce8:  [<628191de>] virtio_dev_remove+0x1e/0x7e [virtio]
62031d08:  [<601cf242>] __device_release_driver+0x75/0xe4
62031d28:  [<601cf2dd>] device_release_driver+0x2c/0x40
62031d48:  [<601ce0dd>] driver_unbind+0x7d/0xc6
62031d88:  [<601cd5d9>] drv_attr_store+0x27/0x29
62031d98:  [<60115f61>] sysfs_write_file+0x100/0x14d
62031df8:  [<600b737d>] vfs_write+0xcb/0x184
62031e08:  [<600b58b8>] filp_close+0x88/0x94
62031e38:  [<600b7686>] sys_write+0x59/0x88
62031e88:  [<6001ced1>] handle_syscall+0x5d/0x80
62031ea8:  [<60030a74>] userspace+0x405/0x531
62031f08:  [<600d32cc>] sys_dup+0x0/0x5e
62031f28:  [<601b11d6>] strcpy+0x0/0x18
62031f38:  [<600be46c>] do_execve+0x10/0x12
62031f48:  [<600184c7>] run_init_process+0x43/0x45
62031fd8:  [<60019a91>] new_thread_handler+0xba/0xbc

Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/char/virtio_console.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index 684b0d5..ee4dbea 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -2062,7 +2062,8 @@ static void virtcons_remove(struct virtio_device *vdev)
 	/* Disable interrupts for vqs */
 	vdev->config->reset(vdev);
 	/* Finish up work that's lined up */
-	cancel_work_sync(&portdev->control_work);
+	if (use_multiport(portdev))
+		cancel_work_sync(&portdev->control_work);
 
 	list_for_each_entry_safe(port, port2, &portdev->ports, list)
 		unplug_port(port);


