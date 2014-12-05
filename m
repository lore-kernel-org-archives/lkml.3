Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932128AbaLEXiq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 18:38:46 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53900 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387AbaLEWqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:46:09 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dmitry Torokhov <dtor@chromium.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.17 070/122] ACPI / PM: Ignore wakeup setting if the ACPI companion cant wake up
Date: Fri,  5 Dec 2014 14:44:04 -0800
Message-Id: <20141205223316.272019476@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205223305.514276242@linuxfoundation.org>
References: <20141205223305.514276242@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/device_pm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/acpi/device_pm.c
+++ b/drivers/acpi/device_pm.c
@@ -877,7 +877,7 @@ int acpi_dev_suspend_late(struct device
 		return 0;
 
 	target_state = acpi_target_system_state();
-	wakeup = device_may_wakeup(dev);
+	wakeup = device_may_wakeup(dev) && acpi_device_can_wakeup(adev);
 	error = acpi_device_wakeup(adev, target_state, wakeup);
 	if (wakeup && error)
 		return error;


