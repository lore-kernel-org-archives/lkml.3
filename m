Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511Ab3LZAwV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Dec 2013 19:52:21 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:50364 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752446Ab3LZAwU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Dec 2013 19:52:20 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Viresh Kumar <viresh.kumar@linaro.org>, bjorn@mork.no
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] cpufreq: try to resume policies which failed on last resume
Date: Thu, 26 Dec 2013 02:05:50 +0100
Message-ID: <5562479.pVWRuDL0y6@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <f9d7b0d5424e4443597d2ed39bec3fedd2b10d1e.1387848958.git.viresh.kumar@linaro.org>
References: <f9d7b0d5424e4443597d2ed39bec3fedd2b10d1e.1387848958.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, December 24, 2013 07:11:00 AM Viresh Kumar wrote:
> __cpufreq_add_dev() can fail sometimes while we are resuming our system.
> Currently we are clearing all sysfs nodes for cpufreq's failed policy as that
> could make userspace unstable. But if we suspend/resume again, we should atleast
> try to bring back those policies.
> 
> This patch fixes this issue by clearing fallback data on failure and trying to
> allocate a new struct cpufreq_policy on second resume.
> 
> Reported-and-tested-by: Bjørn Mork <bjorn@mork.no>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>

Well, while I appreciate the work done here, I don't like the changelog,
I don't really like the way the code is written and I don't like the comments.
Sorry about that.

Bjorn, can you please test the patch below instead along with the [2/2]
from this series (on top of linux-pm.git/pm-cpufreq)?

Rafael


---
From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Subject: cpufreq: Clean up after a failing light-weight initialization

If cpufreq_policy_restore() returns NULL during system resume,
__cpufreq_add_dev() should just fall back to the full initialization
instead of returning an error, because that may actually make things
work.  Moreover, it should not leave stale fallback data behind after
it has failed to restore a previously existing policy.

This change is based on Viresh Kumar's work.

Reported-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/cpufreq/cpufreq.c |   23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

Index: linux-pm/drivers/cpufreq/cpufreq.c
===================================================================
--- linux-pm.orig/drivers/cpufreq/cpufreq.c
+++ linux-pm/drivers/cpufreq/cpufreq.c
@@ -1016,15 +1016,17 @@ static int __cpufreq_add_dev(struct devi
 	read_unlock_irqrestore(&cpufreq_driver_lock, flags);
 #endif
 
-	if (frozen)
-		/* Restore the saved policy when doing light-weight init */
-		policy = cpufreq_policy_restore(cpu);
-	else
+	/*
+	 * Restore the saved policy when doing light-weight init and fall back
+	 * to the full init if that fails.
+	 */
+	policy = frozen ? cpufreq_policy_restore(cpu) : NULL;
+	if (!policy) {
+		frozen = false;
 		policy = cpufreq_policy_alloc();
-
-	if (!policy)
-		goto nomem_out;
-
+		if (!policy)
+			goto nomem_out;
+	}
 
 	/*
 	 * In the resume path, since we restore a saved policy, the assignment
@@ -1118,8 +1120,11 @@ err_get_freq:
 	if (cpufreq_driver->exit)
 		cpufreq_driver->exit(policy);
 err_set_policy_cpu:
-	if (frozen)
+	if (frozen) {
+		/* Do not leave stale fallback data behind. */
+		per_cpu(cpufreq_cpu_data_fallback, cpu) = NULL;
 		cpufreq_policy_put_kobj(policy);
+	}
 	cpufreq_policy_free(policy);
 
 nomem_out:

