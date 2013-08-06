Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510Ab3HFRYM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 13:24:12 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:52388 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756350Ab3HFRYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 13:24:07 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 04/11] cpufreq: Use sizeof(*ptr) form for finding size of a struct
Date: Tue,  6 Aug 2013 22:53:06 +0530
Message-Id: <e1acaa33d625248e691062141f15f2d113ec81b0.1375809311.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
In-Reply-To: <cover.1375809311.git.viresh.kumar@linaro.org>
References: <cover.1375809311.git.viresh.kumar@linaro.org>
In-Reply-To: <cover.1375809311.git.viresh.kumar@linaro.org>
References: <cover.1375809311.git.viresh.kumar@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chapter 14 of Documentation/CodingStyle says:

The preferred form for passing a size of a struct is the following:

	p = kmalloc(sizeof(*p), ...);

The alternative form where struct name is spelled out hurts readability and
introduces an opportunity for a bug when the pointer variable type is changed
but the corresponding sizeof that is passed to a memory allocator is not.

This wasn't followed consistently in drivers/cpufreq, lets make it more
consistent by always following this rule.

Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/acpi-cpufreq.c         |  4 ++--
 drivers/cpufreq/cpufreq.c              |  9 ++++-----
 drivers/cpufreq/cpufreq_conservative.c |  2 +-
 drivers/cpufreq/cpufreq_ondemand.c     |  2 +-
 drivers/cpufreq/cpufreq_stats.c        |  2 +-
 drivers/cpufreq/e_powersaver.c         |  4 ++--
 drivers/cpufreq/exynos-cpufreq.c       |  2 +-
 drivers/cpufreq/gx-suspmod.c           |  2 +-
 drivers/cpufreq/ia64-acpi-cpufreq.c    |  4 ++--
 drivers/cpufreq/pmac64-cpufreq.c       |  5 ++---
 drivers/cpufreq/powernow-k7.c          | 13 ++++++-------
 drivers/cpufreq/powernow-k8.c          |  6 +++---
 drivers/cpufreq/s3c24xx-cpufreq.c      |  6 +++---
 drivers/cpufreq/sparc-us2e-cpufreq.c   |  5 ++---
 drivers/cpufreq/sparc-us3-cpufreq.c    |  5 ++---
 15 files changed, 33 insertions(+), 38 deletions(-)

diff --git a/drivers/cpufreq/acpi-cpufreq.c b/drivers/cpufreq/acpi-cpufreq.c
index e673670..44758ce 100644
--- a/drivers/cpufreq/acpi-cpufreq.c
+++ b/drivers/cpufreq/acpi-cpufreq.c
@@ -709,7 +709,7 @@ static int acpi_cpufreq_cpu_init(struct cpufreq_policy *policy)
 		return blacklisted;
 #endif
 
-	data = kzalloc(sizeof(struct acpi_cpufreq_data), GFP_KERNEL);
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
 
@@ -799,7 +799,7 @@ static int acpi_cpufreq_cpu_init(struct cpufreq_policy *policy)
 		goto err_unreg;
 	}
 
