Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758384Ab3BWE1H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 23:27:07 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:41890 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757366Ab3BWE1D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 23:27:03 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: Dave Jones <davej@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        tianyu.lan@intel.com, linux-acpi@vger.kernel.org
Subject: Re: [GIT PATCH] USB patches for 3.9-rc1
Date: Sat, 23 Feb 2013 05:33:39 +0100
Message-ID: <1522889.3cbJt7lHsB@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130223014427.GA1709@balto.lan>
References: <20130222085954.GA4352@redhat.com> <8156425.nbPzS18WCu@vostro.rjw.lan> <20130223014427.GA1709@balto.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, February 23, 2013 02:44:27 AM Fabio Baltieri wrote:
> On Sat, Feb 23, 2013 at 01:35:26AM +0100, Rafael J. Wysocki wrote:
> > On Saturday, February 23, 2013 01:10:55 AM Fabio Baltieri wrote:
> > > Well, this did the trick in my case:
> > > 
> > > --- >8 ---
> > > diff --git a/drivers/acpi/power.c b/drivers/acpi/power.c
> > > index b820528..54175a0 100644
> > > --- a/drivers/acpi/power.c
> > > +++ b/drivers/acpi/power.c
> > > @@ -795,7 +795,7 @@ int acpi_add_power_resource(acpi_handle handle)
> > >         int state, result = -ENODEV;
> > >  
> > >         acpi_bus_get_device(handle, &device);
> > > -       if (device)
> > > +       if (!device)
> > >                 return 0;
> > >  
> > >         resource = kzalloc(sizeof(*resource), GFP_KERNEL);
> > > --- >8 ---
> > > 
> > > But I guess it's working as a coincidence and something else is wrong -
> > > I'll not even try to make a patch out of it and will leave the dirty
> > > work to the ACPI guys instead.
> > 
> > Well, this patch effectively disables the handling of power resources on your
> > machine entirely.  The effect of which is probably that the power resources
> > can't be turned off for the USB controllers, so they don't go into D3cold.
> 
> Ok, as I wrote, I suspected this was just shutting off something and not
> solving the real problem.
> 
> So, I'll try to recap all the threads here:
> 
> > And the bisection found a commit that restores the handling of power resources
> > for you, which is not entirely surprising, but the root cause is somewhere else
> > most likely.
> 
> Indeed.
> 
> > The new sysfs interface for power resources control may be helpful here.  You
> > need to use the Linus' current for it to work, though.
> > 
> > Can you please do
> > 
> > $ find /sys/devices/LNXSYSTM:00/ -name power_state -print -exec cat {} \;
> > $ find /sys/devices/LNXSYSTM:00/ -name real_power_state -print -exec cat {} \;
> > $ find /sys/devices/LNXSYSTM:00/ -name power_resources_D\* -print -exec ls {} \;
> > $ find /sys/devices/LNXSYSTM:00/ -name resource_in_use -print -exec cat {} \;
> > and send the output?
> 
> With the acpi_add_power_resource disabled all power_state read "D0",
> other attributes are not generated.

Yup.  That's how it should be.

> With a plain kernel that's the output:
> 
> $ find /sys/devices/LNXSYSTM:00/ -name power_state -print -exec cat {} \;
> /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:09/LNXVIDEO:01/power_state
> D0
> /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:29/power_state
> D0
> /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:34/power_state
> D0
> /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:1f/power_state
> D0
> /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/power_state
> D0
> 
> $ find /sys/devices/LNXSYSTM:00/ -name real_power_state -print -exec cat {} \;
> /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:29/real_power_state
> D3cold
> /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:34/real_power_state
> D3cold
> /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:1f/real_power_state
> D3cold

This is obviously wrong.  We expect the devices to be in D0, while they really
are in D3cold.  Let's look deeper.

> $ find /sys/devices/LNXSYSTM:00/ -name power_resources_D\* -print -exec ls {} \;
> /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:29/power_resources_D0
> LNXPOWER:00
> /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:29/power_resources_D1
> LNXPOWER:00
> /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:29/power_resources_D2
> LNXPOWER:00
> /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:34/power_resources_D0
> LNXPOWER:00
> /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:34/power_resources_D1
> LNXPOWER:00
> /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:34/power_resources_D2
> LNXPOWER:00
> /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:1f/power_resources_D0
> LNXPOWER:00
> /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:1f/power_resources_D1
> LNXPOWER:00
> /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:1f/power_resources_D2
> LNXPOWER:00

PNP0A08 is the PCI root bridge and device:29, device:34, device:1f are the USB
controllers.  All of them have ACPI power states D0, D1, D2 and D3cold, where
D0-D2 depend on the same power resource, so in fact they all are the same state
(what sense does this make?).

I suspect that the power resource being shared (and it being shared in such a
broken way) has to do something with the breakage.

> $ find /sys/devices/LNXSYSTM:00/ -name resource_in_use -print -exec cat {} \;
> /sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/device:08/PNP0C09:00/LNXPOWER:00/resource_in_use
> 0

There's one power resource in the system and it's usage count is 0, so it is
"off" (which is consistent with the real power states of the USB controllers).

Now, the boot log shows that the power resource was "on" when it was found,
so the initial states of the USB controllers should have been D0.

However, the DSDT source shows that the very same power resource that the D0-D2
power states of the devices depend on is listed for them as a wakeup power
resource by _PRW.  [Is that even valid?  It doesn't seem to make sense anyway.]
Thus when pci_acpi_setup() does acpi_pci_sleep_wake(pci_dev, false), which
calls acpi_pm_device_sleep_wake(&dev->dev, false), eventually
acpi_disable_wakeup_device_power() will be called for the device.  This leads
to calling acpi_power_off_list() for wakeup resources and that list includes
our single power resource, so its refcount will be dropped and it will be
turned off silently without updating the current power state of the device.

So first, the commit that broke things for you was probably
d2e5f0c (ACPI / PCI: Rework the setup and cleanup of device wakeup) which moved
the wakeup initialization, but didn't show up in the bisection, because the
power resources handling didn't work at that point.  And if I'm not mistaken,
it only broke things because we've never assumed that a wakeup power resource
may be the same as a power resource the device's power states depend on (which
we should).

Now, how to fix this is an interesting problem.

After some consideration I got the appended patch, but I'm really tired now
and couldn't really test it, so caveat emptor.  I'll look at it once again
tomorrow and see if it still makes sense to me then.

> > Can you please check if the problem is still there in the master
> > branch of the linux-pm.git tree alone?
> 
> Not sure if this was for me or Dave, anyway linux-pm.git master
> currently points as:
> 
> 10baf04 Merge branch 'release' of git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux
> 
> and the problem is still there.

OK, thanks for verifying this.

> > May I see the bisection log, BTW?
> 
> Sure, here it is:
> 
> git bisect start
> # bad: [8793422fd9ac5037f5047f80473007301df3689f] Merge tag 'pm+acpi-3.9-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm
> git bisect bad 8793422fd9ac5037f5047f80473007301df3689f
> # good: [19f949f52599ba7c3f67a5897ac6be14bfcb1200] Linux 3.8
> git bisect good 19f949f52599ba7c3f67a5897ac6be14bfcb1200
> # good: [8909ff652ddfc83ecdf450f96629c25489d88f77] Merge tag 'regulator-3.9' of git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator
> git bisect good 8909ff652ddfc83ecdf450f96629c25489d88f77
> # good: [3aad3f03b2b6d2d977b985c49274cdb78a1593e5] Merge tag 'spi-for-linus' of git://git.secretlab.ca/git/linux
> git bisect good 3aad3f03b2b6d2d977b985c49274cdb78a1593e5
> # bad: [e8f71df723339b6d3861886f58c245812d1994f8] Merge branch 'acpi-cleanup'
> git bisect bad e8f71df723339b6d3861886f58c245812d1994f8
> # bad: [701190fd7419f6757c19cdc6473830c79debb3ae] clk: x86: add support for Lynxpoint LPSS clocks
> git bisect bad 701190fd7419f6757c19cdc6473830c79debb3ae
> # good: [3e5621a750e2cfb26748c34acbb67c691845494a] ACPICA: Update ACPICA initialization messages.
> git bisect good 3e5621a750e2cfb26748c34acbb67c691845494a
> # bad: [115c9ad854bd4c0f58ebcb967ec1b0a1c4e4b2d3] ACPI: remove unused acpi_op_bind and acpi_op_unbind
> git bisect bad 115c9ad854bd4c0f58ebcb967ec1b0a1c4e4b2d3
> # good: [e3863094c6f9b2f980d6e7a5cad6b4d03a4dd579] ACPI: Drop the second argument of acpi_bus_scan()
> git bisect good e3863094c6f9b2f980d6e7a5cad6b4d03a4dd579
> # good: [38a9a67a281eeebcd7cccf87f0e371f58ae625e3] ACPI / PCI: Move the _PRT setup and cleanup code to pci-acpi.c
> git bisect good 38a9a67a281eeebcd7cccf87f0e371f58ae625e3
> # good: [e0ebda2ee12c261fb2f2d7abf21489b93d9caa4e] ACPI: Remove unused struct acpi_pci_root.id member
> git bisect good e0ebda2ee12c261fb2f2d7abf21489b93d9caa4e
> # bad: [abe99210e0f624cea39f1dc375ba818b201c0d7f] ACPI / scan: Fix check of device_attach() return value.
> git bisect bad abe99210e0f624cea39f1dc375ba818b201c0d7f
> # bad: [f95988de06ea62ef5bd861f06e9ef56cea405ed1] ACPI / scan: Treat power resources in a special way
> git bisect bad f95988de06ea62ef5bd861f06e9ef56cea405ed1

Thanks.  I had hoped it would give me a hint, but it didn't after all.

> > Can you please send a dmesg boot log and the output of acpidump from the
> > affected machine?
> 
> dmesg:
> http://paste.ubuntu.com/5556864/
> 
> acpidump:
> http://paste.ubuntu.com/5556867/

Thanks a lot for the great info, it all helped.

Thanks,
Rafael


---
 drivers/acpi/internal.h |    2 
 drivers/acpi/power.c    |  106 ++++++++++++++++++++++++++++++++++++------------
 drivers/acpi/scan.c     |    2 
 3 files changed, 82 insertions(+), 28 deletions(-)

Index: test/drivers/acpi/internal.h
===================================================================
--- test.orig/drivers/acpi/internal.h
+++ test/drivers/acpi/internal.h
@@ -84,7 +84,7 @@ int acpi_extract_power_resources(union a
 				 struct list_head *list);
 int acpi_add_power_resource(acpi_handle handle);
 void acpi_power_add_remove_device(struct acpi_device *adev, bool add);
-int acpi_power_min_system_level(struct list_head *list);
+int acpi_power_wakeup_list_init(struct list_head *list);
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
 
@@ -521,16 +531,29 @@ void acpi_power_add_remove_device(struct
 	}
 }
 
-int acpi_power_min_system_level(struct list_head *list)
+int acpi_power_wakeup_list_init(struct list_head *list)
 {
 	struct acpi_power_resource_entry *entry;
 	int system_level = 5;
 
 	list_for_each_entry(entry, list, node) {
 		struct acpi_power_resource *resource = entry->resource;
+		acpi_handle handle = resource->device.handle;
+		int result;
+		int state;
+
+		mutex_lock(&resource->resource_lock);
+
+		result = acpi_power_get_state(handle, &state);
+		if (!result && state == ACPI_POWER_RESOURCE_STATE_ON) {
+			resource->ref_count++;
+			resource->wakeup_enabled = true;
+		}
 
 		if (system_level > resource->system_level)
 			system_level = resource->system_level;
+
+		mutex_unlock(&resource->resource_lock);
 	}
 	return system_level;
 }
@@ -610,6 +633,7 @@ int acpi_device_sleep_wake(struct acpi_d
  */
 int acpi_enable_wakeup_device_power(struct acpi_device *dev, int sleep_state)
 {
+	struct acpi_power_resource_entry *entry;
 	int err = 0;
 
 	if (!dev || !dev->wakeup.flags.valid)
@@ -620,17 +644,31 @@ int acpi_enable_wakeup_device_power(stru
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
 
@@ -647,6 +685,7 @@ int acpi_enable_wakeup_device_power(stru
  */
 int acpi_disable_wakeup_device_power(struct acpi_device *dev)
 {
+	struct acpi_power_resource_entry *entry;
 	int err = 0;
 
 	if (!dev || !dev->wakeup.flags.valid)
@@ -668,10 +707,25 @@ int acpi_disable_wakeup_device_power(str
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
@@ -1153,7 +1153,7 @@ static int acpi_bus_extract_wakeup_devic
 	if (!list_empty(&wakeup->resources)) {
 		int sleep_state;
 
-		sleep_state = acpi_power_min_system_level(&wakeup->resources);
+		sleep_state = acpi_power_wakeup_list_init(&wakeup->resources);
 		if (sleep_state < wakeup->sleep_state) {
 			acpi_handle_warn(handle, "Overriding _PRW sleep state "
 					 "(S%d) by S%d from power resources\n",


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
