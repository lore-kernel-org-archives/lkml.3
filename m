Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397AbaANHMZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 02:12:25 -0500
Received: from mga02.intel.com ([134.134.136.20]:9264 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406AbaANHMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 02:12:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,657,1384329600"; 
   d="scan'208";a="438439850"
Subject: [PATCH] PM: Enable asynchronous noirq resume threads to save the
 resuming time
From: Chuansheng Liu <chuansheng.liu@intel.com>
To: rjw@rjwysocki.net, gregkh@linuxfoundation.org, len.brown@intel.com,
        pavel@ucw.cz
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        chuansheng.liu@intel.com, zhuangzhi.li@intel.com
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Jan 2014 15:18:08 +0800
Message-ID: <1389683888.3650.78.camel@cliu38-desktop-build>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Currently, the dpm_resume_noirq() is done synchronously, and for PCI devices
pci_pm_resume_noirq():

pci_pm_resume_noirq()
 pci_pm_default_resume_early()
  pci_power_up()
   pci_raw_set_power_state()
Which set the device from D3hot to D0 mostly, for every device, there will
be one 10ms(pci_pm_d3_delay) to wait.

Hence normally dpm_resume_noirq() will cost > 100ms, which is bigger for mobile
platform.

Here implementing it with asynchronous way which will reduce much.

For example below, The 80% time is saved.
With synchronous way:
[ 1411.272218] PM: noirq resume of devices complete after 92.223 msecs
With asynchronous way:
[  110.616735] PM: noirq resume of devices complete after 10.544 msecs

Signed-off-by: Liu, Chuansheng <chuansheng.liu@intel.com>
---
 drivers/base/power/main.c |   42 +++++++++++++++++++++++++++++++++---------
 1 file changed, 33 insertions(+), 9 deletions(-)

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index 1b41fca..1b9d774 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -505,6 +505,19 @@ static int device_resume_noirq(struct device *dev, pm_message_t state)
 	return error;
 }
 
+static bool is_async(struct device *dev);
+
+static void async_resume_noirq(void *data, async_cookie_t cookie)
+{
+	struct device *dev = (struct device *)data;
+	int error;
+
+	error = device_resume_noirq(dev, pm_transition);
+	if (error)
+		pm_dev_err(dev, pm_transition, " noirq", error);
+	put_device(dev);
+}
+
 /**
  * dpm_resume_noirq - Execute "noirq resume" callbacks for all devices.
  * @state: PM transition of the system being carried out.
@@ -514,29 +527,40 @@ static int device_resume_noirq(struct device *dev, pm_message_t state)
  */
 static void dpm_resume_noirq(pm_message_t state)
 {
+	struct device *dev;
 	ktime_t starttime = ktime_get();
+	pm_transition = state;
+
+	list_for_each_entry(dev, &dpm_noirq_list, power.entry) {
+		if (is_async(dev)) {
+			get_device(dev);
+			async_schedule(async_resume_noirq, dev);
+		}
+	}
 
 	mutex_lock(&dpm_list_mtx);
 	while (!list_empty(&dpm_noirq_list)) {
-		struct device *dev = to_device(dpm_noirq_list.next);
-		int error;
+		dev = to_device(dpm_noirq_list.next);
 
 		get_device(dev);
 		list_move_tail(&dev->power.entry, &dpm_late_early_list);
 		mutex_unlock(&dpm_list_mtx);
 
-		error = device_resume_noirq(dev, state);
-		if (error) {
-			suspend_stats.failed_resume_noirq++;
-			dpm_save_failed_step(SUSPEND_RESUME_NOIRQ);
-			dpm_save_failed_dev(dev_name(dev));
-			pm_dev_err(dev, state, " noirq", error);
+		if (!is_async(dev)) {
+			int error;
+			error = device_resume_noirq(dev, state);
+			if (error) {
+				suspend_stats.failed_resume_noirq++;
+				dpm_save_failed_step(SUSPEND_RESUME_NOIRQ);
+				dpm_save_failed_dev(dev_name(dev));
+				pm_dev_err(dev, state, " noirq", error);
+			}
 		}
-
 		mutex_lock(&dpm_list_mtx);
 		put_device(dev);
 	}
 	mutex_unlock(&dpm_list_mtx);
+	async_synchronize_full();
 	dpm_show_time(starttime, state, "noirq");
 	resume_device_irqs();
 	cpuidle_resume();
-- 
1.7.9.5



