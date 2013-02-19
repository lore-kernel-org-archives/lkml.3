Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934231Ab3BSSwd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 13:52:33 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54335 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932886Ab3BSSw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:52:29 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 39/81] virtio_console: Don't access uninitialized data.
Date: Tue, 19 Feb 2013 15:49:02 -0300
Message-Id: <1361299784-8830-40-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
References: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Sjur=20Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/char/virtio_console.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index cdf2f54..f77e341 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -1808,7 +1808,8 @@ static void virtcons_remove(struct virtio_device *vdev)
 	/* Disable interrupts for vqs */
 	vdev->config->reset(vdev);
 	/* Finish up work that's lined up */
-	cancel_work_sync(&portdev->control_work);
+	if (use_multiport(portdev))
+		cancel_work_sync(&portdev->control_work);
 
 	list_for_each_entry_safe(port, port2, &portdev->ports, list)
 		unplug_port(port);
-- 
1.7.9.5

