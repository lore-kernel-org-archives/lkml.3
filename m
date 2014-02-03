Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722AbaBCBd1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 20:33:27 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:55699 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752658AbaBCBdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 20:33:25 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Aaron Lu <aaron.lu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH] ACPI / hotplug / PCI: Scan root bus under the PCI rescan-remove lock
Date: Mon, 03 Feb 2014 02:47:51 +0100
Message-ID: <1470947.hTFtukjoka@vostro.rjw.lan>
User-Agent: KMail/4.11.4 (Linux/3.13.0+; KDE/4.11.4; x86_64; ; )
In-Reply-To: <1935791.liE9ZlzmO9@vostro.rjw.lan>
References: <2217793.001RY6hKlo@vostro.rjw.lan> <1935791.liE9ZlzmO9@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Since acpiphp_check_bridge() called by acpiphp_check_host_bridge()
does things that require PCI rescan-remove locking around it,
make acpiphp_check_host_bridge() use that locking.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---

One more thing I overlooked in the PCI rescan-remove locking patchset.

I just found it sitting there in a dark dusty corner and staring at me in
horror when I approached it with a vacuum cleaner ...

Anyway, 3.14-rc2 material on top of patches [1-2/13] from this series:
https://lkml.org/lkml/2014/2/1/123

Thanks,
Rafael

---
 drivers/pci/hotplug/acpiphp_glue.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -829,7 +829,11 @@ void acpiphp_check_host_bridge(acpi_hand
 
 	bridge = acpiphp_handle_to_bridge(handle);
 	if (bridge) {
+		pci_lock_rescan_remove();
+
 		acpiphp_check_bridge(bridge);
+
+		pci_unlock_rescan_remove();
 		put_bridge(bridge);
 	}
 }

