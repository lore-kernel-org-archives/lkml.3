Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388AbbANH1j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:27:39 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57887 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754365AbbANH1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:27:38 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alex Williamson <alex.williamson@redhat.com>
Subject: [PATCH 3.18 070/150] driver core: Fix unbalanced device reference in drivers_probe
Date: Tue, 13 Jan 2015 23:22:21 -0800
Message-Id: <20150114072059.011158978@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150114072055.842408181@linuxfoundation.org>
References: <20150114072055.842408181@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Williamson <alex.williamson@redhat.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/base/bus.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -254,13 +254,15 @@ static ssize_t store_drivers_probe(struc
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


