Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499Ab3FYQTa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 12:19:30 -0400
Received: from mga11.intel.com ([192.55.52.93]:16532 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752455Ab3FYQT2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 12:19:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,938,1363158000"; 
   d="scan'208";a="355551849"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Yinghai Lu <yinghai@kernel.org>,
        john.ronciak@intel.com, miles.j.penner@intel.com,
        bruce.w.allan@intel.com,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        x86@kernel.org
Subject: [PATCH 5/6] PCI: acpiphp: look _RMV method a bit deeper in the hierarhcy
Date: Tue, 25 Jun 2013 19:22:09 +0300
Message-Id: <1372177330-28013-6-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1372177330-28013-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1372177330-28013-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The acpiphp driver finds out whether the device is hotpluggable by checking
whether it has _RMV method behind it (and if it returns 1). However, at
least Acer Aspire S5 with Thunderbolt host router has this method placed
behind device called EPUP (endpoint upstream port?) and not directly behind
the root port as can be seen from the ASL code below:

Device (RP05)
{
	...
	Device (HRUP)
	{
		Name (_ADR, Zero)
		Name (_PRW, Package (0x02)
		{
			0x09,
			0x04
		})
		Device (HRDN)
		{
			Name (_ADR, 0x00040000)
			Name (_PRW, Package (0x02)
			{
				0x09,
				0x04
			})
			Device (EPUP)
			{
				Name (_ADR, Zero)
				Method (_RMV, 0, NotSerialized)
				{
					Return (One)
				}
			}
		}
	}

If we want to support such machines we must look for the _RMV method a bit
deeper in the hierarchy. Fix this by changing pcihp_is_ejectable() to check
few more devices down from the root port.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/pci/hotplug/acpi_pcihp.c | 53 ++++++++++++++++++++++++++++++++++++----
 1 file changed, 48 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/hotplug/acpi_pcihp.c b/drivers/pci/hotplug/acpi_pcihp.c
index 2a47e82..2760954 100644
--- a/drivers/pci/hotplug/acpi_pcihp.c
+++ b/drivers/pci/hotplug/acpi_pcihp.c
@@ -408,21 +408,64 @@ got_one:
 }
 EXPORT_SYMBOL(acpi_get_hp_hw_control_from_firmware);
 
+static acpi_status pcihp_evaluate_rmv(acpi_handle handle, u32 lvl,
+				      void *context, void **return_not_used)
+{
+	unsigned long long *removable = context;
+	unsigned long long value;
+	acpi_status status;
+
+	status = acpi_evaluate_integer(handle, "_RMV", NULL, &value);
+	if (ACPI_SUCCESS(status) && value) {
+		*removable = value;
+		return AE_CTRL_TERMINATE;
+	}
+	return AE_OK;
+}
+
+/*
+ * pcihp_is_removable - check if this device is removable
+ * @handle: ACPI handle of the device
+ * @depth: how deep in the hierarchy we look for the _RMV
+ *
+ * Look for _RMV method behind the device. @depth specifies how deep in the
+ * hierarchy we search.
+ *
+ * Returns %true if the device is removable, %false otherwise.
+ */
+static bool pcihp_is_removable(acpi_handle handle, size_t depth)
+{
+	unsigned long long removable = 0;
+	acpi_status status;
+
+	status = pcihp_evaluate_rmv(handle, 0, &removable, NULL);
+	if ((status == AE_CTRL_TERMINATE) && removable)
+		return true;
+
+	acpi_walk_namespace(ACPI_TYPE_DEVICE, handle, depth, pcihp_evaluate_rmv,
+			    NULL, &removable, NULL);
+	return !!removable;
+}
+
+/*
+ * Some BIOSes, like the one in Acer Aspire S5 places the _RMV method a bit
+ * deeper in the hierarhcy. So check at least 3 levels behind this device.
+ */
+#define PCIHP_RMV_MAX_DEPTH	3
+
 static int pcihp_is_ejectable(acpi_handle handle)
 {
 	acpi_status status;
 	acpi_handle tmp;
-	unsigned long long removable;
+
 	status = acpi_get_handle(handle, "_ADR", &tmp);
 	if (ACPI_FAILURE(status))
 		return 0;
 	status = acpi_get_handle(handle, "_EJ0", &tmp);
 	if (ACPI_SUCCESS(status))
 		return 1;
-	status = acpi_evaluate_integer(handle, "_RMV", NULL, &removable);
-	if (ACPI_SUCCESS(status) && removable)
-		return 1;
-	return 0;
+
+	return pcihp_is_removable(handle, PCIHP_RMV_MAX_DEPTH);
 }
 
 /**
-- 
1.8.3.1

