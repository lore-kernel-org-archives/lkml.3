Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368AbaBBRHT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 12:07:19 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:55039 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752067AbaBBRGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 12:06:25 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Aaron Lu <aaron.lu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Robert Moore <robert.moore@intel.com>
Subject: [PATCH v3 1/7] ACPICA: Introduce acpi_get_data_full() and rework acpi_get_data()
Date: Sun, 02 Feb 2014 18:12:49 +0100
Message-ID: <7484343.nY7Wcb50gC@vostro.rjw.lan>
User-Agent: KMail/4.11.4 (Linux/3.13.0+; KDE/4.11.4; x86_64; ; )
In-Reply-To: <5157096.hCmU2aoKCT@vostro.rjw.lan>
References: <2217793.001RY6hKlo@vostro.rjw.lan> <1519631.YS65c9Af2C@vostro.rjw.lan> <5157096.hCmU2aoKCT@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Introduce a new function, acpi_get_data_full(), working in analogy
with acpi_get_data() except that it can execute a callback provided
as its 4th argument right after acpi_ns_get_attached_data() has
returned a success.

That will allow Linux to reference count the object pointed to by
*data before the namespace mutex is released so as to ensure that it
will not be freed going forward until the reference to it acquired
by acpi_get_data_full() is dropped.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/acpica/nsxfeval.c |   33 ++++++++++++++++++++++++++++++---
 include/acpi/acpixf.h          |    4 ++++
 2 files changed, 34 insertions(+), 3 deletions(-)

Index: linux-pm/drivers/acpi/acpica/nsxfeval.c
===================================================================
--- linux-pm.orig/drivers/acpi/acpica/nsxfeval.c
+++ linux-pm/drivers/acpi/acpica/nsxfeval.c
@@ -923,19 +923,22 @@ ACPI_EXPORT_SYMBOL(acpi_detach_data)
 
 /*******************************************************************************
  *
- * FUNCTION:    acpi_get_data
+ * FUNCTION:    acpi_get_data_full
  *
  * PARAMETERS:  obj_handle          - Namespace node
  *              handler             - Handler used in call to attach_data
  *              data                - Where the data is returned
+ *              callback            - function to execute before returning
  *
  * RETURN:      Status
  *
- * DESCRIPTION: Retrieve data that was previously attached to a namespace node.
+ * DESCRIPTION: Retrieve data that was previously attached to a namespace node
+ *              and execute a callback before returning.
  *
  ******************************************************************************/
 acpi_status
-acpi_get_data(acpi_handle obj_handle, acpi_object_handler handler, void **data)
+acpi_get_data_full(acpi_handle obj_handle, acpi_object_handler handler,
+		   void **data, void (*callback)(void *))
 {
 	struct acpi_namespace_node *node;
 	acpi_status status;
@@ -960,10 +963,34 @@ acpi_get_data(acpi_handle obj_handle, ac
 	}
 
 	status = acpi_ns_get_attached_data(node, handler, data);
+	if (ACPI_SUCCESS(status) && callback) {
+		callback(*data);
+	}
 
 unlock_and_exit:
 	(void)acpi_ut_release_mutex(ACPI_MTX_NAMESPACE);
 	return (status);
 }
 
+ACPI_EXPORT_SYMBOL(acpi_get_data_full)
+
+/*******************************************************************************
+ *
+ * FUNCTION:    acpi_get_data
+ *
+ * PARAMETERS:  obj_handle          - Namespace node
+ *              handler             - Handler used in call to attach_data
+ *              data                - Where the data is returned
+ *
+ * RETURN:      Status
+ *
+ * DESCRIPTION: Retrieve data that was previously attached to a namespace node.
+ *
+ ******************************************************************************/
+acpi_status
+acpi_get_data(acpi_handle obj_handle, acpi_object_handler handler, void **data)
+{
+	return acpi_get_data_full(obj_handle, handler, data, NULL);
+}
+
 ACPI_EXPORT_SYMBOL(acpi_get_data)
Index: linux-pm/include/acpi/acpixf.h
===================================================================
--- linux-pm.orig/include/acpi/acpixf.h
+++ linux-pm/include/acpi/acpixf.h
@@ -230,6 +230,10 @@ acpi_attach_data(acpi_handle object, acp
 acpi_status acpi_detach_data(acpi_handle object, acpi_object_handler handler);
 
 acpi_status
+acpi_get_data_full(acpi_handle object, acpi_object_handler handler, void **data,
+		   void (*callback)(void *));
+
+acpi_status
 acpi_get_data(acpi_handle object, acpi_object_handler handler, void **data);
 
 acpi_status

