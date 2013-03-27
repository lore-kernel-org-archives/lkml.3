Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779Ab3C0KEN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 06:04:13 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:51429 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753784Ab3C0KEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 06:04:09 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpomaTLPZjxcTGKo2mmcqgPvqQVsj1778X1u2rbb3wV+phA@mail.gmail.com>
References: <cover.1362381470.git.viresh.kumar@linaro.org>
	<0823a96fea2d8284b7d83cee390dd5973fdaaa94.1362381470.git.viresh.kumar@linaro.org>
	<CAKohponTZ29BX6CrUvFMy9RXV==0wRFu4C-W1xd6t1RmLASTvQ@mail.gmail.com>
	<2565053.YP0dCLmaW9@vostro.rjw.lan>
	<20130326152059.GA1698@jshin-Toonie>
	<CAKohpons4Tr8F2RuRGCxbOFmJaK9YbAafV-3v6=cijRupe2hUA@mail.gmail.com>
	<20130326194832.GB24945@jshin-Toonie>
	<CAKohpomaTLPZjxcTGKo2mmcqgPvqQVsj1778X1u2rbb3wV+phA@mail.gmail.com>
Date: Wed, 27 Mar 2013 15:34:08 +0530
Message-ID: <CAKohpo=A4BBecmepsYSqHYrJg5n9WE-QB3ssvb_dOBZYXuB-eg@mail.gmail.com>
Subject: Re: [PATCH V3 2/4] cpufreq: governor: Implement per policy instances
 of governors
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Jacob Shin <jacob.shin@amd.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, Arvind Chauhan <Arvind.Chauhan@arm.com>
Content-Type: multipart/mixed; boundary=089e01184d74b4131004d8e5283f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--089e01184d74b4131004d8e5283f
Content-Type: text/plain; charset=ISO-8859-1

On 27 March 2013 09:59, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> On 27 March 2013 01:18, Jacob Shin <jacob.shin@amd.com> wrote:

>> Hmm .. I don't think this works for both ondemand and conservative
>> governors running at the same time .

Hi Jacob,

This must be early morning for you and you must be looking for something
to start with.

I am still stuck at a issue, which i am not able to fix.
- cat of */cpufreq/ondemand/** isn't showing anything on console, but all
  pointers are correctly set and i can see the right values with printk()
- I am able to see all prints for have_multiple_policies enabled.
- Due to this, i haven't tested any corner cases for now.

@Rafael: I will post all this as a separate patch later which you can then
fold into original commit. I am just waiting for a complete fix.

Following is the work i have done until now (attached too), leave earlier
fixups:

--------x-------------x------------------

From: Viresh Kumar <viresh.kumar@linaro.org>
Date: Tue, 26 Mar 2013 23:20:18 +0530
Subject: [PATCH] fixup! cpufreq: governor: Implement per policy instances of
 governors

---
 drivers/cpufreq/cpufreq.c              | 13 +++++++
 drivers/cpufreq/cpufreq_conservative.c | 24 ++++++------
 drivers/cpufreq/cpufreq_governor.c     | 71 ++++++++++++++++++++++++----------
 drivers/cpufreq/cpufreq_governor.h     | 28 ++++++++++++--
 drivers/cpufreq/cpufreq_ondemand.c     | 25 ++++++------
 include/linux/cpufreq.h                |  2 +
 6 files changed, 113 insertions(+), 50 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 3d83b02..3d990b4 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -136,6 +136,11 @@ struct kobject *get_governor_parent_kobj(struct
cpufreq_policy *policy)
  return cpufreq_global_kobject;
 }

+bool have_multiple_policies(void)
+{
+ return cpufreq_driver->have_multiple_policies;
+}
+
 static struct cpufreq_policy *__cpufreq_cpu_get(unsigned int cpu, bool sysfs)
 {
  struct cpufreq_policy *data;
@@ -1554,6 +1559,13 @@ static int __cpufreq_governor(struct
cpufreq_policy *policy,
  policy->cpu, event);
  ret = policy->governor->governor(policy, event);

+ if (!ret) {
+ if (event == CPUFREQ_GOV_POLICY_INIT)
+ policy->governor->initialized++;
+ else if (event == CPUFREQ_GOV_POLICY_EXIT)
+ policy->governor->initialized--;
+ }
+
  /* we keep one module reference alive for
  each CPU governed by this CPU */
  if ((event != CPUFREQ_GOV_START) || ret)
@@ -1577,6 +1589,7 @@ int cpufreq_register_governor(struct
cpufreq_governor *governor)

  mutex_lock(&cpufreq_governor_mutex);

