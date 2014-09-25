Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806AbaIYIgQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 04:36:16 -0400
Received: from mga03.intel.com ([134.134.136.65]:61732 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601AbaIYIgO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 04:36:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,595,1406617200"; 
   d="scan'208";a="608342330"
From: Lan Tianyu <tianyu.lan@intel.com>
To: peterz@infradead.org, mingo@kernel.org, rafael.j.wysocki@intel.com,
        toshi.kani@hp.com, akpm@linux-foundation.org, tianyu.lan@intel.com,
        ktkhai@parallels.com, fabf@skynet.be, laijs@cn.fujitsu.com,
        srivatsa.bhat@linux.vnet.ibm.com, ego@linux.vnet.ibm.com,
        srivatsa@mit.edu, viresh.kumar@linaro.org
Cc: todd.e.brandt@linux.intel.com, tipbot@zytor.com,
        wangyun@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: [RFC PATCH V3 0/3] PM/CPU: Parallel enalbing nonboot cpus with resume devices
Date: Thu, 25 Sep 2014 16:32:02 +0800
Message-Id: <1411633925-9018-1-git-send-email-tianyu.lan@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is to parallel enabling nonboot cpus with resuming devices
during system resume in order to accelerate S2RAM. From test result on
a 8 logical core Haswell machine, system resume time reduces from 347ms
to 217ms with this patchset.

In the current world, all nonboot cpus are enabled serially during system
resume. System resume sequence is that boot cpu enables nonboot cpu one by
one and then resume devices. Before resuming devices, there are few tasks
assigned to nonboot cpus after they are brought up. This wastes cpu usage.

This patchset is to allow boot cpu to go forward to resume devices after
bringing up one nonboot cpu and starting a thread. The thread will be in
charge of bringing up other frozen cpus. The thread will be scheduled to
the first online cpu to run . This makes enabling cpu2~x parallel with
resuming devices.

Patch 2 is to change the policy of init MTRR/PAT for nonboot cpus. Original
code is to init all nonboot cpus' MTRR/PAT after all nonboot cpus coming online
during system resume. Now parallel enabling nonboot cpus with resuming devices and
nonboot cpus will be assigned with tasks before all cpus are online. So
it's necessary to do init MTRR/PAT just after one nonboot cpus comes online
just like dynamic single cpu online. 

Patch 3 is to guarantee that all cpus are online before changing cpufreq_suspended
flag in the cpufreq_resume() to avoid breaking cpufreq subsystem.

Lan Tianyu (3):
  PM/CPU: Parallel enalbing nonboot cpus with resume devices
  X86/CPU: Initialize MTRR/PAT when each cpu is online during system
    resume.
  Cpufreq: Hold cpu_add_remove_lock before change cpufreq_suspended flag

 drivers/cpufreq/cpufreq.c |  2 ++
 kernel/cpu.c              | 64 +++++++++++++++++++++++++++++++++++++++--------
 2 files changed, 55 insertions(+), 11 deletions(-)

-- 
1.8.4.rc0.1.g8f6a3e5.dirty

