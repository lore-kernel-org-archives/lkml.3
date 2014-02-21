Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932169AbaBUAFF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 19:05:05 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:57794 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756153AbaBUAE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 19:04:59 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Lv Zheng <lv.zheng@intel.com>, Len Brown <lenb@kernel.org>,
        Robert Moore <robert.moore@intel.com>, Tony Luck <tony.luck@intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@acpica.org
Subject: [PATCH] ACPI: Drop acpi_evaluate_hotplug_ost() and ACPI_HOTPLUG_OST
Date: Fri, 21 Feb 2014 01:19:52 +0100
Message-ID: <60567343.brKB2SuRkR@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1392789739-32317-1-git-send-email-jiang.liu@linux.intel.com>
References: <1392789739-32317-1-git-send-email-jiang.liu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, February 19, 2014 02:02:15 PM Jiang Liu wrote:
> Rename acpi_evaluate_hotplug_ost() to acpi_evaluate_ost() for later resue.
> 
> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>

Below is a patch replacing acpi_evaluate_hotplug_ost() with acpi_evaluate_ost()
and dropping the ACPI_HOTPLUG_OST which I don't believe is necessary at all.

On top of the current linux-next and your series.

Thanks,
Rafael

---
From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Subject: ACPI: Drop acpi_evaluate_hotplug_ost() and ACPI_HOTPLUG_OST

Replace acpi_evaluate_hotplug_ost() with acpi_evaluate_ost()
everywhere and drop the ACPI_HOTPLUG_OST symbol so that hotplug
_OST is supported unconditionally.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/bus.c                |    4 +---
 drivers/acpi/scan.c               |   10 +++++-----
 drivers/acpi/utils.c              |    2 +-
 drivers/xen/xen-acpi-cpuhotplug.c |    2 +-
 drivers/xen/xen-acpi-memhotplug.c |    2 +-
 include/acpi/acpi_bus.h           |    8 --------
 6 files changed, 9 insertions(+), 19 deletions(-)

Index: linux-pm/drivers/acpi/bus.c
===================================================================
--- linux-pm.orig/drivers/acpi/bus.c
+++ linux-pm/drivers/acpi/bus.c
@@ -311,9 +311,7 @@ static void acpi_bus_osc_support(void)
 	capbuf[OSC_SUPPORT_DWORD] |= OSC_SB_PPC_OST_SUPPORT;
 #endif
 
-#ifdef ACPI_HOTPLUG_OST
 	capbuf[OSC_SUPPORT_DWORD] |= OSC_SB_HOTPLUG_OST_SUPPORT;
-#endif
 
 	if (!ghes_disable)
 		capbuf[OSC_SUPPORT_DWORD] |= OSC_SB_APEI_SUPPORT;
@@ -410,7 +408,7 @@ static void acpi_bus_notify(acpi_handle
 	return;
 
  err:
-	acpi_evaluate_hotplug_ost(handle, type, ost_code, NULL);
+	acpi_evaluate_ost(handle, type, ost_code, NULL);
 }
 
 /* --------------------------------------------------------------------------
Index: linux-pm/include/acpi/acpi_bus.h
===================================================================
--- linux-pm.orig/include/acpi/acpi_bus.h
+++ linux-pm/include/acpi/acpi_bus.h
@@ -51,14 +51,6 @@ acpi_evaluate_reference(acpi_handle hand
 acpi_status
 acpi_evaluate_ost(acpi_handle handle, u32 source_event, u32 status_code,
 		  struct acpi_buffer *status_buf);
-#ifdef ACPI_HOTPLUG_OST
-#define	acpi_evaluate_hotplug_ost	acpi_evaluate_ost
-#else
-static inline acpi_status
-acpi_evaluate_hotplug_ost(acpi_handle handle, u32 source_event,
-			u32 status_code, struct acpi_buffer *status_buf)
-{ return AE_OK; }
-#endif
 
 acpi_status
 acpi_get_physical_device_location(acpi_handle handle, struct acpi_pld_info **pld);
Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -463,8 +463,8 @@ static int acpi_generic_hotplug_event(st
 			dev_info(&adev->dev, "Eject disabled\n");
 			return -EPERM;
 		}
-		acpi_evaluate_hotplug_ost(adev->handle, ACPI_NOTIFY_EJECT_REQUEST,
-					  ACPI_OST_SC_EJECT_IN_PROGRESS, NULL);
+		acpi_evaluate_ost(adev->handle, ACPI_NOTIFY_EJECT_REQUEST,
+				  ACPI_OST_SC_EJECT_IN_PROGRESS, NULL);
 		return acpi_scan_hot_remove(adev);
 	}
 	return -EINVAL;
@@ -514,7 +514,7 @@ void acpi_device_hotplug(void *data, u32
 		ost_code = ACPI_OST_SC_SUCCESS;
 
  err_out:
-	acpi_evaluate_hotplug_ost(adev->handle, src, ost_code, NULL);
+	acpi_evaluate_ost(adev->handle, src, ost_code, NULL);
 
  out:
 	acpi_bus_put_acpi_device(adev);
@@ -574,8 +574,8 @@ acpi_eject_store(struct device *d, struc
 		return count;
 
 	put_device(&acpi_device->dev);
-	acpi_evaluate_hotplug_ost(acpi_device->handle, ACPI_OST_EC_OSPM_EJECT,
-				  ACPI_OST_SC_NON_SPECIFIC_FAILURE, NULL);
+	acpi_evaluate_ost(acpi_device->handle, ACPI_OST_EC_OSPM_EJECT,
+			  ACPI_OST_SC_NON_SPECIFIC_FAILURE, NULL);
 	return status == AE_NO_MEMORY ? -ENOMEM : -EAGAIN;
 }
 
Index: linux-pm/drivers/acpi/utils.c
===================================================================
--- linux-pm.orig/drivers/acpi/utils.c
+++ linux-pm/drivers/acpi/utils.c
@@ -422,7 +422,7 @@ out:
 EXPORT_SYMBOL(acpi_get_physical_device_location);
 
 /**
- * acpi_evaluate_hotplug_ost: Evaluate _OST for hotplug operations
+ * acpi_evaluate_ost: Evaluate _OST for hotplug operations
  * @handle: ACPI device handle
  * @source_event: source event code
  * @status_code: status code
Index: linux-pm/drivers/xen/xen-acpi-cpuhotplug.c
===================================================================
--- linux-pm.orig/drivers/xen/xen-acpi-cpuhotplug.c
+++ linux-pm/drivers/xen/xen-acpi-cpuhotplug.c
@@ -313,7 +313,7 @@ static void acpi_processor_hotplug_notif
 		goto out;
 	}
 
-	(void) acpi_evaluate_hotplug_ost(handle, event, ost_code, NULL);
+	(void) acpi_evaluate_ost(handle, event, ost_code, NULL);
 
 out:
 	acpi_scan_lock_release();
Index: linux-pm/drivers/xen/xen-acpi-memhotplug.c
===================================================================
--- linux-pm.orig/drivers/xen/xen-acpi-memhotplug.c
+++ linux-pm/drivers/xen/xen-acpi-memhotplug.c
@@ -285,7 +285,7 @@ static void acpi_memory_device_notify(ac
 		return;
 	}
 
-	(void) acpi_evaluate_hotplug_ost(handle, event, ost_code, NULL);
+	(void) acpi_evaluate_ost(handle, event, ost_code, NULL);
 	return;
 }
 

