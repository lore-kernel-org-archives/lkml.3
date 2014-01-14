Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130AbaANXJK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 18:09:10 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:61238 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751892AbaANXIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 18:08:36 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linux PM list <linux-pm@vger.kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH 1/3] PM / sleep: Flag to avoid executing suspend callbacks for devices
Date: Wed, 15 Jan 2014 00:13:53 +0100
Message-ID: <2057014.FtPLgvpVX8@vostro.rjw.lan>
User-Agent: KMail/4.11.3 (Linux/3.13.0-rc8+; KDE/4.11.3; x86_64; ; )
In-Reply-To: <5420830.W4laSGaAU9@vostro.rjw.lan>
References: <5420830.W4laSGaAU9@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Currently, some subsystems (e.g. PCI and the ACPI PM domain) have to
resume all runtime-suspended devices during system suspend, mostly
because those devices may need to be reprogrammed due to different
wakeup settings for system sleep and runtime PM.  However, at least
in some cases that isn't really necessary, because the wakeup
settings aren't really different.

The idea here is that subsystems should know whether or not it is
necessary to reprogram a given device during system suspend and they
should be able to tell the PM core about that.  For this reason,
modify the PM core so that if the .prepare() callback returns a
positive value for certain device, the core will set a new
power.no_suspend flag for it.  Then, if that flag is set, the core
will skip all of the subsequent suspend callbacks for that device.

However, since parents may need to be resumed so that their children
can be reprogrammed, make the PM core clear power.no_suspend for
devices that don't have power.ignore_children set and whose
children don't have power.no_suspend set.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/base/power/main.c |   38 ++++++++++++++++++++++++++------------
 include/linux/pm.h        |    1 +
 2 files changed, 27 insertions(+), 12 deletions(-)

Index: linux-pm/drivers/base/power/main.c
===================================================================
--- linux-pm.orig/drivers/base/power/main.c
+++ linux-pm/drivers/base/power/main.c
@@ -918,7 +918,7 @@ static int device_suspend_noirq(struct d
 	pm_callback_t callback = NULL;
 	char *info = NULL;
 
-	if (dev->power.syscore)
+	if (dev->power.syscore || dev->power.no_suspend)
 		return 0;
 
 	if (dev->pm_domain) {
@@ -1006,7 +1006,7 @@ static int device_suspend_late(struct de
 
 	__pm_runtime_disable(dev, false);
 
-	if (dev->power.syscore)
+	if (dev->power.syscore || dev->power.no_suspend)
 		return 0;
 
 	if (dev->pm_domain) {
@@ -1143,8 +1143,10 @@ static int __device_suspend(struct devic
 	 * for it, this is equivalent to the device signaling wakeup, so the
 	 * system suspend operation should be aborted.
 	 */
-	if (pm_runtime_barrier(dev) && device_may_wakeup(dev))
+	if (pm_runtime_barrier(dev) && device_may_wakeup(dev)) {
 		pm_wakeup_event(dev, 0);
+		dev->power.no_suspend = false;
+	}
 
 	if (pm_wakeup_pending()) {
 		async_error = -EBUSY;
@@ -1157,6 +1159,9 @@ static int __device_suspend(struct devic
 	dpm_watchdog_set(&wd, dev);
 	device_lock(dev);
 
+	if (dev->power.no_suspend)
+		goto End;
+
 	if (dev->pm_domain) {
 		info = "power domain ";
 		callback = pm_op(&dev->pm_domain->ops, state);
@@ -1205,9 +1210,13 @@ static int __device_suspend(struct devic
  End:
 	if (!error) {
 		dev->power.is_suspended = true;
-		if (dev->power.wakeup_path
-		    && dev->parent && !dev->parent->power.ignore_children)
-			dev->parent->power.wakeup_path = true;
+		if (dev->parent && !dev->parent->power.ignore_children) {
+			if (dev->power.wakeup_path)
+				dev->parent->power.wakeup_path = true;
+
+			if (!dev->power.no_suspend)
+				dev->parent->power.no_suspend = false;
+		}
 	}
 
 	device_unlock(dev);
@@ -1307,7 +1316,7 @@ static int device_prepare(struct device
 {
 	int (*callback)(struct device *) = NULL;
 	char *info = NULL;
-	int error = 0;
+	int ret = 0;
 
 	if (dev->power.syscore)
 		return 0;
@@ -1323,6 +1332,7 @@ static int device_prepare(struct device
 	device_lock(dev);
 
 	dev->power.wakeup_path = device_may_wakeup(dev);
+	dev->power.no_suspend = false;
 
 	if (dev->pm_domain) {
 		info = "preparing power domain ";
@@ -1344,16 +1354,20 @@ static int device_prepare(struct device
 	}
 
 	if (callback) {
-		error = callback(dev);
-		suspend_report_result(callback, error);
+		ret = callback(dev);
+		suspend_report_result(callback, ret);
 	}
 
 	device_unlock(dev);
 
-	if (error)
+	if (ret < 0) {
 		pm_runtime_put(dev);
+	} else if (ret > 0) {
+		dev->power.no_suspend = true;
+		ret = 0;
+	}
 
-	return error;
+	return ret;
 }
 
 /**
@@ -1422,7 +1436,7 @@ EXPORT_SYMBOL_GPL(dpm_suspend_start);
 
 void __suspend_report_result(const char *function, void *fn, int ret)
 {
-	if (ret)
+	if (ret < 0)
 		printk(KERN_ERR "%s(): %pF returns %d\n", function, fn, ret);
 }
 EXPORT_SYMBOL_GPL(__suspend_report_result);
Index: linux-pm/include/linux/pm.h
===================================================================
--- linux-pm.orig/include/linux/pm.h
+++ linux-pm/include/linux/pm.h
@@ -544,6 +544,7 @@ struct dev_pm_info {
 	bool			is_suspended:1;	/* Ditto */
 	bool			ignore_children:1;
 	bool			early_init:1;	/* Owned by the PM core */
+	bool			no_suspend:1;
 	spinlock_t		lock;
 #ifdef CONFIG_PM_SLEEP
 	struct list_head	entry;

