Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664Ab3ARVtm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 16:49:42 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:45781 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761Ab3ARVtk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 16:49:40 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Moore, Robert" <robert.moore@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH] ACPI / scan: Drop acpi_bus_add() and use acpi_bus_scan() instead (was: Re: [PATCH] ACPI / scan: Fold acpi_bus_scan() into acpi_bus_add())
Date: Fri, 18 Jan 2013 22:55:35 +0100
Message-ID: <3264138.cPdAZaaUCO@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc4; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAE9FiQXU_KQfoND=rQDczB65jxKYxWpnnQT4pSW296sUscG8HA@mail.gmail.com>
References: <6681740.NxX6Su8EKC@vostro.rjw.lan> <CAE9FiQXU_KQfoND=rQDczB65jxKYxWpnnQT4pSW296sUscG8HA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, January 18, 2013 09:47:21 AM Yinghai Lu wrote:
> On Fri, Jan 18, 2013 at 4:35 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >
> > The only difference between acpi_bus_scan() into acpi_bus_add() is
> > the invocation of acpi_update_all_gpes() in the latter which in fact
> > is unnecessary, because acpi_update_all_gpes() has already been
> > called by acpi_scan_init() and the way it is implemented causes the
> > next invocations of it to do nothing.
> >
> > For this reason, drop the acpi_update_all_gpes() call from
> > acpi_bus_add() and fold acpi_bus_scan() into it.  Additionally,
> > rename acpi_bus_scan_fixed() to acpi_bus_add_fixed(), because
> > acpi_bus_scan() is not present any more, and rearrange the code
> > in acpi_scan_init() slightly.
> >
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > ---
> >  drivers/acpi/scan.c |   52 +++++++++++++++++++++-------------------------------
> >  1 file changed, 21 insertions(+), 31 deletions(-)
> >
> > Index: linux-pm/drivers/acpi/scan.c
> > ===================================================================
> > --- linux-pm.orig/drivers/acpi/scan.c
> > +++ linux-pm/drivers/acpi/scan.c
> > @@ -1584,24 +1584,6 @@ static acpi_status acpi_bus_device_attac
> >         return status;
> >  }
> >
> > -static int acpi_bus_scan(acpi_handle handle)
> > -{
> > -       void *device = NULL;
> > -
> > -       if (ACPI_SUCCESS(acpi_bus_check_add(handle, 0, NULL, &device)))
> > -               acpi_walk_namespace(ACPI_TYPE_ANY, handle, ACPI_UINT32_MAX,
> > -                                   acpi_bus_check_add, NULL, NULL, &device);
> > -
> > -       if (!device)
> > -               return -ENODEV;
> > -
> > -       if (ACPI_SUCCESS(acpi_bus_device_attach(handle, 0, NULL, NULL)))
> > -               acpi_walk_namespace(ACPI_TYPE_ANY, handle, ACPI_UINT32_MAX,
> > -                                   acpi_bus_device_attach, NULL, NULL, NULL);
> > -
> > -       return 0;
> > -}
> > -
> >  /**
> >   * acpi_bus_add - Add ACPI device node objects in a given namespace scope.
> >   * @handle: Root of the namespace scope to scan.
> > @@ -1616,13 +1598,19 @@ static int acpi_bus_scan(acpi_handle han
> >   */
> >  int acpi_bus_add(acpi_handle handle)
> 
> looks like scan is good name.
> 
> scan = add + attach better than
> add = add + attach?

Well, I thought "add = create + attach". :-)

Anyway, scan works for me too.

Thanks,
Rafael


---
From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Subject: ACPI / scan: Drop acpi_bus_add() and use acpi_bus_scan() instead

The only difference between acpi_bus_scan() and acpi_bus_add() is the
invocation of acpi_update_all_gpes() in the latter which in fact is
unnecessary, because acpi_update_all_gpes() has already been called
by acpi_scan_init() and the way it is implemented guarantees the next
invocations of it to do nothing.

