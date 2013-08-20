Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752290Ab3HTGja (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 02:39:30 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:58643 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752156Ab3HTGj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 02:39:28 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 0/5] cpufreq: Fixes for 3.12
Date: Tue, 20 Aug 2013 12:08:21 +0530
Message-Id: <cover.1376979090.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

You recently did this:

commit 878f6e074e9a7784a6e351512eace4ccb3542eef
Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Date:   Sun Aug 18 15:35:59 2013 +0200

    Revert "cpufreq: Use cpufreq_policy_list for iterating over policies"
    
    Revert commit eb60852 (cpufreq: Use cpufreq_policy_list for iterating
    over policies), because it breaks system suspend/resume on multiple
    machines.
    
    It either causes resume to block indefinitely or causes the BUG_ON()
    in lock_policy_rwsem_##mode() to trigger on sysfs accesses to cpufreq
    attributes.
    
------x------------x---------------

This patchset gets the reverted patch back along with few supporting patches.
Cause of the initial problem you observed was this:

- At suspend all CPUs are removed leaving boot cpu. At this time policies aren't
  freed and also aren't removed from cpufreq_policy_list. And per-cpu variable
  cpufreq_cpu_data is marked as NULL.
- At resume CPUs other than boot cpu called __cpufreq_add_dev(). The tricky
  change that was introduced by my patch was: We iterate over list of policies
  instead of CPUs, where we used to get policy structure associated with
  CPUs using per-cpu variable. Which used to be NULL for first CPU of a policy
  that turned up. For the first cpu we don't want to call
  cpufreq_add_policy_cpu() but want __cpufreq_add_add() to continue.

  When we called cpufreq_add_policy_cpu() it tried to stop the governor (which
  was already stopped) and hence errors leading into unstable state.

This patchset fixes these issues and is tested with suspend-resume over my
thinkpad with ubuntu. Apart from minor cleanups it removes policy from
cpufreq_policy_list in case of suspend/resume as well and hence we will never
call cpufreq_add_policy_cpu() for first cpu of a policy.

--
viresh

Viresh Kumar (5):
  cpufreq: align closing brace '}' of an if block
  cpufreq: remove policy from cpufreq_policy_list in system suspend
  cpufreq: remove unnecessary check in __cpufreq_governor()
  cpufreq: remove cpufreq_policy_cpu per-cpu variable
  cpufreq: Use cpufreq_policy_list for iterating over policies

 drivers/cpufreq/cpufreq.c | 77 +++++++++++++++--------------------------------
 1 file changed, 24 insertions(+), 53 deletions(-)

-- 
1.7.12.rc2.18.g61b472e

