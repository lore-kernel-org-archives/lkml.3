Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443Ab3CDHiL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 02:38:11 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:50777 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755373Ab3CDHiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 02:38:08 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        robin.randhawa@arm.com, Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V3 0/4] CPUFreq: Implement per policy instances of governors
Date: Mon,  4 Mar 2013 15:37:52 +0800
Message-Id: <cover.1362381470.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is targetted for 3.10-rc1 or linux-next just after the merge window.

All patches are pushed here for others to apply:
http://git.linaro.org/gitweb?p=people/vireshk/linux.git;a=shortlog;h=refs/heads/for-3.10

Currently, there can't be multiple instances of single governor_type. If we have
a multi-package system, where we have multiple instances of struct policy (per
package), we can't have multiple instances of same governor. i.e. We can't have
multiple instances of ondemand governor for multiple packages.

Governors directory in sysfs is created at /sys/devices/system/cpu/cpufreq/
governor-name/. Which again reflects that there can be only one instance of a
governor_type in the system.

This is a bottleneck for multicluster system, where we want different packages
to use same governor type, but with different tunables.

This patchset is inclined towards fixing this issue. Now we will create
governors directory in cpu/cpu*/cpufreq/<gov> for platforms which have multiple
struct policy alive at any moment. For others the interface is kept same:
cpu/cpufreq/<gov>.

@Rafael: Clearly, I don't want to have following patch: "cpufreq: Add Kconfig
option to enable/disable have_multiple_policies" and added it because of comment
from Borislov against which nobody else replied :)

So, please drop it if you agree over my comments with earlier version.

V2->V3:
- Fixed value of CPUFREQ_GOV_POLICY_EXIT in the correct patch
- Drop indentation fixes from intel_pstate.c

V1->V2:
- Few patches from V1 are already picked up by Rafael for 3.9-rc1
- Last two patches are new
- Added dbs_data->exit() routines to free up memory used for struct tuners.

Viresh Kumar (4):
  cpufreq: Add per policy governor-init/exit infrastructure
  cpufreq: governor: Implement per policy instances of governors
  cpufreq: Get rid of "struct global_attr"
  cpufreq: Add Kconfig option to enable/disable have_multiple_policies

 drivers/cpufreq/Kconfig                |   3 +
 drivers/cpufreq/acpi-cpufreq.c         |   9 +-
 drivers/cpufreq/cpufreq.c              |  27 +++--
 drivers/cpufreq/cpufreq_conservative.c | 148 +++++++++++++---------
 drivers/cpufreq/cpufreq_governor.c     | 159 ++++++++++++++----------
 drivers/cpufreq/cpufreq_governor.h     |  43 +++++--
 drivers/cpufreq/cpufreq_ondemand.c     | 216 +++++++++++++++++++--------------
 drivers/cpufreq/intel_pstate.c         |  20 +--
 include/linux/cpufreq.h                |  44 ++++---
 9 files changed, 397 insertions(+), 272 deletions(-)

-- 
1.7.12.rc2.18.g61b472e

