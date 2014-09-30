Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224AbaI3AJm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 20:09:42 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:54893 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753926AbaI3AJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 20:09:16 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Robert Moore <robert.moore@intel.com>
Subject: [PATCH 1/5] PM / sleep: Export dpm_suspend_late/noirq() and dpm_resume_early/noirq()
Date: Tue, 30 Sep 2014 02:21:34 +0200
Message-ID: <30053709.YziuPq9VAC@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1622293.rpSt5UtDk3@vostro.rjw.lan>
References: <1622293.rpSt5UtDk3@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Subsequent change sets will add platform-related operations between
dpm_suspend_late() and dpm_suspend_noirq() as well as between
dpm_resume_noirq() and dpm_resume_early() in suspend_enter(), so
export these functions for suspend_enter() to be able to call them
separately and split the invocations of dpm_suspend_end() and
dpm_resume_start() in there accordingly.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/base/power/main.c |    8 ++++----
 include/linux/pm.h        |    4 ++++
 kernel/power/suspend.c    |   14 +++++++++++---
 3 files changed, 19 insertions(+), 7 deletions(-)

Index: linux-pm/drivers/base/power/main.c
===================================================================
--- linux-pm.orig/drivers/base/power/main.c
+++ linux-pm/drivers/base/power/main.c
@@ -540,7 +540,7 @@ static void async_resume_noirq(void *dat
  * Call the "noirq" resume handlers for all devices in dpm_noirq_list and
  * enable device drivers to receive interrupts.
  */
-static void dpm_resume_noirq(pm_message_t state)
+void dpm_resume_noirq(pm_message_t state)
 {
 	struct device *dev;
 	ktime_t starttime = ktime_get();
@@ -662,7 +662,7 @@ static void async_resume_early(void *dat
  * dpm_resume_early - Execute "early resume" callbacks for all devices.
  * @state: PM transition of the system being carried out.
  */
-static void dpm_resume_early(pm_message_t state)
+void dpm_resume_early(pm_message_t state)
 {
 	struct device *dev;
 	ktime_t starttime = ktime_get();
@@ -1093,7 +1093,7 @@ static int device_suspend_noirq(struct d
  * Prevent device drivers from receiving interrupts and call the "noirq" suspend
  * handlers for all non-sysdev devices.
  */
-static int dpm_suspend_noirq(pm_message_t state)
+int dpm_suspend_noirq(pm_message_t state)
 {
 	ktime_t starttime = ktime_get();
 	int error = 0;
@@ -1232,7 +1232,7 @@ static int device_suspend_late(struct de
  * dpm_suspend_late - Execute "late suspend" callbacks for all devices.
  * @state: PM transition of the system being carried out.
  */
-static int dpm_suspend_late(pm_message_t state)
+int dpm_suspend_late(pm_message_t state)
 {
 	ktime_t starttime = ktime_get();
 	int error = 0;
Index: linux-pm/kernel/power/suspend.c
===================================================================
--- linux-pm.orig/kernel/power/suspend.c
+++ linux-pm/kernel/power/suspend.c
@@ -265,11 +265,16 @@ static int suspend_enter(suspend_state_t
 	if (error)
 		goto Platform_finish;
 
-	error = dpm_suspend_end(PMSG_SUSPEND);
+	error = dpm_suspend_late(PMSG_SUSPEND);
 	if (error) {
-		printk(KERN_ERR "PM: Some devices failed to power down\n");
+		printk(KERN_ERR "PM: late suspend of devices failed\n");
 		goto Platform_finish;
 	}
+	error = dpm_suspend_noirq(PMSG_SUSPEND);
+	if (error) {
+		printk(KERN_ERR "PM: noirq suspend of devices failed\n");
+		goto Devices_early_resume;
+	}
 	error = platform_suspend_prepare_late(state);
 	if (error)
 		goto Platform_wake;
@@ -319,7 +324,10 @@ static int suspend_enter(suspend_state_t
 
  Platform_wake:
 	platform_suspend_wake(state);
-	dpm_resume_start(PMSG_RESUME);
+	dpm_resume_noirq(PMSG_RESUME);
+
+ Devices_early_resume:
+	dpm_resume_early(PMSG_RESUME);
 
  Platform_finish:
 	platform_suspend_finish(state);
Index: linux-pm/include/linux/pm.h
===================================================================
--- linux-pm.orig/include/linux/pm.h
+++ linux-pm/include/linux/pm.h
@@ -680,12 +680,16 @@ struct dev_pm_domain {
 extern void device_pm_lock(void);
 extern void dpm_resume_start(pm_message_t state);
 extern void dpm_resume_end(pm_message_t state);
+extern void dpm_resume_noirq(pm_message_t state);
+extern void dpm_resume_early(pm_message_t state);
 extern void dpm_resume(pm_message_t state);
 extern void dpm_complete(pm_message_t state);
 
 extern void device_pm_unlock(void);
 extern int dpm_suspend_end(pm_message_t state);
 extern int dpm_suspend_start(pm_message_t state);
+extern int dpm_suspend_noirq(pm_message_t state);
+extern int dpm_suspend_late(pm_message_t state);
 extern int dpm_suspend(pm_message_t state);
 extern int dpm_prepare(pm_message_t state);
 

