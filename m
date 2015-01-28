Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965304AbbA2Chm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:37:42 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47003 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965266AbbA2Chg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:37:36 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Williamson <alex.williamson@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 031/139] driver core: Fix unbalanced device reference in drivers_probe
Date: Wed, 28 Jan 2015 14:19:34 -0800
Message-Id: <1422483682-15393-32-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422483682-15393-1-git-send-email-kamal@canonical.com>
References: <1422483682-15393-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Williamson <alex.williamson@redhat.com>

commit 0372ffb35d00288802265586a29c117911d02fb8 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/base/bus.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 73f6c29..a7ce942 100644
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
1.9.1

