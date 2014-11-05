Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608AbaKEO7a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 09:59:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50939 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755347AbaKEOyT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 09:54:19 -0500
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: robert.schoene@tu-dresden.de, sboyd@codeaurora.org,
        Prarit Bhargava <prarit@redhat.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>, linux-pm@vger.kernel.org
Subject: [PATCH 2/5] cpufreq, fix locking around CPUFREQ_GOV_POLICY_EXIT calls
Date: Wed,  5 Nov 2014 09:53:56 -0500
Message-Id: <1415199239-19019-3-git-send-email-prarit@redhat.com>
In-Reply-To: <1415199239-19019-1-git-send-email-prarit@redhat.com>
References: <1415199239-19019-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 955ef4833574636819cd269cfbae12f79cbde63a (" cpufreq: Drop rwsem
lock around CPUFREQ_GOV_POLICY_EXIT") opens up a hole in the locking
scheme for cpufreq.

Simple tests such as rapidly switching the governor between ondemand and
performance or attempting to read policy values while a governor switch occurs
now fail with very NULL pointer warnings, sysfs namespace collisions, and
system hangs.  In short, the locking that policy->rwsem is supposed to provide
is currently broken.

The identified commit attempts to resolve a lockdep warning by removing
a lock around a section of code which does a shutdown of the
existing policy.  The problem is that this is part of the _critical_ section of
code that switches the governors and must be protected by the lock; without
locking readers may access now NULL or stale data, and writes may collide with
each other.

With the previous patch, which now returns -EBUSY during times of
contention the deadlock reported in
955ef4833574636819cd269cfbae12f79cbde63a (" cpufreq: Drop rwsem lock
around CPUFREQ_GOV_POLICY_EXIT") cannot occur, so adding the locks back
into this section of code is possible.

Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linux-pm@vger.kernel.org
Signed-off-by: Prarit Bhargava <prarit@redhat.com>
---
 drivers/cpufreq/cpufreq.c |    4 ----
 include/linux/cpufreq.h   |    4 ----
 2 files changed, 8 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 3f09ca9..e33cb15 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -2222,9 +2222,7 @@ static int cpufreq_set_policy(struct cpufreq_policy *policy,
 	/* end old governor */
 	if (old_gov) {
 		__cpufreq_governor(policy, CPUFREQ_GOV_STOP);
-		up_write(&policy->rwsem);
 		__cpufreq_governor(policy, CPUFREQ_GOV_POLICY_EXIT);
-		down_write(&policy->rwsem);
 	}
 
 	/* start new governor */
@@ -2233,9 +2231,7 @@ static int cpufreq_set_policy(struct cpufreq_policy *policy,
 		if (!__cpufreq_governor(policy, CPUFREQ_GOV_START))
 			goto out;
 
-		up_write(&policy->rwsem);
 		__cpufreq_governor(policy, CPUFREQ_GOV_POLICY_EXIT);
-		down_write(&policy->rwsem);
 	}
 
 	/* new governor failed, so re-start old one */
diff --git a/include/linux/cpufreq.h b/include/linux/cpufreq.h
index 503b085..43909ad 100644
--- a/include/linux/cpufreq.h
+++ b/include/linux/cpufreq.h
@@ -100,10 +100,6 @@ struct cpufreq_policy {
 	 * - Any routine that will write to the policy structure and/or may take away
 	 *   the policy altogether (eg. CPU hotplug), will hold this lock in write
 	 *   mode before doing so.
-	 *
-	 * Additional rules:
-	 * - Lock should not be held across
-	 *     __cpufreq_governor(data, CPUFREQ_GOV_POLICY_EXIT);
 	 */
 	struct rw_semaphore	rwsem;
 
-- 
1.7.9.3

