Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932352AbbA2JFX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:05:23 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44836 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932204AbbA2JFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:05:12 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alex Williamson <alex.williamson@redhat.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 028/176] driver core: Fix unbalanced device reference in drivers_probe
Date: Wed, 28 Jan 2015 15:27:38 +0100
Message-Id: <ce3740b1080853a3f6c879374b468ae8800028a8.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Williamson <alex.williamson@redhat.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit bb34cb6bbd287b57e955bc5cfd42fcde6aaca279 upstream.

bus_find_device_by_name() acquires a device reference which is never
released.  This results in an object leak, which on older kernels
results in failure to release all resources of PCI devices.  libvirt
uses drivers_probe to re-attach devices to the host after assignment
and is therefore a common trigger for this leak.

Example:

# cd /sys/bus/pci/
# dmesg -C
# echo 1 > devices/0000\:01\:00.0/sriov_numvfs
# echo 0 > devices/0000\:01\:00.0/sriov_numvfs
# dmesg | grep 01:10
 pci 0000:01:10.0: [8086:10ca] type 00 class 0x020000
 kobject: '0000:01:10.0' (ffff8801d79cd0a8): kobject_add_internal: parent: '0000:00:01.0', set: 'devices'
 kobject: '0000:01:10.0' (ffff8801d79cd0a8): kobject_uevent_env
 kobject: '0000:01:10.0' (ffff8801d79cd0a8): fill_kobj_path: path = '/devices/pci0000:00/0000:00:01.0/0000:01:10.0'
 kobject: '0000:01:10.0' (ffff8801d79cd0a8): kobject_uevent_env
 kobject: '0000:01:10.0' (ffff8801d79cd0a8): fill_kobj_path: path = '/devices/pci0000:00/0000:00:01.0/0000:01:10.0'
 kobject: '0000:01:10.0' (ffff8801d79cd0a8): kobject_uevent_env
 kobject: '0000:01:10.0' (ffff8801d79cd0a8): fill_kobj_path: path = '/devices/pci0000:00/0000:00:01.0/0000:01:10.0'
 kobject: '0000:01:10.0' (ffff8801d79cd0a8): kobject_cleanup, parent           (null)
 kobject: '0000:01:10.0' (ffff8801d79cd0a8): calling ktype release
 kobject: '0000:01:10.0': free name

[kobject freed as expected]

# dmesg -C
# echo 1 > devices/0000\:01\:00.0/sriov_numvfs
# echo 0000:01:10.0 > drivers_probe
# echo 0 > devices/0000\:01\:00.0/sriov_numvfs
# dmesg | grep 01:10
 pci 0000:01:10.0: [8086:10ca] type 00 class 0x020000
 kobject: '0000:01:10.0' (ffff8801d79ce0a8): kobject_add_internal: parent: '0000:00:01.0', set: 'devices'
 kobject: '0000:01:10.0' (ffff8801d79ce0a8): kobject_uevent_env
 kobject: '0000:01:10.0' (ffff8801d79ce0a8): fill_kobj_path: path = '/devices/pci0000:00/0000:00:01.0/0000:01:10.0'
 kobject: '0000:01:10.0' (ffff8801d79ce0a8): kobject_uevent_env
 kobject: '0000:01:10.0' (ffff8801d79ce0a8): fill_kobj_path: path = '/devices/pci0000:00/0000:00:01.0/0000:01:10.0'
 kobject: '0000:01:10.0' (ffff8801d79ce0a8): kobject_uevent_env
 kobject: '0000:01:10.0' (ffff8801d79ce0a8): fill_kobj_path: path = '/devices/pci0000:00/0000:00:01.0/0000:01:10.0'

[no free]

Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/base/bus.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 4c289ab91357..aed92e41f291 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -243,13 +243,15 @@ static ssize_t store_drivers_probe(struct bus_type *bus,
 				   const char *buf, size_t count)
 {
 	struct device *dev;
+	int err = -EINVAL;
 
 	dev = bus_find_device_by_name(bus, NULL, buf);
 	if (!dev)
 		return -ENODEV;
-	if (bus_rescan_devices_helper(dev, NULL) != 0)
-		return -EINVAL;
-	return count;
+	if (bus_rescan_devices_helper(dev, NULL) == 0)
+		err = count;
+	put_device(dev);
+	return err;
 }
 
 static struct device *next_device(struct klist_iter *i)
-- 
2.2.2

