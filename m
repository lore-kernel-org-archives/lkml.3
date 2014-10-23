Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421AbaJWMM0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 08:12:26 -0400
Received: from albert.telenet-ops.be ([195.130.137.90]:40671 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754980AbaJWMMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 08:12:16 -0400
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH 2/2] PM / Domains: Extract code to power off/on a PM domain
Date: Thu, 23 Oct 2014 14:12:16 +0200
Message-Id: <1414066336-11168-2-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414066336-11168-1-git-send-email-geert+renesas@glider.be>
References: <1414066336-11168-1-git-send-email-geert+renesas@glider.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PM domains are powered on/off from various places. Some callers do
latency measurements, others don't. Consolidate using two helper
functions, which always measure the latencies, and update the stored
latencies when needed.

Other minor changes:
  - Use pr_warn() instead of pr_warning(),
  - There's no need to check genpd->name, %s handles NULL pointers fine,
  - Make the warning format strings identical, to save memory.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
 drivers/base/power/domain.c | 101 ++++++++++++++++++++++++++------------------
 1 file changed, 60 insertions(+), 41 deletions(-)

diff --git a/drivers/base/power/domain.c b/drivers/base/power/domain.c
index 28d6e8bf746c4683..7b2007be51188ff8 100644
--- a/drivers/base/power/domain.c
+++ b/drivers/base/power/domain.c
@@ -151,6 +151,59 @@ static void genpd_recalc_cpu_exit_latency(struct generic_pm_domain *genpd)
 	genpd->cpuidle_data->idle_state->exit_latency = usecs64;
 }
 
+static int do_genpd_power_on(struct generic_pm_domain *genpd)
+{
+	ktime_t time_start;
+	s64 elapsed_ns;
+	int ret;
+
+	if (!genpd->power_on)
+		return 0;
+
+	time_start = ktime_get();
+	ret = genpd->power_on(genpd);
+	if (ret)
+		return ret;
+
+	elapsed_ns = ktime_to_ns(ktime_sub(ktime_get(), time_start));
+	if (elapsed_ns <= genpd->power_on_latency_ns)
+		return ret;
+
+	genpd->power_on_latency_ns = elapsed_ns;
+	genpd->max_off_time_changed = true;
+	genpd_recalc_cpu_exit_latency(genpd);
+	pr_warn("%s: Power-%s latency exceeded, new value %lld ns\n",
+		genpd->name, "on", elapsed_ns);
+
+	return ret;
+}
+
+static int do_genpd_power_off(struct generic_pm_domain *genpd)
+{
+	ktime_t time_start;
+	s64 elapsed_ns;
+	int ret;
+
+	if (!genpd->power_off)
+		return 0;
+
+	time_start = ktime_get();
+	ret = genpd->power_off(genpd);
+	if (ret == -EBUSY)
+		return ret;
+
+	elapsed_ns = ktime_to_ns(ktime_sub(ktime_get(), time_start));
+	if (elapsed_ns <= genpd->power_off_latency_ns)
+		return ret;
+
+	genpd->power_off_latency_ns = elapsed_ns;
+	genpd->max_off_time_changed = true;
+	pr_warn("%s: Power-%s latency exceeded, new value %lld ns\n",
+		genpd->name, "off", elapsed_ns);
+
+	return ret;
+}
+
 /**
  * __pm_genpd_poweron - Restore power to a given PM domain and its masters.
  * @genpd: PM domain to power up.
@@ -222,25 +275,9 @@ static int __pm_genpd_poweron(struct generic_pm_domain *genpd)
 		}
 	}
 
-	if (genpd->power_on) {
-		ktime_t time_start = ktime_get();
-		s64 elapsed_ns;
-
-		ret = genpd->power_on(genpd);
-		if (ret)
-			goto err;
-
-		elapsed_ns = ktime_to_ns(ktime_sub(ktime_get(), time_start));
-		if (elapsed_ns > genpd->power_on_latency_ns) {
-			genpd->power_on_latency_ns = elapsed_ns;
-			genpd->max_off_time_changed = true;
-			genpd_recalc_cpu_exit_latency(genpd);
-			if (genpd->name)
-				pr_warning("%s: Power-on latency exceeded, "
-					"new value %lld ns\n", genpd->name,
-					elapsed_ns);
-		}
-	}
+	ret = do_genpd_power_on(genpd);
+	if (ret)
+		goto err;
 
  out:
 	genpd_set_active(genpd);
@@ -529,16 +566,11 @@ static int pm_genpd_poweroff(struct generic_pm_domain *genpd)
 	}
 
 	if (genpd->power_off) {
-		ktime_t time_start;
-		s64 elapsed_ns;
-
 		if (atomic_read(&genpd->sd_count) > 0) {
 			ret = -EBUSY;
 			goto out;
 		}
 
-		time_start = ktime_get();
-
 		/*
 		 * If sd_count > 0 at this point, one of the subdomains hasn't
 		 * managed to call pm_genpd_poweron() for the master yet after
@@ -547,21 +579,11 @@ static int pm_genpd_poweroff(struct generic_pm_domain *genpd)
 		 * the pm_genpd_poweron() restore power for us (this shouldn't
 		 * happen very often).
 		 */
-		ret = genpd->power_off(genpd);
+		ret = do_genpd_power_off(genpd);
 		if (ret == -EBUSY) {
 			genpd_set_active(genpd);
 			goto out;
 		}
-
-		elapsed_ns = ktime_to_ns(ktime_sub(ktime_get(), time_start));
-		if (elapsed_ns > genpd->power_off_latency_ns) {
-			genpd->power_off_latency_ns = elapsed_ns;
-			genpd->max_off_time_changed = true;
-			if (genpd->name)
-				pr_warning("%s: Power-off latency exceeded, "
-					"new value %lld ns\n", genpd->name,
-					elapsed_ns);
-		}
 	}
 
 	genpd->status = GPD_STATE_POWER_OFF;
@@ -796,8 +818,7 @@ static void pm_genpd_sync_poweroff(struct generic_pm_domain *genpd)
 	    || atomic_read(&genpd->sd_count) > 0)
 		return;
 
-	if (genpd->power_off)
-		genpd->power_off(genpd);
+	do_genpd_power_off(genpd);
 
 	genpd->status = GPD_STATE_POWER_OFF;
 
@@ -828,8 +849,7 @@ static void pm_genpd_sync_poweron(struct generic_pm_domain *genpd)
 		genpd_sd_counter_inc(link->master);
 	}
 
-	if (genpd->power_on)
-		genpd->power_on(genpd);
+	do_genpd_power_on(genpd);
 
 	genpd->status = GPD_STATE_ACTIVE;
 }
@@ -1251,8 +1271,7 @@ static int pm_genpd_restore_noirq(struct device *dev)
 			 * If the domain was off before the hibernation, make
 			 * sure it will be off going forward.
 			 */
-			if (genpd->power_off)
-				genpd->power_off(genpd);
+			do_genpd_power_off(genpd);
 
 			return 0;
 		}
-- 
1.9.1

