Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751474Ab3HSXh0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 19:37:26 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:50427 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241Ab3HSXhY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 19:37:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux PCI <linux-pci@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Toshi Kani <toshi.kani@hp.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH] ACPI / PM: Hold acpi_scan_lock over system PM transitions
Date: Tue, 20 Aug 2013 01:47:57 +0200
Message-ID: <2852781.TfChGuuEkJ@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.11.0-rc5+; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Bad things happen if ACPI hotplug events are handled during system
PM transitions, especially if devices are removed as a result.
To prevent those bad things from happening, acquire acpi_scan_lock
when a transition is started and release it when that transition
is complete or has been aborted.

This fixes resume lockup on my test-bed Acer Aspire S5 that happens
when Thunderbolt devices are disconnected from the machine while
suspended.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---

Applies on top of the linux-next branch of the linux-pm.git tree.

Thanks,
Rafael

---
 drivers/acpi/sleep.c |   39 ++++++++++++++++++++++++---------------
 1 file changed, 24 insertions(+), 15 deletions(-)

Index: linux-pm/drivers/acpi/sleep.c
===================================================================
--- linux-pm.orig/drivers/acpi/sleep.c
+++ linux-pm/drivers/acpi/sleep.c
@@ -420,10 +420,21 @@ static void acpi_pm_finish(void)
 }
 
 /**
- *	acpi_pm_end - Finish up suspend sequence.
+ * acpi_pm_start - Start system PM transition.
+ */
+static void acpi_pm_start(u32 acpi_state)
+{
+	acpi_target_sleep_state = acpi_state;
+	acpi_sleep_tts_switch(acpi_target_sleep_state);
+	acpi_scan_lock_acquire();
+}
+
+/**
+ * acpi_pm_end - Finish up system PM transition.
  */
 static void acpi_pm_end(void)
 {
+	acpi_scan_lock_release();
 	/*
 	 * This is necessary in case acpi_pm_finish() is not called during a
 	 * failing transition to a sleep state.
@@ -451,21 +462,19 @@ static u32 acpi_suspend_states[] = {
 static int acpi_suspend_begin(suspend_state_t pm_state)
 {
 	u32 acpi_state = acpi_suspend_states[pm_state];
-	int error = 0;
+	int error;
 
 	error = (nvs_nosave || nvs_nosave_s3) ? 0 : suspend_nvs_alloc();
 	if (error)
 		return error;
 
-	if (sleep_states[acpi_state]) {
-		acpi_target_sleep_state = acpi_state;
-		acpi_sleep_tts_switch(acpi_target_sleep_state);
-	} else {
-		printk(KERN_ERR "ACPI does not support this state: %d\n",
-			pm_state);
-		error = -ENOSYS;
+	if (!sleep_states[acpi_state]) {
+		pr_err("ACPI does not support sleep state S%u\n", acpi_state);
+		return -ENOSYS;
 	}
-	return error;
+
+	acpi_pm_start(acpi_state);
+	return 0;
 }
 
 /**
@@ -631,10 +640,8 @@ static int acpi_hibernation_begin(void)
 	int error;
 
 	error = nvs_nosave ? 0 : suspend_nvs_alloc();
-	if (!error) {
-		acpi_target_sleep_state = ACPI_STATE_S4;
-		acpi_sleep_tts_switch(acpi_target_sleep_state);
-	}
+	if (!error)
+		acpi_pm_start(ACPI_STATE_S4);
 
 	return error;
 }
@@ -713,8 +720,10 @@ static int acpi_hibernation_begin_old(vo
 	if (!error) {
 		if (!nvs_nosave)
 			error = suspend_nvs_alloc();
-		if (!error)
+		if (!error) {
 			acpi_target_sleep_state = ACPI_STATE_S4;
+			acpi_scan_lock_acquire();
+		}
 	}
 	return error;
 }

