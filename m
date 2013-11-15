Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093Ab3KOVq3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 16:46:29 -0500
Received: from smtprelay0137.hostedemail.com ([216.40.44.137]:45023 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751996Ab3KOVqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 16:46:21 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:2:41:69:355:379:541:599:960:966:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1535:1593:1594:1605:1730:1747:1777:1792:2196:2199:2393:2553:2559:2562:2828:2896:2898:3138:3139:3140:3141:3142:3622:3865:3866:3867:3870:3872:3874:4051:4120:4250:4321:4385:4605:5007:7652:10004:10848:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12555:12740,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: ducks71_8e6069d47ce51
X-Filterd-Recvd-Size: 9619
Message-ID: <1384551981.18739.36.camel@joe-AO722>
Subject: Re: [PATCH] power: Replace printks with pr_* routines
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Shuah Khan <shuah.kh@samsung.com>, len.brown@intel.com, pavel@ucw.cz,
        rjw@rjwysocki.net, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com
Date: Fri, 15 Nov 2013 13:46:21 -0800
In-Reply-To: <20131115211922.GB14410@kroah.com>
References: <1384531806-11500-1-git-send-email-shuah.kh@samsung.com>
	 <20131115211922.GB14410@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-11-16 at 06:19 +0900, Greg KH wrote:
> On Fri, Nov 15, 2013 at 09:10:06AM -0700, Shuah Khan wrote:
> > Replaced printks with pr_* routines. dev_* routines could have been used,
> > but chose to use pr_* to avoid breaking scripts that might be relying on
> > a specific text.
> 
> I'd really like to switch to dev_* instead, even changing to pr_* should
> change the output prefix (if it's set for this file, odds are it isn't
> though...)

It's not.

Something like this?

Pass a struct device * through to the PM
suspend logging routines.  Use dev_<level>
instead of printks.

---

 drivers/base/power/main.c  | 20 ++++++++++----------
 drivers/pci/pci-driver.c   | 18 +++++++++---------
 drivers/pnp/driver.c       |  2 +-
 drivers/usb/core/hcd-pci.c |  4 ++--
 include/linux/pm.h         | 14 ++++++++------
 5 files changed, 30 insertions(+), 28 deletions(-)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index c12e9b9..e0c12e6 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -351,8 +351,8 @@ static void pm_dev_dbg(struct device *dev, pm_message_t state, char *info)
 static void pm_dev_err(struct device *dev, pm_message_t state, char *info,
 			int error)
 {
-	printk(KERN_ERR "PM: Device %s failed to %s%s: error %d\n",
-		dev_name(dev), pm_verb(state.event), info, error);
+	dev_err(dev, "PM: failed to %s%s: error %d\n",
+		pm_verb(state.event), info, error);
 }
 
 static void dpm_show_time(ktime_t starttime, pm_message_t state, char *info)
@@ -385,7 +385,7 @@ static int dpm_run_callback(pm_callback_t cb, struct device *dev,
 
 	pm_dev_dbg(dev, state, info);
 	error = cb(dev);
-	suspend_report_result(cb, error);
+	suspend_report_result(dev, cb, error);
 
 	initcall_debug_report(dev, calltime, error, state, info);
 
@@ -1112,7 +1112,7 @@ static int legacy_suspend(struct device *dev, pm_message_t state,
 	calltime = initcall_debug_start(dev);
 
 	error = cb(dev, state);
-	suspend_report_result(cb, error);
+	suspend_report_result(dev, cb, error);
 
 	initcall_debug_report(dev, calltime, error, state, info);
 
@@ -1345,7 +1345,7 @@ static int device_prepare(struct device *dev, pm_message_t state)
 
 	if (callback) {
 		error = callback(dev);
-		suspend_report_result(callback, error);
+		suspend_report_result(dev, callback, error);
 	}
 
 	device_unlock(dev);
@@ -1381,9 +1381,8 @@ int dpm_prepare(pm_message_t state)
 				error = 0;
 				continue;
 			}
-			printk(KERN_INFO "PM: Device %s not prepared "
-				"for power transition: code %d\n",
-				dev_name(dev), error);
+			dev_info(dev, "PM: not prepared for power transition: code %d\n",
+				 error);
 			put_device(dev);
 			break;
 		}
@@ -1417,10 +1416,11 @@ int dpm_suspend_start(pm_message_t state)
 }
 EXPORT_SYMBOL_GPL(dpm_suspend_start);
 
-void __suspend_report_result(const char *function, void *fn, int ret)
+void __suspend_report_result(const struct device *dev,
+			     const char *function, void *fn, int ret)
 {
 	if (ret)
-		printk(KERN_ERR "%s(): %pF returns %d\n", function, fn, ret);
+		dev_err(dev, "PM: %s(): %pF returns %d\n", function, fn, ret);
 }
 EXPORT_SYMBOL_GPL(__suspend_report_result);
 
diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 4548535..340de34 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -484,7 +484,7 @@ static int pci_legacy_suspend(struct device *dev, pm_message_t state)
 		int error;
 
 		error = drv->suspend(pci_dev, state);
-		suspend_report_result(drv->suspend, error);
+		suspend_report_result(dev, drv->suspend, error);
 		if (error)
 			return error;
 
@@ -511,7 +511,7 @@ static int pci_legacy_suspend_late(struct device *dev, pm_message_t state)
 		int error;
 
 		error = drv->suspend_late(pci_dev, state);
-		suspend_report_result(drv->suspend_late, error);
+		suspend_report_result(dev, drv->suspend_late, error);
 		if (error)
 			return error;
 
