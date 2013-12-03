Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752653Ab3LCFu5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 00:50:57 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:34677 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438Ab3LCFuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 00:50:55 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, nm@ti.com, ceh@ti.com,
        dirk.brandewie@gmail.com, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V5 1/2] cpufreq: Mark ARM drivers with CPUFREQ_NEED_INITIAL_FREQ_CHECK flag
Date: Tue,  3 Dec 2013 11:20:45 +0530
Message-Id: <9d053f4218adb8b1b1527a3a37d5ceffbbc5f1c3.1386049700.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes boot loaders set CPU frequency to a value outside of frequency table
present with cpufreq core. In such cases CPU might be unstable if it has to run
on that frequency for long duration of time and so its better to set it to a
frequency which is specified in frequency table.

On some systems we can't really say what frequency we're running at the moment
and so for these we shouldn't check if we are running at a frequency present in
frequency table. And so we really can't force this for all the cpufreq drivers.

Hence we are created another flag here: CPUFREQ_NEED_INITIAL_FREQ_CHECK that
will be marked by platforms which want to go for this check at boot time.

Initially this is done for all ARM platforms but others may follow if required.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
V4->V5:
- Inverted flag, moved to CPUFREQ_NEED_INITIAL_FREQ_CHECK instead of
  CPUFREQ_SKIP_INITIAL_FREQ_CHECK and so this patch does it now for all the ARM
  drivers.
- Flag and its usage expression changed in 2/2 as well..

 drivers/cpufreq/arm_big_little.c     | 3 ++-
 drivers/cpufreq/davinci-cpufreq.c    | 2 +-
 drivers/cpufreq/dbx500-cpufreq.c     | 3 ++-
 drivers/cpufreq/exynos-cpufreq.c     | 2 +-
 drivers/cpufreq/exynos5440-cpufreq.c | 3 ++-
 drivers/cpufreq/imx6q-cpufreq.c      | 1 +
 drivers/cpufreq/integrator-cpufreq.c | 1 +
 drivers/cpufreq/kirkwood-cpufreq.c   | 1 +
 drivers/cpufreq/omap-cpufreq.c       | 2 +-
 drivers/cpufreq/pxa2xx-cpufreq.c     | 1 +
 drivers/cpufreq/pxa3xx-cpufreq.c     | 1 +
 drivers/cpufreq/s3c2416-cpufreq.c    | 2 +-
 drivers/cpufreq/s3c24xx-cpufreq.c    | 2 +-
 drivers/cpufreq/s3c64xx-cpufreq.c    | 2 +-
 drivers/cpufreq/s5pv210-cpufreq.c    | 2 +-
 drivers/cpufreq/sa1100-cpufreq.c     | 2 +-
 drivers/cpufreq/sa1110-cpufreq.c     | 2 +-
 drivers/cpufreq/spear-cpufreq.c      | 2 +-
 drivers/cpufreq/tegra-cpufreq.c      | 1 +
 include/linux/cpufreq.h              | 9 +++++++++
 20 files changed, 31 insertions(+), 13 deletions(-)

