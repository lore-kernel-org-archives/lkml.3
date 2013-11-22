Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242Ab3KVL37 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 06:29:59 -0500
Received: from mail-qe0-f44.google.com ([209.85.128.44]:45245 "EHLO
	mail-qe0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752638Ab3KVL34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 06:29:56 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, tianyu.lan@intel.com, nm@ti.com,
        jinchoi@broadcom.com, sebastian.capella@linaro.org,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 0/2] cpufreq: suspend governors during s2r/hibernation
Date: Fri, 22 Nov 2013 16:59:47 +0530
Message-Id: <cover.1385118255.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds cpufreq callbacks to dpm_{suspend|resume}_noirq() for
handling suspend/resume of cpufreq governors. This is required for early suspend
and late resume of governors.

There are multiple problems that are fixed by this patch:
- Nishanth Menon (TI) found an interesting problem on his platform, OMAP. His board
  wasn't working well with suspend/resume as calls for removing non-boot CPUs
  was turning out into a call to drivers ->target() which then tries to play
  with regulators. But regulators and their I2C bus were already suspended and
  this resulted in a failure. This is why we need a PM notifier here.
- Lan Tianyu (Intel) & Jinhyuk Choi (Broadcom) found another issue where
  tunables configuration for clusters/sockets with non-boot CPUs was getting
  lost after suspend/resume, as we were notifying governors with
  CPUFREQ_GOV_POLICY_EXIT on removal of the last cpu for that policy and so
  deallocating memory for tunables.

This was earlier sent here:
https://lkml.org/lkml/2013/11/15/107

V1->V2:
- Used direct callbacks from dpm_{suspend|resume}_noirq() for
  suspending/resuming govenors instead of doing that with help of PM notifiers.
- Patch 2/2: Switching to the desirable frequency before suspending the
  governors.


Viresh Kumar (2):
  cpufreq: suspend governors on system suspend/hibernate
  cpufreq: Change freq before suspending governors

 drivers/base/power/main.c |  3 ++
 drivers/cpufreq/cpufreq.c | 79 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/cpufreq.h   |  5 +++
 3 files changed, 87 insertions(+)

-- 
1.7.12.rc2.18.g61b472e

