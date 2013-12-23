Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757018Ab3LWHzx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 02:55:53 -0500
Received: from mail-qc0-f175.google.com ([209.85.216.175]:45808 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752885Ab3LWHzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 02:55:51 -0500
Message-ID: <52B7EC81.6060202@linaro.org>
Date: Mon, 23 Dec 2013 13:25:45 +0530
From: viresh kumar <viresh.kumar@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: =?UTF-8?B?QmrDuHJuIE1vcms=?= <bjorn@mork.no>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH Resend] cpufreq: remove sysfs files for CPU which failed
 to come back after resume
References: <610b63b7594e5cd364c498f60e69b9e174db9257.1387554926.git.viresh.kumar@linaro.org>	<1651441.C2UQleWVoy@vostro.rjw.lan> <871u14i00j.fsf@nemi.mork.no>	<CAKohpok1dGMPSAehwsVeiyHzxaHupenA4sP5cxCrjVYQMyrVWA@mail.gmail.com> <87d2kokqdl.fsf@nemi.mork.no>
In-Reply-To: <87d2kokqdl.fsf@nemi.mork.no>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 December 2013 12:25 PM, Bjørn Mork wrote:
> That's correct.  The immediate result of the failure is exactly the
> same.

Okay..

> The difference is that a subsequent resume would restore the cpufreq
> device whether it existed or not.  That made a complete suspend/resume
> fix up any missing cpufreq device, e.g. one that was removed by a
> previous error.

I see.. Please see if below patch fixes it for you, it should :)


From: Viresh Kumar <viresh.kumar@linaro.org>
Date: Mon, 23 Dec 2013 13:19:47 +0530
Subject: [PATCH] cpufreq: try to resume policies which failed on last resume
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

__cpufreq_add_dev() can fail sometimes while we are resuming our system.
Currently we are clearing all sysfs nodes for cpufreq's failed policy as that
could make userspace unstable. But if we suspend/resume again, we should atleast
try to bring back those policies.

This patch fixes this issue by clearing fallback data on failure and trying to
allocate a new struct cpufreq_policy on second resume.

Reported-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 drivers/cpufreq/cpufreq.c | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index fab042e..7523d35 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1010,16 +1010,24 @@ static int __cpufreq_add_dev(struct device *dev, struct subsys_interface *sif,
 	read_unlock_irqrestore(&cpufreq_driver_lock, flags);
 #endif

-	if (frozen)
+	if (frozen) {
 		/* Restore the saved policy when doing light-weight init */
 		policy = cpufreq_policy_restore(cpu);
-	else
+
+		/*
+		 * As we failed to resume cpufreq core last time, lets try to
+		 * create a new policy.
+		 */
+		if (!policy)
+			frozen = false;
+	}
+
+	if (!frozen)
 		policy = cpufreq_policy_alloc();

 	if (!policy)
 		goto nomem_out;

-
 	/*
 	 * In the resume path, since we restore a saved policy, the assignment
 	 * to policy->cpu is like an update of the existing policy, rather than
@@ -1112,8 +1120,14 @@ err_get_freq:
 	if (cpufreq_driver->exit)
 		cpufreq_driver->exit(policy);
 err_set_policy_cpu:
-	if (frozen)
+	if (frozen) {
+		/*
+		 * Clear fallback data as we should try to make things work on
+		 * next suspend/resume
+		 */
+		per_cpu(cpufreq_cpu_data_fallback, cpu) = NULL;
 		cpufreq_policy_put_kobj(policy);
+	}
 	cpufreq_policy_free(policy);

 nomem_out:

