Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932620Ab3FRQDp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 12:03:45 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:53948 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756147Ab3FRQDn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 12:03:43 -0400
Message-ID: <51C084D9.50008@gmail.com>
Date: Wed, 19 Jun 2013 00:03:37 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        "Alexander E . Patrakov" <patrakov@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yijing Wang <wangyijing@huawei.com>, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Len Brown <lenb@kernel.org>, stable@vger.kernel.org,
        Jiang Liu <jiang.liu@huawei.com>
Subject: Re: [BUGFIX v2 2/4] ACPI, DOCK: resolve possible deadlock scenarios
References: <1371238081-32260-1-git-send-email-jiang.liu@huawei.com> <2139297.LeMhgEjsya@vostro.rjw.lan> <51BDF1E0.5070201@gmail.com> <2972274.Y9Nv7DUfsQ@vostro.rjw.lan>
In-Reply-To: <2972274.Y9Nv7DUfsQ@vostro.rjw.lan>
Content-Type: multipart/mixed;
 boundary="------------000700010704030103000407"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000700010704030103000407
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 06/17/2013 07:40 PM, Rafael J. Wysocki wrote:
> On Monday, June 17, 2013 01:12:00 AM Jiang Liu wrote:
>> On 06/16/2013 06:54 AM, Rafael J. Wysocki wrote:
>>> On Saturday, June 15, 2013 11:20:40 PM Rafael J. Wysocki wrote:
>>>> On Saturday, June 15, 2013 10:17:42 PM Rafael J. Wysocki wrote:
>>>
>>> [...]
>>>
>>>>
>>>> Which sysfs interfaces do you mean, by the way?
>>>>
>>>> If you mean "eject", then it takes acpi_scan_lock and hotplug_dock_devices()
>>>> should always be run under acpi_scan_lock too.  It isn't at the moment,
>>>> because write_undock() doesn't take acpi_scan_lock(), but this is an obvious
>>>> bug (so I'm going to send a patch to fix it in a while).
>>>>
>>>> With that bug fixed, the possible race between acpi_eject_store() and
>>>> hotplug_dock_devices() should be prevented from happening, so perhaps we're
>>>> worrying about something that cannot happen?
>>>
>>> So here's a question: What particular races are possible if we remove
>>> ds->hp_lock entirely without doing anything else just yet?  I mean, how to
>>> *trigger* them from the start to the end and not how they can possibly happen
>>> but never do, because there's no way they can be actually triggered?
>> Hi Rafael,
>>     I have no really platform which triggers this bug, but I may imagine
>> a possible platform if it's valid for explanation.
>>     Let's think about a laptop dock station with a thunderbolt
>> controller built-in. The dock station is managed by dock driver and
>> acpiphp driver. And the PCIe hierarchy managed by the thunderbolt
>> controller may be managed by dock driver and ACPIPHP driver too.
>> So it may trigger the issue by pressing the dock button and unplugging
>> thunderbolt cable concurrently.
>>     But after all, this is all by imagination:). We may need to find a
>> simple and quick solution for 3.10 and the stable trees and enhance the
>> solution later to avoid introducing new bugs while fixing a bug.
> 
> Well, if that particular bug is not fixed in 3,10, it won't be a tragedy,
> and I *really* don't want that code to get substantially more complex than
> it is now.
Hi Rafael,
    I hope I could help to simplify the implementation too, but failed