diff --git a/drivers/cpufreq/arm_big_little.c b/drivers/cpufreq/arm_big_little.c
index 5519933..72f87e9 100644
--- a/drivers/cpufreq/arm_big_little.c
+++ b/drivers/cpufreq/arm_big_little.c
@@ -488,7 +488,8 @@ static int bL_cpufreq_exit(struct cpufreq_policy *policy)
 static struct cpufreq_driver bL_cpufreq_driver = {
 	.name			= "arm-big-little",
 	.flags			= CPUFREQ_STICKY |
-					CPUFREQ_HAVE_GOVERNOR_PER_POLICY,
+					CPUFREQ_HAVE_GOVERNOR_PER_POLICY |
+					CPUFREQ_NEED_INITIAL_FREQ_CHECK,
 	.verify			= cpufreq_generic_frequency_table_verify,
 	.target_index		= bL_cpufreq_set_target,
 	.get			= bL_cpufreq_get_rate,
diff --git a/drivers/cpufreq/davinci-cpufreq.c b/drivers/cpufreq/davinci-cpufreq.c
index 5e8a854..04f3390 100644
--- a/drivers/cpufreq/davinci-cpufreq.c
+++ b/drivers/cpufreq/davinci-cpufreq.c
@@ -126,7 +126,7 @@ static int davinci_cpu_init(struct cpufreq_policy *policy)
 }
 
 static struct cpufreq_driver davinci_driver = {
-	.flags		= CPUFREQ_STICKY,
+	.flags		= CPUFREQ_STICKY | CPUFREQ_NEED_INITIAL_FREQ_CHECK,
 	.verify		= davinci_verify_speed,
 	.target_index	= davinci_target,
 	.get		= davinci_getspeed,
diff --git a/drivers/cpufreq/dbx500-cpufreq.c b/drivers/cpufreq/dbx500-cpufreq.c
index 0e67ab9..21d9898 100644
--- a/drivers/cpufreq/dbx500-cpufreq.c
+++ b/drivers/cpufreq/dbx500-cpufreq.c
@@ -48,7 +48,8 @@ static int dbx500_cpufreq_init(struct cpufreq_policy *policy)
 }
 
 static struct cpufreq_driver dbx500_cpufreq_driver = {
-	.flags  = CPUFREQ_STICKY | CPUFREQ_CONST_LOOPS,
+	.flags  = CPUFREQ_STICKY | CPUFREQ_CONST_LOOPS |
+			CPUFREQ_NEED_INITIAL_FREQ_CHECK,
 	.verify = cpufreq_generic_frequency_table_verify,
 	.target_index = dbx500_cpufreq_target,
 	.get    = dbx500_cpufreq_getspeed,
diff --git a/drivers/cpufreq/exynos-cpufreq.c b/drivers/cpufreq/exynos-cpufreq.c
index f3c2287..85e67dc 100644
--- a/drivers/cpufreq/exynos-cpufreq.c
+++ b/drivers/cpufreq/exynos-cpufreq.c
@@ -218,7 +218,7 @@ static int exynos_cpufreq_cpu_init(struct cpufreq_policy *policy)
 }
 
 static struct cpufreq_driver exynos_driver = {
-	.flags		= CPUFREQ_STICKY,
+	.flags		= CPUFREQ_STICKY | CPUFREQ_NEED_INITIAL_FREQ_CHECK,
 	.verify		= cpufreq_generic_frequency_table_verify,
 	.target_index	= exynos_target,
 	.get		= exynos_getspeed,
diff --git a/drivers/cpufreq/exynos5440-cpufreq.c b/drivers/cpufreq/exynos5440-cpufreq.c
index 76bef8b..ffe6fae 100644
--- a/drivers/cpufreq/exynos5440-cpufreq.c
+++ b/drivers/cpufreq/exynos5440-cpufreq.c
@@ -312,7 +312,8 @@ static int exynos_cpufreq_cpu_init(struct cpufreq_policy *policy)
 }
 
 static struct cpufreq_driver exynos_driver = {
-	.flags		= CPUFREQ_STICKY | CPUFREQ_ASYNC_NOTIFICATION,
+	.flags		= CPUFREQ_STICKY | CPUFREQ_ASYNC_NOTIFICATION |
+				CPUFREQ_NEED_INITIAL_FREQ_CHECK,
 	.verify		= cpufreq_generic_frequency_table_verify,
 	.target_index	= exynos_target,
 	.get		= exynos_getspeed,
diff --git a/drivers/cpufreq/imx6q-cpufreq.c b/drivers/cpufreq/imx6q-cpufreq.c
index 4b3f18e..530ce9a 100644
--- a/drivers/cpufreq/imx6q-cpufreq.c
+++ b/drivers/cpufreq/imx6q-cpufreq.c
@@ -138,6 +138,7 @@ static int imx6q_cpufreq_init(struct cpufreq_policy *policy)
 }
 
 static struct cpufreq_driver imx6q_cpufreq_driver = {
+	.flags = CPUFREQ_NEED_INITIAL_FREQ_CHECK,
 	.verify = cpufreq_generic_frequency_table_verify,
 	.target_index = imx6q_set_target,
 	.get = imx6q_get_speed,
diff --git a/drivers/cpufreq/integrator-cpufreq.c b/drivers/cpufreq/integrator-cpufreq.c
index 7d8ab000d..0e27844 100644
--- a/drivers/cpufreq/integrator-cpufreq.c
+++ b/drivers/cpufreq/integrator-cpufreq.c
@@ -190,6 +190,7 @@ static int integrator_cpufreq_init(struct cpufreq_policy *policy)
 }
 
 static struct cpufreq_driver integrator_driver = {
+	.flags		= CPUFREQ_NEED_INITIAL_FREQ_CHECK,
 	.verify		= integrator_verify_policy,
 	.target		= integrator_set_target,
 	.get		= integrator_get,
diff --git a/drivers/cpufreq/kirkwood-cpufreq.c b/drivers/cpufreq/kirkwood-cpufreq.c
index 0767a4e..eb7abe3 100644
--- a/drivers/cpufreq/kirkwood-cpufreq.c
+++ b/drivers/cpufreq/kirkwood-cpufreq.c
@@ -97,6 +97,7 @@ static int kirkwood_cpufreq_cpu_init(struct cpufreq_policy *policy)
 }
 
 static struct cpufreq_driver kirkwood_cpufreq_driver = {
+	.flags	= CPUFREQ_NEED_INITIAL_FREQ_CHECK,
 	.get	= kirkwood_cpufreq_get_cpu_frequency,
 	.verify	= cpufreq_generic_frequency_table_verify,
 	.target_index = kirkwood_cpufreq_target,
diff --git a/drivers/cpufreq/omap-cpufreq.c b/drivers/cpufreq/omap-cpufreq.c
index a0acd0b..5de1e5f 100644
--- a/drivers/cpufreq/omap-cpufreq.c
+++ b/drivers/cpufreq/omap-cpufreq.c
@@ -162,7 +162,7 @@ static int omap_cpu_exit(struct cpufreq_policy *policy)
 }
 
 static struct cpufreq_driver omap_driver = {
-	.flags		= CPUFREQ_STICKY,
+	.flags		= CPUFREQ_STICKY | CPUFREQ_NEED_INITIAL_FREQ_CHECK,
 	.verify		= cpufreq_generic_frequency_table_verify,
 	.target_index	= omap_target,
 	.get		= omap_getspeed,
diff --git a/drivers/cpufreq/pxa2xx-cpufreq.c b/drivers/cpufreq/pxa2xx-cpufreq.c
index 0a0f436..a9195a8 100644
--- a/drivers/cpufreq/pxa2xx-cpufreq.c
+++ b/drivers/cpufreq/pxa2xx-cpufreq.c
@@ -423,6 +423,7 @@ static int pxa_cpufreq_init(struct cpufreq_policy *policy)
 }
 
 static struct cpufreq_driver pxa_cpufreq_driver = {
+	.flags	= CPUFREQ_NEED_INITIAL_FREQ_CHECK,
 	.verify	= cpufreq_generic_frequency_table_verify,
 	.target_index = pxa_set_target,
 	.init	= pxa_cpufreq_init,
diff --git a/drivers/cpufreq/pxa3xx-cpufreq.c b/drivers/cpufreq/pxa3xx-cpufreq.c
index 9384004..3785687 100644
--- a/drivers/cpufreq/pxa3xx-cpufreq.c
+++ b/drivers/cpufreq/pxa3xx-cpufreq.c
@@ -201,6 +201,7 @@ static int pxa3xx_cpufreq_init(struct cpufreq_policy *policy)
 }
 
 static struct cpufreq_driver pxa3xx_cpufreq_driver = {
+	.flags		= CPUFREQ_NEED_INITIAL_FREQ_CHECK,
 	.verify		= cpufreq_generic_frequency_table_verify,
 	.target_index	= pxa3xx_cpufreq_set,
 	.init		= pxa3xx_cpufreq_init,
diff --git a/drivers/cpufreq/s3c2416-cpufreq.c b/drivers/cpufreq/s3c2416-cpufreq.c
index 8d904a0..826b8be 100644
--- a/drivers/cpufreq/s3c2416-cpufreq.c
+++ b/drivers/cpufreq/s3c2416-cpufreq.c
@@ -481,7 +481,7 @@ err_hclk:
 }
 
 static struct cpufreq_driver s3c2416_cpufreq_driver = {
-	.flags          = 0,
+	.flags		= CPUFREQ_NEED_INITIAL_FREQ_CHECK,
 	.verify		= cpufreq_generic_frequency_table_verify,
 	.target_index	= s3c2416_cpufreq_set_target,
 	.get		= s3c2416_cpufreq_get_speed,
diff --git a/drivers/cpufreq/s3c24xx-cpufreq.c b/drivers/cpufreq/s3c24xx-cpufreq.c
index 4850882..d38e50f 100644
--- a/drivers/cpufreq/s3c24xx-cpufreq.c
+++ b/drivers/cpufreq/s3c24xx-cpufreq.c
@@ -448,7 +448,7 @@ static int s3c_cpufreq_resume(struct cpufreq_policy *policy)
 #endif
 
 static struct cpufreq_driver s3c24xx_driver = {
-	.flags		= CPUFREQ_STICKY,
+	.flags		= CPUFREQ_STICKY | CPUFREQ_NEED_INITIAL_FREQ_CHECK,
 	.target		= s3c_cpufreq_target,
 	.get		= s3c_cpufreq_get,
 	.init		= s3c_cpufreq_init,
diff --git a/drivers/cpufreq/s3c64xx-cpufreq.c b/drivers/cpufreq/s3c64xx-cpufreq.c
index 67e302e..8435f45 100644
--- a/drivers/cpufreq/s3c64xx-cpufreq.c
+++ b/drivers/cpufreq/s3c64xx-cpufreq.c
@@ -226,7 +226,7 @@ static int s3c64xx_cpufreq_driver_init(struct cpufreq_policy *policy)
 }
 
 static struct cpufreq_driver s3c64xx_cpufreq_driver = {
-	.flags          = 0,
+	.flags		= CPUFREQ_NEED_INITIAL_FREQ_CHECK,
 	.verify		= cpufreq_generic_frequency_table_verify,
 	.target_index	= s3c64xx_cpufreq_set_target,
 	.get		= s3c64xx_cpufreq_get_speed,
diff --git a/drivers/cpufreq/s5pv210-cpufreq.c b/drivers/cpufreq/s5pv210-cpufreq.c
index e3973da..ccd548c 100644
--- a/drivers/cpufreq/s5pv210-cpufreq.c
+++ b/drivers/cpufreq/s5pv210-cpufreq.c
@@ -560,7 +560,7 @@ static int s5pv210_cpufreq_reboot_notifier_event(struct notifier_block *this,
 }
 
 static struct cpufreq_driver s5pv210_driver = {
-	.flags		= CPUFREQ_STICKY,
+	.flags		= CPUFREQ_STICKY | CPUFREQ_NEED_INITIAL_FREQ_CHECK,
 	.verify		= cpufreq_generic_frequency_table_verify,
 	.target_index	= s5pv210_target,
 	.get		= s5pv210_getspeed,
diff --git a/drivers/cpufreq/sa1100-cpufreq.c b/drivers/cpufreq/sa1100-cpufreq.c
index 623da74..728eab7 100644
--- a/drivers/cpufreq/sa1100-cpufreq.c
+++ b/drivers/cpufreq/sa1100-cpufreq.c
@@ -201,7 +201,7 @@ static int __init sa1100_cpu_init(struct cpufreq_policy *policy)
 }
 
 static struct cpufreq_driver sa1100_driver __refdata = {
-	.flags		= CPUFREQ_STICKY,
+	.flags		= CPUFREQ_STICKY | CPUFREQ_NEED_INITIAL_FREQ_CHECK,
 	.verify		= cpufreq_generic_frequency_table_verify,
 	.target_index	= sa1100_target,
 	.get		= sa11x0_getspeed,
diff --git a/drivers/cpufreq/sa1110-cpufreq.c b/drivers/cpufreq/sa1110-cpufreq.c
index 2c2b2e6..5463767 100644
--- a/drivers/cpufreq/sa1110-cpufreq.c
+++ b/drivers/cpufreq/sa1110-cpufreq.c
@@ -312,7 +312,7 @@ static int __init sa1110_cpu_init(struct cpufreq_policy *policy)
 /* sa1110_driver needs __refdata because it must remain after init registers
  * it with cpufreq_register_driver() */
 static struct cpufreq_driver sa1110_driver __refdata = {
-	.flags		= CPUFREQ_STICKY,
+	.flags		= CPUFREQ_STICKY | CPUFREQ_NEED_INITIAL_FREQ_CHECK,
 	.verify		= cpufreq_generic_frequency_table_verify,
 	.target_index	= sa1110_target,
 	.get		= sa11x0_getspeed,
diff --git a/drivers/cpufreq/spear-cpufreq.c b/drivers/cpufreq/spear-cpufreq.c
index 45ea4c0..c7525fe 100644
--- a/drivers/cpufreq/spear-cpufreq.c
+++ b/drivers/cpufreq/spear-cpufreq.c
@@ -162,7 +162,7 @@ static int spear_cpufreq_init(struct cpufreq_policy *policy)
 
 static struct cpufreq_driver spear_cpufreq_driver = {
 	.name		= "cpufreq-spear",
-	.flags		= CPUFREQ_STICKY,
+	.flags		= CPUFREQ_STICKY | CPUFREQ_NEED_INITIAL_FREQ_CHECK,
 	.verify		= cpufreq_generic_frequency_table_verify,
 	.target_index	= spear_cpufreq_target,
 	.get		= spear_cpufreq_get,
diff --git a/drivers/cpufreq/tegra-cpufreq.c b/drivers/cpufreq/tegra-cpufreq.c
index b7309c3..01b5578 100644
--- a/drivers/cpufreq/tegra-cpufreq.c
+++ b/drivers/cpufreq/tegra-cpufreq.c
@@ -214,6 +214,7 @@ static int tegra_cpu_exit(struct cpufreq_policy *policy)
 }
 
 static struct cpufreq_driver tegra_cpufreq_driver = {
+	.flags		= CPUFREQ_NEED_INITIAL_FREQ_CHECK,
 	.verify		= cpufreq_generic_frequency_table_verify,
 	.target_index	= tegra_target,
 	.get		= tegra_getspeed,
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index ee5fe9d..bfb62cb 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -252,6 +252,15 @@ struct cpufreq_driver {
  */
 #define CPUFREQ_ASYNC_NOTIFICATION  (1 << 4)
 
+/*
+ * Set by drivers which want cpufreq core to check if CPU is running at a
+ * frequency present in freq-table exposed by the driver. For these drivers if
+ * CPU is found running at an out of table freq, we will try to set it to a freq
+ * from the table. And if that fails, we will stop further boot process by
+ * issuing a BUG_ON().
+ */
+#define CPUFREQ_NEED_INITIAL_FREQ_CHECK	(1 << 5)
+
 int cpufreq_register_driver(struct cpufreq_driver *driver_data);
 int cpufreq_unregister_driver(struct cpufreq_driver *driver_data);
 
-- 
1.7.12.rc2.18.g61b472e