-	data->freq_table = kmalloc(sizeof(struct cpufreq_frequency_table) *
+	data->freq_table = kmalloc(sizeof(*data->freq_table) *
 		    (perf->state_count+1), GFP_KERNEL);
 	if (!data->freq_table) {
 		result = -ENOMEM;
diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 8b087e5..7864a90 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -873,7 +873,7 @@ static void cpufreq_init_policy(struct cpufreq_policy *policy)
 	struct cpufreq_policy new_policy;
 	int ret = 0;
 
-	memcpy(&new_policy, policy, sizeof(struct cpufreq_policy));
+	memcpy(&new_policy, policy, sizeof(*policy));
 	/* assure that the starting sequence is run in __cpufreq_set_policy */
 	policy->governor = NULL;
 
@@ -1824,7 +1824,7 @@ int cpufreq_get_policy(struct cpufreq_policy *policy, unsigned int cpu)
 	if (!cpu_policy)
 		return -EINVAL;
 
-	memcpy(policy, cpu_policy, sizeof(struct cpufreq_policy));
+	memcpy(policy, cpu_policy, sizeof(*policy));
 
 	cpufreq_cpu_put(cpu_policy);
 	return 0;
@@ -1843,8 +1843,7 @@ static int __cpufreq_set_policy(struct cpufreq_policy *policy,
 	pr_debug("setting new policy for CPU %u: %u - %u kHz\n", new_policy->cpu,
 		new_policy->min, new_policy->max);
 
-	memcpy(&new_policy->cpuinfo, &policy->cpuinfo,
-				sizeof(struct cpufreq_cpuinfo));
+	memcpy(&new_policy->cpuinfo, &policy->cpuinfo, sizeof(policy->cpuinfo));
 
 	if (new_policy->min > policy->max || new_policy->max < policy->min) {
 		ret = -EINVAL;
@@ -1963,7 +1962,7 @@ int cpufreq_update_policy(unsigned int cpu)
 	}
 
 	pr_debug("updating policy for CPU %u\n", cpu);
-	memcpy(&new_policy, policy, sizeof(struct cpufreq_policy));
+	memcpy(&new_policy, policy, sizeof(*policy));
 	new_policy.min = policy->user_policy.min;
 	new_policy.max = policy->user_policy.max;
 	new_policy.policy = policy->user_policy.policy;
diff --git a/drivers/cpufreq/cpufreq_conservative.c b/drivers/cpufreq/cpufreq_conservative.c
index d2bd9ef..7f67a75 100644
--- a/drivers/cpufreq/cpufreq_conservative.c
+++ b/drivers/cpufreq/cpufreq_conservative.c
@@ -317,7 +317,7 @@ static int cs_init(struct dbs_data *dbs_data)
 {
 	struct cs_dbs_tuners *tuners;
 
-	tuners = kzalloc(sizeof(struct cs_dbs_tuners), GFP_KERNEL);
+	tuners = kzalloc(sizeof(*tuners), GFP_KERNEL);
 	if (!tuners) {
 		pr_err("%s: kzalloc failed\n", __func__);
 		return -ENOMEM;
diff --git a/drivers/cpufreq/cpufreq_ondemand.c b/drivers/cpufreq/cpufreq_ondemand.c
index 8f134b3..87f3305 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -482,7 +482,7 @@ static int od_init(struct dbs_data *dbs_data)
 	u64 idle_time;
 	int cpu;
 
-	tuners = kzalloc(sizeof(struct od_dbs_tuners), GFP_KERNEL);
+	tuners = kzalloc(sizeof(*tuners), GFP_KERNEL);
 	if (!tuners) {
 		pr_err("%s: kzalloc failed\n", __func__);
 		return -ENOMEM;
diff --git a/drivers/cpufreq/cpufreq_stats.c b/drivers/cpufreq/cpufreq_stats.c
index a17b14e..04452f0 100644
--- a/drivers/cpufreq/cpufreq_stats.c
+++ b/drivers/cpufreq/cpufreq_stats.c
@@ -198,7 +198,7 @@ static int cpufreq_stats_create_table(struct cpufreq_policy *policy,
 	unsigned int cpu = policy->cpu;
 	if (per_cpu(cpufreq_stats_table, cpu))
 		return -EBUSY;
-	stat = kzalloc(sizeof(struct cpufreq_stats), GFP_KERNEL);
+	stat = kzalloc(sizeof(*stat), GFP_KERNEL);
 	if ((stat) == NULL)
 		return -ENOMEM;
 
diff --git a/drivers/cpufreq/e_powersaver.c b/drivers/cpufreq/e_powersaver.c
index a60efae..de974be 100644
--- a/drivers/cpufreq/e_powersaver.c
+++ b/drivers/cpufreq/e_powersaver.c
@@ -54,7 +54,7 @@ static struct acpi_processor_performance *eps_acpi_cpu_perf;
 /* Minimum necessary to get acpi_processor_get_bios_limit() working */
 static int eps_acpi_init(void)
 {
-	eps_acpi_cpu_perf = kzalloc(sizeof(struct acpi_processor_performance),
+	eps_acpi_cpu_perf = kzalloc(sizeof(*eps_acpi_cpu_perf),
 				      GFP_KERNEL);
 	if (!eps_acpi_cpu_perf)
 		return -ENOMEM;
@@ -366,7 +366,7 @@ static int eps_cpu_init(struct cpufreq_policy *policy)
 		states = 2;
 
 	/* Allocate private data and frequency table for current cpu */
-	centaur = kzalloc(sizeof(struct eps_cpu_data)
+	centaur = kzalloc(sizeof(*centaur)
 		    + (states + 1) * sizeof(struct cpufreq_frequency_table),
 		    GFP_KERNEL);
 	if (!centaur)
diff --git a/drivers/cpufreq/exynos-cpufreq.c b/drivers/cpufreq/exynos-cpufreq.c
index 0d32f02..3664751 100644
--- a/drivers/cpufreq/exynos-cpufreq.c
+++ b/drivers/cpufreq/exynos-cpufreq.c
@@ -289,7 +289,7 @@ static int __init exynos_cpufreq_init(void)
 {
 	int ret = -EINVAL;
 
-	exynos_info = kzalloc(sizeof(struct exynos_dvfs_info), GFP_KERNEL);
+	exynos_info = kzalloc(sizeof(*exynos_info), GFP_KERNEL);
 	if (!exynos_info)
 		return -ENOMEM;
 
diff --git a/drivers/cpufreq/gx-suspmod.c b/drivers/cpufreq/gx-suspmod.c
index 3dfc99b..4f25fb6 100644
--- a/drivers/cpufreq/gx-suspmod.c
+++ b/drivers/cpufreq/gx-suspmod.c
@@ -466,7 +466,7 @@ static int __init cpufreq_gx_init(void)
 
 	pr_debug("geode suspend modulation available.\n");
 
-	params = kzalloc(sizeof(struct gxfreq_params), GFP_KERNEL);
+	params = kzalloc(sizeof(*params), GFP_KERNEL);
 	if (params == NULL)
 		return -ENOMEM;
 
diff --git a/drivers/cpufreq/ia64-acpi-cpufreq.c b/drivers/cpufreq/ia64-acpi-cpufreq.c
index 573c14e..08792dd 100644
--- a/drivers/cpufreq/ia64-acpi-cpufreq.c
+++ b/drivers/cpufreq/ia64-acpi-cpufreq.c
@@ -274,7 +274,7 @@ acpi_cpufreq_cpu_init (
 
 	pr_debug("acpi_cpufreq_cpu_init\n");
 
-	data = kzalloc(sizeof(struct cpufreq_acpi_io), GFP_KERNEL);
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
 	if (!data)
 		return (-ENOMEM);
 
@@ -304,7 +304,7 @@ acpi_cpufreq_cpu_init (
 	}
 
 	/* alloc freq_table */
-	data->freq_table = kmalloc(sizeof(struct cpufreq_frequency_table) *
+	data->freq_table = kmalloc(sizeof(*data->freq_table) *
 	                           (data->acpi_data.state_count + 1),
 	                           GFP_KERNEL);
 	if (!data->freq_table) {
diff --git a/drivers/cpufreq/pmac64-cpufreq.c b/drivers/cpufreq/pmac64-cpufreq.c
index 7ba4234..4d7799b 100644
--- a/drivers/cpufreq/pmac64-cpufreq.c
+++ b/drivers/cpufreq/pmac64-cpufreq.c
@@ -447,9 +447,8 @@ static int __init g5_neo2_cpufreq_init(struct device_node *cpus)
 		if (!shdr)
 			goto bail_noprops;
 		g5_fvt_table = (struct smu_sdbp_fvt *)&shdr[1];
-		ssize = (shdr->len * sizeof(u32)) -
-			sizeof(struct smu_sdbp_header);
-		g5_fvt_count = ssize / sizeof(struct smu_sdbp_fvt);
+		ssize = (shdr->len * sizeof(u32)) - sizeof(*shdr);
+		g5_fvt_count = ssize / sizeof(*g5_fvt_table);
 		g5_fvt_cur = 0;
 
 		/* Sanity checking */
diff --git a/drivers/cpufreq/powernow-k7.c b/drivers/cpufreq/powernow-k7.c
index 9558708..4687d40 100644
--- a/drivers/cpufreq/powernow-k7.c
+++ b/drivers/cpufreq/powernow-k7.c
@@ -177,7 +177,7 @@ static int get_ranges(unsigned char *pst)
 	unsigned int speed;
 	u8 fid, vid;
 
-	powernow_table = kzalloc((sizeof(struct cpufreq_frequency_table) *
+	powernow_table = kzalloc((sizeof(*powernow_table) *
 				(number_scales + 1)), GFP_KERNEL);
 	if (!powernow_table)
 		return -ENOMEM;
@@ -309,8 +309,7 @@ static int powernow_acpi_init(void)
 		goto err0;
 	}
 
-	acpi_processor_perf = kzalloc(sizeof(struct acpi_processor_performance),
-				      GFP_KERNEL);
+	acpi_processor_perf = kzalloc(sizeof(*acpi_processor_perf), GFP_KERNEL);
 	if (!acpi_processor_perf) {
 		retval = -ENOMEM;
 		goto err0;
@@ -346,7 +345,7 @@ static int powernow_acpi_init(void)
 		goto err2;
 	}
 
-	powernow_table = kzalloc((sizeof(struct cpufreq_frequency_table) *
+	powernow_table = kzalloc((sizeof(*powernow_table) *
 				(number_scales + 1)), GFP_KERNEL);
 	if (!powernow_table) {
 		retval = -ENOMEM;
@@ -497,7 +496,7 @@ static int powernow_decode_bios(int maxfid, int startvid)
 					"relevant to this CPU).\n",
 					psb->numpst);
 
-			p += sizeof(struct psb_s);
+			p += sizeof(*psb);
 
 			pst = (struct pst_s *) p;
 
@@ -510,12 +509,12 @@ static int powernow_decode_bios(int maxfid, int startvid)
 				    (maxfid == pst->maxfid) &&
 				    (startvid == pst->startvid)) {
 					print_pst_entry(pst, j);
-					p = (char *)pst + sizeof(struct pst_s);
+					p = (char *)pst + sizeof(*pst);
 					ret = get_ranges(p);
 					return ret;
 				} else {
 					unsigned int k;
-					p = (char *)pst + sizeof(struct pst_s);
+					p = (char *)pst + sizeof(*pst);
 					for (k = 0; k < number_scales; k++)
 						p += 2;
 				}
diff --git a/drivers/cpufreq/powernow-k8.c b/drivers/cpufreq/powernow-k8.c
index c39d189..3f3c6ca 100644
--- a/drivers/cpufreq/powernow-k8.c
+++ b/drivers/cpufreq/powernow-k8.c
@@ -623,7 +623,7 @@ static int fill_powernow_table(struct powernow_k8_data *data,
 	if (check_pst_table(data, pst, maxvid))
 		return -EINVAL;
 
-	powernow_table = kmalloc((sizeof(struct cpufreq_frequency_table)
+	powernow_table = kmalloc((sizeof(*powernow_table)
 		* (data->numps + 1)), GFP_KERNEL);
 	if (!powernow_table) {
 		printk(KERN_ERR PFX "powernow_table memory alloc failure\n");
@@ -793,7 +793,7 @@ static int powernow_k8_cpu_init_acpi(struct powernow_k8_data *data)
 	}
 
 	/* fill in data->powernow_table */
-	powernow_table = kmalloc((sizeof(struct cpufreq_frequency_table)
+	powernow_table = kmalloc((sizeof(*powernow_table)
 		* (data->acpi_data.state_count + 1)), GFP_KERNEL);
 	if (!powernow_table) {
 		pr_debug("powernow_table memory alloc failure\n");
@@ -1106,7 +1106,7 @@ static int powernowk8_cpu_init(struct cpufreq_policy *pol)
 	if (rc)
 		return -ENODEV;
 
-	data = kzalloc(sizeof(struct powernow_k8_data), GFP_KERNEL);
+	data = kzalloc(sizeof(*data), GFP_KERNEL);
 	if (!data) {
 		printk(KERN_ERR PFX "unable to alloc powernow_k8_data");
 		return -ENOMEM;
diff --git a/drivers/cpufreq/s3c24xx-cpufreq.c b/drivers/cpufreq/s3c24xx-cpufreq.c
index 87781eb..f169ee5 100644
--- a/drivers/cpufreq/s3c24xx-cpufreq.c
+++ b/drivers/cpufreq/s3c24xx-cpufreq.c
@@ -522,7 +522,7 @@ int __init s3c_cpufreq_setboard(struct s3c_cpufreq_board *board)
 	/* Copy the board information so that each board can make this
 	 * initdata. */
 
-	ours = kzalloc(sizeof(struct s3c_cpufreq_board), GFP_KERNEL);
+	ours = kzalloc(sizeof(*ours), GFP_KERNEL);
 	if (ours == NULL) {
 		printk(KERN_ERR "%s: no memory\n", __func__);
 		return -ENOMEM;
@@ -615,7 +615,7 @@ static int s3c_cpufreq_build_freq(void)
 	size = cpu_cur.info->calc_freqtable(&cpu_cur, NULL, 0);
 	size++;
 
-	ftab = kmalloc(sizeof(struct cpufreq_frequency_table) * size, GFP_KERNEL);
+	ftab = kmalloc(sizeof(*ftab) * size, GFP_KERNEL);
 	if (!ftab) {
 		printk(KERN_ERR "%s: no memory for tables\n", __func__);
 		return -ENOMEM;
@@ -691,7 +691,7 @@ int __init s3c_plltab_register(struct cpufreq_frequency_table *plls,
 	struct cpufreq_frequency_table *vals;
 	unsigned int size;
 
-	size = sizeof(struct cpufreq_frequency_table) * (plls_no + 1);
+	size = sizeof(*vals) * (plls_no + 1);
 
 	vals = kmalloc(size, GFP_KERNEL);
 	if (vals) {
diff --git a/drivers/cpufreq/sparc-us2e-cpufreq.c b/drivers/cpufreq/sparc-us2e-cpufreq.c
index 93061a4..7c43a72 100644
--- a/drivers/cpufreq/sparc-us2e-cpufreq.c
+++ b/drivers/cpufreq/sparc-us2e-cpufreq.c
@@ -351,12 +351,11 @@ static int __init us2e_freq_init(void)
 		struct cpufreq_driver *driver;
 
 		ret = -ENOMEM;
-		driver = kzalloc(sizeof(struct cpufreq_driver), GFP_KERNEL);
+		driver = kzalloc(sizeof(*driver), GFP_KERNEL);
 		if (!driver)
 			goto err_out;
 
-		us2e_freq_table = kzalloc(
-			(NR_CPUS * sizeof(struct us2e_freq_percpu_info)),
+		us2e_freq_table = kzalloc((NR_CPUS * sizeof(*us2e_freq_table)),
 			GFP_KERNEL);
 		if (!us2e_freq_table)
 			goto err_out;
diff --git a/drivers/cpufreq/sparc-us3-cpufreq.c b/drivers/cpufreq/sparc-us3-cpufreq.c
index 880ee29..7f500c1 100644
--- a/drivers/cpufreq/sparc-us3-cpufreq.c
+++ b/drivers/cpufreq/sparc-us3-cpufreq.c
@@ -212,12 +212,11 @@ static int __init us3_freq_init(void)
 		struct cpufreq_driver *driver;
 
 		ret = -ENOMEM;
-		driver = kzalloc(sizeof(struct cpufreq_driver), GFP_KERNEL);
+		driver = kzalloc(sizeof(*driver), GFP_KERNEL);
 		if (!driver)
 			goto err_out;
 
-		us3_freq_table = kzalloc(
-			(NR_CPUS * sizeof(struct us3_freq_percpu_info)),
+		us3_freq_table = kzalloc((NR_CPUS * sizeof(*us3_freq_table)),
 			GFP_KERNEL);
 		if (!us3_freq_table)
 			goto err_out;
-- 
1.7.12.rc2.18.g61b472e

