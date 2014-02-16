Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507AbaBPXil (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 18:38:41 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:53056 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752322AbaBPXii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 18:38:38 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linux PM list <linux-pm@vger.kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/3] ACPI / PM: Avoid resuming devices in ACPI PM domain during system suspend
Date: Mon, 17 Feb 2014 00:52:26 +0100
Message-ID: <4644785.jPoV06XLG5@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1829141.MEZji1aIKp@vostro.rjw.lan>
References: <5420830.W4laSGaAU9@vostro.rjw.lan> <1829141.MEZji1aIKp@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Rework the ACPI PM domain's PM callbacks to avoid resuming devices
during system suspend in order to modify their wakeup settings if
that isn't necessary.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/device_pm.c |   24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

Index: linux-pm/drivers/acpi/device_pm.c
===================================================================
--- linux-pm.orig/drivers/acpi/device_pm.c
+++ linux-pm/drivers/acpi/device_pm.c
@@ -900,12 +900,28 @@ EXPORT_SYMBOL_GPL(acpi_dev_resume_early)
  */
 int acpi_subsys_prepare(struct device *dev)
 {
+	struct acpi_device *adev = ACPI_COMPANION(dev);
+	u32 target_state;
+	int error, state;
+
+	if (!adev || !pm_runtime_enabled_and_suspended(dev))
+		return pm_generic_prepare(dev);
+
+	target_state = acpi_target_system_state();
+	error = acpi_dev_pm_get_state(dev, adev, target_state, NULL, &state);
+	if (error || state != adev->power.state
+	    || device_may_wakeup(dev) != !!adev->wakeup.prepare_count) {
+		pm_runtime_resume(dev);
+		return pm_generic_prepare(dev);
+	}
 	/*
-	 * Follow PCI and resume devices suspended at run time before running
-	 * their system suspend callbacks.
+	 * If this is a wakeup device, wakeup power has been enabled already for
+	 * it during the preceding runtime suspend.  Caveat: "sleep state" is
+	 * one of the _DSW arguments, but that shouldn't matter for the devices
+	 * using acpi_general_pm_domain.
 	 */
-	pm_runtime_resume(dev);
-	return pm_generic_prepare(dev);
+	error =  pm_generic_prepare(dev);
+	return error ? error : 1;
 }
 EXPORT_SYMBOL_GPL(acpi_subsys_prepare);
 

