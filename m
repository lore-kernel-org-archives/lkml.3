Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759026Ab3BWOMB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 09:12:01 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:42184 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758877Ab3BWOL5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 09:11:57 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: Dave Jones <davej@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        tianyu.lan@intel.com, linux-acpi@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org
Subject: [PATCH] ACPI / PM: Take unusual configurations of power resources into account (was: Re: [GIT PATCH] USB patches for 3.9-rc1)
Date: Sat, 23 Feb 2013 15:18:36 +0100
Message-ID: <4258343.ok1n3SAim3@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130223114914.GA1786@balto.lan>
References: <20130222085954.GA4352@redhat.com> <1522889.3cbJt7lHsB@vostro.rjw.lan> <20130223114914.GA1786@balto.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, February 23, 2013 12:49:14 PM Fabio Baltieri wrote:
> Hello Rafael,
> 
> On Sat, Feb 23, 2013 at 05:33:39AM +0100, Rafael J. Wysocki wrote:
> > On Saturday, February 23, 2013 02:44:27 AM Fabio Baltieri wrote:
> > > On Sat, Feb 23, 2013 at 01:35:26AM +0100, Rafael J. Wysocki wrote:
> > > > The new sysfs interface for power resources control may be helpful here.  You
> > > > need to use the Linus' current for it to work, though.
> > > > 
> > > > Can you please do
> > > > 
> > > > $ find /sys/devices/LNXSYSTM:00/ -name power_state -print -exec cat {} \;
> > > > $ find /sys/devices/LNXSYSTM:00/ -name real_power_state -print -exec cat {} \;
> > > > $ find /sys/devices/LNXSYSTM:00/ -name power_resources_D\* -print -exec ls {} \;
> > > > $ find /sys/devices/LNXSYSTM:00/ -name resource_in_use -print -exec cat {} \;
> > > > and send the output?
> > > 
> > > With the acpi_add_power_resource disabled all power_state read "D0",
> > > other attributes are not generated.
> > 
> > Yup.  That's how it should be.
> > 
> > > With a plain kernel that's the output:
> > > 
> > > $ find /sys/devices/LNXSYSTM:00/ -name power_state -print -exec cat {} \;
> > > /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:09/LNXVIDEO:01/power_state
> > > D0
> > > /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:29/power_state
> > > D0
> > > /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:34/power_state
> > > D0
> > > /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:1f/power_state
> > > D0
> > > /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/power_state
> > > D0
> > > 
> > > $ find /sys/devices/LNXSYSTM:00/ -name real_power_state -print -exec cat {} \;
> > > /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:29/real_power_state
> > > D3cold
> > > /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:34/real_power_state
> > > D3cold
> > > /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:1f/real_power_state
> > > D3cold
> > 
> > This is obviously wrong.  We expect the devices to be in D0, while they really
> > are in D3cold.  Let's look deeper.
> > 
> > > $ find /sys/devices/LNXSYSTM:00/ -name power_resources_D\* -print -exec ls {} \;
> > > /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:29/power_resources_D0
> > > LNXPOWER:00
> > > /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:29/power_resources_D1
> > > LNXPOWER:00
> > > /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:29/power_resources_D2
> > > LNXPOWER:00
> > > /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:34/power_resources_D0
> > > LNXPOWER:00
> > > /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:34/power_resources_D1
> > > LNXPOWER:00
> > > /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:34/power_resources_D2
> > > LNXPOWER:00
> > > /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:1f/power_resources_D0
> > > LNXPOWER:00
> > > /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:1f/power_resources_D1
> > > LNXPOWER:00
> > > /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:1f/power_resources_D2
> > > LNXPOWER:00
> > 
> > PNP0A08 is the PCI root bridge and device:29, device:34, device:1f are the USB
> > controllers.  All of them have ACPI power states D0, D1, D2 and D3cold, where
> > D0-D2 depend on the same power resource, so in fact they all are the same state
> > (what sense does this make?).
> > 
> > I suspect that the power resource being shared (and it being shared in such a
> > broken way) has to do something with the breakage.
> > 
> > > $ find /sys/devices/LNXSYSTM:00/ -name resource_in_use -print -exec cat {} \;
> > > /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:08/PNP0C09:00/LNXPOWER:00/resource_in_use
> > > 0
> > 
> > There's one power resource in the system and it's usage count is 0, so it is
> > "off" (which is consistent with the real power states of the USB controllers).
> > 
> > Now, the boot log shows that the power resource was "on" when it was found,
> > so the initial states of the USB controllers should have been D0.
> 
> Sounds reasonable, I see that the ports are active until the kernel
> starts.
> 
> > However, the DSDT source shows that the very same power resource that the D0-D2
> > power states of the devices depend on is listed for them as a wakeup power
> > resource by _PRW.  [Is that even valid?  It doesn't seem to make sense anyway.]
> > Thus when pci_acpi_setup() does acpi_pci_sleep_wake(pci_dev, false), which
> > calls acpi_pm_device_sleep_wake(&dev->dev, false), eventually
> > acpi_disable_wakeup_device_power() will be called for the device.  This leads
> > to calling acpi_power_off_list() for wakeup resources and that list includes
> > our single power resource, so its refcount will be dropped and it will be
> > turned off silently without updating the current power state of the device.
> > 
> > So first, the commit that broke things for you was probably
> > d2e5f0c (ACPI / PCI: Rework the setup and cleanup of device wakeup) which moved
> > the wakeup initialization, but didn't show up in the bisection, because the
> > power resources handling didn't work at that point.  And if I'm not mistaken,
> > it only broke things because we've never assumed that a wakeup power resource
> > may be the same as a power resource the device's power states depend on (which
> > we should).
> > 
> > Now, how to fix this is an interesting problem.
> > 
> > After some consideration I got the appended patch, but I'm really tired now
> > and couldn't really test it, so caveat emptor.  I'll look at it once again
> > tomorrow and see if it still makes sense to me then.
> [snip]
> > ---
> >  drivers/acpi/internal.h |    2 
> >  drivers/acpi/power.c    |  106 ++++++++++++++++++++++++++++++++++++------------
> >  drivers/acpi/scan.c     |    2 
> >  3 files changed, 82 insertions(+), 28 deletions(-)
> 
> Well, this works fine on my system.  The power is back and from sysfs I
> got all three real_power_state to D0 and resource_in_use to 1.
> 
> Anything else I should check?