@@ -638,7 +638,7 @@ static int pci_pm_suspend(struct device *dev)
 		int error;
 
 		error = pm->suspend(dev);
-		suspend_report_result(pm->suspend, error);
+		suspend_report_result(dev, pm->suspend, error);
 		if (error)
 			return error;
 
@@ -674,7 +674,7 @@ static int pci_pm_suspend_noirq(struct device *dev)
 		int error;
 
 		error = pm->suspend_noirq(dev);
-		suspend_report_result(pm->suspend_noirq, error);
+		suspend_report_result(dev, pm->suspend_noirq, error);
 		if (error)
 			return error;
 
@@ -791,7 +791,7 @@ static int pci_pm_freeze(struct device *dev)
 		int error;
 
 		error = pm->freeze(dev);
-		suspend_report_result(pm->freeze, error);
+		suspend_report_result(dev, pm->freeze, error);
 		if (error)
 			return error;
 	}
@@ -814,7 +814,7 @@ static int pci_pm_freeze_noirq(struct device *dev)
 		int error;
 
 		error = drv->pm->freeze_noirq(dev);
-		suspend_report_result(drv->pm->freeze_noirq, error);
+		suspend_report_result(dev, drv->pm->freeze_noirq, error);
 		if (error)
 			return error;
 	}
@@ -898,7 +898,7 @@ static int pci_pm_poweroff(struct device *dev)
 		int error;
 
 		error = pm->poweroff(dev);
-		suspend_report_result(pm->poweroff, error);
+		suspend_report_result(dev, pm->poweroff, error);
 		if (error)
 			return error;
 	}
@@ -927,7 +927,7 @@ static int pci_pm_poweroff_noirq(struct device *dev)
 		int error;
 
 		error = drv->pm->poweroff_noirq(dev);
-		suspend_report_result(drv->pm->poweroff_noirq, error);
+		suspend_report_result(dev, drv->pm->poweroff_noirq, error);
 		if (error)
 			return error;
 	}
@@ -1040,7 +1040,7 @@ static int pci_pm_runtime_suspend(struct device *dev)
 	pci_dev->state_saved = false;
 	pci_dev->no_d3cold = false;
 	error = pm->runtime_suspend(dev);
-	suspend_report_result(pm->runtime_suspend, error);
+	suspend_report_result(dev, pm->runtime_suspend, error);
 	if (error)
 		return error;
 	if (!pci_dev->d3cold_allowed)
diff --git a/drivers/pnp/driver.c b/drivers/pnp/driver.c
index 6936e0a..1e70fc6 100644
--- a/drivers/pnp/driver.c
+++ b/drivers/pnp/driver.c
@@ -165,7 +165,7 @@ static int __pnp_bus_suspend(struct device *dev, pm_message_t state)
 
 	if (pnp_drv->driver.pm && pnp_drv->driver.pm->suspend) {
 		error = pnp_drv->driver.pm->suspend(dev);
-		suspend_report_result(pnp_drv->driver.pm->suspend, error);
+		suspend_report_result(dev, pnp_drv->driver.pm->suspend, error);
 		if (error)
 			return error;
 	}
diff --git a/drivers/usb/core/hcd-pci.c b/drivers/usb/core/hcd-pci.c
index dfe9d0f..890ae99 100644
--- a/drivers/usb/core/hcd-pci.c
+++ b/drivers/usb/core/hcd-pci.c
@@ -453,7 +453,7 @@ static int suspend_common(struct device *dev, bool do_wakeup)
 				HCD_WAKEUP_PENDING(hcd->shared_hcd))
 			return -EBUSY;
 		retval = hcd->driver->pci_suspend(hcd, do_wakeup);
-		suspend_report_result(hcd->driver->pci_suspend, retval);
+		suspend_report_result(dev, hcd->driver->pci_suspend, retval);
 
 		/* Check again in case wakeup raced with pci_suspend */
 		if ((retval == 0 && do_wakeup && HCD_WAKEUP_PENDING(hcd)) ||
@@ -566,7 +566,7 @@ static int hcd_pci_suspend_noirq(struct device *dev)
 		dev_dbg(dev, "--> PCI %s\n",
 				pci_power_name(pci_dev->current_state));
 	} else {
-		suspend_report_result(pci_prepare_to_sleep, retval);
+		suspend_report_result(dev, pci_prepare_to_sleep, retval);
 		return retval;
 	}
 
diff --git a/include/linux/pm.h b/include/linux/pm.h
index a224c7f..d2a525a 100644
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -644,12 +644,11 @@ extern int dpm_suspend_start(pm_message_t state);
 extern int dpm_suspend(pm_message_t state);
 extern int dpm_prepare(pm_message_t state);
 
-extern void __suspend_report_result(const char *function, void *fn, int ret);
+extern void __suspend_report_result(const struct device *dev,
+				    const char *function, void *fn, int ret);
 
-#define suspend_report_result(fn, ret)					\
-	do {								\
-		__suspend_report_result(__func__, fn, ret);		\
-	} while (0)
+#define suspend_report_result(dev, fn, ret)				\
+	__suspend_report_result(dev, __func__, fn, ret)
 
 extern int device_pm_wait_for_dev(struct device *sub, struct device *dev);
 extern void dpm_for_each_dev(void *data, void (*fn)(struct device *, void *));
@@ -685,7 +684,10 @@ static inline int dpm_suspend_start(pm_message_t state)
 	return 0;
 }
 
-#define suspend_report_result(fn, ret)		do {} while (0)
+static inline void suspend_report_result(const struct device *dev,
+					 const char *fn, int ret)
+{
+}
 
 static inline int device_pm_wait_for_dev(struct device *a, struct device *b)
 {


