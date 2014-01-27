Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560AbaA0Adh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 19:33:37 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:50632 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753442AbaA0AcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 19:32:24 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Aaron Lu <aaron.lu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 2/11] ACPI / hotplug / PCI: Simplify register_slot()
Date: Mon, 27 Jan 2014 01:38:47 +0100
Message-ID: <7524438.fFikVHOtly@vostro.rjw.lan>
User-Agent: KMail/4.11.4 (Linux/3.13.0+; KDE/4.11.4; x86_64; ; )
In-Reply-To: <2217793.001RY6hKlo@vostro.rjw.lan>
References: <2217793.001RY6hKlo@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

The err label in register_slot() is only jumped to from one place,
so move the code under the label to that place and drop the label.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/pci/hotplug/acpiphp_glue.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -316,8 +316,10 @@ static acpi_status register_slot(acpi_ha
 
 	slot = kzalloc(sizeof(struct acpiphp_slot), GFP_KERNEL);
 	if (!slot) {
-		status = AE_NO_MEMORY;
-		goto err;
+		mutex_lock(&acpiphp_context_lock);
+		acpiphp_put_context(context);
+		mutex_unlock(&acpiphp_context_lock);
+		return AE_NO_MEMORY;
 	}
 
 	slot->bus = bridge->pci_bus;
@@ -385,12 +387,6 @@ static acpi_status register_slot(acpi_ha
 	}
 
 	return AE_OK;
-
- err:
-	mutex_lock(&acpiphp_context_lock);
-	acpiphp_put_context(context);
-	mutex_unlock(&acpiphp_context_lock);
-	return status;
 }
 
 static struct acpiphp_bridge *acpiphp_handle_to_bridge(acpi_handle handle)

