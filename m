Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181AbaCXIGB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 04:06:01 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:57527 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbaCXIF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 04:05:56 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V5 0/3] cpufreq: Introduce cpufreq_freq_transition_{begin|end}()
Date: Mon, 24 Mar 2014 13:35:43 +0530
Message-Id: <cover.1395644073.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Whenever we change the frequency of a CPU, we call the PRECHANGE and POSTCHANGE
notifiers. They must be serialized, i.e. PRECHANGE and POSTCHANGE notifiers
should strictly alternate, thereby preventing two different sets of PRECHANGE or
POSTCHANGE notifiers from interleaving arbitrarily.

The following examples illustrate why this is important:

Scenario 1:
-----------
A thread reading the value of cpuinfo_cur_freq, will call
__cpufreq_cpu_get()->cpufreq_out_of_sync()->cpufreq_notify_transition()

The ondemand governor can decide to change the frequency of the CPU at the same
time and hence it can end up sending the notifications via ->target().

If the notifiers are not serialized, the following sequence can occur:
- PRECHANGE Notification for freq A (from cpuinfo_cur_freq)
- PRECHANGE Notification for freq B (from target())
- Freq changed by target() to B
- POSTCHANGE Notification for freq B
- POSTCHANGE Notification for freq A

We can see from the above that the last POSTCHANGE Notification happens for freq
A but the hardware is set to run at freq B.

Where would we break then?: adjust_jiffies() in cpufreq.c & cpufreq_callback()
in arch/arm/kernel/smp.c (which also adjusts the jiffies). All the
loops_per_jiffy calculations will get messed up.

Scenario 2:
-----------
The governor calls __cpufreq_driver_target() to change the frequency. At the
same time, if we change scaling_{min|max}_freq from sysfs, it will end up
calling the governor's CPUFREQ_GOV_LIMITS notification, which will also call
__cpufreq_driver_target(). And hence we end up issuing concurrent calls to
->target().

Typically, platforms have the following logic in their ->target() routines:
(Eg: cpufreq-cpu0, omap, exynos, etc)

A. If new freq is more than old: Increase voltage
B. Change freq
C. If new freq is less than old: decrease voltage

Now, if the two concurrent calls to ->target() are X and Y, where X is trying to
increase the freq and Y is trying to decrease it, we get the following race
condition:

X.A: voltage gets increased for larger freq
Y.A: nothing happens
Y.B: freq gets decreased
Y.C: voltage gets decreased
X.B: freq gets increased
X.C: nothing happens

Thus we can end up setting a freq which is not supported by the voltage we have
set. That will probably make the clock to the CPU unstable and the system might
not work properly anymore.


This patchset introduces a new set of routines cpufreq_freq_transition_begin()
and cpufreq_freq_transition_end(), which will guarantee that calls to frequency
transition routines are serialized. Later patches force other drivers to use
these new routines.


V4: https://lkml.org/lkml/2014/3/21/23

V4->V5:
- Replaced false with 0 as the variable was of int type instead of bool.
- There were some discussions about requirement of a barrier, but it looks like
  overkill for now. So, leaving that unless we have a real problem.

Srivatsa S. Bhat (1):
  cpufreq: Make sure frequency transitions are serialized

Viresh Kumar (2):
  cpufreq: Convert existing drivers to use
    cpufreq_freq_transition_{begin|end}
  cpufreq: Make cpufreq_notify_transition &
    cpufreq_notify_post_transition static

 drivers/cpufreq/cpufreq-nforce2.c    |  4 +--
 drivers/cpufreq/cpufreq.c            | 52 +++++++++++++++++++++++++++++-------
 drivers/cpufreq/exynos5440-cpufreq.c |  4 +--
 drivers/cpufreq/gx-suspmod.c         |  4 +--
 drivers/cpufreq/integrator-cpufreq.c |  4 +--
 drivers/cpufreq/longhaul.c           |  4 +--
 drivers/cpufreq/pcc-cpufreq.c        |  4 +--
 drivers/cpufreq/powernow-k6.c        |  4 +--
 drivers/cpufreq/powernow-k7.c        |  4 +--
 drivers/cpufreq/powernow-k8.c        |  4 +--
 drivers/cpufreq/s3c24xx-cpufreq.c    |  4 +--
 drivers/cpufreq/sh-cpufreq.c         |  4 +--
 drivers/cpufreq/unicore2-cpufreq.c   |  4 +--
 include/linux/cpufreq.h              | 12 ++++++---
 14 files changed, 76 insertions(+), 36 deletions(-)

-- 
1.7.12.rc2.18.g61b472e