until now:(. The PCI hotplug core has the same re-entrance issue too,
and I have struggled with that issue about one year now:(
    I have tried another solution by removing ds->hp_lock and
hotplug_devices list, please refer to the attachment. It could be used
to solve the deadlock issue in acpiphp, but may not be used to support
the coming fix for an ATA driver
regression(https://bugzilla.kernel.org/show_bug.cgi?id=59871).
    The time window for 3.10 is closing, it would be great if we could
reach a quick solution here.
Regards!
Gerry

> 
> Thanks,
> Rafael
> 
> 


--------------000700010704030103000407
Content-Type: text/x-patch;
 name="0001-.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-.patch"

>From d1a3f472ea81c780c370a98b553cf83f82d3e961 Mon Sep 17 00:00:00 2001
From: Jiang Liu <jiang.liu@huawei.com>
Date: Tue, 18 Jun 2013 22:22:23 +0800
Subject: [PATCH]

---
 drivers/acpi/dock.c                | 108 +++++++++++++++----------------------
 drivers/pci/hotplug/acpiphp_glue.c |  32 ++++++-----
 2 files changed, 62 insertions(+), 78 deletions(-)

diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
index 469ef56..fd8830a 100644
--- a/drivers/acpi/dock.c
+++ b/drivers/acpi/dock.c
@@ -58,10 +58,7 @@ struct dock_station {
 	unsigned long last_dock_time;
 	u32 flags;
 	spinlock_t dd_lock;
-	struct mutex hp_lock;
 	struct list_head dependent_devices;
-	struct list_head hotplug_devices;
-
 	struct list_head sibling;
 	struct platform_device *dock_device;
 };
@@ -70,7 +67,6 @@ static int dock_station_count;
 
 struct dock_dependent_device {
 	struct list_head list;
-	struct list_head hotplug_list;
 	acpi_handle handle;
 	const struct acpi_dock_ops *ops;
 	void *context;
@@ -105,7 +101,6 @@ add_dock_dependent_device(struct dock_station *ds, acpi_handle handle)
 
 	dd->handle = handle;
 	INIT_LIST_HEAD(&dd->list);
-	INIT_LIST_HEAD(&dd->hotplug_list);
 
 	spin_lock(&ds->dd_lock);
 	list_add_tail(&dd->list, &ds->dependent_devices);
@@ -115,38 +110,6 @@ add_dock_dependent_device(struct dock_station *ds, acpi_handle handle)
 }
 
 /**
- * dock_add_hotplug_device - associate a hotplug handler with the dock station
- * @ds: The dock station
- * @dd: The dependent device struct
- *
- * Add the dependent device to the dock's hotplug device list
- */
-static void
-dock_add_hotplug_device(struct dock_station *ds,
-			struct dock_dependent_device *dd)
-{
-	mutex_lock(&ds->hp_lock);
-	list_add_tail(&dd->hotplug_list, &ds->hotplug_devices);
-	mutex_unlock(&ds->hp_lock);
-}
-
-/**
- * dock_del_hotplug_device - remove a hotplug handler from the dock station
- * @ds: The dock station
- * @dd: the dependent device struct
- *
- * Delete the dependent device from the dock's hotplug device list
- */
-static void
-dock_del_hotplug_device(struct dock_station *ds,
-			struct dock_dependent_device *dd)
-{
-	mutex_lock(&ds->hp_lock);
-	list_del(&dd->hotplug_list);
-	mutex_unlock(&ds->hp_lock);
-}
-
-/**
  * find_dock_dependent_device - get a device dependent on this dock
  * @ds: the dock station
  * @handle: the acpi_handle of the device we want
@@ -349,12 +312,10 @@ static void hotplug_dock_devices(struct dock_station *ds, u32 event)
 {
 	struct dock_dependent_device *dd;
 
-	mutex_lock(&ds->hp_lock);
-
 	/*
 	 * First call driver specific hotplug functions
 	 */
-	list_for_each_entry(dd, &ds->hotplug_devices, hotplug_list)
+	list_for_each_entry(dd, &ds->dependent_devices, list)
 		if (dd->ops && dd->ops->handler)
 			dd->ops->handler(dd->handle, event, dd->context);
 
@@ -370,7 +331,6 @@ static void hotplug_dock_devices(struct dock_station *ds, u32 event)
 		else
 			dock_create_acpi_device(dd->handle);
 	}
-	mutex_unlock(&ds->hp_lock);
 }
 
 static void dock_event(struct dock_station *ds, u32 event, int num)
@@ -392,7 +352,7 @@ static void dock_event(struct dock_station *ds, u32 event, int num)
 	if (num == DOCK_EVENT)
 		kobject_uevent_env(&dev->kobj, KOBJ_CHANGE, envp);
 
-	list_for_each_entry(dd, &ds->hotplug_devices, hotplug_list)
+	list_for_each_entry(dd, &ds->dependent_devices, list)
 		if (dd->ops && dd->ops->uevent)
 			dd->ops->uevent(dd->handle, event, dd->context);
 
@@ -559,19 +519,9 @@ void unregister_dock_notifier(struct notifier_block *nb)
 }
 EXPORT_SYMBOL_GPL(unregister_dock_notifier);
 
-/**
- * register_hotplug_dock_device - register a hotplug function
- * @handle: the handle of the device
- * @ops: handlers to call after docking
- * @context: device specific data
- *
- * If a driver would like to perform a hotplug operation after a dock
- * event, they can register an acpi_notifiy_handler to be called by
- * the dock driver after _DCK is executed.
- */
-int
-register_hotplug_dock_device(acpi_handle handle, const struct acpi_dock_ops *ops,
-			     void *context)
+/* must be called with ACPI scan lock held */
+int __register_hotplug_dock_device(acpi_handle handle,
+	       const struct acpi_dock_ops *ops, void *context)
 {
 	struct dock_dependent_device *dd;
 	struct dock_station *dock_station;
@@ -594,20 +544,39 @@ register_hotplug_dock_device(acpi_handle handle, const struct acpi_dock_ops *ops
 		if (dd) {
 			dd->ops = ops;
 			dd->context = context;
-			dock_add_hotplug_device(dock_station, dd);
 			ret = 0;
 		}
 	}
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(register_hotplug_dock_device);
 
 /**
- * unregister_hotplug_dock_device - remove yourself from the hotplug list
- * @handle: the acpi handle of the device
+ * register_hotplug_dock_device - register a hotplug function
+ * @handle: the handle of the device
+ * @ops: handlers to call after docking
+ * @context: device specific data
+ *
+ * If a driver would like to perform a hotplug operation after a dock
+ * event, they can register an acpi_notifiy_handler to be called by
+ * the dock driver after _DCK is executed.
  */
-void unregister_hotplug_dock_device(acpi_handle handle)
+int
+register_hotplug_dock_device(acpi_handle handle,
+			     const struct acpi_dock_ops *ops, void *context)
+{
+	int ret;
+
+	acpi_scan_lock_acquire();
+	ret = __register_hotplug_dock_device(handle, ops, context);
+	acpi_scan_lock_release();
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(register_hotplug_dock_device);
+
+/* must be called with ACPI scan lock held */
+void __unregister_hotplug_dock_device(acpi_handle handle)
 {
 	struct dock_dependent_device *dd;
 	struct dock_station *dock_station;
@@ -617,10 +586,23 @@ void unregister_hotplug_dock_device(acpi_handle handle)
 
 	list_for_each_entry(dock_station, &dock_stations, sibling) {
 		dd = find_dock_dependent_device(dock_station, handle);
-		if (dd)
-			dock_del_hotplug_device(dock_station, dd);
+		if (dd) {
+			dd->ops = NULL;
+			dd->context = NULL;
+		}
 	}
 }
+
+/**
+ * unregister_hotplug_dock_device - remove yourself from the hotplug list
+ * @handle: the acpi handle of the device
+ */
+void unregister_hotplug_dock_device(acpi_handle handle)
+{
+	acpi_scan_lock_acquire();
+	__unregister_hotplug_dock_device(handle);
+	acpi_scan_lock_release();
+}
 EXPORT_SYMBOL_GPL(unregister_hotplug_dock_device);
 
 /**
@@ -945,10 +927,8 @@ static int __init dock_add(acpi_handle handle)
 	dock_station->dock_device = dd;
 	dock_station->last_dock_time = jiffies - HZ;
 
-	mutex_init(&dock_station->hp_lock);
 	spin_lock_init(&dock_station->dd_lock);
 	INIT_LIST_HEAD(&dock_station->sibling);
-	INIT_LIST_HEAD(&dock_station->hotplug_devices);
 	ATOMIC_INIT_NOTIFIER_HEAD(&dock_notifier_list);
 	INIT_LIST_HEAD(&dock_station->dependent_devices);
 
diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index 716aa93..699b8ca 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -61,6 +61,8 @@ static DEFINE_MUTEX(bridge_mutex);
 static void handle_hotplug_event_bridge (acpi_handle, u32, void *);
 static void acpiphp_sanitize_bus(struct pci_bus *bus);
 static void acpiphp_set_hpp_values(struct pci_bus *bus);
+static void _handle_hotplug_event_func(acpi_handle handle, u32 type,
+				       void *context);
 static void handle_hotplug_event_func(acpi_handle handle, u32 type, void *context);
 static void free_bridge(struct kref *kref);
 
@@ -147,7 +149,7 @@ static int post_dock_fixups(struct notifier_block *nb, unsigned long val,
 
 
 static const struct acpi_dock_ops acpiphp_dock_ops = {
-	.handler = handle_hotplug_event_func,
+	.handler = _handle_hotplug_event_func,
 };
 
 /* Check whether the PCI device is managed by native PCIe hotplug driver */
@@ -1065,22 +1067,13 @@ static void handle_hotplug_event_bridge(acpi_handle handle, u32 type,
 	alloc_acpi_hp_work(handle, type, context, _handle_hotplug_event_bridge);
 }
 
-static void _handle_hotplug_event_func(struct work_struct *work)
+static void _handle_hotplug_event_func(acpi_handle handle, u32 type,
+				       void *context)
 {
-	struct acpiphp_func *func;
+	struct acpiphp_func *func = context;
 	char objname[64];
 	struct acpi_buffer buffer = { .length = sizeof(objname),
 				      .pointer = objname };
-	struct acpi_hp_work *hp_work;
-	acpi_handle handle;
-	u32 type;
-
-	hp_work = container_of(work, struct acpi_hp_work, work);
-	handle = hp_work->handle;
-	type = hp_work->type;
-	func = (struct acpiphp_func *)hp_work->context;
-
-	acpi_scan_lock_acquire();
 
 	acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer);
 
@@ -1113,7 +1106,18 @@ static void _handle_hotplug_event_func(struct work_struct *work)
 		warn("notify_handler: unknown event type 0x%x for %s\n", type, objname);
 		break;
 	}
+}
+
+static void _handle_hotplug_event_cb(struct work_struct *work)
+{
+	struct acpiphp_func *func;
+	struct acpi_hp_work *hp_work;
 
+	hp_work = container_of(work, struct acpi_hp_work, work);
+	func = (struct acpiphp_func *)hp_work->context;
+	acpi_scan_lock_acquire();
+	_handle_hotplug_event_func(hp_work->handle, hp_work->type,
+				    hp_work->context);
 	acpi_scan_lock_release();
 	kfree(hp_work); /* allocated in handle_hotplug_event_func */
 	put_bridge(func->slot->bridge);
@@ -1141,7 +1145,7 @@ static void handle_hotplug_event_func(acpi_handle handle, u32 type,
 	 * don't deadlock on hotplug actions.
 	 */
 	get_bridge(func->slot->bridge);
-	alloc_acpi_hp_work(handle, type, context, _handle_hotplug_event_func);
+	alloc_acpi_hp_work(handle, type, context, _handle_hotplug_event_cb);
 }
 
 /*
-- 
1.8.1.2


--------------000700010704030103000407--
