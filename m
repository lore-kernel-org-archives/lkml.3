Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932988Ab3AOWud (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:50:33 -0500
Received: from mail.kernel.org ([198.145.19.201]:46022 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933051Ab3AOWu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:50:27 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Zhang Rui <rui.zhang@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Joseph Salisbury <joseph.salisbury@canonical.com>
Subject: [ 067/171] ACPI : do not use Lid and Sleep button for S5 wakeup
Date: Tue, 15 Jan 2013 14:43:52 -0800
Message-Id: <20130115224318.243389840@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115224313.394976595@linuxfoundation.org>
References: <20130115224313.394976595@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Rui <rui.zhang@intel.com>

commit b7e383046c2c7c13ad928cd7407eafff758ddd4b upstream.

When system enters power off, the _PSW of Lid device is enabled.
But this may cause the system to reboot instead of power off.

A proper way to fix this is to always disable lid wakeup capability for S5.

References: https://bugzilla.kernel.org/show_bug.cgi?id=35262
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Joseph Salisbury <joseph.salisbury@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/scan.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -789,8 +789,8 @@ acpi_bus_extract_wakeup_device_power_pac
 static void acpi_bus_set_run_wake_flags(struct acpi_device *device)
 {
 	struct acpi_device_id button_device_ids[] = {
-		{"PNP0C0D", 0},
 		{"PNP0C0C", 0},
+		{"PNP0C0D", 0},
 		{"PNP0C0E", 0},
 		{"", 0},
 	};
@@ -802,6 +802,11 @@ static void acpi_bus_set_run_wake_flags(
 	/* Power button, Lid switch always enable wakeup */
 	if (!acpi_match_device_ids(device, button_device_ids)) {
 		device->wakeup.flags.run_wake = 1;
+		if (!acpi_match_device_ids(device, &button_device_ids[1])) {
+			/* Do not use Lid/sleep button for S5 wakeup */
+			if (device->wakeup.sleep_state == ACPI_STATE_S5)
+				device->wakeup.sleep_state = ACPI_STATE_S4;
+		}
 		device_set_wakeup_capable(&device->dev, true);
 		return;
 	}


