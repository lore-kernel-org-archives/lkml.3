Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751408AbaJOW5E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 18:57:04 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:38976 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870AbaJOW5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 18:57:01 -0400
Date: Wed, 15 Oct 2014 15:56:57 -0700
From: Dmitry Torokhov <dtor@chromium.org>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Benson Leung <bleung@chromium.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ACPI: do not fail suspend if unable to configure wakeup
Message-ID: <20141015225657.GA818@dtor-ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Newer kernels put i2c devices with ACPI companion in ACPI power domain and
then ACPI will try to configure them for wakeup (if requested).
Unfortunately on some Chromebooks firmware separates wakeup GPIO into a
completely separate device (which is handled by the kernel as a sleep
button), leaving the touchpads themselves not wakeup capable (as far as
ACPI is concerned). This causes ACPI late suspend code to fail to configure
them as wakeup sources and aborts entire suspend.

To work around this issues let's not abort entire suspend process if
driver asked to be a wakeup source but ACPI can not satisfy that
request.

Note that originally I tried to simply change the driver to not mark
device as wakeup source, unfortunately then we do not know that we
should not be powering down the device completely, otherwise we can't
wake up.

Verified by making sure that "echo mem > /sys/power/state" works on
Squawks.

Reviewed-by: Benson Leung <bleung@chromium.org>
Signed-off-by: Dmitry Torokhov <dtor@chromium.org>
---
 drivers/acpi/device_pm.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/acpi/device_pm.c b/drivers/acpi/device_pm.c
index 67075f8..440bc3d 100644
--- a/drivers/acpi/device_pm.c
+++ b/drivers/acpi/device_pm.c
@@ -871,6 +871,7 @@ int acpi_dev_suspend_late(struct device *dev)
 	struct acpi_device *adev = ACPI_COMPANION(dev);
 	u32 target_state;
 	bool wakeup;
+	bool can_wakeup;
 	int error;
 
 	if (!adev)
@@ -878,12 +879,19 @@ int acpi_dev_suspend_late(struct device *dev)
 
 	target_state = acpi_target_system_state();
 	wakeup = device_may_wakeup(dev);
-	error = acpi_device_wakeup(adev, target_state, wakeup);
-	if (wakeup && error)
-		return error;
+	can_wakeup = acpi_device_can_wakeup(adev);
+
+	if (can_wakeup) {
+		error = acpi_device_wakeup(adev, target_state, wakeup);
+		if (wakeup && error)
+			return error;
+	} else if (wakeup) {
+		dev_warn(dev,
+			 "device is not wakeup-capable, not enabling wakeup\n");
+	}
 
 	error = acpi_dev_pm_low_power(dev, adev, target_state);
-	if (error)
+	if (error && can_wakeup)
 		acpi_device_wakeup(adev, ACPI_STATE_UNKNOWN, false);
 
 	return error;
-- 
2.1.0.rc2.206.gedb03e5


-- 
Dmitry
