Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756922AbaBUA1U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 19:27:20 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45873 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755796AbaBTXwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 18:52:43 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.12 67/82] ACPI / hotplug / PCI: Relax the checking of _STA return values
Date: Thu, 20 Feb 2014 15:52:50 -0800
Message-Id: <20140220235021.487910930@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140220235019.483734207@linuxfoundation.org>
References: <20140220235019.483734207@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mika Westerberg <mika.westerberg@linux.intel.com>

commit 7282059489868e0ed1b0d79765730c6b233a8399 upstream.

The ACPI specification (ACPI 5.0A, Section 6.3.7) says:

 _STA may return bit 0 clear (not present) with bit 3 set (device is
 functional). This case is used to indicate a valid device for which
 no device driver should be loaded (for example, a bridge device.)
 Children of this device may be present and valid. OSPM should
 continue enumeration below a device whose _STA returns this bit
 combination.

Evidently, some BIOSes follow that and return 0x0A from _STA, which
causes problems to happen when they trigger bus check or device check
notifications for those devices too.  Namely, ACPIPHP thinks that they
are gone and may drop them, for example, if such a notification is
triggered during a resume from system suspend.

To fix that, modify ACPICA to regard devies as present and
functioning if _STA returns both the ACPI_STA_DEVICE_ENABLED
and ACPI_STA_DEVICE_FUNCTIONING bits set for them.

Reported-and-tested-by: Peter Wu <lekensteyn@gmail.com>
[rjw: Subject and changelog, minor code modifications]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/hotplug/acpiphp_glue.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -706,6 +706,17 @@ static unsigned int get_slot_status(stru
 	return (unsigned int)sta;
 }
 
+static inline bool device_status_valid(unsigned int sta)
+{
+	/*
+	 * ACPI spec says that _STA may return bit 0 clear with bit 3 set
+	 * if the device is valid but does not require a device driver to be
+	 * loaded (Section 6.3.7 of ACPI 5.0A).
+	 */
+	unsigned int mask = ACPI_STA_DEVICE_ENABLED | ACPI_STA_DEVICE_FUNCTIONING;
+	return (sta & mask) == mask;
+}
+
 /**
  * trim_stale_devices - remove PCI devices that are not responding.
  * @dev: PCI device to start walking the hierarchy from.
@@ -721,7 +732,7 @@ static void trim_stale_devices(struct pc
 		unsigned long long sta;
 
 		status = acpi_evaluate_integer(handle, "_STA", NULL, &sta);
-		alive = (ACPI_SUCCESS(status) && sta == ACPI_STA_ALL)
+		alive = (ACPI_SUCCESS(status) && device_status_valid(sta))
 			|| acpiphp_no_hotplug(handle);
 	}
 	if (!alive) {
@@ -764,7 +775,7 @@ static void acpiphp_check_bridge(struct
 		mutex_lock(&slot->crit_sect);
 		if (slot_no_hotplug(slot)) {
 			; /* do nothing */
-		} else if (get_slot_status(slot) == ACPI_STA_ALL) {
+		} else if (device_status_valid(get_slot_status(slot))) {
 			/* remove stale devices if any */
 			list_for_each_entry_safe(dev, tmp, &bus->devices,
 						 bus_list)


