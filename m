Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933154AbbA1BhY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 20:37:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41306 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760038AbbA1B2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:28:31 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.18 58/61] ACPI / PM: Do not disable wakeup GPEs that have not been enabled
Date: Tue, 27 Jan 2015 17:27:10 -0800
Message-Id: <20150128012643.203022945@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150128012636.936333725@linuxfoundation.org>
References: <20150128012636.936333725@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

commit 175f8e2650f7ca6b33d338be3ccc1c00e89594ea upstream.

In some cases acpi_device_wakeup() may be called to ensure wakeup
power to be off for a given device even though that device's wakeup
GPE has not been enabled so far.  It calls acpi_disable_gpe() on a
GPE that's not enabled and this causes ACPICA to return the AE_LIMIT
status code from that call which then is reported as an error by the
ACPICA's debug facilities (if enabled).  This may lead to a fair
amount of confusion, so introduce a new ACPI device wakeup flag
to store the wakeup GPE status and avoid disabling wakeup GPEs
that have not been enabled.

Reported-and-tested-by: Venkat Raghavulu <venkat.raghavulu@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/device_pm.c |   12 ++++++++++--
 include/acpi/acpi_bus.h  |    1 +
 2 files changed, 11 insertions(+), 2 deletions(-)

--- a/drivers/acpi/device_pm.c
+++ b/drivers/acpi/device_pm.c
@@ -680,13 +680,21 @@ static int acpi_device_wakeup(struct acp
 		if (error)
 			return error;
 
+		if (adev->wakeup.flags.enabled)
+			return 0;
+
 		res = acpi_enable_gpe(wakeup->gpe_device, wakeup->gpe_number);
-		if (ACPI_FAILURE(res)) {
+		if (ACPI_SUCCESS(res)) {
+			adev->wakeup.flags.enabled = 1;
+		} else {
 			acpi_disable_wakeup_device_power(adev);
 			return -EIO;
 		}
 	} else {
-		acpi_disable_gpe(wakeup->gpe_device, wakeup->gpe_number);
+		if (adev->wakeup.flags.enabled) {
+			acpi_disable_gpe(wakeup->gpe_device, wakeup->gpe_number);
+			adev->wakeup.flags.enabled = 0;
+		}
 		acpi_disable_wakeup_device_power(adev);
 	}
 	return 0;
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -312,6 +312,7 @@ struct acpi_device_wakeup_flags {
 	u8 valid:1;		/* Can successfully enable wakeup? */
 	u8 run_wake:1;		/* Run-Wake GPE devices */
 	u8 notifier_present:1;  /* Wake-up notify handler has been installed */
+	u8 enabled:1;		/* Enabled for wakeup */
 };
 
 struct acpi_device_wakeup_context {