For this reason, drop acpi_bus_add() and make all its callers use
acpi_bus_scan() directly instead of it.  Additionally, rearrange the
code in acpi_scan_init() slightly to improve the visibility of the
acpi_update_all_gpes() call in there.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/acpi_memhotplug.c     |    2 -
 drivers/acpi/container.c           |    2 -
 drivers/acpi/dock.c                |    2 -
 drivers/acpi/processor_driver.c    |    2 -
 drivers/acpi/scan.c                |   54 +++++++++++++++----------------------
 drivers/pci/hotplug/acpiphp_glue.c |    4 +-
 drivers/pci/hotplug/sgi_hotplug.c  |    4 +-
 include/acpi/acpi_bus.h            |    2 -
 8 files changed, 31 insertions(+), 41 deletions(-)

Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -1584,26 +1584,8 @@ static acpi_status acpi_bus_device_attac
 	return status;
 }
 
-static int acpi_bus_scan(acpi_handle handle)
-{
-	void *device = NULL;
-
-	if (ACPI_SUCCESS(acpi_bus_check_add(handle, 0, NULL, &device)))
-		acpi_walk_namespace(ACPI_TYPE_ANY, handle, ACPI_UINT32_MAX,
-				    acpi_bus_check_add, NULL, NULL, &device);
-
-	if (!device)
-		return -ENODEV;
-
-	if (ACPI_SUCCESS(acpi_bus_device_attach(handle, 0, NULL, NULL)))
-		acpi_walk_namespace(ACPI_TYPE_ANY, handle, ACPI_UINT32_MAX,
-				    acpi_bus_device_attach, NULL, NULL, NULL);
-
-	return 0;
-}
-
 /**
- * acpi_bus_add - Add ACPI device node objects in a given namespace scope.
+ * acpi_bus_scan - Add ACPI device node objects in a given namespace scope.
  * @handle: Root of the namespace scope to scan.
  *
  * Scan a given ACPI tree (probably recently hot-plugged) and create and add
@@ -1614,18 +1596,24 @@ static int acpi_bus_scan(acpi_handle han
  * in the table trunk from which the kernel could create a device and add an
  * appropriate driver.
  */
-int acpi_bus_add(acpi_handle handle)
+int acpi_bus_scan(acpi_handle handle)
 {
-	int err;
+	void *device = NULL;
+
+	if (ACPI_SUCCESS(acpi_bus_check_add(handle, 0, NULL, &device)))
+		acpi_walk_namespace(ACPI_TYPE_ANY, handle, ACPI_UINT32_MAX,
+				    acpi_bus_check_add, NULL, NULL, &device);
+
+	if (!device)
+		return -ENODEV;
 
-	err = acpi_bus_scan(handle);
-	if (err)
-		return err;
+	if (ACPI_SUCCESS(acpi_bus_device_attach(handle, 0, NULL, NULL)))
+		acpi_walk_namespace(ACPI_TYPE_ANY, handle, ACPI_UINT32_MAX,
+				    acpi_bus_device_attach, NULL, NULL, NULL);
 
-	acpi_update_all_gpes();
 	return 0;
 }
-EXPORT_SYMBOL(acpi_bus_add);
+EXPORT_SYMBOL(acpi_bus_scan);
 
 static acpi_status acpi_bus_device_detach(acpi_handle handle, u32 lvl_not_used,
 					  void *not_used, void **ret_not_used)
@@ -1714,13 +1702,15 @@ int __init acpi_scan_init(void)
 		return result;
 
 	result = acpi_bus_get_device(ACPI_ROOT_OBJECT, &acpi_root);
-	if (!result)
-		result = acpi_bus_scan_fixed();
-
 	if (result)
+		return result;
+
+	result = acpi_bus_scan_fixed();
+	if (result) {
 		acpi_device_unregister(acpi_root);
-	else
-		acpi_update_all_gpes();
+		return result;
+	}
 
-	return result;
+	acpi_update_all_gpes();
+	return 0;
 }
