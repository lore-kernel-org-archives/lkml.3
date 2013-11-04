Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607Ab3KDN1W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 08:27:22 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:49709 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753236Ab3KDN0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 08:26:02 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux PCI <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Toshi Kani <toshi.kani@hp.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: [Update][PATCH 3/6] ACPI / hotplug: Fix handle_root_bridge_removal()
Date: Mon, 04 Nov 2013 14:33:09 +0100
Message-ID: <6808835.gmCqHn1NaE@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <2970389.SeMGM45Qln@vostro.rjw.lan>
References: <5839747.7HXXGHmMBd@vostro.rjw.lan> <2970389.SeMGM45Qln@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

It is required to do get_device() on the struct acpi_device in
question before passing it to acpi_bus_hot_remove_device() through
acpi_os_hotplug_execute(), because acpi_bus_hot_remove_device()
calls acpi_scan_hot_remove() that does put_device() on that
object.

The ACPI PCI root removal routine, handle_root_bridge_removal(),
doesn't do that, which may lead to premature freeing of the
device object or to executing put_device() on an object that
has been freed already.

Fix this problem by making handle_root_bridge_removal() use
get_device() as appropriate.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/pci_root.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

Index: linux-pm/drivers/acpi/pci_root.c
===================================================================
--- linux-pm.orig/drivers/acpi/pci_root.c
+++ linux-pm/drivers/acpi/pci_root.c
@@ -608,9 +608,12 @@ static void handle_root_bridge_removal(s
 	ej_event->device = device;
 	ej_event->event = ACPI_NOTIFY_EJECT_REQUEST;
 
+	get_device(&device->dev);
 	status = acpi_os_hotplug_execute(acpi_bus_hot_remove_device, ej_event);
-	if (ACPI_FAILURE(status))
+	if (ACPI_FAILURE(status)) {
+		put_device(&device->dev);
 		kfree(ej_event);
+	}
 }
 
 static void _handle_hotplug_event_root(struct work_struct *work)

