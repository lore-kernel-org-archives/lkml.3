Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030339Ab3HBKK6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 06:10:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37360 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030228Ab3HBKK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 06:10:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Toshi Kani <toshi.kani@hp.com>
Subject: [ 59/99] ACPI / scan: Always call acpi_bus_scan() for bus check notifications
Date: Fri,  2 Aug 2013 18:08:12 +0800
Message-Id: <20130802100234.256989759@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.4.841.g1a3f60e
In-Reply-To: <20130802100225.478715166@linuxfoundation.org>
References: <20130802100225.478715166@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

commit 8832f7e43fa7f0f19bd54e13766a825dd1ed4d6f upstream.

An ACPI_NOTIFY_BUS_CHECK notification means that we should scan the
entire namespace starting from the given handle even if the device
represented by that handle is present (other devices below it may
just have appeared).

For this reason, modify acpi_scan_bus_device_check() to always run
acpi_bus_scan() if the notification being handled is of type
ACPI_NOTIFY_BUS_CHECK.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Acked-by: Toshi Kani <toshi.kani@hp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/scan.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -237,10 +237,12 @@ static void acpi_scan_bus_device_check(a
 
 	mutex_lock(&acpi_scan_lock);
 
-	acpi_bus_get_device(handle, &device);
-	if (device) {
-		dev_warn(&device->dev, "Attempt to re-insert\n");
-		goto out;
+	if (ost_source != ACPI_NOTIFY_BUS_CHECK) {
+		acpi_bus_get_device(handle, &device);
+		if (device) {
+			dev_warn(&device->dev, "Attempt to re-insert\n");
+			goto out;
+		}
 	}
 	acpi_evaluate_hotplug_ost(handle, ost_source,
 				  ACPI_OST_SC_INSERT_IN_PROGRESS, NULL);


