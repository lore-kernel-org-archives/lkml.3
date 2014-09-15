Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755261AbaIOTj5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 15:39:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55521 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754620AbaIOTj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:39:28 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Benjamin Block <bebl@mageta.org>,
        Knut Petersen <Knut_Petersen@t-online.de>,
        Lan Tianyu <tianyu.lan@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.14 067/114] ACPI: Run fixed event device notifications in process context
Date: Mon, 15 Sep 2014 12:26:07 -0700
Message-Id: <20140915192643.543605702@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192641.428509513@linuxfoundation.org>
References: <20140915192641.428509513@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lan Tianyu <tianyu.lan@intel.com>

commit 236105db632c6279a020f78c83e22eaef746006b upstream.

Currently, notify callbacks for fixed button events are run from
interrupt context.  That is not necessary and after commit 0bf6368ee8f2
(ACPI / button: Add ACPI Button event via netlink routine) it causes
netlink routines to be called from interrupt context which is not
correct.

Also, that is different from non-fixed device events (including
non-fixed button events) whose notify callbacks are all executed from
process context.

For the above reasons, make fixed button device notify callbacks run
in process context which will avoid the deadlock when using netlink
to report button events to user space.

Fixes: 0bf6368ee8f2 (ACPI / button: Add ACPI Button event via netlink routine)
Link: https://lkml.org/lkml/2014/8/21/606
Reported-by: Benjamin Block <bebl@mageta.org>
Reported-by: Knut Petersen <Knut_Petersen@t-online.de>
Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
[rjw: Function names, subject and changelog.]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/scan.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -916,12 +916,17 @@ static void acpi_device_notify(acpi_hand
 	device->driver->ops.notify(device, event);
 }
 
-static acpi_status acpi_device_notify_fixed(void *data)
+static void acpi_device_notify_fixed(void *data)
 {
 	struct acpi_device *device = data;
 
 	/* Fixed hardware devices have no handles */
 	acpi_device_notify(NULL, ACPI_FIXED_HARDWARE_EVENT, device);
+}
+
+static acpi_status acpi_device_fixed_event(void *data)
+{
+	acpi_os_execute(OSL_NOTIFY_HANDLER, acpi_device_notify_fixed, data);
 	return AE_OK;
 }
 
@@ -932,12 +937,12 @@ static int acpi_device_install_notify_ha
 	if (device->device_type == ACPI_BUS_TYPE_POWER_BUTTON)
 		status =
 		    acpi_install_fixed_event_handler(ACPI_EVENT_POWER_BUTTON,
-						     acpi_device_notify_fixed,
+						     acpi_device_fixed_event,
 						     device);
 	else if (device->device_type == ACPI_BUS_TYPE_SLEEP_BUTTON)
 		status =
 		    acpi_install_fixed_event_handler(ACPI_EVENT_SLEEP_BUTTON,
-						     acpi_device_notify_fixed,
+						     acpi_device_fixed_event,
 						     device);
 	else
 		status = acpi_install_notify_handler(device->handle,
@@ -954,10 +959,10 @@ static void acpi_device_remove_notify_ha
 {
 	if (device->device_type == ACPI_BUS_TYPE_POWER_BUTTON)
 		acpi_remove_fixed_event_handler(ACPI_EVENT_POWER_BUTTON,
-						acpi_device_notify_fixed);
+						acpi_device_fixed_event);
 	else if (device->device_type == ACPI_BUS_TYPE_SLEEP_BUTTON)
 		acpi_remove_fixed_event_handler(ACPI_EVENT_SLEEP_BUTTON,
-						acpi_device_notify_fixed);
+						acpi_device_fixed_event);
 	else
 		acpi_remove_notify_handler(device->handle, ACPI_DEVICE_NOTIFY,
 					   acpi_device_notify);


