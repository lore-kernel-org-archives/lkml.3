Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751643AbaBKKfh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 05:35:37 -0500
Received: from mga14.intel.com ([143.182.124.37]:41035 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751053AbaBKKfd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 05:35:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,825,1384329600"; 
   d="scan'208";a="473322302"
Date: Tue, 11 Feb 2014 12:42:37 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Peter Wu <lekensteyn@gmail.com>,
        Bastien Traverse <bastien.traverse@gmail.com>,
        linux-kernel@vger.kernel.org, francis.moro@gmail.com,
        linux-pm@vger.kernel.org
Subject: Re: 3.12: ethernet controller missing after resuming from suspend to
 RAM
Message-ID: <20140211104237.GE18029@intel.com>
References: <52F2CC7B.80406@gmail.com>
 <1747020.MhBDqPO9oJ@vostro.rjw.lan>
 <20140210122035.GY18029@intel.com>
 <4302366.hs31VgE4VT@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4302366.hs31VgE4VT@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 11:39:29PM +0100, Rafael J. Wysocki wrote:
> > _STA() returns 0x0A instead of 0x0F. Could there be something missing in
> > the ACPI hotplug code that overlooks this and removes the device on resume?
> 
> That is possible.  Actually even quite likely, but let's wait for the response
> from Peter.

Here's a hack that should take the 0xa return value into consideration. It
turned out that this case is even mentioned in the ACPI spec.

diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index e2a783fdb98f..014381b42d86 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -730,6 +730,17 @@ static unsigned int get_slot_status(struct acpiphp_slot *slot)
 	return (unsigned int)sta;
 }
 
+static inline bool device_sta_valid(unsigned long long sta)
+{
+	/*
+	 * ACPI spec says that _STA may return bit 0 clear with bit 8 set
+	 * if the device is valid but does not require device driver to be
+	 * loaded (chapter 6.3.7).
+	 */
+	unsigned mask = ACPI_STA_DEVICE_ENABLED | ACPI_STA_DEVICE_FUNCTIONING;
+	return (sta & mask) == mask;
+}
+
 /**
  * trim_stale_devices - remove PCI devices that are not responding.
  * @dev: PCI device to start walking the hierarchy from.
@@ -745,7 +756,7 @@ static void trim_stale_devices(struct pci_dev *dev)
 		unsigned long long sta;
 
 		status = acpi_evaluate_integer(handle, "_STA", NULL, &sta);
-		alive = (ACPI_SUCCESS(status) && sta == ACPI_STA_ALL)
+		alive = (ACPI_SUCCESS(status) && device_sta_valid(sta))
 			|| acpiphp_no_hotplug(handle);
 	}
 	if (!alive) {
@@ -792,7 +803,7 @@ static void acpiphp_check_bridge(struct acpiphp_bridge *bridge)
 		mutex_lock(&slot->crit_sect);
 		if (slot_no_hotplug(slot)) {
 			; /* do nothing */
-		} else if (get_slot_status(slot) == ACPI_STA_ALL) {
+		} else if (device_sta_valid(get_slot_status(slot))) {
 			/* remove stale devices if any */
 			list_for_each_entry_safe_reverse(dev, tmp,
 							 &bus->devices, bus_list)


