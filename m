Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857Ab3K2A0z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 19:26:55 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:61339 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752318Ab3K2A0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 19:26:46 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Linux PCI <linux-pci@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Aaron Lu <aaron.lu@intel.com>, Toshi Kani <toshi.kani@hp.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-ide@vger.kernel.org,
        linux-usb@vger.kernel.org, Lan Tianyu <tianyu.lan@intel.com>
Subject: [PATCH 2/3] ACPI / bind: Pass struct acpi_device pointer to acpi_bind_one()
Date: Fri, 29 Nov 2013 01:38:15 +0100
Message-ID: <10690501.mTAEnhY36F@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <4501334.ovACrGogrl@vostro.rjw.lan>
References: <4501334.ovACrGogrl@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

There is no reason to pass an ACPI handle to acpi_bind_one() instead
of a struct acpi_device pointer to the target device object, so
modify that function to take a struct acpi_device pointer as its
second argument and update all code depending on it accordingly.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/acpi_memhotplug.c |   15 +++++++--------
 drivers/acpi/acpi_processor.c  |    2 +-
 drivers/acpi/glue.c            |    9 +++------
 drivers/acpi/internal.h        |    2 +-
 4 files changed, 12 insertions(+), 16 deletions(-)

Index: linux-pm/drivers/acpi/glue.c
===================================================================
--- linux-pm.orig/drivers/acpi/glue.c
+++ linux-pm/drivers/acpi/glue.c
@@ -172,9 +172,8 @@ static void acpi_physnode_link_name(char
 		strcpy(buf, PHYSICAL_NODE_STRING);
 }
 
-int acpi_bind_one(struct device *dev, acpi_handle handle)
+int acpi_bind_one(struct device *dev, struct acpi_device *acpi_dev)
 {
-	struct acpi_device *acpi_dev = NULL;
 	struct acpi_device_physical_node *physical_node, *pn;
 	char physical_node_name[PHYSICAL_NODE_NAME_SIZE];
 	struct list_head *physnode_list;
@@ -182,14 +181,12 @@ int acpi_bind_one(struct device *dev, ac
 	int retval = -EINVAL;
 
 	if (ACPI_COMPANION(dev)) {
-		if (handle) {
+		if (acpi_dev) {
 			dev_warn(dev, "ACPI companion already set\n");
 			return -EINVAL;
 		} else {
 			acpi_dev = ACPI_COMPANION(dev);
 		}
-	} else {
-		acpi_bus_get_device(handle, &acpi_dev);
 	}
 	if (!acpi_dev)
 		return -EINVAL;
@@ -314,7 +311,7 @@ static int acpi_platform_notify(struct d
 			ret = -ENODEV;
 			goto out;
 		}
-		ret = acpi_bind_one(dev, adev->handle);
+		ret = acpi_bind_one(dev, adev);
 		if (ret)
 			goto out;
 	}
Index: linux-pm/drivers/acpi/internal.h
===================================================================
--- linux-pm.orig/drivers/acpi/internal.h
+++ linux-pm/drivers/acpi/internal.h
@@ -86,7 +86,7 @@ void acpi_init_device_object(struct acpi
 			     int type, unsigned long long sta);
 void acpi_device_add_finalize(struct acpi_device *device);
 void acpi_free_pnp_ids(struct acpi_device_pnp *pnp);
-int acpi_bind_one(struct device *dev, acpi_handle handle);
+int acpi_bind_one(struct device *dev, struct acpi_device *adev);
 int acpi_unbind_one(struct device *dev);
 bool acpi_device_is_present(struct acpi_device *adev);
 
Index: linux-pm/drivers/acpi/acpi_processor.c
===================================================================
--- linux-pm.orig/drivers/acpi/acpi_processor.c
+++ linux-pm/drivers/acpi/acpi_processor.c
@@ -395,7 +395,7 @@ static int acpi_processor_add(struct acp
 		goto err;
 	}
 
-	result = acpi_bind_one(dev, pr->handle);
+	result = acpi_bind_one(dev, device);
 	if (result)
 		goto err;
 
Index: linux-pm/drivers/acpi/acpi_memhotplug.c
===================================================================
--- linux-pm.orig/drivers/acpi/acpi_memhotplug.c
+++ linux-pm/drivers/acpi/acpi_memhotplug.c
@@ -180,14 +180,14 @@ static unsigned long acpi_meminfo_end_pf
 
 static int acpi_bind_memblk(struct memory_block *mem, void *arg)
 {
-	return acpi_bind_one(&mem->dev, (acpi_handle)arg);
+	return acpi_bind_one(&mem->dev, arg);
 }
 
 static int acpi_bind_memory_blocks(struct acpi_memory_info *info,
-				   acpi_handle handle)
+				   struct acpi_device *adev)
 {
 	return walk_memory_range(acpi_meminfo_start_pfn(info),
-				 acpi_meminfo_end_pfn(info), (void *)handle,
+				 acpi_meminfo_end_pfn(info), adev,
 				 acpi_bind_memblk);
 }
 
@@ -197,8 +197,7 @@ static int acpi_unbind_memblk(struct mem
 	return 0;
 }
 
-static void acpi_unbind_memory_blocks(struct acpi_memory_info *info,
-				      acpi_handle handle)
+static void acpi_unbind_memory_blocks(struct acpi_memory_info *info)
 {
 	walk_memory_range(acpi_meminfo_start_pfn(info),
 			  acpi_meminfo_end_pfn(info), NULL, acpi_unbind_memblk);
@@ -242,9 +241,9 @@ static int acpi_memory_enable_device(str
 		if (result && result != -EEXIST)
 			continue;
 
-		result = acpi_bind_memory_blocks(info, handle);
+		result = acpi_bind_memory_blocks(info, mem_device->device);
 		if (result) {
-			acpi_unbind_memory_blocks(info, handle);
+			acpi_unbind_memory_blocks(info);
 			return -ENODEV;
 		}
 
@@ -285,7 +284,7 @@ static void acpi_memory_remove_memory(st
 		if (nid == NUMA_NO_NODE)
 			nid = memory_add_physaddr_to_nid(info->start_addr);
 
-		acpi_unbind_memory_blocks(info, handle);
+		acpi_unbind_memory_blocks(info);
 		remove_memory(nid, info->start_addr, info->length);
 		list_del(&info->list);
 		kfree(info);