No need.

> I'll re-test again when you submit the patch formally!

Thanks, it is appended.

I've only changed acpi_power_wakeup_list_init() so that it returns an error if
it cannot get the current states of wakeup power resources, which is essential.
The rest of the patch is the same as before.

Besides, it looks like it will be useful to have wakeup power resources exposed
in sysfs too, so I think I'll cut a patch for that.

Thanks,
Rafael


---
From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Subject: ACPI / PM: Take unusual configurations of power resources into account

Commit d2e5f0c (ACPI / PCI: Rework the setup and cleanup of device
wakeup) moved the initial disabling of system wakeup for PCI devices
into a place where it can actually work and that exposed a hidden old
issue with crap^Wunusual system designs where the same power
resources are used for both wakeup power and device power control at
run time.

Namely, say there is one power resource such that the ACPI power
state D0 of a PCI device depends on that power resource (i.e. the
device is in D0 when that power resource is "on") and it is used
as a wakeup power resource for the same device.  Then, calling
acpi_pci_sleep_wake(pci_dev, false) for the device in question will
cause the reference counter of that power resource to drop to 0,
which in turn will cause it to be turned off.  As a result, the
device will go into D3cold at that point, although it should have
stayed in D0.

As it turns out, that happens to USB controllers on some laptops
and USB becomes unusable on those machines as a result, which is
a major regression from v3.8.

To fix this problem, (1) increment the reference counters of wakup
power resources during their initialization if they are "on"
initially, (2) prevent acpi_disable_wakeup_device_power() from
decrementing the reference counters of wakeup power resources that
were not enabled for wakeup power previously, and (3) prevent
acpi_enable_wakeup_device_power() from incrementing the reference
counters of wakeup power resources that already are enabled for
wakeup power.

In addition to that, if it is impossible to determine the initial
states of wakeup power resources, avoid enabling wakeup for devices
whose wakeup power depends on those power resources.

Reported-by: Dave Jones <davej@redhat.com>
Reported-by: Fabio Baltieri <fabio.baltieri@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/internal.h |    2 
 drivers/acpi/power.c    |  112 ++++++++++++++++++++++++++++++++++++------------
 drivers/acpi/scan.c     |    9 +++
 3 files changed, 94 insertions(+), 29 deletions(-)

