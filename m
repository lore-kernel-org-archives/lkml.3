Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926Ab3CWTRc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Mar 2013 15:17:32 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:32511 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676Ab3CWTRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Mar 2013 15:17:30 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Bob Moore <robert.moore@intel.com>
Cc: Len Brown <len.brown@intel.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Mattia Dongili <malattia@linux.it>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Adam Belay <abelay@mit.edu>, Bjorn Helgaas <bhelgaas@google.com>,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH] ACPI: Set length even for TYPE_END_TAG acpi resource
Date: Sat, 23 Mar 2013 12:16:37 -0700
Message-Id: <1364066197-11670-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Found with pm/linux-next, network device in QEMU/KVM guest does not
work anymore.

Bisected to commit c13085e5
    ACPICA: Resource Mgr: Prevent infinite loops in resource walks

That commit will check acpi_resource length strictly.
it cause acpi_set_current_resources return failure and irq for pci device
is not set properly.

Set length for all those TYPE_END_TAG acpi_resources.

Bisected-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Mattia Dongili <malattia@linux.it>
Cc: Matthew Garrett <matthew.garrett@nebula.com>
Cc: Adam Belay <abelay@mit.edu>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: platform-driver-x86@vger.kernel.org

---
 drivers/acpi/pci_link.c            |    1 +
 drivers/platform/x86/sony-laptop.c |    3 ++-
 drivers/pnp/pnpacpi/rsparser.c     |    1 +
 3 files changed, 4 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/acpi/pci_link.c
===================================================================
--- linux-2.6.orig/drivers/acpi/pci_link.c
+++ linux-2.6/drivers/acpi/pci_link.c
@@ -354,6 +354,7 @@ static int acpi_pci_link_set(struct acpi
 
 	}
 	resource->end.type = ACPI_RESOURCE_TYPE_END_TAG;
+	resource->end.length = sizeof(struct acpi_resource);
 
 	/* Attempt to set the resource */
 	status = acpi_set_current_resources(link->device->handle, &buffer);
Index: linux-2.6/drivers/platform/x86/sony-laptop.c
===================================================================
--- linux-2.6.orig/drivers/platform/x86/sony-laptop.c
+++ linux-2.6/drivers/platform/x86/sony-laptop.c
@@ -4121,7 +4121,7 @@ static int sony_pic_enable(struct acpi_d
 		resource->res3.data.irq.sharable = ACPI_SHARED;
 
 		resource->res4.type = ACPI_RESOURCE_TYPE_END_TAG;
-
+		resource->res4.length = sizeof(struct acpi_resource);
 	}
 	/* setup Type 2/3 resources */
 	else {
@@ -4140,6 +4140,7 @@ static int sony_pic_enable(struct acpi_d
 		resource->res2.data.irq.sharable = ACPI_SHARED;
 
 		resource->res3.type = ACPI_RESOURCE_TYPE_END_TAG;
+		resource->res3.length = sizeof(struct acpi_resource);
 	}
 
 	/* Attempt to set the resource */
Index: linux-2.6/drivers/pnp/pnpacpi/rsparser.c
===================================================================
--- linux-2.6.orig/drivers/pnp/pnpacpi/rsparser.c
+++ linux-2.6/drivers/pnp/pnpacpi/rsparser.c
@@ -634,6 +634,7 @@ int pnpacpi_build_resource_template(stru
 	}
 	/* resource will pointer the end resource now */
 	resource->type = ACPI_RESOURCE_TYPE_END_TAG;
+	resource->length = sizeof(struct acpi_resource);
 
 	return 0;
 }