Index: linux-pm/drivers/acpi/acpi_memhotplug.c
===================================================================
--- linux-pm.orig/drivers/acpi/acpi_memhotplug.c
+++ linux-pm/drivers/acpi/acpi_memhotplug.c
@@ -167,7 +167,7 @@ acpi_memory_get_device(acpi_handle handl
 	 * Now add the notified device.  This creates the acpi_device
 	 * and invokes .add function
 	 */
-	result = acpi_bus_add(handle);
+	result = acpi_bus_scan(handle);
 	if (result) {
 		acpi_handle_warn(handle, "Cannot add acpi bus\n");
 		return -EINVAL;
Index: linux-pm/drivers/acpi/container.c
===================================================================
--- linux-pm.orig/drivers/acpi/container.c
+++ linux-pm/drivers/acpi/container.c
@@ -166,7 +166,7 @@ static void container_notify_cb(acpi_han
 		if (!ACPI_FAILURE(status) || device)
 			break;
 
-		result = acpi_bus_add(handle);
+		result = acpi_bus_scan(handle);
 		if (result) {
 			acpi_handle_warn(handle, "Failed to add container\n");
 			break;
Index: linux-pm/drivers/acpi/dock.c
===================================================================
--- linux-pm.orig/drivers/acpi/dock.c
+++ linux-pm/drivers/acpi/dock.c
@@ -317,7 +317,7 @@ static struct acpi_device * dock_create_
 		 * no device created for this object,
 		 * so we should create one.
 		 */
-		ret = acpi_bus_add(handle);
+		ret = acpi_bus_scan(handle);
 		if (ret)
 			pr_debug("error adding bus, %x\n", -ret);
 
Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -746,7 +746,7 @@ static int acpiphp_bus_add(struct acpiph
 		dbg("acpi_bus_trim return %x\n", ret_val);
 	}
 
-	ret_val = acpi_bus_add(func->handle);
+	ret_val = acpi_bus_scan(func->handle);
 	if (!ret_val)
 		ret_val = acpi_bus_get_device(func->handle, &device);
 
@@ -1129,7 +1129,7 @@ static void handle_bridge_insertion(acpi
 		return;
 	}
 
-	if (acpi_bus_add(handle)) {
+	if (acpi_bus_scan(handle)) {
 		err("cannot add bridge to acpi list\n");
 		return;
 	}
Index: linux-pm/include/acpi/acpi_bus.h
===================================================================
--- linux-pm.orig/include/acpi/acpi_bus.h
+++ linux-pm/include/acpi/acpi_bus.h
@@ -385,7 +385,7 @@ static inline int acpi_bus_generate_proc
 #endif
 int acpi_bus_register_driver(struct acpi_driver *driver);
 void acpi_bus_unregister_driver(struct acpi_driver *driver);
-int acpi_bus_add(acpi_handle handle);
+int acpi_bus_scan(acpi_handle handle);
 void acpi_bus_hot_remove_device(void *context);
 int acpi_bus_trim(struct acpi_device *start);
 acpi_status acpi_bus_get_ejd(acpi_handle handle, acpi_handle * ejd);
Index: linux-pm/drivers/acpi/processor_driver.c
===================================================================
--- linux-pm.orig/drivers/acpi/processor_driver.c
+++ linux-pm/drivers/acpi/processor_driver.c
@@ -699,7 +699,7 @@ static void acpi_processor_hotplug_notif
 		if (!acpi_bus_get_device(handle, &device))
 			break;
 
-		result = acpi_bus_add(handle);
+		result = acpi_bus_scan(handle);
 		if (result) {
 			acpi_handle_err(handle, "Unable to add the device\n");
 			break;
Index: linux-pm/drivers/pci/hotplug/sgi_hotplug.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/sgi_hotplug.c
+++ linux-pm/drivers/pci/hotplug/sgi_hotplug.c
@@ -447,9 +447,9 @@ static int enable_slot(struct hotplug_sl
 			if (ACPI_SUCCESS(ret) &&
 			    (adr>>16) == (slot->device_num + 1)) {
 
-				ret = acpi_bus_add(chandle);
+				ret = acpi_bus_scan(chandle);
 				if (ACPI_FAILURE(ret)) {
-					printk(KERN_ERR "%s: acpi_bus_add "
+					printk(KERN_ERR "%s: acpi_bus_scan "
 					       "failed (0x%x) for slot %d "
 					       "func %d\n", __func__,
 					       ret, (int)(adr>>16),

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
