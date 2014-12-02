Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933549AbaLBTZf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 14:25:35 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46823 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932979AbaLBTZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 14:25:31 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 116/121] ACPI / PM: Ignore wakeup setting if the ACPI companion can't wake up
Date: Tue,  2 Dec 2014 11:19:55 -0800
Message-Id: <1417548000-1794-117-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417548000-1794-1-git-send-email-kamal@canonical.com>
References: <1417548000-1794-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt12 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

commit 78579b7c7eb45f0e7ec5e9437087ed21749f9a9c upstream.

As reported by Dmitry, on some Chromebooks there are devices with
corresponding ACPI objects and with unusual system wakeup
configuration.  Namely, they technically are wakeup-capable, but the
wakeup is handled via a platform-specific out-of-band mechanism and
the ACPI PM layer has no information on the wakeup capability.  As
a result, device_may_wakeup(dev) called from acpi_dev_suspend_late()
returns 'true' for those devices, but the wakeup.flags.valid flag is
unset for the corresponding ACPI device objects, so acpi_device_wakeup()
reproducibly fails for them causing acpi_dev_suspend_late() to return
an error code.  The entire system suspend is then aborted and the
machines in question cannot suspend at all.

Address the problem by ignoring the device_may_wakeup(dev) return
value in acpi_dev_suspend_late() if the ACPI companion of the device
being handled has wakeup.flags.valid unset (in which case it is clear
that the wakeup is supposed to be handled by other means).

This fixes a regression introduced by commit a76e9bd89ae7 (i2c:
attach/detach I2C client device to the ACPI power domain) as the
affected systems could suspend and resume successfully before that
commit.

Fixes: a76e9bd89ae7 (i2c: attach/detach I2C client device to the ACPI power domain)
Reported-by: Dmitry Torokhov <dtor@chromium.org>
Reviewed-by: Dmitry Torokhov <dtor@chromium.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/acpi/device_pm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/device_pm.c b/drivers/acpi/device_pm.c
index b3480cf..5b39ae5 100644
--- a/drivers/acpi/device_pm.c
+++ b/drivers/acpi/device_pm.c
@@ -857,7 +857,7 @@ int acpi_dev_suspend_late(struct device *dev)
 		return 0;
 
 	target_state = acpi_target_system_state();
-	wakeup = device_may_wakeup(dev);
+	wakeup = device_may_wakeup(dev) && acpi_device_can_wakeup(adev);
 	error = __acpi_device_sleep_wake(adev, target_state, wakeup);
 	if (wakeup && error)
 		return error;
-- 
1.9.1

