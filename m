Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757213Ab3KZOg3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 09:36:29 -0500
Received: from mail-ob0-f178.google.com ([209.85.214.178]:40301 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757186Ab3KZOgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 09:36:23 -0500
MIME-Version: 1.0
Date: Tue, 26 Nov 2013 20:06:22 +0530
Message-ID: <CAKohpoka9VCi+Siygf6wWF4v=9pZawtO-ZZ5EoFDuJpAyv7VBA@mail.gmail.com>
Subject: Re: [PATCH V3 4/6] cpufreq: exynos: Use cpufreq_generic_suspend()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nishanth Menon <nm@ti.com>, Stephen Warren <swarren@wwwdotorg.org>,
        Kgene Kim <kgene.kim@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        linux-tegra@vger.kernel.org, jinchoi@broadcom.com,
        Lan Tianyu <tianyu.lan@intel.com>,
        Sebastian Capella <sebastian.capella@linaro.org>,
        Jonghwan Choi <jhbird.choi@samsung.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 November 2013 19:41, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> Currently we have implemented PM notifiers to disable/enable ->target() routines
> functionality during suspend/resume.
>
> Now we have support present in cpufreq core, lets use it.
>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
>  drivers/cpufreq/exynos-cpufreq.c | 97 +++-------------------------------------
>  1 file changed, 6 insertions(+), 91 deletions(-)

Jonghwan Choi reported an issue with this patch. He asked me
to look at: 6e45eb

And so following diff is updated for this patch in my repo.. Will get
that fixed in V4:

diff --git a/drivers/cpufreq/exynos-cpufreq.c b/drivers/cpufreq/exynos-cpufreq.c
index 4b6e6a6..3f216da 100644
--- a/drivers/cpufreq/exynos-cpufreq.c
+++ b/drivers/cpufreq/exynos-cpufreq.c
@@ -22,8 +22,8 @@
 #include "exynos-cpufreq.h"

 static struct exynos_dvfs_info *exynos_info;
-
 static struct regulator *arm_regulator;
+static unsigned int locking_frequency;

 static int exynos_cpufreq_get_index(unsigned int freq)
 {
@@ -134,7 +134,7 @@ static int exynos_target(struct cpufreq_policy
*policy, unsigned int index)
 static int exynos_cpufreq_cpu_init(struct cpufreq_policy *policy)
 {
        policy->clk = exynos_info->cpu_clk;
-       policy->suspend_freq = clk_get_rate(exynos_info->cpu_clk) / 1000;
+       policy->suspend_freq = locking_frequency;
        return cpufreq_generic_init(policy, exynos_info->freq_table, 100000);
 }

@@ -182,6 +182,9 @@ static int __init exynos_cpufreq_init(void)
                goto err_vdd_arm;
        }

+       /* Done here as we want to capture boot frequency */
+       locking_frequency = clk_get_rate(exynos_info->cpu_clk) / 1000;
+
        if (!cpufreq_register_driver(&exynos_driver))
                return 0;
