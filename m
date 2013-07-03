Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756401Ab3GCODH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 10:03:07 -0400
Received: from mga03.intel.com ([143.182.124.21]:16372 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932778Ab3GCOCf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 10:02:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,988,1363158000"; 
   d="scan'208";a="263621170"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Yinghai Lu <yinghai@kernel.org>,
        john.ronciak@intel.com, miles.j.penner@intel.com,
        bruce.w.allan@intel.com,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, x86@kernel.org
Subject: [PATCH v2 6/8] PCI: acpiphp: workaround for Thunderbolt on Acer Aspire S5
Date: Wed,  3 Jul 2013 17:04:53 +0300
Message-Id: <1372860295-8306-7-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1372860295-8306-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1372860295-8306-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

Correct ACPI PCI hotplug imeplementation should have _RMV method in a
PCI slot (device under pci bridge). In Acer Aspire S5 case we have it
deeper in hierarchy:

Device (RP05)
{
   // ...
   Device (HRUP)
   {
       // ...
       Device (HRDN)
       {
           // ...
           Device (EPUP)
           {
               // ...
               Method (_RMV, 0, NotSerialized)  // _RMV: Removal Status
               {
                   Return (One)
               }
           }
       }
   }
}

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/pci/hotplug/acpi_pcihp.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/pci/hotplug/acpi_pcihp.c b/drivers/pci/hotplug/acpi_pcihp.c
index 2a47e82..d92ebfb 100644
--- a/drivers/pci/hotplug/acpi_pcihp.c
+++ b/drivers/pci/hotplug/acpi_pcihp.c
@@ -422,6 +422,19 @@ static int pcihp_is_ejectable(acpi_handle handle)
 	status = acpi_evaluate_integer(handle, "_RMV", NULL, &removable);
 	if (ACPI_SUCCESS(status) && removable)
 		return 1;
+
+	/*
+	 * Workaround for Thunderbolt implementation on Acer Aspire S5.
+	 *
+	 * Correct ACPI PCI hotplug imeplementation has _RMV method in a PCI
+	 * slot (device under pci bridge). In Acer Aspire S5 case we have it
+	 * deeper in hierarchy.
+	 */
+	status = acpi_evaluate_integer(handle, "HRDN.EPUP._RMV", NULL,
+			&removable);
+	if (ACPI_SUCCESS(status) && removable)
+		return 1;
+
 	return 0;
 }
 
-- 
1.8.3.2

