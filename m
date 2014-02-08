Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999AbaBHPH7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 10:07:59 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:63288 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751833AbaBHPHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 10:07:55 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Linux PCI <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] ACPI / hotplug / PCI: Execute _EJ0 under the ACPI scan lock
Date: Sat, 08 Feb 2014 16:22:30 +0100
Message-ID: <1629492.WLGZp2sePX@vostro.rjw.lan>
User-Agent: KMail/4.11.4 (Linux/3.13.0+; KDE/4.11.4; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Since acpi_device_hotplug() assumes that ACPI handles of device
objects passed to it will not become invalid while acpi_scan_lock
is being held, make acpiphp_disable_slot() acquire acpi_scan_lock,
because it generally causes _EJ0 to be executed for one of the
devices in the slot and that may cause its ACPI handle to become
invalid.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---

Hi All,

This change is not necessary in 3.14-rc (it wouldn't hurt, though), but it
closes a (mostly theoretical) race on top of the changes I've queued up for
3.15 in linux-next.

Thanks,
Rafael

---
 drivers/pci/hotplug/acpiphp_glue.c |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -1007,9 +1007,15 @@ int acpiphp_disable_slot(struct acpiphp_
 {
 	int ret;
 
+	/*
+	 * Acquire acpi_scan_lock to ensure that the execution of _EJ0 in
+	 * acpiphp_disable_and_eject_slot() will be synchronized properly.
+	 */
+	acpi_scan_lock_acquire();
 	pci_lock_rescan_remove();
 	ret = acpiphp_disable_and_eject_slot(slot);
 	pci_unlock_rescan_remove();
+	acpi_scan_lock_release();
 	return ret;
 }
 

