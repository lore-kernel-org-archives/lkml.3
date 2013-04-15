Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948Ab3DONEg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 09:04:36 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:44978 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054Ab3DONEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 09:04:32 -0400
From: Grygorii Strashko <grygorii.strashko@ti.com>
To: Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Grygorii Strashko <grygorii.strashko@ti.com>,
        <linux-kernel@vger.kernel.org>, Mike Turquette <mturquette@linaro.org>,
        Nishanth Menon <nm@ti.com>, Tero Kristo <t-kristo@ti.com>,
        linux-omap <linux-omap@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
Subject: [RFC v1] regulator: core: introduce regulator chain locking scheme
Date: Mon, 15 Apr 2013 16:03:35 +0300
Message-ID: <1366031015-17073-2-git-send-email-grygorii.strashko@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1366031015-17073-1-git-send-email-grygorii.strashko@ti.com>
References: <1366031015-17073-1-git-send-email-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In some cases the regulators may be organized in a chain like:
  ->regA->regB->regC
where regA is supplier for regB and regB is supplier for regC.

Currently it would be possible to reconfigure regA and regC at same time
form different contexts, because each regulator has it own mutex.
But in some cases, the only the whole chain is allowed be reconfigured
because of dependencies between regulators - to change regB
configuration the regA need to be updated first.

Hence, introduce regulator chain locking scheme to lock whole Regulator
chain in case if any part of it has been accessed from outside.

To achieve this goal:
- abstract regulator locking out into helper functions;
- use the root Regulator (which has no supply defined, like regA) in chain to
  protect the whole chain;
- implement regulator chain locking scheme as proposed by Thomas Gleixner for CCF
  re-entrance in https://lkml.org/lkml/2013/3/27/171 and in the similar way as
  it is done for CCF by Mike Turquette in https://lkml.org/lkml/2013/3/28/512

In addition, such locking scheme allows to have access to the supplier
regulator API from inside child's (consumer) regulator API.

Cc: linux-kernel@vger.kernel.org
Cc: Mike Turquette <mturquette@linaro.org>
Cc: Nishanth Menon <nm@ti.com>
Cc: Tero Kristo <t-kristo@ti.com>
Cc: linux-omap <linux-omap@vger.kernel.org>
Cc: linux-arm <linux-arm-kernel@lists.infradead.org>

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/regulator/core.c         |  134 ++++++++++++++++++++++++--------------
 include/linux/regulator/driver.h |    2 +
 2 files changed, 88 insertions(+), 48 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index e3661c2..089cc63 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -110,6 +110,44 @@ static const char *rdev_get_name(struct regulator_dev *rdev)
 		return "";
 }
 
