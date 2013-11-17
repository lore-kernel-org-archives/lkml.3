Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554Ab3KQQ06 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 11:26:58 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:58607 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752352Ab3KQQZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 11:25:53 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        "Moore, Robert" <robert.moore@intel.com>,
        Toshi Kani <toshi.kani@hp.com>, Yinghai Lu <yinghai@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>, Lv Zheng <lv.zheng@intel.com>
Subject: [PATCH 1/10] ACPICA: Delete all attached data objects on node deletion
Date: Sun, 17 Nov 2013 17:31:07 +0100
Message-ID: <6412948.nIyY9Gd76l@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1421028.Rsfpmhnym3@vostro.rjw.lan>
References: <1421028.Rsfpmhnym3@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Since many data objects may be attached to a single namespace node,
acpi_ns_delete_node() should take that into account and delete all
of those objects along with the namespace node itself, calling
deletion handlers for all of them in the process.  Make that happen.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/acpica/nsalloc.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

Index: linux-pm/drivers/acpi/acpica/nsalloc.c
===================================================================
--- linux-pm.orig/drivers/acpi/acpica/nsalloc.c
+++ linux-pm/drivers/acpi/acpica/nsalloc.c
@@ -106,6 +106,7 @@ struct acpi_namespace_node *acpi_ns_crea
 void acpi_ns_delete_node(struct acpi_namespace_node *node)
 {
 	union acpi_operand_object *obj_desc;
+	union acpi_operand_object *next_obj_desc;
 
 	ACPI_FUNCTION_NAME(ns_delete_node);
 
@@ -119,7 +120,8 @@ void acpi_ns_delete_node(struct acpi_nam
 	 * detached above, the only possible remaining object is a data object.
 	 */
 	obj_desc = node->object;
-	if (obj_desc && (obj_desc->common.type == ACPI_TYPE_LOCAL_DATA)) {
+	while (obj_desc && obj_desc->common.type == ACPI_TYPE_LOCAL_DATA) {
+		next_obj_desc = obj_desc->common.next_object;
 
 		/* Invoke the attached data deletion handler if present */
 
@@ -128,6 +130,8 @@ void acpi_ns_delete_node(struct acpi_nam
 		}
 
 		acpi_ut_remove_reference(obj_desc);
+
+		obj_desc = next_obj_desc;
 	}
 
 	/* Now we can delete the node */

