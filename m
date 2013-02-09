Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932404Ab3BIBLV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 20:11:21 -0500
Received: from mail-vb0-f42.google.com ([209.85.212.42]:56103 "EHLO
	mail-vb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947581Ab3BIBIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 20:08:43 -0500
From: Len Brown <lenb@kernel.org>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Daniel Lezcano <daniel.lezcano@linaro.org>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH 08/16] ACPI / idle: pass the cpuidle_device parameter
Date: Fri,  8 Feb 2013 20:08:12 -0500
Message-Id: <6ef0f086beafb3c7d81cd3de81d886d105ea25b2.1360371180.git.len.brown@intel.com>
X-Mailer: git-send-email 1.8.1.3.535.ga923c31
In-Reply-To: <1360372100-28482-1-git-send-email-lenb@kernel.org>
References: <1360372100-28482-1-git-send-email-lenb@kernel.org>
In-Reply-To: <b1beab48f6148d50fee4a56d741cc3168fe1b995.1360371180.git.len.brown@intel.com>
References: <b1beab48f6148d50fee4a56d741cc3168fe1b995.1360371180.git.len.brown@intel.com>
Reply-To: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Lezcano <daniel.lezcano@linaro.org>

The cpuidle_device is retrieved in the function by using directly
the global variable. But the caller of this function already have
this device and it can be passed as a parameter. That is one small
step to encapsulate the code more.

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Len Brown <len.brown@intel.com>
---
 drivers/acpi/processor_idle.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index 82626e9..6837065 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -928,13 +928,14 @@ struct cpuidle_driver acpi_idle_driver = {
  * device i.e. per-cpu data
  *
  * @pr: the ACPI processor
+ * @dev : the cpuidle device
  */
-static int acpi_processor_setup_cpuidle_cx(struct acpi_processor *pr)
+static int acpi_processor_setup_cpuidle_cx(struct acpi_processor *pr,
+					   struct cpuidle_device *dev)
 {
 	int i, count = CPUIDLE_DRIVER_STATE_START;
 	struct acpi_processor_cx *cx;
 	struct cpuidle_state_usage *state_usage;
-	struct cpuidle_device *dev = per_cpu(acpi_cpuidle_device, pr->id);
 
 	if (!pr->flags.power_setup_done)
 		return -EINVAL;
@@ -1089,7 +1090,7 @@ int acpi_processor_hotplug(struct acpi_processor *pr)
 	cpuidle_disable_device(dev);
 	acpi_processor_get_power_info(pr);
 	if (pr->flags.power) {
-		acpi_processor_setup_cpuidle_cx(pr);
+		acpi_processor_setup_cpuidle_cx(pr, dev);
 		ret = cpuidle_enable_device(dev);
 	}
 	cpuidle_resume_and_unlock();
@@ -1147,8 +1148,8 @@ int acpi_processor_cst_has_changed(struct acpi_processor *pr)
 				continue;
 			acpi_processor_get_power_info(_pr);
 			if (_pr->flags.power) {
-				acpi_processor_setup_cpuidle_cx(_pr);
 				dev = per_cpu(acpi_cpuidle_device, cpu);
+				acpi_processor_setup_cpuidle_cx(_pr, dev);
 				cpuidle_enable_device(dev);
 			}
 		}
@@ -1217,7 +1218,7 @@ int __cpuinit acpi_processor_power_init(struct acpi_processor *pr)
 			return -ENOMEM;
 		per_cpu(acpi_cpuidle_device, pr->id) = dev;
 
-		acpi_processor_setup_cpuidle_cx(pr);
+		acpi_processor_setup_cpuidle_cx(pr, dev);
 
 		/* Register per-cpu cpuidle_device. Cpuidle driver
 		 * must already be registered before registering device
-- 
1.8.1.3.535.ga923c31

