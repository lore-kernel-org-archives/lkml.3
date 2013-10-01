Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752245Ab3JASih (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 14:38:37 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:62952 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262Ab3JASie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 14:38:34 -0400
Date: Tue, 1 Oct 2013 13:38:31 -0500
From: Kim Phillips <kim.phillips@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        a.motakis@virtualopensystems.com, Alexander Graf <agraf@suse.de>,
        Alex Williamson <alex.williamson@redhat.com>,
        stuart.yoder@freescale.com, Wood Scott-B07421 <B07421@freescale.com>,
        Sethi Varun-B16395 <B16395@freescale.com>,
        Bhushan Bharat-R65777 <R65777@freescale.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        santosh.shukla@linaro.org, kvm@vger.kernel.org
Subject: RFC: (re-)binding the VFIO platform driver to a platform device
Message-Id: <20131001133831.6e46e8e00e09d5d9079fde57@linaro.org>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Santosh and I are having a problem figuring out how to enable binding
(and re-binding) platform devices to a platform VFIO driver (see
Antonis' WIP: [1]) in an upstream-acceptable manner.

Binding platform drivers currently depends on a string match in the
device node's compatible entry.  On an arndale, one can currently
rebind the same device to the same driver like so:

echo 12ce0000.i2c > /sys/bus/platform/drivers/s3c-i2c/12ce0000.i2c/driver/unbind
echo 12ce0000.i2c > /sys/bus/platform/drivers/s3c-i2c/bind

And one can bind it to the vfio-dt driver, as Antonis instructs, by
appending a 'vfio-dt' string to the device tree compatible entry for
the device.  Then this would work:

echo 12ce0000.i2c > /sys/bus/platform/drivers/s3c-i2c/12ce0000.i2c/driver/unbind
echo 12ce0000.i2c > /sys/bus/platform/drivers/vfio-dt/bind

Consequently, the hack patch below [2] allows any platform device to be
bound to the vfio-dt driver, without making changes to the device
tree.  It's a hack because I don't see having any driver name specific
code in drivers/base/bus.c being upstream acceptable.

Alternately, device tree compatible entries may be made writeable after
boot, e.g.:

echo vfio-platform > /proc/device-tree/i2c\@12CE0000/compatible

[note s/vfio-dt/vfio-platform/]

but that would require the vfio-platform module be reloaded, thereby
unbinding it from any existing devices it was bound to: we're
seeking a more dynamic solution.

Alex Graf (cc'd) proposed an alternate approach: re-write the driver
name in the device's sysfs entry:

echo "vfio-platform" > /sys/bus/platform/devices/101e0000.rtc/driver/driver_name

The advantage of this approach is that we can achieve the re-bind
(unbind + bind) as an atomic operation, which alleviates userspace from
having to coordinate with other device operations (I think VM migration
is an example case here).

Note that driver_name currently doesn't exist in sysfs, so it would
either have to be added, or another means developed to rename the
driver symlink itself:

cd /sys/bus/platform/devices/12ce0000.i2c
ln -s ../../bus/platform/drivers/s5p-ehci /tmp/tmp-link
mv -Tf /tmp/tmp-link driver

So I guess the question is:  Is our understanding corret - are we on
the right track at all here?  Is the hack below definitely not
acceptable?  Is it correct to assume upstream maintainers are against
writing compatible entries to the device tree sysfs at runtime?  Would
a driver_name be acceptable to add to sysfs, or should we investigate
something like the atomic mv command above further?

Thanks,

Kim

[1] Note that in this RFC, 'vfio-dt' is the name for the driver (-dt for
device tree) which has already been pointed out as a misnomer and
should probably be rewritten as 'vfio-platform':

http://lists.linux-foundation.org/pipermail/iommu/2013-August/006284.html

[2]
>From 6fa383d3f7bb53eb5efbb324c07484191b29543d Mon Sep 17 00:00:00 2001
From: Kim Phillips <kim.phillips@linaro.org>
Date: Fri, 27 Sep 2013 14:36:04 -0500
Subject: [PATCH] hack/rfc: allow vfio-dt to bind to any platform device

---
 drivers/base/bus.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 4c289ab..1cf08d6 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -201,7 +201,8 @@ static ssize_t bind_store(struct device_driver *drv, const char *buf,
 	int err = -ENODEV;
 
 	dev = bus_find_device_by_name(bus, NULL, buf);
-	if (dev && dev->driver == NULL && driver_match_device(drv, dev)) {
+	if (dev && dev->driver == NULL && (driver_match_device(drv, dev) ||
+	    !strcmp(drv->name, "vfio-dt"))) {
 		if (dev->parent)	/* Needed for USB */
 			device_lock(dev->parent);
 		device_lock(dev);
-- 
1.8.4
