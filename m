Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521Ab3IFT5b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 15:57:31 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:42890 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751070Ab3IFT52 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 15:57:28 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 2/5] cpufreq: Invoke __cpufreq_remove_dev_finish() after
 releasing cpu_hotplug.lock
To: rjw@sisk.pl, sboyd@codeaurora.org, viresh.kumar@linaro.org
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sat, 07 Sep 2013 01:23:27 +0530
Message-ID: <20130906195318.26919.88933.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20130906195206.26919.20884.stgit@srivatsabhat.in.ibm.com>
References: <20130906195206.26919.20884.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13090619-5806-0000-0000-000022A875CE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__cpufreq_remove_dev_finish() handles the kobject cleanup for a CPU going
offline. But because we destroy the kobject towards the end of the CPU offline
phase, there are certain race windows where a task can try to write to a
cpufreq sysfs file (eg: using store_scaling_max_freq()) while we are taking
that CPU offline, and this can bump up the kobject refcount, which in turn might
hinder the CPU offline task from running to completion. (It can also cause
other more serious problems such as trying to acquire a destroyed timer-mutex
etc., depending on the exact stage of the cleanup at which the task managed to
take a new refcount).

To fix the race window, we will need to synchronize those store_*() call-sites
with CPU hotplug, using get_online_cpus()/put_online_cpus(). However, that
in turn can cause a total deadlock because it can end up waiting for the
CPU offline task to complete, with incremented refcount!

Write to sysfs                            CPU offline task
--------------                            ----------------
kobj_refcnt++

                                          Acquire cpu_hotplug.lock

get_online_cpus();

					  Wait for kobj_refcnt to drop to zero

                     **DEADLOCK**



A simple way to avoid this problem is to perform the kobject cleanup in the
CPU offline path, with the cpu_hotplug.lock *released*. That is, we can
perform the wait-for-kobj-refcnt-to-drop as well as the subsequent cleanup
in the CPU_POST_DEAD stage of CPU offline, which is run with cpu_hotplug.lock
released. Doing this helps us avoid deadlocks due to holding kobject refcounts
and waiting on each other on the cpu_hotplug.lock.

(Note: We can't move all of the cpufreq CPU offline steps to the
CPU_POST_DEAD stage, because certain things such as stopping the governors
have to be done before the outgoing CPU is marked offline. So retain those
parts in the CPU_DOWN_PREPARE stage itself).

Reported-by: Stephen Boyd <sboyd@codeaurora.org>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 drivers/cpufreq/cpufreq.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 3e5aeb6..a6fe3fd 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -2085,6 +2085,9 @@ static int cpufreq_cpu_callback(struct notifier_block *nfb,
 
 		case CPU_DOWN_PREPARE:
 			__cpufreq_remove_dev_prepare(dev, NULL, frozen);
+			break;
+
+		case CPU_POST_DEAD:
 			__cpufreq_remove_dev_finish(dev, NULL, frozen);
 			break;
 