Index: test/drivers/acpi/internal.h
===================================================================
--- test.orig/drivers/acpi/internal.h
+++ test/drivers/acpi/internal.h
@@ -84,7 +84,7 @@ int acpi_extract_power_resources(union a
 				 struct list_head *list);
 int acpi_add_power_resource(acpi_handle handle);
 void acpi_power_add_remove_device(struct acpi_device *adev, bool add);
-int acpi_power_min_system_level(struct list_head *list);
+int acpi_power_wakeup_list_init(struct list_head *list, int *system_level);
 int acpi_device_sleep_wake(struct acpi_device *dev,
                            int enable, int sleep_state, int dev_state);
 int acpi_power_get_inferred_state(struct acpi_device *device, int *state);
Index: test/drivers/acpi/power.c
===================================================================
--- test.orig/drivers/acpi/power.c
+++ test/drivers/acpi/power.c
@@ -73,6 +73,7 @@ struct acpi_power_resource {
 	u32 system_level;
 	u32 order;
 	unsigned int ref_count;
+	bool wakeup_enabled;
 	struct mutex resource_lock;
 };
 
@@ -272,11 +273,9 @@ static int __acpi_power_on(struct acpi_p
 	return 0;
 }
 
-static int acpi_power_on(struct acpi_power_resource *resource)
+static int acpi_power_on_unlocked(struct acpi_power_resource *resource)
 {
-	int result = 0;;
-
-	mutex_lock(&resource->resource_lock);
+	int result = 0;
 
 	if (resource->ref_count++) {
 		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
@@ -293,9 +292,16 @@ static int acpi_power_on(struct acpi_pow
 				schedule_work(&dep->work);
 		}
 	}
+	return result;
+}
 
-	mutex_unlock(&resource->resource_lock);
+static int acpi_power_on(struct acpi_power_resource *resource)
+{
+	int result;
 
+	mutex_lock(&resource->resource_lock);
+	result = acpi_power_on_unlocked(resource);
+	mutex_unlock(&resource->resource_lock);
 	return result;
 }
 
@@ -313,17 +319,15 @@ static int __acpi_power_off(struct acpi_
 	return 0;
 }
 
-static int acpi_power_off(struct acpi_power_resource *resource)
+static int acpi_power_off_unlocked(struct acpi_power_resource *resource)
 {
 	int result = 0;
 
-	mutex_lock(&resource->resource_lock);
-
 	if (!resource->ref_count) {
 		ACPI_DEBUG_PRINT((ACPI_DB_INFO,
 				  "Power resource [%s] already off",
 				  resource->name));
-		goto unlock;
+		return 0;
 	}
 
 	if (--resource->ref_count) {
@@ -335,10 +339,16 @@ static int acpi_power_off(struct acpi_po
 		if (result)
 			resource->ref_count++;
 	}
+	return result;
+}
 
- unlock:
-	mutex_unlock(&resource->resource_lock);
+static int acpi_power_off(struct acpi_power_resource *resource)
+{
+	int result;
 
+	mutex_lock(&resource->resource_lock);
+	result = acpi_power_off_unlocked(resource);
+	mutex_unlock(&resource->resource_lock);
 	return result;
 }
 
@@ -521,18 +531,35 @@ void acpi_power_add_remove_device(struct
 	}
 }
 
-int acpi_power_min_system_level(struct list_head *list)
+int acpi_power_wakeup_list_init(struct list_head *list, int *system_level_p)
 {
 	struct acpi_power_resource_entry *entry;
 	int system_level = 5;
 
 	list_for_each_entry(entry, list, node) {
 		struct acpi_power_resource *resource = entry->resource;
+		acpi_handle handle = resource->device.handle;
+		int result;
+		int state;
 
+		mutex_lock(&resource->resource_lock);
+
+		result = acpi_power_get_state(handle, &state);
+		if (result) {
+			mutex_unlock(&resource->resource_lock);
+			return result;
+		}
+		if (state == ACPI_POWER_RESOURCE_STATE_ON) {
+			resource->ref_count++;
+			resource->wakeup_enabled = true;
+		}
 		if (system_level > resource->system_level)
 			system_level = resource->system_level;
+
+		mutex_unlock(&resource->resource_lock);
 	}
-	return system_level;
+	*system_level_p = system_level;
+	return 0;
 }
 
 /* --------------------------------------------------------------------------
@@ -610,6 +637,7 @@ int acpi_device_sleep_wake(struct acpi_d
  */
 int acpi_enable_wakeup_device_power(struct acpi_device *dev, int sleep_state)
 {
+	struct acpi_power_resource_entry *entry;
 	int err = 0;
 
 	if (!dev || !dev->wakeup.flags.valid)
@@ -620,17 +648,31 @@ int acpi_enable_wakeup_device_power(stru
 	if (dev->wakeup.prepare_count++)
 		goto out;
 
-	err = acpi_power_on_list(&dev->wakeup.resources);
-	if (err) {
-		dev_err(&dev->dev, "Cannot turn wakeup power resources on\n");
-		dev->wakeup.flags.valid = 0;
-	} else {
-		/*
-		 * Passing 3 as the third argument below means the device may be
-		 * put into arbitrary power state afterward.
-		 */
-		err = acpi_device_sleep_wake(dev, 1, sleep_state, 3);
+	list_for_each_entry(entry, &dev->wakeup.resources, node) {
+		struct acpi_power_resource *resource = entry->resource;
+
+		mutex_lock(&resource->resource_lock);
+
+		if (!resource->wakeup_enabled) {
+			err = acpi_power_on_unlocked(resource);
+			if (!err)
+				resource->wakeup_enabled = true;
+		}
+
+		mutex_unlock(&resource->resource_lock);
+
+		if (err) {
+			dev_err(&dev->dev,
+				"Cannot turn wakeup power resources on\n");
+			dev->wakeup.flags.valid = 0;
+			goto out;
+		}
 	}
+	/*
+	 * Passing 3 as the third argument below means the device may be
+	 * put into arbitrary power state afterward.
+	 */
+	err = acpi_device_sleep_wake(dev, 1, sleep_state, 3);
 	if (err)
 		dev->wakeup.prepare_count = 0;
 
@@ -647,6 +689,7 @@ int acpi_enable_wakeup_device_power(stru
  */
 int acpi_disable_wakeup_device_power(struct acpi_device *dev)
 {
+	struct acpi_power_resource_entry *entry;
 	int err = 0;
 
 	if (!dev || !dev->wakeup.flags.valid)
@@ -668,10 +711,25 @@ int acpi_disable_wakeup_device_power(str
 	if (err)
 		goto out;
 
-	err = acpi_power_off_list(&dev->wakeup.resources);
-	if (err) {
-		dev_err(&dev->dev, "Cannot turn wakeup power resources off\n");
-		dev->wakeup.flags.valid = 0;
+	list_for_each_entry(entry, &dev->wakeup.resources, node) {
+		struct acpi_power_resource *resource = entry->resource;
+
+		mutex_lock(&resource->resource_lock);
+
+		if (resource->wakeup_enabled) {
+			err = acpi_power_off_unlocked(resource);
+			if (!err)
+				resource->wakeup_enabled = false;
+		}
+
+		mutex_unlock(&resource->resource_lock);
+
+		if (err) {
+			dev_err(&dev->dev,
+				"Cannot turn wakeup power resources off\n");
+			dev->wakeup.flags.valid = 0;
+			break;
+		}
 	}
 
  out:
Index: test/drivers/acpi/scan.c
===================================================================
--- test.orig/drivers/acpi/scan.c
+++ test/drivers/acpi/scan.c
@@ -1153,7 +1153,14 @@ static int acpi_bus_extract_wakeup_devic
 	if (!list_empty(&wakeup->resources)) {
 		int sleep_state;
 
-		sleep_state = acpi_power_min_system_level(&wakeup->resources);
+		err = acpi_power_wakeup_list_init(&wakeup->resources,
+						  &sleep_state);
+		if (err) {
+			acpi_handle_warn(handle, "Retrieving current states "
+					 "of wakeup power resources failed\n");
+			acpi_power_resources_list_free(&wakeup->resources);
+			goto out;
+		}
 		if (sleep_state < wakeup->sleep_state) {
 			acpi_handle_warn(handle, "Overriding _PRW sleep state "
 					 "(S%d) by S%d from power resources\n",


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
