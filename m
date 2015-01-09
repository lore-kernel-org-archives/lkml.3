Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757533AbbAIKkU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 05:40:20 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44588 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757497AbbAIKc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 05:32:29 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Lee Jones <lee.jones@linaro.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 77/78] mfd: viperboard: Fix platform-device id collision
Date: Fri,  9 Jan 2015 11:32:26 +0100
Message-Id: <0702a76da972aa3a3a7091a4e3abe833017a2904.1420799385.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
References: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
In-Reply-To: <cover.1420799385.git.jslaby@suse.cz>
References: <cover.1420799385.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit b6684228726cc25551a43f5c0bd9c5f977f10f48 upstream.

Allow more than one viperboard to be connected by registering with
PLATFORM_DEVID_AUTO instead of PLATFORM_DEVID_NONE.

The subdevices are currently registered with PLATFORM_DEVID_NONE, which
will cause a name collision on the platform bus when a second viperboard
is plugged in:

viperboard 1-2.4:1.0: version 0.00 found at bus 001 address 004
------------[ cut here ]------------
WARNING: CPU: 0 PID: 181 at /home/johan/work/omicron/src/linux/fs/sysfs/dir.c:31 sysfs_warn_dup+0x74/0x84()
sysfs: cannot create duplicate filename '/bus/platform/devices/viperboard-gpio'
Modules linked in: i2c_viperboard viperboard netconsole [last unloaded: viperboard]
CPU: 0 PID: 181 Comm: bash Tainted: G        W      3.17.0-rc6 #1
[<c0016bf4>] (unwind_backtrace) from [<c0013860>] (show_stack+0x20/0x24)
[<c0013860>] (show_stack) from [<c04305f8>] (dump_stack+0x24/0x28)
[<c04305f8>] (dump_stack) from [<c0040fb4>] (warn_slowpath_common+0x80/0x98)
[<c0040fb4>] (warn_slowpath_common) from [<c004100c>] (warn_slowpath_fmt+0x40/0x48)
[<c004100c>] (warn_slowpath_fmt) from [<c016f1bc>] (sysfs_warn_dup+0x74/0x84)
[<c016f1bc>] (sysfs_warn_dup) from [<c016f548>] (sysfs_do_create_link_sd.isra.2+0xcc/0xd0)
[<c016f548>] (sysfs_do_create_link_sd.isra.2) from [<c016f588>] (sysfs_create_link+0x3c/0x48)
[<c016f588>] (sysfs_create_link) from [<c02867ec>] (bus_add_device+0x12c/0x1e0)
[<c02867ec>] (bus_add_device) from [<c0284820>] (device_add+0x410/0x584)
[<c0284820>] (device_add) from [<c0289440>] (platform_device_add+0xd8/0x26c)
[<c0289440>] (platform_device_add) from [<c02a5ae4>] (mfd_add_device+0x240/0x344)
[<c02a5ae4>] (mfd_add_device) from [<c02a5ce0>] (mfd_add_devices+0xb8/0x110)
[<c02a5ce0>] (mfd_add_devices) from [<bf00d1c8>] (vprbrd_probe+0x160/0x1b0 [viperboard])
[<bf00d1c8>] (vprbrd_probe [viperboard]) from [<c030c000>] (usb_probe_interface+0x1bc/0x2a8)
[<c030c000>] (usb_probe_interface) from [<c028768c>] (driver_probe_device+0x14c/0x3ac)
[<c028768c>] (driver_probe_device) from [<c02879e4>] (__driver_attach+0xa4/0xa8)
[<c02879e4>] (__driver_attach) from [<c0285698>] (bus_for_each_dev+0x70/0xa4)
[<c0285698>] (bus_for_each_dev) from [<c0287030>] (driver_attach+0x2c/0x30)
[<c0287030>] (driver_attach) from [<c030a288>] (usb_store_new_id+0x170/0x1ac)
[<c030a288>] (usb_store_new_id) from [<c030a2f8>] (new_id_store+0x34/0x3c)
[<c030a2f8>] (new_id_store) from [<c02853ec>] (drv_attr_store+0x30/0x3c)
[<c02853ec>] (drv_attr_store) from [<c016eaa8>] (sysfs_kf_write+0x5c/0x60)
[<c016eaa8>] (sysfs_kf_write) from [<c016dc68>] (kernfs_fop_write+0xd4/0x194)
[<c016dc68>] (kernfs_fop_write) from [<c010fe40>] (vfs_write+0xb4/0x1c0)
[<c010fe40>] (vfs_write) from [<c01104a8>] (SyS_write+0x4c/0xa0)
[<c01104a8>] (SyS_write) from [<c000f900>] (ret_fast_syscall+0x0/0x48)
---[ end trace 98e8603c22d65817 ]---
viperboard 1-2.4:1.0: Failed to add mfd devices to core.
viperboard: probe of 1-2.4:1.0 failed with error -17

Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/mfd/viperboard.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/viperboard.c b/drivers/mfd/viperboard.c
index af2a6703f34f..7bf6dd9625b9 100644
--- a/drivers/mfd/viperboard.c
+++ b/drivers/mfd/viperboard.c
@@ -93,8 +93,9 @@ static int vprbrd_probe(struct usb_interface *interface,
 		 version >> 8, version & 0xff,
 		 vb->usb_dev->bus->busnum, vb->usb_dev->devnum);
 
-	ret = mfd_add_devices(&interface->dev, -1, vprbrd_devs,
-				ARRAY_SIZE(vprbrd_devs), NULL, 0, NULL);
+	ret = mfd_add_devices(&interface->dev, PLATFORM_DEVID_AUTO,
+				vprbrd_devs, ARRAY_SIZE(vprbrd_devs), NULL, 0,
+				NULL);
 	if (ret != 0) {
 		dev_err(&interface->dev, "Failed to add mfd devices to core.");
 		goto error;
-- 
2.2.1

