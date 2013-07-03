Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932637Ab3GCOCc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 10:02:32 -0400
Received: from mga11.intel.com ([192.55.52.93]:53044 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932081Ab3GCOC2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 10:02:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,988,1363158000"; 
   d="scan'208";a="364753090"
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
Subject: [PATCH v2 5/8] PCI: acpiphp: kill SLOT_ENABLED in favor of always re-enumerating the devices
Date: Wed,  3 Jul 2013 17:04:52 +0300
Message-Id: <1372860295-8306-6-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1372860295-8306-1-git-send-email-mika.westerberg@linux.intel.com>
References: <1372860295-8306-1-git-send-email-mika.westerberg@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The acpiphp driver checks SLOT_ENABLED flag only in aciphp_enable_slot() to
prevent re-enumeration of the already enabled slot.  Because of that it is
not possible to add new devices behind the slot later on (like it is the
case with Thunderbolt devices).

Now, there are two places where acpiphp_enable_slot() gets called:
 1) On Bus Check event for a function (in case of a dock).
 2) When userpace enables a slot by writing '1' to
    /sys/bus/pci/slots/*/power.

In the first case it doesn't make sense to do the check because we are
ought to re-enumerate the bus anyway and see if there are any new devices
added farther in the hierarchy, according the the ACPI specification.

The second case where userspace explicitly enables the device also doesn't
need this check as we already check if the slot is powered on or off in
power_on_slot() and don't do it twice.

So get rid of the SLOT_ENABLED flag and always re-enumerate devices behind
a slot when acpiphp_enable_slot() is called. In addition doing this allows
userspace to simulate Bus Check event by writing '1' to the 'power' file
under the slot.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/pci/hotplug/acpiphp.h      |  1 -
 drivers/pci/hotplug/acpiphp_glue.c | 18 +-----------------
 2 files changed, 1 insertion(+), 18 deletions(-)

diff --git a/drivers/pci/hotplug/acpiphp.h b/drivers/pci/hotplug/acpiphp.h
index 6fdd49c..ecc61b7 100644
--- a/drivers/pci/hotplug/acpiphp.h
+++ b/drivers/pci/hotplug/acpiphp.h
@@ -154,7 +154,6 @@ struct acpiphp_attention_info
 /* slot flags */
 
 #define SLOT_POWEREDON		(0x00000001)
-#define SLOT_ENABLED		(0x00000002)
 #define SLOT_MULTIFUNCTION	(0x00000004)
 
 /* function flags */
diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index c9ec06e..506f38f 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -304,7 +304,7 @@ register_slot(acpi_handle handle, u32 lvl, void *context, void **rv)
 
 	if (pci_bus_read_dev_vendor_id(pbus, PCI_DEVFN(device, function),
 				       &val, 60*1000))
-		slot->flags |= (SLOT_ENABLED | SLOT_POWEREDON);
+		slot->flags |= SLOT_POWEREDON;
 
 	if (is_dock_device(handle)) {
 		/* we don't want to call this device's _EJ0
@@ -725,18 +725,6 @@ static int __ref enable_device(struct acpiphp_slot *slot)
 
 	pci_bus_add_devices(bus);
 
-	slot->flags |= SLOT_ENABLED;
-	list_for_each_entry(func, &slot->funcs, sibling) {
-		dev = pci_get_slot(bus, PCI_DEVFN(slot->device,
-						  func->function));
-		if (!dev) {
-			/* Do not set SLOT_ENABLED flag if some funcs
-			   are not added. */
-			slot->flags &= (~SLOT_ENABLED);
-			continue;
-		}
-	}
-
 	return 0;
 }
 
@@ -782,8 +770,6 @@ static int disable_device(struct acpiphp_slot *slot)
 		acpiphp_bus_trim(func->handle);
 	}
 
-	slot->flags &= (~SLOT_ENABLED);
-
 	return 0;
 }
 
@@ -1229,8 +1215,6 @@ int acpiphp_enable_slot(struct acpiphp_slot *slot)
 		goto err_exit;
 
 	if (get_slot_status(slot) == ACPI_STA_ALL) {
-		if (slot->flags & SLOT_ENABLED)
-			goto err_exit;
 		/* configure all functions */
 		retval = enable_device(slot);
 		if (retval)
-- 
1.8.3.2