+ governor->initialized = 0;
  err = -EBUSY;
  if (__find_governor(governor->name) == NULL) {
  err = 0;
diff --git a/drivers/cpufreq/cpufreq_conservative.c
b/drivers/cpufreq/cpufreq_conservative.c
index 63499c8..c09d7c8 100644
--- a/drivers/cpufreq/cpufreq_conservative.c
+++ b/drivers/cpufreq/cpufreq_conservative.c
@@ -157,11 +157,13 @@ static int dbs_cpufreq_notifier(struct
notifier_block *nb, unsigned long val,
 }

 /************************** sysfs interface ************************/
+static struct common_dbs_data cs_dbs_cdata;
+declare_get_tuners(cs);
+
 static ssize_t store_sampling_down_factor(struct cpufreq_policy *policy,
  const char *buf, size_t count)
 {
- struct dbs_data *dbs_data = policy->governor_data;
- struct cs_dbs_tuners *cs_tuners = dbs_data->tuners;
+ struct cs_dbs_tuners *cs_tuners = cs_get_tuners(policy, NULL);
  unsigned int input;
  int ret;
  ret = sscanf(buf, "%u", &input);
@@ -176,8 +178,8 @@ static ssize_t store_sampling_down_factor(struct
cpufreq_policy *policy,
 static ssize_t store_sampling_rate(struct cpufreq_policy *policy,
  const char *buf, size_t count)
 {
- struct dbs_data *dbs_data = policy->governor_data;
- struct cs_dbs_tuners *cs_tuners = dbs_data->tuners;
+ struct dbs_data *dbs_data = NULL;
+ struct cs_dbs_tuners *cs_tuners = cs_get_tuners(policy, &dbs_data);
  unsigned int input;
  int ret;
  ret = sscanf(buf, "%u", &input);
@@ -192,8 +194,7 @@ static ssize_t store_sampling_rate(struct
cpufreq_policy *policy,
 static ssize_t store_up_threshold(struct cpufreq_policy *policy,
  const char *buf, size_t count)
 {
- struct dbs_data *dbs_data = policy->governor_data;
- struct cs_dbs_tuners *cs_tuners = dbs_data->tuners;
+ struct cs_dbs_tuners *cs_tuners = cs_get_tuners(policy, NULL);
  unsigned int input;
  int ret;
  ret = sscanf(buf, "%u", &input);
@@ -208,8 +209,7 @@ static ssize_t store_up_threshold(struct
cpufreq_policy *policy,
 static ssize_t store_down_threshold(struct cpufreq_policy *policy,
  const char *buf, size_t count)
 {
- struct dbs_data *dbs_data = policy->governor_data;
- struct cs_dbs_tuners *cs_tuners = dbs_data->tuners;
+ struct cs_dbs_tuners *cs_tuners = cs_get_tuners(policy, NULL);
  unsigned int input;
  int ret;
  ret = sscanf(buf, "%u", &input);
@@ -226,8 +226,7 @@ static ssize_t store_down_threshold(struct
cpufreq_policy *policy,
 static ssize_t store_ignore_nice(struct cpufreq_policy *policy,
  const char *buf, size_t count)
 {
- struct dbs_data *dbs_data = policy->governor_data;
- struct cs_dbs_tuners *cs_tuners = dbs_data->tuners;
+ struct cs_dbs_tuners *cs_tuners = cs_get_tuners(policy, NULL);
  unsigned int input, j;
  int ret;

@@ -259,8 +258,7 @@ static ssize_t store_ignore_nice(struct
cpufreq_policy *policy,
 static ssize_t store_freq_step(struct cpufreq_policy *policy,
  const char *buf, size_t count)
 {
- struct dbs_data *dbs_data = policy->governor_data;
- struct cs_dbs_tuners *cs_tuners = dbs_data->tuners;
+ struct cs_dbs_tuners *cs_tuners = cs_get_tuners(policy, NULL);
  unsigned int input;
  int ret;
  ret = sscanf(buf, "%u", &input);
@@ -285,7 +283,7 @@ show_one(cs, up_threshold, up_threshold);
 show_one(cs, down_threshold, down_threshold);
 show_one(cs, ignore_nice, ignore_nice);
 show_one(cs, freq_step, freq_step);
-declare_show_sampling_rate_min();
+declare_show_sampling_rate_min(cs);

 cpufreq_freq_attr_rw(sampling_rate);
 cpufreq_freq_attr_rw(sampling_down_factor);
diff --git a/drivers/cpufreq/cpufreq_governor.c
b/drivers/cpufreq/cpufreq_governor.c
index 41e5e56..54ca5fc 100644
--- a/drivers/cpufreq/cpufreq_governor.c
+++ b/drivers/cpufreq/cpufreq_governor.c
@@ -216,10 +216,9 @@ static void set_sampling_rate(struct dbs_data *dbs_data,
 int cpufreq_governor_dbs(struct cpufreq_policy *policy,
  struct common_dbs_data *cdata, unsigned int event)
 {
- struct dbs_data *dbs_data = policy->governor_data;
+ struct dbs_data *dbs_data;
  struct od_cpu_dbs_info_s *od_dbs_info = NULL;
  struct cs_cpu_dbs_info_s *cs_dbs_info = NULL;
- struct cs_ops *cs_ops = NULL;
  struct od_ops *od_ops = NULL;
  struct od_dbs_tuners *od_tuners = NULL;
  struct cs_dbs_tuners *cs_tuners = NULL;
@@ -228,11 +227,22 @@ int cpufreq_governor_dbs(struct cpufreq_policy *policy,
  int io_busy = 0;
  int rc;

+ if (have_multiple_policies())
+ dbs_data = policy->governor_data;
+ else
+ dbs_data = cdata->gdbs_data;
+
  WARN_ON(!dbs_data && (event != CPUFREQ_GOV_POLICY_INIT));

  switch (event) {
  case CPUFREQ_GOV_POLICY_INIT:
- WARN_ON(dbs_data);
+ if (have_multiple_policies()) {
+ WARN_ON(dbs_data);
+ } else if (dbs_data) {
+ policy->governor_data = dbs_data;
+ return 0;
+ }
+
  dbs_data = kzalloc(sizeof(*dbs_data), GFP_KERNEL);
  if (!dbs_data) {
  pr_err("%s: POLICY_INIT: kzalloc failed\n", __func__);
@@ -246,6 +256,15 @@ int cpufreq_governor_dbs(struct cpufreq_policy *policy,
  kfree(dbs_data);
  return rc;
  }
+
+ rc = sysfs_create_group(get_governor_parent_kobj(policy),
+ dbs_data->cdata->attr_group);
+ if (rc) {
+ cdata->exit(dbs_data);
+ kfree(dbs_data);
+ return rc;
+ }
+
  policy->governor_data = dbs_data;

  /* policy latency is in nS. Convert it to uS first */
@@ -258,10 +277,36 @@ int cpufreq_governor_dbs(struct cpufreq_policy *policy,
  MIN_LATENCY_MULTIPLIER * latency);
  set_sampling_rate(dbs_data, max(dbs_data->min_sampling_rate,
  latency * LATENCY_MULTIPLIER));
+
+ if (dbs_data->cdata->governor == GOV_CONSERVATIVE) {
+ struct cs_ops *cs_ops = dbs_data->cdata->gov_ops;
+
+ cpufreq_register_notifier(cs_ops->notifier_block,
+ CPUFREQ_TRANSITION_NOTIFIER);
+ }
+
+ if (!have_multiple_policies())
+ cdata->gdbs_data = dbs_data;
+
  return 0;
  case CPUFREQ_GOV_POLICY_EXIT:
- cdata->exit(dbs_data);
- kfree(dbs_data);
+ if ((policy->governor->initialized == 1) ||
+ have_multiple_policies()) {
+ sysfs_remove_group(get_governor_parent_kobj(policy),
+ dbs_data->cdata->attr_group);
+
+ if (dbs_data->cdata->governor == GOV_CONSERVATIVE) {
+ struct cs_ops *cs_ops = dbs_data->cdata->gov_ops;
+
+ cpufreq_register_notifier(cs_ops->notifier_block,
+ CPUFREQ_TRANSITION_NOTIFIER);
+ }
+
+ cdata->exit(dbs_data);
+ kfree(dbs_data);
+ cdata->gdbs_data = NULL;
+ }
+
  policy->governor_data = NULL;
  return 0;
  }
@@ -273,7 +318,6 @@ int cpufreq_governor_dbs(struct cpufreq_policy *policy,
  cs_dbs_info = dbs_data->cdata->get_cpu_dbs_info_s(cpu);
  sampling_rate = cs_tuners->sampling_rate;
  ignore_nice = cs_tuners->ignore_nice;
- cs_ops = dbs_data->cdata->gov_ops;
  } else {
  od_tuners = dbs_data->tuners;
  od_dbs_info = dbs_data->cdata->get_cpu_dbs_info_s(cpu);
@@ -307,13 +351,6 @@ int cpufreq_governor_dbs(struct cpufreq_policy *policy,
      dbs_data->cdata->gov_dbs_timer);
  }

- rc = sysfs_create_group(get_governor_parent_kobj(policy),
- dbs_data->cdata->attr_group);
- if (rc) {
- mutex_unlock(&dbs_data->mutex);
- return rc;
- }
-
  /*
  * conservative does not implement micro like ondemand
  * governor, thus we are bound to jiffes/HZ
@@ -322,9 +359,6 @@ int cpufreq_governor_dbs(struct cpufreq_policy *policy,
  cs_dbs_info->down_skip = 0;
  cs_dbs_info->enable = 1;
  cs_dbs_info->requested_freq = policy->cur;
-
- cpufreq_register_notifier(cs_ops->notifier_block,
- CPUFREQ_TRANSITION_NOTIFIER);
  } else {
  od_dbs_info->rate_mult = 1;
  od_dbs_info->sample_type = OD_NORMAL_SAMPLE;
@@ -349,11 +383,6 @@ int cpufreq_governor_dbs(struct cpufreq_policy *policy,
  mutex_lock(&dbs_data->mutex);
  mutex_destroy(&cpu_cdbs->timer_mutex);

- sysfs_remove_group(get_governor_parent_kobj(policy),
- dbs_data->cdata->attr_group);
- if (dbs_data->cdata->governor == GOV_CONSERVATIVE)
- cpufreq_unregister_notifier(cs_ops->notifier_block,
- CPUFREQ_TRANSITION_NOTIFIER);
  mutex_unlock(&dbs_data->mutex);

  break;
diff --git a/drivers/cpufreq/cpufreq_governor.h
b/drivers/cpufreq/cpufreq_governor.h
index 8b18d25..fcf10d9 100644
--- a/drivers/cpufreq/cpufreq_governor.h
+++ b/drivers/cpufreq/cpufreq_governor.h
@@ -40,13 +40,29 @@
 /* Ondemand Sampling types */
 enum {OD_NORMAL_SAMPLE, OD_SUB_SAMPLE};

+
+#define declare_get_tuners(_gov) \
+static struct _gov##_dbs_tuners *_gov##_get_tuners \
+(struct cpufreq_policy *policy, struct dbs_data **ldbs_data) \
+{ \
+ if (have_multiple_policies()) { \
+ struct dbs_data *dbs_data = policy->governor_data; \
+ if (ldbs_data) \
+ *ldbs_data = dbs_data; \
+ return dbs_data->tuners; \
+ } else { \
+ if (ldbs_data) \
+ *ldbs_data = _gov##_dbs_cdata.gdbs_data; \
+ return _gov##_dbs_cdata.gdbs_data->tuners; \
+ } \
+}
+
 /* Macro creating sysfs show routines */
 #define show_one(_gov, file_name, object) \
 static ssize_t show_##file_name \
 (struct cpufreq_policy *policy, char *buf) \
 { \
- struct dbs_data *dbs_data = policy->governor_data; \
- struct _gov##_dbs_tuners *tuners = dbs_data->tuners; \
+ struct _gov##_dbs_tuners *tuners = _gov##_get_tuners(policy, NULL); \
  return sprintf(buf, "%u\n", tuners->file_name); \
 }

@@ -133,6 +149,9 @@ struct common_dbs_data {
  int governor;
  struct attribute_group *attr_group;

+ /* Common data for platforms that don't set have_multiple_policies */
+ struct dbs_data *gdbs_data;
+
  struct cpu_dbs_common_info *(*get_cpu_cdbs)(int cpu);
  void *(*get_cpu_dbs_info_s)(int cpu);
  void (*gov_dbs_timer)(struct work_struct *work);
@@ -177,11 +196,12 @@ static inline int
delay_for_sampling_rate(unsigned int sampling_rate)
  return delay;
 }

-#define declare_show_sampling_rate_min() \
+#define declare_show_sampling_rate_min(_gov) \
 static ssize_t show_sampling_rate_min(struct cpufreq_policy *policy, \
  char *buf) \
 { \
- struct dbs_data *dbs_data = policy->governor_data; \
+ struct dbs_data *dbs_data = NULL; \
+ _gov##_get_tuners(policy, &dbs_data); \
  return sprintf(buf, "%u\n", dbs_data->min_sampling_rate); \
 }

diff --git a/drivers/cpufreq/cpufreq_ondemand.c
b/drivers/cpufreq/cpufreq_ondemand.c
index 29ed48a..4860137 100644
--- a/drivers/cpufreq/cpufreq_ondemand.c
+++ b/drivers/cpufreq/cpufreq_ondemand.c
@@ -257,6 +257,9 @@ max_delay:
 }

 /************************** sysfs interface ************************/
+static struct common_dbs_data od_dbs_cdata;
+declare_get_tuners(od);
+
 /**
  * update_sampling_rate - update sampling rate effective immediately if needed.
  * @new_rate: new sampling rate
@@ -321,12 +324,14 @@ static void update_sampling_rate(struct dbs_data
*dbs_data,
 static ssize_t store_sampling_rate(struct cpufreq_policy *policy,
  const char *buf, size_t count)
 {
- struct dbs_data *dbs_data = policy->governor_data;
+ struct dbs_data *dbs_data = NULL;
  unsigned int input;
  int ret;
  ret = sscanf(buf, "%u", &input);
  if (ret != 1)
  return -EINVAL;
+
+ od_get_tuners(policy, &dbs_data);
  update_sampling_rate(dbs_data, input);
  return count;
 }
@@ -334,8 +339,7 @@ static ssize_t store_sampling_rate(struct
cpufreq_policy *policy,
 static ssize_t store_io_is_busy(struct cpufreq_policy *policy, const char *buf,
  size_t count)
 {
- struct dbs_data *dbs_data = policy->governor_data;
- struct od_dbs_tuners *od_tuners = dbs_data->tuners;
+ struct od_dbs_tuners *od_tuners = od_get_tuners(policy, NULL);
  unsigned int input;
  int ret;
  unsigned int j;
@@ -358,8 +362,7 @@ static ssize_t store_io_is_busy(struct
cpufreq_policy *policy, const char *buf,
 static ssize_t store_up_threshold(struct cpufreq_policy *policy,
  const char *buf, size_t count)
 {
- struct dbs_data *dbs_data = policy->governor_data;
- struct od_dbs_tuners *od_tuners = dbs_data->tuners;
+ struct od_dbs_tuners *od_tuners = od_get_tuners(policy, NULL);
  unsigned int input;
  int ret;
  ret = sscanf(buf, "%u", &input);
@@ -379,8 +382,7 @@ static ssize_t store_up_threshold(struct
cpufreq_policy *policy,
 static ssize_t store_sampling_down_factor(struct cpufreq_policy *policy,
  const char *buf, size_t count)
 {
- struct dbs_data *dbs_data = policy->governor_data;
- struct od_dbs_tuners *od_tuners = dbs_data->tuners;
+ struct od_dbs_tuners *od_tuners = od_get_tuners(policy, NULL);
  unsigned int input, j;
  int ret;
  ret = sscanf(buf, "%u", &input);
@@ -401,8 +403,7 @@ static ssize_t store_sampling_down_factor(struct
cpufreq_policy *policy,
 static ssize_t store_ignore_nice(struct cpufreq_policy *policy, const
char *buf,
  size_t count)
 {
- struct dbs_data *dbs_data = policy->governor_data;
- struct od_dbs_tuners *od_tuners = dbs_data->tuners;
+ struct od_dbs_tuners *od_tuners = od_get_tuners(policy, NULL);
  unsigned int input;
  int ret;

@@ -437,8 +438,7 @@ static ssize_t store_ignore_nice(struct
cpufreq_policy *policy, const char *buf,
 static ssize_t store_powersave_bias(struct cpufreq_policy *policy,
  const char *buf, size_t count)
 {
- struct dbs_data *dbs_data = policy->governor_data;
- struct od_dbs_tuners *od_tuners = dbs_data->tuners;
+ struct od_dbs_tuners *od_tuners = od_get_tuners(policy, NULL);
  unsigned int input;
  int ret;
  ret = sscanf(buf, "%u", &input);
@@ -460,7 +460,7 @@ show_one(od, up_threshold, up_threshold);
 show_one(od, sampling_down_factor, sampling_down_factor);
 show_one(od, ignore_nice, ignore_nice);
 show_one(od, powersave_bias, powersave_bias);
-declare_show_sampling_rate_min();
+declare_show_sampling_rate_min(od);

 cpufreq_freq_attr_rw(sampling_rate);
 cpufreq_freq_attr_rw(io_is_busy);
@@ -530,6 +530,7 @@ static int od_init(struct dbs_data *dbs_data)
  tuners->io_is_busy = should_io_be_busy();

  dbs_data->tuners = tuners;
+ pr_info("%s: tuners %p\n", __func__, tuners);
  mutex_init(&dbs_data->mutex);
  return 0;
 }
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index dd53cea..394ea0d 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -187,6 +187,7 @@ static inline unsigned long cpufreq_scale(unsigned
long old, u_int div, u_int mu

 struct cpufreq_governor {
  char name[CPUFREQ_NAME_LEN];
+ int initialized;
  int (*governor) (struct cpufreq_policy *policy,
  unsigned int event);
  ssize_t (*show_setspeed) (struct cpufreq_policy *policy,
@@ -323,6 +324,7 @@ const char *cpufreq_get_current_driver(void);
 int cpufreq_get_policy(struct cpufreq_policy *policy, unsigned int cpu);
 int cpufreq_update_policy(unsigned int cpu);
 struct kobject *get_governor_parent_kobj(struct cpufreq_policy *policy);
+bool have_multiple_policies(void);

 #ifdef CONFIG_CPU_FREQ
 /* query the current CPU frequency (in kHz). If zero, cpufreq
couldn't detect it */

--089e01184d74b4131004d8e5283f
Content-Type: application/octet-stream; 
	name="0001-fixup-cpufreq-governor-Implement-per-policy-instance.patch"
Content-Disposition: attachment; 
	filename="0001-fixup-cpufreq-governor-Implement-per-policy-instance.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hesbrvja0

RnJvbSBjYWNhOGIxNTc5OGVjYzVhZTFhNDZkYzJkYzhlZDY2YzJmZjc1MTliIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpNZXNzYWdlLUlkOiA8Y2FjYThiMTU3OThlY2M1YWUxYTQ2ZGMyZGM4ZWQ2
NmMyZmY3NTE5Yi4xMzY0Mzc4Mjc1LmdpdC52aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KRnJvbTog
VmlyZXNoIEt1bWFyIDx2aXJlc2gua3VtYXJAbGluYXJvLm9yZz4KRGF0ZTogVHVlLCAyNiBNYXIg
MjAxMyAyMzoyMDoxOCArMDUzMApTdWJqZWN0OiBbUEFUQ0hdIGZpeHVwISBjcHVmcmVxOiBnb3Zl
cm5vcjogSW1wbGVtZW50IHBlciBwb2xpY3kgaW5zdGFuY2VzIG9mCiBnb3Zlcm5vcnMKCi0tLQog
ZHJpdmVycy9jcHVmcmVxL2NwdWZyZXEuYyAgICAgICAgICAgICAgfCAxMyArKysrKysrCiBkcml2
ZXJzL2NwdWZyZXEvY3B1ZnJlcV9jb25zZXJ2YXRpdmUuYyB8IDI0ICsrKysrKy0tLS0tLQogZHJp
dmVycy9jcHVmcmVxL2NwdWZyZXFfZ292ZXJub3IuYyAgICAgfCA3MSArKysrKysrKysrKysrKysr
KysrKysrKystLS0tLS0tLS0tCiBkcml2ZXJzL2NwdWZyZXEvY3B1ZnJlcV9nb3Zlcm5vci5oICAg
ICB8IDI4ICsrKysrKysrKysrKy0tCiBkcml2ZXJzL2NwdWZyZXEvY3B1ZnJlcV9vbmRlbWFuZC5j
ICAgICB8IDI1ICsrKysrKy0tLS0tLQogaW5jbHVkZS9saW51eC9jcHVmcmVxLmggICAgICAgICAg
ICAgICAgfCAgMiArCiA2IGZpbGVzIGNoYW5nZWQsIDExMyBpbnNlcnRpb25zKCspLCA1MCBkZWxl
dGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL2NwdWZyZXEvY3B1ZnJlcS5jIGIvZHJpdmVy
cy9jcHVmcmVxL2NwdWZyZXEuYwppbmRleCAzZDgzYjAyLi4zZDk5MGI0IDEwMDY0NAotLS0gYS9k
cml2ZXJzL2NwdWZyZXEvY3B1ZnJlcS5jCisrKyBiL2RyaXZlcnMvY3B1ZnJlcS9jcHVmcmVxLmMK
QEAgLTEzNiw2ICsxMzYsMTEgQEAgc3RydWN0IGtvYmplY3QgKmdldF9nb3Zlcm5vcl9wYXJlbnRf
a29iaihzdHJ1Y3QgY3B1ZnJlcV9wb2xpY3kgKnBvbGljeSkKIAkJcmV0dXJuIGNwdWZyZXFfZ2xv
YmFsX2tvYmplY3Q7CiB9CiAKK2Jvb2wgaGF2ZV9tdWx0aXBsZV9wb2xpY2llcyh2b2lkKQorewor
CXJldHVybiBjcHVmcmVxX2RyaXZlci0+aGF2ZV9tdWx0aXBsZV9wb2xpY2llczsKK30KKwogc3Rh
dGljIHN0cnVjdCBjcHVmcmVxX3BvbGljeSAqX19jcHVmcmVxX2NwdV9nZXQodW5zaWduZWQgaW50
IGNwdSwgYm9vbCBzeXNmcykKIHsKIAlzdHJ1Y3QgY3B1ZnJlcV9wb2xpY3kgKmRhdGE7CkBAIC0x
NTU0LDYgKzE1NTksMTMgQEAgc3RhdGljIGludCBfX2NwdWZyZXFfZ292ZXJub3Ioc3RydWN0IGNw
dWZyZXFfcG9saWN5ICpwb2xpY3ksCiAJCQkJCQlwb2xpY3ktPmNwdSwgZXZlbnQpOwogCXJldCA9
IHBvbGljeS0+Z292ZXJub3ItPmdvdmVybm9yKHBvbGljeSwgZXZlbnQpOwogCisJaWYgKCFyZXQp
IHsKKwkJaWYgKGV2ZW50ID09IENQVUZSRVFfR09WX1BPTElDWV9JTklUKQorCQkJcG9saWN5LT5n
b3Zlcm5vci0+aW5pdGlhbGl6ZWQrKzsKKwkJZWxzZSBpZiAoZXZlbnQgPT0gQ1BVRlJFUV9HT1Zf
UE9MSUNZX0VYSVQpCisJCQlwb2xpY3ktPmdvdmVybm9yLT5pbml0aWFsaXplZC0tOworCX0KKwog
CS8qIHdlIGtlZXAgb25lIG1vZHVsZSByZWZlcmVuY2UgYWxpdmUgZm9yCiAJCQllYWNoIENQVSBn
b3Zlcm5lZCBieSB0aGlzIENQVSAqLwogCWlmICgoZXZlbnQgIT0gQ1BVRlJFUV9HT1ZfU1RBUlQp
IHx8IHJldCkKQEAgLTE1NzcsNiArMTU4OSw3IEBAIGludCBjcHVmcmVxX3JlZ2lzdGVyX2dvdmVy
bm9yKHN0cnVjdCBjcHVmcmVxX2dvdmVybm9yICpnb3Zlcm5vcikKIAogCW11dGV4X2xvY2soJmNw
dWZyZXFfZ292ZXJub3JfbXV0ZXgpOwogCisJZ292ZXJub3ItPmluaXRpYWxpemVkID0gMDsKIAll
cnIgPSAtRUJVU1k7CiAJaWYgKF9fZmluZF9nb3Zlcm5vcihnb3Zlcm5vci0+bmFtZSkgPT0gTlVM
TCkgewogCQllcnIgPSAwOwpkaWZmIC0tZ2l0IGEvZHJpdmVycy9jcHVmcmVxL2NwdWZyZXFfY29u
c2VydmF0aXZlLmMgYi9kcml2ZXJzL2NwdWZyZXEvY3B1ZnJlcV9jb25zZXJ2YXRpdmUuYwppbmRl
eCA2MzQ5OWM4Li5jMDlkN2M4IDEwMDY0NAotLS0gYS9kcml2ZXJzL2NwdWZyZXEvY3B1ZnJlcV9j
b25zZXJ2YXRpdmUuYworKysgYi9kcml2ZXJzL2NwdWZyZXEvY3B1ZnJlcV9jb25zZXJ2YXRpdmUu
YwpAQCAtMTU3LDExICsxNTcsMTMgQEAgc3RhdGljIGludCBkYnNfY3B1ZnJlcV9ub3RpZmllcihz
dHJ1Y3Qgbm90aWZpZXJfYmxvY2sgKm5iLCB1bnNpZ25lZCBsb25nIHZhbCwKIH0KIAogLyoqKioq
KioqKioqKioqKioqKioqKioqKioqIHN5c2ZzIGludGVyZmFjZSAqKioqKioqKioqKioqKioqKioq
KioqKiovCitzdGF0aWMgc3RydWN0IGNvbW1vbl9kYnNfZGF0YSBjc19kYnNfY2RhdGE7CitkZWNs
YXJlX2dldF90dW5lcnMoY3MpOworCiBzdGF0aWMgc3NpemVfdCBzdG9yZV9zYW1wbGluZ19kb3du
X2ZhY3RvcihzdHJ1Y3QgY3B1ZnJlcV9wb2xpY3kgKnBvbGljeSwKIAkJY29uc3QgY2hhciAqYnVm
LCBzaXplX3QgY291bnQpCiB7Ci0Jc3RydWN0IGRic19kYXRhICpkYnNfZGF0YSA9IHBvbGljeS0+
Z292ZXJub3JfZGF0YTsKLQlzdHJ1Y3QgY3NfZGJzX3R1bmVycyAqY3NfdHVuZXJzID0gZGJzX2Rh
dGEtPnR1bmVyczsKKwlzdHJ1Y3QgY3NfZGJzX3R1bmVycyAqY3NfdHVuZXJzID0gY3NfZ2V0X3R1
bmVycyhwb2xpY3ksIE5VTEwpOwogCXVuc2lnbmVkIGludCBpbnB1dDsKIAlpbnQgcmV0OwogCXJl
dCA9IHNzY2FuZihidWYsICIldSIsICZpbnB1dCk7CkBAIC0xNzYsOCArMTc4LDggQEAgc3RhdGlj
IHNzaXplX3Qgc3RvcmVfc2FtcGxpbmdfZG93bl9mYWN0b3Ioc3RydWN0IGNwdWZyZXFfcG9saWN5
ICpwb2xpY3ksCiBzdGF0aWMgc3NpemVfdCBzdG9yZV9zYW1wbGluZ19yYXRlKHN0cnVjdCBjcHVm
cmVxX3BvbGljeSAqcG9saWN5LAogCQljb25zdCBjaGFyICpidWYsIHNpemVfdCBjb3VudCkKIHsK
LQlzdHJ1Y3QgZGJzX2RhdGEgKmRic19kYXRhID0gcG9saWN5LT5nb3Zlcm5vcl9kYXRhOwotCXN0
cnVjdCBjc19kYnNfdHVuZXJzICpjc190dW5lcnMgPSBkYnNfZGF0YS0+dHVuZXJzOworCXN0cnVj
dCBkYnNfZGF0YSAqZGJzX2RhdGEgPSBOVUxMOworCXN0cnVjdCBjc19kYnNfdHVuZXJzICpjc190
dW5lcnMgPSBjc19nZXRfdHVuZXJzKHBvbGljeSwgJmRic19kYXRhKTsKIAl1bnNpZ25lZCBpbnQg
aW5wdXQ7CiAJaW50IHJldDsKIAlyZXQgPSBzc2NhbmYoYnVmLCAiJXUiLCAmaW5wdXQpOwpAQCAt
MTkyLDggKzE5NCw3IEBAIHN0YXRpYyBzc2l6ZV90IHN0b3JlX3NhbXBsaW5nX3JhdGUoc3RydWN0
IGNwdWZyZXFfcG9saWN5ICpwb2xpY3ksCiBzdGF0aWMgc3NpemVfdCBzdG9yZV91cF90aHJlc2hv
bGQoc3RydWN0IGNwdWZyZXFfcG9saWN5ICpwb2xpY3ksCiAJCWNvbnN0IGNoYXIgKmJ1Ziwgc2l6
ZV90IGNvdW50KQogewotCXN0cnVjdCBkYnNfZGF0YSAqZGJzX2RhdGEgPSBwb2xpY3ktPmdvdmVy
bm9yX2RhdGE7Ci0Jc3RydWN0IGNzX2Ric190dW5lcnMgKmNzX3R1bmVycyA9IGRic19kYXRhLT50
dW5lcnM7CisJc3RydWN0IGNzX2Ric190dW5lcnMgKmNzX3R1bmVycyA9IGNzX2dldF90dW5lcnMo
cG9saWN5LCBOVUxMKTsKIAl1bnNpZ25lZCBpbnQgaW5wdXQ7CiAJaW50IHJldDsKIAlyZXQgPSBz
c2NhbmYoYnVmLCAiJXUiLCAmaW5wdXQpOwpAQCAtMjA4LDggKzIwOSw3IEBAIHN0YXRpYyBzc2l6
ZV90IHN0b3JlX3VwX3RocmVzaG9sZChzdHJ1Y3QgY3B1ZnJlcV9wb2xpY3kgKnBvbGljeSwKIHN0
YXRpYyBzc2l6ZV90IHN0b3JlX2Rvd25fdGhyZXNob2xkKHN0cnVjdCBjcHVmcmVxX3BvbGljeSAq
cG9saWN5LAogCQljb25zdCBjaGFyICpidWYsIHNpemVfdCBjb3VudCkKIHsKLQlzdHJ1Y3QgZGJz
X2RhdGEgKmRic19kYXRhID0gcG9saWN5LT5nb3Zlcm5vcl9kYXRhOwotCXN0cnVjdCBjc19kYnNf
dHVuZXJzICpjc190dW5lcnMgPSBkYnNfZGF0YS0+dHVuZXJzOworCXN0cnVjdCBjc19kYnNfdHVu
ZXJzICpjc190dW5lcnMgPSBjc19nZXRfdHVuZXJzKHBvbGljeSwgTlVMTCk7CiAJdW5zaWduZWQg
aW50IGlucHV0OwogCWludCByZXQ7CiAJcmV0ID0gc3NjYW5mKGJ1ZiwgIiV1IiwgJmlucHV0KTsK
QEAgLTIyNiw4ICsyMjYsNyBAQCBzdGF0aWMgc3NpemVfdCBzdG9yZV9kb3duX3RocmVzaG9sZChz
dHJ1Y3QgY3B1ZnJlcV9wb2xpY3kgKnBvbGljeSwKIHN0YXRpYyBzc2l6ZV90IHN0b3JlX2lnbm9y
ZV9uaWNlKHN0cnVjdCBjcHVmcmVxX3BvbGljeSAqcG9saWN5LAogCQljb25zdCBjaGFyICpidWYs
IHNpemVfdCBjb3VudCkKIHsKLQlzdHJ1Y3QgZGJzX2RhdGEgKmRic19kYXRhID0gcG9saWN5LT5n
b3Zlcm5vcl9kYXRhOwotCXN0cnVjdCBjc19kYnNfdHVuZXJzICpjc190dW5lcnMgPSBkYnNfZGF0
YS0+dHVuZXJzOworCXN0cnVjdCBjc19kYnNfdHVuZXJzICpjc190dW5lcnMgPSBjc19nZXRfdHVu
ZXJzKHBvbGljeSwgTlVMTCk7CiAJdW5zaWduZWQgaW50IGlucHV0LCBqOwogCWludCByZXQ7CiAK
QEAgLTI1OSw4ICsyNTgsNyBAQCBzdGF0aWMgc3NpemVfdCBzdG9yZV9pZ25vcmVfbmljZShzdHJ1
Y3QgY3B1ZnJlcV9wb2xpY3kgKnBvbGljeSwKIHN0YXRpYyBzc2l6ZV90IHN0b3JlX2ZyZXFfc3Rl
cChzdHJ1Y3QgY3B1ZnJlcV9wb2xpY3kgKnBvbGljeSwKIAkJY29uc3QgY2hhciAqYnVmLCBzaXpl
X3QgY291bnQpCiB7Ci0Jc3RydWN0IGRic19kYXRhICpkYnNfZGF0YSA9IHBvbGljeS0+Z292ZXJu
b3JfZGF0YTsKLQlzdHJ1Y3QgY3NfZGJzX3R1bmVycyAqY3NfdHVuZXJzID0gZGJzX2RhdGEtPnR1
bmVyczsKKwlzdHJ1Y3QgY3NfZGJzX3R1bmVycyAqY3NfdHVuZXJzID0gY3NfZ2V0X3R1bmVycyhw
b2xpY3ksIE5VTEwpOwogCXVuc2lnbmVkIGludCBpbnB1dDsKIAlpbnQgcmV0OwogCXJldCA9IHNz
Y2FuZihidWYsICIldSIsICZpbnB1dCk7CkBAIC0yODUsNyArMjgzLDcgQEAgc2hvd19vbmUoY3Ms
IHVwX3RocmVzaG9sZCwgdXBfdGhyZXNob2xkKTsKIHNob3dfb25lKGNzLCBkb3duX3RocmVzaG9s
ZCwgZG93bl90aHJlc2hvbGQpOwogc2hvd19vbmUoY3MsIGlnbm9yZV9uaWNlLCBpZ25vcmVfbmlj
ZSk7CiBzaG93X29uZShjcywgZnJlcV9zdGVwLCBmcmVxX3N0ZXApOwotZGVjbGFyZV9zaG93X3Nh
bXBsaW5nX3JhdGVfbWluKCk7CitkZWNsYXJlX3Nob3dfc2FtcGxpbmdfcmF0ZV9taW4oY3MpOwog
CiBjcHVmcmVxX2ZyZXFfYXR0cl9ydyhzYW1wbGluZ19yYXRlKTsKIGNwdWZyZXFfZnJlcV9hdHRy
X3J3KHNhbXBsaW5nX2Rvd25fZmFjdG9yKTsKZGlmZiAtLWdpdCBhL2RyaXZlcnMvY3B1ZnJlcS9j
cHVmcmVxX2dvdmVybm9yLmMgYi9kcml2ZXJzL2NwdWZyZXEvY3B1ZnJlcV9nb3Zlcm5vci5jCmlu
ZGV4IDQxZTVlNTYuLjU0Y2E1ZmMgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvY3B1ZnJlcS9jcHVmcmVx
X2dvdmVybm9yLmMKKysrIGIvZHJpdmVycy9jcHVmcmVxL2NwdWZyZXFfZ292ZXJub3IuYwpAQCAt
MjE2LDEwICsyMTYsOSBAQCBzdGF0aWMgdm9pZCBzZXRfc2FtcGxpbmdfcmF0ZShzdHJ1Y3QgZGJz
X2RhdGEgKmRic19kYXRhLAogaW50IGNwdWZyZXFfZ292ZXJub3JfZGJzKHN0cnVjdCBjcHVmcmVx
X3BvbGljeSAqcG9saWN5LAogCQlzdHJ1Y3QgY29tbW9uX2Ric19kYXRhICpjZGF0YSwgdW5zaWdu
ZWQgaW50IGV2ZW50KQogewotCXN0cnVjdCBkYnNfZGF0YSAqZGJzX2RhdGEgPSBwb2xpY3ktPmdv
dmVybm9yX2RhdGE7CisJc3RydWN0IGRic19kYXRhICpkYnNfZGF0YTsKIAlzdHJ1Y3Qgb2RfY3B1
X2Ric19pbmZvX3MgKm9kX2Ric19pbmZvID0gTlVMTDsKIAlzdHJ1Y3QgY3NfY3B1X2Ric19pbmZv
X3MgKmNzX2Ric19pbmZvID0gTlVMTDsKLQlzdHJ1Y3QgY3Nfb3BzICpjc19vcHMgPSBOVUxMOwog
CXN0cnVjdCBvZF9vcHMgKm9kX29wcyA9IE5VTEw7CiAJc3RydWN0IG9kX2Ric190dW5lcnMgKm9k
X3R1bmVycyA9IE5VTEw7CiAJc3RydWN0IGNzX2Ric190dW5lcnMgKmNzX3R1bmVycyA9IE5VTEw7
CkBAIC0yMjgsMTEgKzIyNywyMiBAQCBpbnQgY3B1ZnJlcV9nb3Zlcm5vcl9kYnMoc3RydWN0IGNw
dWZyZXFfcG9saWN5ICpwb2xpY3ksCiAJaW50IGlvX2J1c3kgPSAwOwogCWludCByYzsKIAorCWlm
IChoYXZlX211bHRpcGxlX3BvbGljaWVzKCkpCisJCWRic19kYXRhID0gcG9saWN5LT5nb3Zlcm5v
cl9kYXRhOworCWVsc2UKKwkJZGJzX2RhdGEgPSBjZGF0YS0+Z2Ric19kYXRhOworCiAJV0FSTl9P
TighZGJzX2RhdGEgJiYgKGV2ZW50ICE9IENQVUZSRVFfR09WX1BPTElDWV9JTklUKSk7CiAKIAlz
d2l0Y2ggKGV2ZW50KSB7CiAJY2FzZSBDUFVGUkVRX0dPVl9QT0xJQ1lfSU5JVDoKLQkJV0FSTl9P
TihkYnNfZGF0YSk7CisJCWlmIChoYXZlX211bHRpcGxlX3BvbGljaWVzKCkpIHsKKwkJCVdBUk5f
T04oZGJzX2RhdGEpOworCQl9IGVsc2UgaWYgKGRic19kYXRhKSB7CisJCQlwb2xpY3ktPmdvdmVy
bm9yX2RhdGEgPSBkYnNfZGF0YTsKKwkJCXJldHVybiAwOworCQl9CisKIAkJZGJzX2RhdGEgPSBr
emFsbG9jKHNpemVvZigqZGJzX2RhdGEpLCBHRlBfS0VSTkVMKTsKIAkJaWYgKCFkYnNfZGF0YSkg
ewogCQkJcHJfZXJyKCIlczogUE9MSUNZX0lOSVQ6IGt6YWxsb2MgZmFpbGVkXG4iLCBfX2Z1bmNf
Xyk7CkBAIC0yNDYsNiArMjU2LDE1IEBAIGludCBjcHVmcmVxX2dvdmVybm9yX2RicyhzdHJ1Y3Qg
Y3B1ZnJlcV9wb2xpY3kgKnBvbGljeSwKIAkJCWtmcmVlKGRic19kYXRhKTsKIAkJCXJldHVybiBy
YzsKIAkJfQorCisJCXJjID0gc3lzZnNfY3JlYXRlX2dyb3VwKGdldF9nb3Zlcm5vcl9wYXJlbnRf
a29iaihwb2xpY3kpLAorCQkJCWRic19kYXRhLT5jZGF0YS0+YXR0cl9ncm91cCk7CisJCWlmIChy
YykgeworCQkJY2RhdGEtPmV4aXQoZGJzX2RhdGEpOworCQkJa2ZyZWUoZGJzX2RhdGEpOworCQkJ
cmV0dXJuIHJjOworCQl9CisKIAkJcG9saWN5LT5nb3Zlcm5vcl9kYXRhID0gZGJzX2RhdGE7CiAK
IAkJLyogcG9saWN5IGxhdGVuY3kgaXMgaW4gblMuIENvbnZlcnQgaXQgdG8gdVMgZmlyc3QgKi8K
QEAgLTI1OCwxMCArMjc3LDM2IEBAIGludCBjcHVmcmVxX2dvdmVybm9yX2RicyhzdHJ1Y3QgY3B1
ZnJlcV9wb2xpY3kgKnBvbGljeSwKIAkJCQlNSU5fTEFURU5DWV9NVUxUSVBMSUVSICogbGF0ZW5j
eSk7CiAJCXNldF9zYW1wbGluZ19yYXRlKGRic19kYXRhLCBtYXgoZGJzX2RhdGEtPm1pbl9zYW1w
bGluZ19yYXRlLAogCQkJCQlsYXRlbmN5ICogTEFURU5DWV9NVUxUSVBMSUVSKSk7CisKKwkJaWYg
KGRic19kYXRhLT5jZGF0YS0+Z292ZXJub3IgPT0gR09WX0NPTlNFUlZBVElWRSkgeworCQkJc3Ry
dWN0IGNzX29wcyAqY3Nfb3BzID0gZGJzX2RhdGEtPmNkYXRhLT5nb3Zfb3BzOworCisJCQljcHVm
cmVxX3JlZ2lzdGVyX25vdGlmaWVyKGNzX29wcy0+bm90aWZpZXJfYmxvY2ssCisJCQkJCUNQVUZS
RVFfVFJBTlNJVElPTl9OT1RJRklFUik7CisJCX0KKworCQlpZiAoIWhhdmVfbXVsdGlwbGVfcG9s
aWNpZXMoKSkKKwkJCWNkYXRhLT5nZGJzX2RhdGEgPSBkYnNfZGF0YTsKKwogCQlyZXR1cm4gMDsK
IAljYXNlIENQVUZSRVFfR09WX1BPTElDWV9FWElUOgotCQljZGF0YS0+ZXhpdChkYnNfZGF0YSk7
Ci0JCWtmcmVlKGRic19kYXRhKTsKKwkJaWYgKChwb2xpY3ktPmdvdmVybm9yLT5pbml0aWFsaXpl
ZCA9PSAxKSB8fAorCQkJCWhhdmVfbXVsdGlwbGVfcG9saWNpZXMoKSkgeworCQkJc3lzZnNfcmVt
b3ZlX2dyb3VwKGdldF9nb3Zlcm5vcl9wYXJlbnRfa29iaihwb2xpY3kpLAorCQkJCQlkYnNfZGF0
YS0+Y2RhdGEtPmF0dHJfZ3JvdXApOworCisJCQlpZiAoZGJzX2RhdGEtPmNkYXRhLT5nb3Zlcm5v
ciA9PSBHT1ZfQ09OU0VSVkFUSVZFKSB7CisJCQkJc3RydWN0IGNzX29wcyAqY3Nfb3BzID0gZGJz
X2RhdGEtPmNkYXRhLT5nb3Zfb3BzOworCisJCQkJY3B1ZnJlcV9yZWdpc3Rlcl9ub3RpZmllcihj
c19vcHMtPm5vdGlmaWVyX2Jsb2NrLAorCQkJCQkJQ1BVRlJFUV9UUkFOU0lUSU9OX05PVElGSUVS
KTsKKwkJCX0KKworCQkJY2RhdGEtPmV4aXQoZGJzX2RhdGEpOworCQkJa2ZyZWUoZGJzX2RhdGEp
OworCQkJY2RhdGEtPmdkYnNfZGF0YSA9IE5VTEw7CisJCX0KKwogCQlwb2xpY3ktPmdvdmVybm9y
X2RhdGEgPSBOVUxMOwogCQlyZXR1cm4gMDsKIAl9CkBAIC0yNzMsNyArMzE4LDYgQEAgaW50IGNw
dWZyZXFfZ292ZXJub3JfZGJzKHN0cnVjdCBjcHVmcmVxX3BvbGljeSAqcG9saWN5LAogCQljc19k
YnNfaW5mbyA9IGRic19kYXRhLT5jZGF0YS0+Z2V0X2NwdV9kYnNfaW5mb19zKGNwdSk7CiAJCXNh
bXBsaW5nX3JhdGUgPSBjc190dW5lcnMtPnNhbXBsaW5nX3JhdGU7CiAJCWlnbm9yZV9uaWNlID0g
Y3NfdHVuZXJzLT5pZ25vcmVfbmljZTsKLQkJY3Nfb3BzID0gZGJzX2RhdGEtPmNkYXRhLT5nb3Zf
b3BzOwogCX0gZWxzZSB7CiAJCW9kX3R1bmVycyA9IGRic19kYXRhLT50dW5lcnM7CiAJCW9kX2Ri
c19pbmZvID0gZGJzX2RhdGEtPmNkYXRhLT5nZXRfY3B1X2Ric19pbmZvX3MoY3B1KTsKQEAgLTMw
NywxMyArMzUxLDYgQEAgaW50IGNwdWZyZXFfZ292ZXJub3JfZGJzKHN0cnVjdCBjcHVmcmVxX3Bv
bGljeSAqcG9saWN5LAogCQkJCQkgICAgIGRic19kYXRhLT5jZGF0YS0+Z292X2Ric190aW1lcik7
CiAJCX0KIAotCQlyYyA9IHN5c2ZzX2NyZWF0ZV9ncm91cChnZXRfZ292ZXJub3JfcGFyZW50X2tv
YmoocG9saWN5KSwKLQkJCQlkYnNfZGF0YS0+Y2RhdGEtPmF0dHJfZ3JvdXApOwotCQlpZiAocmMp
IHsKLQkJCW11dGV4X3VubG9jaygmZGJzX2RhdGEtPm11dGV4KTsKLQkJCXJldHVybiByYzsKLQkJ
fQotCiAJCS8qCiAJCSAqIGNvbnNlcnZhdGl2ZSBkb2VzIG5vdCBpbXBsZW1lbnQgbWljcm8gbGlr
ZSBvbmRlbWFuZAogCQkgKiBnb3Zlcm5vciwgdGh1cyB3ZSBhcmUgYm91bmQgdG8gamlmZmVzL0ha
CkBAIC0zMjIsOSArMzU5LDYgQEAgaW50IGNwdWZyZXFfZ292ZXJub3JfZGJzKHN0cnVjdCBjcHVm
cmVxX3BvbGljeSAqcG9saWN5LAogCQkJY3NfZGJzX2luZm8tPmRvd25fc2tpcCA9IDA7CiAJCQlj
c19kYnNfaW5mby0+ZW5hYmxlID0gMTsKIAkJCWNzX2Ric19pbmZvLT5yZXF1ZXN0ZWRfZnJlcSA9
IHBvbGljeS0+Y3VyOwotCi0JCQljcHVmcmVxX3JlZ2lzdGVyX25vdGlmaWVyKGNzX29wcy0+bm90
aWZpZXJfYmxvY2ssCi0JCQkJCUNQVUZSRVFfVFJBTlNJVElPTl9OT1RJRklFUik7CiAJCX0gZWxz
ZSB7CiAJCQlvZF9kYnNfaW5mby0+cmF0ZV9tdWx0ID0gMTsKIAkJCW9kX2Ric19pbmZvLT5zYW1w
bGVfdHlwZSA9IE9EX05PUk1BTF9TQU1QTEU7CkBAIC0zNDksMTEgKzM4Myw2IEBAIGludCBjcHVm
cmVxX2dvdmVybm9yX2RicyhzdHJ1Y3QgY3B1ZnJlcV9wb2xpY3kgKnBvbGljeSwKIAkJbXV0ZXhf
bG9jaygmZGJzX2RhdGEtPm11dGV4KTsKIAkJbXV0ZXhfZGVzdHJveSgmY3B1X2NkYnMtPnRpbWVy
X211dGV4KTsKIAotCQlzeXNmc19yZW1vdmVfZ3JvdXAoZ2V0X2dvdmVybm9yX3BhcmVudF9rb2Jq
KHBvbGljeSksCi0JCQkJZGJzX2RhdGEtPmNkYXRhLT5hdHRyX2dyb3VwKTsKLQkJaWYgKGRic19k
YXRhLT5jZGF0YS0+Z292ZXJub3IgPT0gR09WX0NPTlNFUlZBVElWRSkKLQkJCWNwdWZyZXFfdW5y
ZWdpc3Rlcl9ub3RpZmllcihjc19vcHMtPm5vdGlmaWVyX2Jsb2NrLAotCQkJCQlDUFVGUkVRX1RS
QU5TSVRJT05fTk9USUZJRVIpOwogCQltdXRleF91bmxvY2soJmRic19kYXRhLT5tdXRleCk7CiAK
IAkJYnJlYWs7CmRpZmYgLS1naXQgYS9kcml2ZXJzL2NwdWZyZXEvY3B1ZnJlcV9nb3Zlcm5vci5o
IGIvZHJpdmVycy9jcHVmcmVxL2NwdWZyZXFfZ292ZXJub3IuaAppbmRleCA4YjE4ZDI1Li5mY2Yx
MGQ5IDEwMDY0NAotLS0gYS9kcml2ZXJzL2NwdWZyZXEvY3B1ZnJlcV9nb3Zlcm5vci5oCisrKyBi
L2RyaXZlcnMvY3B1ZnJlcS9jcHVmcmVxX2dvdmVybm9yLmgKQEAgLTQwLDEzICs0MCwyOSBAQAog
LyogT25kZW1hbmQgU2FtcGxpbmcgdHlwZXMgKi8KIGVudW0ge09EX05PUk1BTF9TQU1QTEUsIE9E
X1NVQl9TQU1QTEV9OwogCisKKyNkZWZpbmUgZGVjbGFyZV9nZXRfdHVuZXJzKF9nb3YpCQkJCQlc
CitzdGF0aWMgc3RydWN0IF9nb3YjI19kYnNfdHVuZXJzICpfZ292IyNfZ2V0X3R1bmVycwkJCVwK
KyhzdHJ1Y3QgY3B1ZnJlcV9wb2xpY3kgKnBvbGljeSwgc3RydWN0IGRic19kYXRhICoqbGRic19k
YXRhKQkJXAorewkJCQkJCQkJCVwKKwlpZiAoaGF2ZV9tdWx0aXBsZV9wb2xpY2llcygpKSB7CQkJ
CQlcCisJCXN0cnVjdCBkYnNfZGF0YSAqZGJzX2RhdGEgPSBwb2xpY3ktPmdvdmVybm9yX2RhdGE7
CVwKKwkJaWYgKGxkYnNfZGF0YSkJCQkJCQlcCisJCQkqbGRic19kYXRhID0gZGJzX2RhdGE7CQkJ
CVwKKwkJcmV0dXJuIGRic19kYXRhLT50dW5lcnM7CQkJCVwKKwl9IGVsc2UgewkJCQkJCQlcCisJ
CWlmIChsZGJzX2RhdGEpCQkJCQkJXAorCQkJKmxkYnNfZGF0YSA9IF9nb3YjI19kYnNfY2RhdGEu
Z2Ric19kYXRhOwlcCisJCXJldHVybiBfZ292IyNfZGJzX2NkYXRhLmdkYnNfZGF0YS0+dHVuZXJz
OwkJXAorCX0JCQkJCQkJCVwKK30KKwogLyogTWFjcm8gY3JlYXRpbmcgc3lzZnMgc2hvdyByb3V0
aW5lcyAqLwogI2RlZmluZSBzaG93X29uZShfZ292LCBmaWxlX25hbWUsIG9iamVjdCkJCQkJXAog
c3RhdGljIHNzaXplX3Qgc2hvd18jI2ZpbGVfbmFtZQkJCQkJCVwKIChzdHJ1Y3QgY3B1ZnJlcV9w
b2xpY3kgKnBvbGljeSwgY2hhciAqYnVmKQkJCQlcCiB7CQkJCQkJCQkJXAotCXN0cnVjdCBkYnNf
ZGF0YSAqZGJzX2RhdGEgPSBwb2xpY3ktPmdvdmVybm9yX2RhdGE7CQlcCi0Jc3RydWN0IF9nb3Yj
I19kYnNfdHVuZXJzICp0dW5lcnMgPSBkYnNfZGF0YS0+dHVuZXJzOwkJXAorCXN0cnVjdCBfZ292
IyNfZGJzX3R1bmVycyAqdHVuZXJzID0gX2dvdiMjX2dldF90dW5lcnMocG9saWN5LCBOVUxMKTsg
XAogCXJldHVybiBzcHJpbnRmKGJ1ZiwgIiV1XG4iLCB0dW5lcnMtPmZpbGVfbmFtZSk7CQkJXAog
fQogCkBAIC0xMzMsNiArMTQ5LDkgQEAgc3RydWN0IGNvbW1vbl9kYnNfZGF0YSB7CiAJaW50IGdv
dmVybm9yOwogCXN0cnVjdCBhdHRyaWJ1dGVfZ3JvdXAgKmF0dHJfZ3JvdXA7CiAKKwkvKiBDb21t
b24gZGF0YSBmb3IgcGxhdGZvcm1zIHRoYXQgZG9uJ3Qgc2V0IGhhdmVfbXVsdGlwbGVfcG9saWNp
ZXMgKi8KKwlzdHJ1Y3QgZGJzX2RhdGEgKmdkYnNfZGF0YTsKKwogCXN0cnVjdCBjcHVfZGJzX2Nv
bW1vbl9pbmZvICooKmdldF9jcHVfY2RicykoaW50IGNwdSk7CiAJdm9pZCAqKCpnZXRfY3B1X2Ri
c19pbmZvX3MpKGludCBjcHUpOwogCXZvaWQgKCpnb3ZfZGJzX3RpbWVyKShzdHJ1Y3Qgd29ya19z
dHJ1Y3QgKndvcmspOwpAQCAtMTc3LDExICsxOTYsMTIgQEAgc3RhdGljIGlubGluZSBpbnQgZGVs
YXlfZm9yX3NhbXBsaW5nX3JhdGUodW5zaWduZWQgaW50IHNhbXBsaW5nX3JhdGUpCiAJcmV0dXJu
IGRlbGF5OwogfQogCi0jZGVmaW5lIGRlY2xhcmVfc2hvd19zYW1wbGluZ19yYXRlX21pbigpCQkJ
CVwKKyNkZWZpbmUgZGVjbGFyZV9zaG93X3NhbXBsaW5nX3JhdGVfbWluKF9nb3YpCQkJCVwKIHN0
YXRpYyBzc2l6ZV90IHNob3dfc2FtcGxpbmdfcmF0ZV9taW4oc3RydWN0IGNwdWZyZXFfcG9saWN5
ICpwb2xpY3ksCVwKIAkJY2hhciAqYnVmKQkJCQkJCVwKIHsJCQkJCQkJCQlcCi0Jc3RydWN0IGRi
c19kYXRhICpkYnNfZGF0YSA9IHBvbGljeS0+Z292ZXJub3JfZGF0YTsJCVwKKwlzdHJ1Y3QgZGJz
X2RhdGEgKmRic19kYXRhID0gTlVMTDsJCQkJXAorCV9nb3YjI19nZXRfdHVuZXJzKHBvbGljeSwg
JmRic19kYXRhKTsJCQkJXAogCXJldHVybiBzcHJpbnRmKGJ1ZiwgIiV1XG4iLCBkYnNfZGF0YS0+
bWluX3NhbXBsaW5nX3JhdGUpOwlcCiB9CiAKZGlmZiAtLWdpdCBhL2RyaXZlcnMvY3B1ZnJlcS9j
cHVmcmVxX29uZGVtYW5kLmMgYi9kcml2ZXJzL2NwdWZyZXEvY3B1ZnJlcV9vbmRlbWFuZC5jCmlu
ZGV4IDI5ZWQ0OGEuLjQ4NjAxMzcgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvY3B1ZnJlcS9jcHVmcmVx
X29uZGVtYW5kLmMKKysrIGIvZHJpdmVycy9jcHVmcmVxL2NwdWZyZXFfb25kZW1hbmQuYwpAQCAt
MjU3LDYgKzI1Nyw5IEBAIG1heF9kZWxheToKIH0KIAogLyoqKioqKioqKioqKioqKioqKioqKioq
KioqIHN5c2ZzIGludGVyZmFjZSAqKioqKioqKioqKioqKioqKioqKioqKiovCitzdGF0aWMgc3Ry
dWN0IGNvbW1vbl9kYnNfZGF0YSBvZF9kYnNfY2RhdGE7CitkZWNsYXJlX2dldF90dW5lcnMob2Qp
OworCiAvKioKICAqIHVwZGF0ZV9zYW1wbGluZ19yYXRlIC0gdXBkYXRlIHNhbXBsaW5nIHJhdGUg
ZWZmZWN0aXZlIGltbWVkaWF0ZWx5IGlmIG5lZWRlZC4KICAqIEBuZXdfcmF0ZTogbmV3IHNhbXBs
aW5nIHJhdGUKQEAgLTMyMSwxMiArMzI0LDE0IEBAIHN0YXRpYyB2b2lkIHVwZGF0ZV9zYW1wbGlu
Z19yYXRlKHN0cnVjdCBkYnNfZGF0YSAqZGJzX2RhdGEsCiBzdGF0aWMgc3NpemVfdCBzdG9yZV9z
YW1wbGluZ19yYXRlKHN0cnVjdCBjcHVmcmVxX3BvbGljeSAqcG9saWN5LAogCQljb25zdCBjaGFy
ICpidWYsIHNpemVfdCBjb3VudCkKIHsKLQlzdHJ1Y3QgZGJzX2RhdGEgKmRic19kYXRhID0gcG9s
aWN5LT5nb3Zlcm5vcl9kYXRhOworCXN0cnVjdCBkYnNfZGF0YSAqZGJzX2RhdGEgPSBOVUxMOwog
CXVuc2lnbmVkIGludCBpbnB1dDsKIAlpbnQgcmV0OwogCXJldCA9IHNzY2FuZihidWYsICIldSIs
ICZpbnB1dCk7CiAJaWYgKHJldCAhPSAxKQogCQlyZXR1cm4gLUVJTlZBTDsKKworCW9kX2dldF90
dW5lcnMocG9saWN5LCAmZGJzX2RhdGEpOwogCXVwZGF0ZV9zYW1wbGluZ19yYXRlKGRic19kYXRh
LCBpbnB1dCk7CiAJcmV0dXJuIGNvdW50OwogfQpAQCAtMzM0LDggKzMzOSw3IEBAIHN0YXRpYyBz
c2l6ZV90IHN0b3JlX3NhbXBsaW5nX3JhdGUoc3RydWN0IGNwdWZyZXFfcG9saWN5ICpwb2xpY3ks
CiBzdGF0aWMgc3NpemVfdCBzdG9yZV9pb19pc19idXN5KHN0cnVjdCBjcHVmcmVxX3BvbGljeSAq
cG9saWN5LCBjb25zdCBjaGFyICpidWYsCiAJCXNpemVfdCBjb3VudCkKIHsKLQlzdHJ1Y3QgZGJz
X2RhdGEgKmRic19kYXRhID0gcG9saWN5LT5nb3Zlcm5vcl9kYXRhOwotCXN0cnVjdCBvZF9kYnNf
dHVuZXJzICpvZF90dW5lcnMgPSBkYnNfZGF0YS0+dHVuZXJzOworCXN0cnVjdCBvZF9kYnNfdHVu
ZXJzICpvZF90dW5lcnMgPSBvZF9nZXRfdHVuZXJzKHBvbGljeSwgTlVMTCk7CiAJdW5zaWduZWQg
aW50IGlucHV0OwogCWludCByZXQ7CiAJdW5zaWduZWQgaW50IGo7CkBAIC0zNTgsOCArMzYyLDcg
QEAgc3RhdGljIHNzaXplX3Qgc3RvcmVfaW9faXNfYnVzeShzdHJ1Y3QgY3B1ZnJlcV9wb2xpY3kg
KnBvbGljeSwgY29uc3QgY2hhciAqYnVmLAogc3RhdGljIHNzaXplX3Qgc3RvcmVfdXBfdGhyZXNo
b2xkKHN0cnVjdCBjcHVmcmVxX3BvbGljeSAqcG9saWN5LAogCQljb25zdCBjaGFyICpidWYsIHNp
emVfdCBjb3VudCkKIHsKLQlzdHJ1Y3QgZGJzX2RhdGEgKmRic19kYXRhID0gcG9saWN5LT5nb3Zl
cm5vcl9kYXRhOwotCXN0cnVjdCBvZF9kYnNfdHVuZXJzICpvZF90dW5lcnMgPSBkYnNfZGF0YS0+
dHVuZXJzOworCXN0cnVjdCBvZF9kYnNfdHVuZXJzICpvZF90dW5lcnMgPSBvZF9nZXRfdHVuZXJz
KHBvbGljeSwgTlVMTCk7CiAJdW5zaWduZWQgaW50IGlucHV0OwogCWludCByZXQ7CiAJcmV0ID0g
c3NjYW5mKGJ1ZiwgIiV1IiwgJmlucHV0KTsKQEAgLTM3OSw4ICszODIsNyBAQCBzdGF0aWMgc3Np
emVfdCBzdG9yZV91cF90aHJlc2hvbGQoc3RydWN0IGNwdWZyZXFfcG9saWN5ICpwb2xpY3ksCiBz
dGF0aWMgc3NpemVfdCBzdG9yZV9zYW1wbGluZ19kb3duX2ZhY3RvcihzdHJ1Y3QgY3B1ZnJlcV9w
b2xpY3kgKnBvbGljeSwKIAkJY29uc3QgY2hhciAqYnVmLCBzaXplX3QgY291bnQpCiB7Ci0Jc3Ry
dWN0IGRic19kYXRhICpkYnNfZGF0YSA9IHBvbGljeS0+Z292ZXJub3JfZGF0YTsKLQlzdHJ1Y3Qg
b2RfZGJzX3R1bmVycyAqb2RfdHVuZXJzID0gZGJzX2RhdGEtPnR1bmVyczsKKwlzdHJ1Y3Qgb2Rf
ZGJzX3R1bmVycyAqb2RfdHVuZXJzID0gb2RfZ2V0X3R1bmVycyhwb2xpY3ksIE5VTEwpOwogCXVu
c2lnbmVkIGludCBpbnB1dCwgajsKIAlpbnQgcmV0OwogCXJldCA9IHNzY2FuZihidWYsICIldSIs
ICZpbnB1dCk7CkBAIC00MDEsOCArNDAzLDcgQEAgc3RhdGljIHNzaXplX3Qgc3RvcmVfc2FtcGxp
bmdfZG93bl9mYWN0b3Ioc3RydWN0IGNwdWZyZXFfcG9saWN5ICpwb2xpY3ksCiBzdGF0aWMgc3Np
emVfdCBzdG9yZV9pZ25vcmVfbmljZShzdHJ1Y3QgY3B1ZnJlcV9wb2xpY3kgKnBvbGljeSwgY29u
c3QgY2hhciAqYnVmLAogCQlzaXplX3QgY291bnQpCiB7Ci0Jc3RydWN0IGRic19kYXRhICpkYnNf
ZGF0YSA9IHBvbGljeS0+Z292ZXJub3JfZGF0YTsKLQlzdHJ1Y3Qgb2RfZGJzX3R1bmVycyAqb2Rf
dHVuZXJzID0gZGJzX2RhdGEtPnR1bmVyczsKKwlzdHJ1Y3Qgb2RfZGJzX3R1bmVycyAqb2RfdHVu
ZXJzID0gb2RfZ2V0X3R1bmVycyhwb2xpY3ksIE5VTEwpOwogCXVuc2lnbmVkIGludCBpbnB1dDsK
IAlpbnQgcmV0OwogCkBAIC00MzcsOCArNDM4LDcgQEAgc3RhdGljIHNzaXplX3Qgc3RvcmVfaWdu
b3JlX25pY2Uoc3RydWN0IGNwdWZyZXFfcG9saWN5ICpwb2xpY3ksIGNvbnN0IGNoYXIgKmJ1ZiwK
IHN0YXRpYyBzc2l6ZV90IHN0b3JlX3Bvd2Vyc2F2ZV9iaWFzKHN0cnVjdCBjcHVmcmVxX3BvbGlj
eSAqcG9saWN5LAogCQljb25zdCBjaGFyICpidWYsIHNpemVfdCBjb3VudCkKIHsKLQlzdHJ1Y3Qg
ZGJzX2RhdGEgKmRic19kYXRhID0gcG9saWN5LT5nb3Zlcm5vcl9kYXRhOwotCXN0cnVjdCBvZF9k
YnNfdHVuZXJzICpvZF90dW5lcnMgPSBkYnNfZGF0YS0+dHVuZXJzOworCXN0cnVjdCBvZF9kYnNf
dHVuZXJzICpvZF90dW5lcnMgPSBvZF9nZXRfdHVuZXJzKHBvbGljeSwgTlVMTCk7CiAJdW5zaWdu
ZWQgaW50IGlucHV0OwogCWludCByZXQ7CiAJcmV0ID0gc3NjYW5mKGJ1ZiwgIiV1IiwgJmlucHV0
KTsKQEAgLTQ2MCw3ICs0NjAsNyBAQCBzaG93X29uZShvZCwgdXBfdGhyZXNob2xkLCB1cF90aHJl
c2hvbGQpOwogc2hvd19vbmUob2QsIHNhbXBsaW5nX2Rvd25fZmFjdG9yLCBzYW1wbGluZ19kb3du
X2ZhY3Rvcik7CiBzaG93X29uZShvZCwgaWdub3JlX25pY2UsIGlnbm9yZV9uaWNlKTsKIHNob3df
b25lKG9kLCBwb3dlcnNhdmVfYmlhcywgcG93ZXJzYXZlX2JpYXMpOwotZGVjbGFyZV9zaG93X3Nh
bXBsaW5nX3JhdGVfbWluKCk7CitkZWNsYXJlX3Nob3dfc2FtcGxpbmdfcmF0ZV9taW4ob2QpOwog
CiBjcHVmcmVxX2ZyZXFfYXR0cl9ydyhzYW1wbGluZ19yYXRlKTsKIGNwdWZyZXFfZnJlcV9hdHRy
X3J3KGlvX2lzX2J1c3kpOwpAQCAtNTMwLDYgKzUzMCw3IEBAIHN0YXRpYyBpbnQgb2RfaW5pdChz
dHJ1Y3QgZGJzX2RhdGEgKmRic19kYXRhKQogCXR1bmVycy0+aW9faXNfYnVzeSA9IHNob3VsZF9p
b19iZV9idXN5KCk7CiAKIAlkYnNfZGF0YS0+dHVuZXJzID0gdHVuZXJzOworCXByX2luZm8oIiVz
OiB0dW5lcnMgJXBcbiIsIF9fZnVuY19fLCB0dW5lcnMpOwogCW11dGV4X2luaXQoJmRic19kYXRh
LT5tdXRleCk7CiAJcmV0dXJuIDA7CiB9CmRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L2NwdWZy
ZXEuaCBiL2luY2x1ZGUvbGludXgvY3B1ZnJlcS5oCmluZGV4IGRkNTNjZWEuLjM5NGVhMGQgMTAw
NjQ0Ci0tLSBhL2luY2x1ZGUvbGludXgvY3B1ZnJlcS5oCisrKyBiL2luY2x1ZGUvbGludXgvY3B1
ZnJlcS5oCkBAIC0xODcsNiArMTg3LDcgQEAgc3RhdGljIGlubGluZSB1bnNpZ25lZCBsb25nIGNw
dWZyZXFfc2NhbGUodW5zaWduZWQgbG9uZyBvbGQsIHVfaW50IGRpdiwgdV9pbnQgbXUKIAogc3Ry
dWN0IGNwdWZyZXFfZ292ZXJub3IgewogCWNoYXIJbmFtZVtDUFVGUkVRX05BTUVfTEVOXTsKKwlp
bnQJaW5pdGlhbGl6ZWQ7CiAJaW50CSgqZ292ZXJub3IpCShzdHJ1Y3QgY3B1ZnJlcV9wb2xpY3kg
KnBvbGljeSwKIAkJCQkgdW5zaWduZWQgaW50IGV2ZW50KTsKIAlzc2l6ZV90CSgqc2hvd19zZXRz
cGVlZCkJKHN0cnVjdCBjcHVmcmVxX3BvbGljeSAqcG9saWN5LApAQCAtMzIzLDYgKzMyNCw3IEBA
IGNvbnN0IGNoYXIgKmNwdWZyZXFfZ2V0X2N1cnJlbnRfZHJpdmVyKHZvaWQpOwogaW50IGNwdWZy
ZXFfZ2V0X3BvbGljeShzdHJ1Y3QgY3B1ZnJlcV9wb2xpY3kgKnBvbGljeSwgdW5zaWduZWQgaW50
IGNwdSk7CiBpbnQgY3B1ZnJlcV91cGRhdGVfcG9saWN5KHVuc2lnbmVkIGludCBjcHUpOwogc3Ry
dWN0IGtvYmplY3QgKmdldF9nb3Zlcm5vcl9wYXJlbnRfa29iaihzdHJ1Y3QgY3B1ZnJlcV9wb2xp
Y3kgKnBvbGljeSk7Citib29sIGhhdmVfbXVsdGlwbGVfcG9saWNpZXModm9pZCk7CiAKICNpZmRl
ZiBDT05GSUdfQ1BVX0ZSRVEKIC8qIHF1ZXJ5IHRoZSBjdXJyZW50IENQVSBmcmVxdWVuY3kgKGlu
IGtIeikuIElmIHplcm8sIGNwdWZyZXEgY291bGRuJ3QgZGV0ZWN0IGl0ICovCi0tIAoxLjcuMTIu
cmMyLjE4Lmc2MWI0NzJlCgo=
--089e01184d74b4131004d8e5283f--
