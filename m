Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755410Ab3CDHri (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 02:47:38 -0500
Received: from mail-da0-f48.google.com ([209.85.210.48]:40594 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773Ab3CDHrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 02:47:35 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, rickard.andersson@stericsson.com,
        fabio.baltieri@linaro.org, tj@kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 0/2] cpufreq: governors: Avoid unnecessary per cpu timer interrupts
Date: Mon,  4 Mar 2013 15:47:22 +0800
Message-Id: <cover.1362382746.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following patch has introduced per cpu timers or works for ondemand and
conservative governors.

        commit 2abfa876f1117b0ab45f191fb1f82c41b1cbc8fe
        Author: Rickard Andersson <rickard.andersson@stericsson.com>
        Date:   Thu Dec 27 14:55:38 2012 +0000

            cpufreq: handle SW coordinated CPUs

This causes additional unnecessary interrupts on all cpus when the load is
recently evaluated by any other cpu. i.e. When load is recently evaluated by cpu
x, we don't really need any other cpu to evaluate this load again for the next
sampling_rate time.

Some sort of code is present to avoid that but we are still getting timer
interrupts for all cpus. A good way of avoiding this would be to modify delays
for all cpus (policy->cpus) whenever any cpu has evaluated load.

This patchset tries to fix this issue.

These patches are applied here:

http://git.linaro.org/gitweb?p=people/vireshk/linux.git;a=shortlog;h=refs/heads/for-3.10

V1->V2:
- Dropped Workqueue modifications and use system_wq directly.

Viresh Kumar (2):
  cpufreq: ondemand: Don't update sample_type if we don't evaluate load
    again
  cpufreq: governors: Avoid unnecessary per cpu timer interrupts

 drivers/cpufreq/cpufreq_conservative.c |  8 ++++---
 drivers/cpufreq/cpufreq_governor.c     | 39 ++++++++++++++++++++++++----------
 drivers/cpufreq/cpufreq_governor.h     |  2 ++
 drivers/cpufreq/cpufreq_ondemand.c     | 34 ++++++++++++++---------------
 4 files changed, 52 insertions(+), 31 deletions(-)

-- 
1.7.12.rc2.18.g61b472e

