Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932614AbaEENeZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 09:34:25 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:37450 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932352AbaEENeX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 09:34:23 -0400
From: Nishanth Menon <nm@ti.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>
CC: Kevin Hilman <khilman@deeprootsystems.com>, <cpufreq@vger.kernel.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Nishanth Menon <nm@ti.com>
Subject: [PATCH 1/2] PM / OPP: Remove cpufreq wrapper dependency on internal data organization
Date: Mon, 5 May 2014 08:33:49 -0500
Message-ID: <1399296830-13056-2-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1399296830-13056-1-git-send-email-nm@ti.com>
References: <1399296830-13056-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CPUFREQ custom functions for OPP (Operating Performance Points)
currently exist inside the OPP library. These custom functions currently
depend on internal data structures to pick up OPP information to create
the cpufreq table.  For example, the cpufreq table is created precisely
in the same order of how OPP entries are stored inside the list implementation.

This kind of tight interdependency is purely artificial since the same
functionality can be achieved using the generic OPP functions
meant to do the same. This interdependency also limits the independent
modification of cpufreq and OPP library.

So use the generic dev_pm_opp_find_freq_ceil function that achieves the
table organization as we currently use.

As a result of this, we dont need to use the internal device_opp
structure anymore, and we hence we can switch over to rcu lock instead
of the mutex holding the internal list lock.

This breaking of dependency on internal data structure imposes no change
to usage of these.

NOTE: This change is a precursor to moving this cpufreq specific logic
out of the generic library into cpufreq.

Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Kevin Hilman <khilman@deeprootsystems.com>
Cc: cpufreq@vger.kernel.org
Cc: linux-samsung-soc@vger.kernel.org
Cc: linux-omap@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 drivers/base/power/opp.c |   55 +++++++++++++++++++++++-----------------------
 1 file changed, 28 insertions(+), 27 deletions(-)

diff --git a/drivers/base/power/opp.c b/drivers/base/power/opp.c
index 2553867..38b43bb 100644
--- a/drivers/base/power/opp.c
+++ b/drivers/base/power/opp.c
@@ -617,53 +617,54 @@ EXPORT_SYMBOL_GPL(dev_pm_opp_disable);
  * the table if any of the mentioned functions have been invoked in the interim.
  *
  * Locking: The internal device_opp and opp structures are RCU protected.
- * To simplify the logic, we pretend we are updater and hold relevant mutex here
- * Callers should ensure that this function is *NOT* called under RCU protection
- * or in contexts where mutex locking cannot be used.
+ * Since we just use the regular accessor functions to access the internal data
+ * structures, we use RCU read lock inside this function. As a result, users of
+ * this function DONOT need to use explicit locks for invoking.
  */
 int dev_pm_opp_init_cpufreq_table(struct device *dev,
 			    struct cpufreq_frequency_table **table)
 {
-	struct device_opp *dev_opp;
 	struct dev_pm_opp *opp;
-	struct cpufreq_frequency_table *freq_table;
-	int i = 0;
+	struct cpufreq_frequency_table *freq_table = NULL;
+	int i, max_opps, ret = 0;
+	unsigned long rate;
 
-	/* Pretend as if I am an updater */
-	mutex_lock(&dev_opp_list_lock);
+	rcu_read_lock();
 
-	dev_opp = find_device_opp(dev);
-	if (IS_ERR(dev_opp)) {
-		int r = PTR_ERR(dev_opp);
-		mutex_unlock(&dev_opp_list_lock);
-		dev_err(dev, "%s: Device OPP not found (%d)\n", __func__, r);
-		return r;
+	max_opps = dev_pm_opp_get_opp_count(dev);
+	if (max_opps <= 0) {
+		ret = max_opps ? max_opps : -ENODATA;
+		goto out;
 	}
 
-	freq_table = kzalloc(sizeof(struct cpufreq_frequency_table) *
-			     (dev_pm_opp_get_opp_count(dev) + 1), GFP_KERNEL);
+	freq_table = kzalloc(sizeof(*freq_table) * (max_opps + 1), GFP_KERNEL);
 	if (!freq_table) {
-		mutex_unlock(&dev_opp_list_lock);
-		dev_warn(dev, "%s: Unable to allocate frequency table\n",
-			__func__);
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto out;
 	}
 
-	list_for_each_entry(opp, &dev_opp->opp_list, node) {
-		if (opp->available) {
-			freq_table[i].driver_data = i;
-			freq_table[i].frequency = opp->rate / 1000;
-			i++;
+	for (i = 0, rate = 0; i < max_opps; i++, rate++) {
+		/* find next rate */
+		opp = dev_pm_opp_find_freq_ceil(dev, &rate);
+		if (IS_ERR(opp)) {
+			ret = PTR_ERR(opp);
+			goto out;
 		}
+		freq_table[i].driver_data = i;
+		freq_table[i].frequency = rate / 1000;
 	}
-	mutex_unlock(&dev_opp_list_lock);
 
 	freq_table[i].driver_data = i;
 	freq_table[i].frequency = CPUFREQ_TABLE_END;
 
 	*table = &freq_table[0];
 
-	return 0;
+out:
+	rcu_read_unlock();
+	if (ret)
+		kfree(freq_table);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(dev_pm_opp_init_cpufreq_table);
 
-- 
1.7.9.5

