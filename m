Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437AbaIZK7V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:59:21 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:59226 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbaIZK6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 06:58:36 -0400
X-Google-Original-Sender: <johan@hovold.com>
From: Johan Hovold <johan@kernel.org>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 1/6] mfd: viperboard: fix platform-device id collision
Date: Fri, 26 Sep 2014 12:55:28 +0200
Message-Id: <1411728933-13351-2-git-send-email-johan@kernel.org>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1411728933-13351-1-git-send-email-johan@kernel.org>
References: <1411728933-13351-1-git-send-email-johan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 drivers/mfd/viperboard.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/mfd/viperboard.c b/drivers/mfd/viperboard.c
index e00f5340ed87..3c2b8f9e3c84 100644
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
1.8.5.5

