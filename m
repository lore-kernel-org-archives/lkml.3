Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759889Ab3K0Bdu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:33:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39302 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932410Ab3K0A6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:58:31 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH 3.12 023/116] ACPI / hotplug: Fix handle_root_bridge_removal()
Date: Tue, 26 Nov 2013 16:56:36 -0800
Message-Id: <20131127005738.548845490@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005736.915454872@linuxfoundation.org>
References: <20131127005736.915454872@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

commit 2441191a19039002b2c454a261fb45986df15184 upstream.

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
Acked-by: Toshi Kani <toshi.kani@hp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/pci_root.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
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


