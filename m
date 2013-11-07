Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777Ab3KGACk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 19:02:40 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:50645 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752505Ab3KGACi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 19:02:38 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Toshi Kani <toshi.kani@hp.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>
Subject: Re: [Update][PATCH 4/6] ACPI / hotplug: Simplify device ejection routines
Date: Thu, 07 Nov 2013 01:14:57 +0100
Message-ID: <1642586.5aH3MlB2GZ@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1383780421.1847.50.camel@misato.fc.hp.com>
References: <5839747.7HXXGHmMBd@vostro.rjw.lan> <1602442.26cFiMyQkW@vostro.rjw.lan> <1383780421.1847.50.camel@misato.fc.hp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 06, 2013 04:27:01 PM Toshi Kani wrote:
> On Mon, 2013-11-04 at 14:36 +0100, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > 
> > Simplify handle_root_bridge_removal() and acpi_eject_store() by
> > getting rid of struct acpi_eject_event and passing device objects
> > directly to async routines executed via acpi_os_hotplug_execute().
>  :
> >  static ssize_t
> >  acpi_eject_store(struct device *d, struct device_attribute *attr,
> >  		const char *buf, size_t count)
> >  {
> >  	struct acpi_device *acpi_device = to_acpi_device(d);
> > -	struct acpi_eject_event *ej_event;
> >  	acpi_object_type not_used;
> >  	acpi_status status;
> > -	int ret;
> >  
> >  	if (!count || buf[0] != '1')
> >  		return -EINVAL;
> > @@ -518,28 +519,17 @@ acpi_eject_store(struct device *d, struc
> >  	if (ACPI_FAILURE(status) || !acpi_device->flags.ejectable)
> >  		return -ENODEV;
> >  
> > -	ej_event = kmalloc(sizeof(*ej_event), GFP_KERNEL);
> > -	if (!ej_event) {
> > -		ret = -ENOMEM;
> > -		goto err_out;
> > -	}
> >  	acpi_evaluate_hotplug_ost(acpi_device->handle, ACPI_OST_EC_OSPM_EJECT,
> >  				  ACPI_OST_SC_EJECT_IN_PROGRESS, NULL);
> > -	ej_event->device = acpi_device;
> > -	ej_event->event = ACPI_OST_EC_OSPM_EJECT;
> >  	get_device(&acpi_device->dev);
> > -	status = acpi_os_hotplug_execute(acpi_bus_hot_remove_device, ej_event);
> > +	status = acpi_os_hotplug_execute(acpi_eject_store_work, acpi_device);
> >  	if (ACPI_SUCCESS(status))
> >  		return count;
> >  
> >  	put_device(&acpi_device->dev);
> > -	kfree(ej_event);
> > -	ret = status == AE_NO_MEMORY ? -ENOMEM : -EAGAIN;
> 
> Why are you deleting the above line as part of this change?

Ah, because I forgot that acpi_os_hotplug_execute() can also return AE_NO_MEMORY. :-)

Good catch, updated pach follows.

Thanks,
Rafael

---
From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Subject: ACPI / hotplug: Simplify device ejection routines

Simplify handle_root_bridge_removal() and acpi_eject_store() by
getting rid of struct acpi_eject_event and passing device objects
directly to async routines executed via acpi_os_hotplug_execute().

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/pci_root.c |   20 ++------------------
 drivers/acpi/scan.c     |   46 ++++++++++++++++++----------------------------
 include/acpi/acpi_bus.h |    5 -----
 3 files changed, 20 insertions(+), 51 deletions(-)

Index: linux-pm/drivers/acpi/pci_root.c
===================================================================
--- linux-pm.orig/drivers/acpi/pci_root.c
+++ linux-pm/drivers/acpi/pci_root.c
@@ -593,27 +593,11 @@ static void handle_root_bridge_insertion
 static void handle_root_bridge_removal(struct acpi_device *device)
 {
 	acpi_status status;
-	struct acpi_eject_event *ej_event;
-
-	ej_event = kmalloc(sizeof(*ej_event), GFP_KERNEL);
-	if (!ej_event) {
-		/* Inform firmware the hot-remove operation has error */
-		(void) acpi_evaluate_hotplug_ost(device->handle,
-					ACPI_NOTIFY_EJECT_REQUEST,
-					ACPI_OST_SC_NON_SPECIFIC_FAILURE,
-					NULL);
-		return;
-	}
-
-	ej_event->device = device;
-	ej_event->event = ACPI_NOTIFY_EJECT_REQUEST;
 
 	get_device(&device->dev);
-	status = acpi_os_hotplug_execute(acpi_bus_hot_remove_device, ej_event);
-	if (ACPI_FAILURE(status)) {
+	status = acpi_os_hotplug_execute(acpi_bus_hot_remove_device, device);
+	if (ACPI_FAILURE(status))
 		put_device(&device->dev);
-		kfree(ej_event);
-	}
 }
 
 static void _handle_hotplug_event_root(struct work_struct *work)
Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -441,18 +441,8 @@ static void acpi_hotplug_notify_cb(acpi_
 					  NULL);
 }
 
-/**
- * acpi_bus_hot_remove_device: hot-remove a device and its children
- * @context: struct acpi_eject_event pointer (freed in this func)
- *
- * Hot-remove a device and its children. This function frees up the
- * memory space passed by arg context, so that the caller may call
- * this function asynchronously through acpi_os_hotplug_execute().
- */
-void acpi_bus_hot_remove_device(void *context)
+void __acpi_bus_hot_remove_device(struct acpi_device *device, u32 ost_src)
 {
-	struct acpi_eject_event *ej_event = context;
-	struct acpi_device *device = ej_event->device;
 	acpi_handle handle = device->handle;
 	int error;
 
@@ -461,13 +451,21 @@ void acpi_bus_hot_remove_device(void *co
 
 	error = acpi_scan_hot_remove(device);
 	if (error && handle)
-		acpi_evaluate_hotplug_ost(handle, ej_event->event,
+		acpi_evaluate_hotplug_ost(handle, ost_src,
 					  ACPI_OST_SC_NON_SPECIFIC_FAILURE,
 					  NULL);
 
 	mutex_unlock(&acpi_scan_lock);
 	unlock_device_hotplug();
-	kfree(context);
+}
+
+/**
+ * acpi_bus_hot_remove_device: Hot-remove a device and its children.
+ * @context: Address of the ACPI device object to hot-remove.
+ */
+void acpi_bus_hot_remove_device(void *context)
+{
+	__acpi_bus_hot_remove_device(context, ACPI_NOTIFY_EJECT_REQUEST);
 }
 EXPORT_SYMBOL(acpi_bus_hot_remove_device);
 
@@ -497,15 +495,18 @@ static ssize_t power_state_show(struct d
 
 static DEVICE_ATTR(power_state, 0444, power_state_show, NULL);
 
+static void acpi_eject_store_work(void *context)
+{
+	__acpi_bus_hot_remove_device(context, ACPI_OST_EC_OSPM_EJECT);
+}
+
 static ssize_t
 acpi_eject_store(struct device *d, struct device_attribute *attr,
 		const char *buf, size_t count)
 {
 	struct acpi_device *acpi_device = to_acpi_device(d);
-	struct acpi_eject_event *ej_event;
 	acpi_object_type not_used;
 	acpi_status status;
-	int ret;
 
 	if (!count || buf[0] != '1')
 		return -EINVAL;
@@ -518,28 +519,17 @@ acpi_eject_store(struct device *d, struc
 	if (ACPI_FAILURE(status) || !acpi_device->flags.ejectable)
 		return -ENODEV;
 
-	ej_event = kmalloc(sizeof(*ej_event), GFP_KERNEL);
-	if (!ej_event) {
-		ret = -ENOMEM;
-		goto err_out;
-	}
 	acpi_evaluate_hotplug_ost(acpi_device->handle, ACPI_OST_EC_OSPM_EJECT,
 				  ACPI_OST_SC_EJECT_IN_PROGRESS, NULL);
-	ej_event->device = acpi_device;
-	ej_event->event = ACPI_OST_EC_OSPM_EJECT;
 	get_device(&acpi_device->dev);
-	status = acpi_os_hotplug_execute(acpi_bus_hot_remove_device, ej_event);
+	status = acpi_os_hotplug_execute(acpi_eject_store_work, acpi_device);
 	if (ACPI_SUCCESS(status))
 		return count;
 
 	put_device(&acpi_device->dev);
-	kfree(ej_event);
-	ret = status == AE_NO_MEMORY ? -ENOMEM : -EAGAIN;
-
- err_out:
 	acpi_evaluate_hotplug_ost(acpi_device->handle, ACPI_OST_EC_OSPM_EJECT,
 				  ACPI_OST_SC_NON_SPECIFIC_FAILURE, NULL);
-	return ret;
+	return status == AE_NO_MEMORY ? -ENOMEM : -EAGAIN;
 }
 
 static DEVICE_ATTR(eject, 0200, NULL, acpi_eject_store);
Index: linux-pm/include/acpi/acpi_bus.h
===================================================================
--- linux-pm.orig/include/acpi/acpi_bus.h
+++ linux-pm/include/acpi/acpi_bus.h
@@ -339,11 +339,6 @@ struct acpi_bus_event {
 	u32 data;
 };
 
-struct acpi_eject_event {
-	struct acpi_device	*device;
-	u32		event;
-};
-
 struct acpi_hp_work {
 	struct work_struct work;
 	acpi_handle handle;

