Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035AbbALSFk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:05:40 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57391 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919AbbALSFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:05:37 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Williamson <alex.williamson@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 024/216] driver core: Fix unbalanced device reference in drivers_probe
Date: Mon, 12 Jan 2015 18:02:21 +0000
Message-Id: <1421085933-32536-25-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/base/bus.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 83e910a57563..876bae5ade33 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -254,13 +254,15 @@ static ssize_t store_drivers_probe(struct bus_type *bus,
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
2.1.4