+static void regulator_lock(struct regulator_dev *rdev)
+{
+	struct regulator_dev *locking_rdev = rdev;
+
+	while (locking_rdev->supply)
+		locking_rdev = locking_rdev->supply->rdev;
+
+	if (!mutex_trylock(&locking_rdev->mutex)) {
+		if (locking_rdev->lock_owner == current) {
+			locking_rdev->lock_count++;
+			return;
+		}
+		mutex_lock(&locking_rdev->mutex);
+	}
+
+	WARN_ON_ONCE(locking_rdev->lock_owner != NULL);
+	WARN_ON_ONCE(locking_rdev->lock_count != 0);
+
+	locking_rdev->lock_count = 1;
+	locking_rdev->lock_owner = current;
+	dev_dbg(&locking_rdev->dev, "Is locked. locking %s\n",
+		rdev_get_name(rdev));
+}
+
+static void regulator_unlock(struct regulator_dev *rdev)
+{
+	struct regulator_dev *locking_rdev = rdev;
+
+	while (locking_rdev->supply)
+		locking_rdev = locking_rdev->supply->rdev;
+
+	if (--locking_rdev->lock_count)
+		return;
+
+	locking_rdev->lock_owner = NULL;
+	mutex_unlock(&locking_rdev->mutex);
+}
+
 /**
  * of_get_regulator - get a regulator device node based on supply name
  * @dev: Device pointer for the consumer (of regulator) device
@@ -292,9 +330,9 @@ static ssize_t regulator_uV_show(struct device *dev,
 	struct regulator_dev *rdev = dev_get_drvdata(dev);
 	ssize_t ret;
 
-	mutex_lock(&rdev->mutex);
+	regulator_lock(rdev);
 	ret = sprintf(buf, "%d\n", _regulator_get_voltage(rdev));
-	mutex_unlock(&rdev->mutex);
+	regulator_unlock(rdev);
 
 	return ret;
 }
@@ -357,9 +395,9 @@ static ssize_t regulator_state_show(struct device *dev,
 	struct regulator_dev *rdev = dev_get_drvdata(dev);
 	ssize_t ret;
 
-	mutex_lock(&rdev->mutex);
+	regulator_lock(rdev);
 	ret = regulator_print_state(buf, _regulator_is_enabled(rdev));
-	mutex_unlock(&rdev->mutex);
+	regulator_unlock(rdev);
 
 	return ret;
 }
@@ -467,10 +505,10 @@ static ssize_t regulator_total_uA_show(struct device *dev,
 	struct regulator *regulator;
 	int uA = 0;
 
-	mutex_lock(&rdev->mutex);
+	regulator_lock(rdev);
 	list_for_each_entry(regulator, &rdev->consumer_list, list)
 		uA += regulator->uA_load;
-	mutex_unlock(&rdev->mutex);
+	regulator_unlock(rdev);
 	return sprintf(buf, "%d\n", uA);
 }
 static DEVICE_ATTR(requested_microamps, 0444, regulator_total_uA_show, NULL);
@@ -1104,7 +1142,7 @@ static struct regulator *create_regulator(struct regulator_dev *rdev,
 	if (regulator == NULL)
 		return NULL;
 
-	mutex_lock(&rdev->mutex);
+	regulator_lock(rdev);
 	regulator->rdev = rdev;
 	list_add(&regulator->list, &rdev->consumer_list);
 
@@ -1156,12 +1194,12 @@ static struct regulator *create_regulator(struct regulator_dev *rdev,
 	    _regulator_is_enabled(rdev))
 		regulator->always_on = true;
 
-	mutex_unlock(&rdev->mutex);
+	regulator_unlock(rdev);
 	return regulator;
 overflow_err:
 	list_del(&regulator->list);
 	kfree(regulator);
-	mutex_unlock(&rdev->mutex);
+	regulator_unlock(rdev);
 	return NULL;
 }
 
@@ -1558,9 +1596,9 @@ int regulator_enable(struct regulator *regulator)
 			return ret;
 	}
 
-	mutex_lock(&rdev->mutex);
+	regulator_lock(rdev);
 	ret = _regulator_enable(rdev);
-	mutex_unlock(&rdev->mutex);
+	regulator_unlock(rdev);
 
 	if (ret != 0 && rdev->supply)
 		regulator_disable(rdev->supply);
@@ -1649,9 +1687,9 @@ int regulator_disable(struct regulator *regulator)
 	if (regulator->always_on)
 		return 0;
 
-	mutex_lock(&rdev->mutex);
+	regulator_lock(rdev);
 	ret = _regulator_disable(rdev);
-	mutex_unlock(&rdev->mutex);
+	regulator_unlock(rdev);
 
 	if (ret == 0 && rdev->supply)
 		regulator_disable(rdev->supply);
@@ -1695,10 +1733,10 @@ int regulator_force_disable(struct regulator *regulator)
 	struct regulator_dev *rdev = regulator->rdev;
 	int ret;
 
-	mutex_lock(&rdev->mutex);
+	regulator_lock(rdev);
 	regulator->uA_load = 0;
 	ret = _regulator_force_disable(regulator->rdev);
-	mutex_unlock(&rdev->mutex);
+	regulator_unlock(rdev);
 
 	if (rdev->supply)
 		while (rdev->open_count--)
@@ -1714,7 +1752,7 @@ static void regulator_disable_work(struct work_struct *work)
 						  disable_work.work);
 	int count, i, ret;
 
-	mutex_lock(&rdev->mutex);
+	regulator_lock(rdev);
 
 	BUG_ON(!rdev->deferred_disables);
 
@@ -1727,7 +1765,7 @@ static void regulator_disable_work(struct work_struct *work)
 			rdev_err(rdev, "Deferred disable failed: %d\n", ret);
 	}
 
-	mutex_unlock(&rdev->mutex);
+	regulator_unlock(rdev);
 
 	if (rdev->supply) {
 		for (i = 0; i < count; i++) {
@@ -1763,9 +1801,9 @@ int regulator_disable_deferred(struct regulator *regulator, int ms)
 	if (!ms)
 		return regulator_disable(regulator);
 
-	mutex_lock(&rdev->mutex);
+	regulator_lock(rdev);
 	rdev->deferred_disables++;
-	mutex_unlock(&rdev->mutex);
+	regulator_unlock(rdev);
 
 	ret = schedule_delayed_work(&rdev->disable_work,
 				    msecs_to_jiffies(ms));
@@ -1863,9 +1901,9 @@ int regulator_is_enabled(struct regulator *regulator)
 	if (regulator->always_on)
 		return 1;
 
-	mutex_lock(&regulator->rdev->mutex);
+	regulator_lock(regulator->rdev);
 	ret = _regulator_is_enabled(regulator->rdev);
-	mutex_unlock(&regulator->rdev->mutex);
+	regulator_unlock(regulator->rdev);
 
 	return ret;
 }
@@ -1983,9 +2021,9 @@ int regulator_list_voltage(struct regulator *regulator, unsigned selector)
 	if (!ops->list_voltage || selector >= rdev->desc->n_voltages)
 		return -EINVAL;
 
-	mutex_lock(&rdev->mutex);
+	regulator_lock(rdev);
 	ret = ops->list_voltage(rdev, selector);
-	mutex_unlock(&rdev->mutex);
+	regulator_unlock(rdev);
 
 	if (ret > 0) {
 		if (ret < rdev->constraints->min_uV)
@@ -2309,7 +2347,7 @@ int regulator_set_voltage(struct regulator *regulator, int min_uV, int max_uV)
 	int ret = 0;
 	int old_min_uV, old_max_uV;
 
-	mutex_lock(&rdev->mutex);
+	regulator_lock(rdev);
 
 	/* If we're setting the same range as last time the change
 	 * should be a noop (some cpufreq implementations use the same
@@ -2345,12 +2383,12 @@ int regulator_set_voltage(struct regulator *regulator, int min_uV, int max_uV)
 		goto out2;
 	
 out:
-	mutex_unlock(&rdev->mutex);
+	regulator_unlock(rdev);
 	return ret;
 out2:
 	regulator->min_uV = old_min_uV;
 	regulator->max_uV = old_max_uV;
-	mutex_unlock(&rdev->mutex);
+	regulator_unlock(rdev);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(regulator_set_voltage);
@@ -2453,7 +2491,7 @@ int regulator_sync_voltage(struct regulator *regulator)
 	struct regulator_dev *rdev = regulator->rdev;
 	int ret, min_uV, max_uV;
 
-	mutex_lock(&rdev->mutex);
+	regulator_lock(rdev);
 
 	if (!rdev->desc->ops->set_voltage &&
 	    !rdev->desc->ops->set_voltage_sel) {
@@ -2482,7 +2520,7 @@ int regulator_sync_voltage(struct regulator *regulator)
 	ret = _regulator_do_set_voltage(rdev, min_uV, max_uV);
 
 out:
-	mutex_unlock(&rdev->mutex);
+	regulator_unlock(rdev);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(regulator_sync_voltage);
@@ -2522,11 +2560,11 @@ int regulator_get_voltage(struct regulator *regulator)
 {
 	int ret;
 
-	mutex_lock(&regulator->rdev->mutex);
+	regulator_lock(regulator->rdev);
 
 	ret = _regulator_get_voltage(regulator->rdev);
 
-	mutex_unlock(&regulator->rdev->mutex);
+	regulator_unlock(regulator->rdev);
 
 	return ret;
 }
@@ -2554,7 +2592,7 @@ int regulator_set_current_limit(struct regulator *regulator,
 	struct regulator_dev *rdev = regulator->rdev;
 	int ret;
 
-	mutex_lock(&rdev->mutex);
+	regulator_lock(rdev);
 
 	/* sanity check */
 	if (!rdev->desc->ops->set_current_limit) {
@@ -2569,7 +2607,7 @@ int regulator_set_current_limit(struct regulator *regulator,
 
 	ret = rdev->desc->ops->set_current_limit(rdev, min_uA, max_uA);
 out:
-	mutex_unlock(&rdev->mutex);
+	regulator_unlock(rdev);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(regulator_set_current_limit);
@@ -2578,7 +2616,7 @@ static int _regulator_get_current_limit(struct regulator_dev *rdev)
 {
 	int ret;
 
-	mutex_lock(&rdev->mutex);
+	regulator_lock(rdev);
 
 	/* sanity check */
 	if (!rdev->desc->ops->get_current_limit) {
@@ -2588,7 +2626,7 @@ static int _regulator_get_current_limit(struct regulator_dev *rdev)
 
 	ret = rdev->desc->ops->get_current_limit(rdev);
 out:
-	mutex_unlock(&rdev->mutex);
+	regulator_unlock(rdev);
 	return ret;
 }
 
@@ -2624,7 +2662,7 @@ int regulator_set_mode(struct regulator *regulator, unsigned int mode)
 	int ret;
 	int regulator_curr_mode;
 
-	mutex_lock(&rdev->mutex);
+	regulator_lock(rdev);
 
 	/* sanity check */
 	if (!rdev->desc->ops->set_mode) {
@@ -2648,7 +2686,7 @@ int regulator_set_mode(struct regulator *regulator, unsigned int mode)
 
 	ret = rdev->desc->ops->set_mode(rdev, mode);
 out:
-	mutex_unlock(&rdev->mutex);
+	regulator_unlock(rdev);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(regulator_set_mode);
@@ -2657,7 +2695,7 @@ static unsigned int _regulator_get_mode(struct regulator_dev *rdev)
 {
 	int ret;
 
-	mutex_lock(&rdev->mutex);
+	regulator_lock(rdev);
 
 	/* sanity check */
 	if (!rdev->desc->ops->get_mode) {
@@ -2667,7 +2705,7 @@ static unsigned int _regulator_get_mode(struct regulator_dev *rdev)
 
 	ret = rdev->desc->ops->get_mode(rdev);
 out:
-	mutex_unlock(&rdev->mutex);
+	regulator_unlock(rdev);
 	return ret;
 }
 
@@ -2719,7 +2757,7 @@ int regulator_set_optimum_mode(struct regulator *regulator, int uA_load)
 	if (rdev->supply)
 		input_uV = regulator_get_voltage(rdev->supply);
 
-	mutex_lock(&rdev->mutex);
+	regulator_lock(rdev);
 
 	/*
 	 * first check to see if we can set modes at all, otherwise just
@@ -2780,7 +2818,7 @@ int regulator_set_optimum_mode(struct regulator *regulator, int uA_load)
 	}
 	ret = mode;
 out:
-	mutex_unlock(&rdev->mutex);
+	regulator_unlock(rdev);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(regulator_set_optimum_mode);
@@ -2849,7 +2887,7 @@ int regulator_allow_bypass(struct regulator *regulator, bool enable)
 	    !(rdev->constraints->valid_ops_mask & REGULATOR_CHANGE_BYPASS))
 		return 0;
 
-	mutex_lock(&rdev->mutex);
+	regulator_lock(rdev);
 
 	if (enable && !regulator->bypass) {
 		rdev->bypass_count++;
@@ -2873,7 +2911,7 @@ int regulator_allow_bypass(struct regulator *regulator, bool enable)
 	if (ret == 0)
 		regulator->bypass = enable;
 
-	mutex_unlock(&rdev->mutex);
+	regulator_unlock(rdev);
 
 	return ret;
 }
@@ -3588,9 +3626,9 @@ int regulator_suspend_prepare(suspend_state_t state)
 	mutex_lock(&regulator_list_mutex);
 	list_for_each_entry(rdev, &regulator_list, list) {
 
-		mutex_lock(&rdev->mutex);
+		regulator_lock(rdev);
 		ret = suspend_prepare(rdev, state);
-		mutex_unlock(&rdev->mutex);
+		regulator_unlock(rdev);
 
 		if (ret < 0) {
 			rdev_err(rdev, "failed to prepare\n");
@@ -3618,7 +3656,7 @@ int regulator_suspend_finish(void)
 	list_for_each_entry(rdev, &regulator_list, list) {
 		struct regulator_ops *ops = rdev->desc->ops;
 
-		mutex_lock(&rdev->mutex);
+		regulator_lock(rdev);
 		if ((rdev->use_count > 0  || rdev->constraints->always_on) &&
 				ops->enable) {
 			error = ops->enable(rdev);
@@ -3637,7 +3675,7 @@ int regulator_suspend_finish(void)
 				ret = error;
 		}
 unlock:
-		mutex_unlock(&rdev->mutex);
+		regulator_unlock(rdev);
 	}
 	mutex_unlock(&regulator_list_mutex);
 	return ret;
@@ -3825,7 +3863,7 @@ static int __init regulator_init_complete(void)
 		if (!ops->disable || (c && c->always_on))
 			continue;
 
-		mutex_lock(&rdev->mutex);
+		regulator_lock(rdev);
 
 		if (rdev->use_count)
 			goto unlock;
@@ -3857,7 +3895,7 @@ static int __init regulator_init_complete(void)
 		}
 
 unlock:
-		mutex_unlock(&rdev->mutex);
+		regulator_unlock(rdev);
 	}
 
 	mutex_unlock(&regulator_list_mutex);
diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index 7df93f5..6bfa2af 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -289,6 +289,8 @@ struct regulator_dev {
 
 	struct blocking_notifier_head notifier;
 	struct mutex mutex; /* consumer lock */
+	struct task_struct *lock_owner; /* consumer thread context */
+	int lock_count; /* number of recursive locks taken */
 	struct module *owner;
 	struct device dev;
 	struct regulation_constraints *constraints;
-- 
1.7.9.5

