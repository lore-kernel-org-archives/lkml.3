Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108AbaBQJZ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 04:25:26 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:54745 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982AbaBQJZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 04:25:23 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org, nm@ti.com,
        swarren@wwwdotorg.org, kgene.kim@samsung.com, jinchoi@broadcom.com,
        tianyu.lan@intel.com, sebastian.capella@linaro.org,
        jhbird.choi@samsung.com, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V6 0/7] cpufreq: suspend early/resume late: dpm_{suspend|resume}()
Date: Mon, 17 Feb 2014 14:55:06 +0530
Message-Id: <cover.1392629003.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset creates/calls cpufreq suspend/resume callbacks from dpm_{suspend|resume}()
for handling suspend/resume of cpufreq governors and core.

There are multiple problems that are fixed by this patch:
- Nishanth Menon (TI) found an interesting problem on his platform, OMAP. His board
  wasn't working well with suspend/resume as calls for removing non-boot CPUs
  was turning out into a call to drivers ->target() which then tries to play
  with regulators. But regulators and their I2C bus were already suspended and
  this resulted in a failure. Many platforms have such problems, samsung, tegra,
  etc.. They solved it with driver specific PM notifiers where they used to
  disable their driver's ->target() routine.
- Lan Tianyu (Intel) & Jinhyuk Choi (Broadcom) found an issue where tunables
  configuration for clusters/sockets with non-boot CPUs was getting lost after
  suspend/resume, as we were notifying governors with CPUFREQ_GOV_POLICY_EXIT on
  removal of the last cpu for that policy and so deallocating memory for
  tunables.  This is fixed by this patch as we don't allow any operation on
  governors after device suspend and before device resume now.

This is already tested by few people and so incorporating their Tested-by as
well.

I have tested this again on latest stuff on my thinkpad for several
suspend/resume cycles.

V6->V7:
- Fixed crash reported by S.Warren on systems without a cpufreq driver.
- Moved some function doc-comments to patch 1 from a later patch.

For-v3.15

Viresh Kumar (7):
  cpufreq: suspend governors on system suspend/hibernate
  cpufreq: suspend governors from dpm_{suspend|resume}()
  cpufreq: call driver's suspend/resume for each policy
  cpufreq: Implement cpufreq_generic_suspend()
  cpufreq: exynos: Use cpufreq_generic_suspend()
  cpufreq: s5pv210: Use cpufreq_generic_suspend()
  cpufreq: Tegra: Use cpufreq_generic_suspend()

 drivers/base/power/main.c         |   5 ++
 drivers/cpufreq/cpufreq.c         | 137 +++++++++++++++++++++++---------------
 drivers/cpufreq/exynos-cpufreq.c  |  96 ++------------------------
 drivers/cpufreq/s5pv210-cpufreq.c |  49 +-------------
 drivers/cpufreq/tegra-cpufreq.c   |  46 ++-----------
 include/linux/cpufreq.h           |  11 +++
 6 files changed, 113 insertions(+), 231 deletions(-)

-- 
1.7.12.rc2.18.g61b472e

