Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752940Ab3BKHuZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 02:50:25 -0500
Received: from service87.mimecast.com ([91.220.42.44]:40561 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715Ab3BKHuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 02:50:23 -0500
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, linaro-dev@lists.linaro.org,
        francescolavra.fl@gmail.com, toddpoynor@google.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 0/4] CPUFreq: Implement per policy instances of governors
Date: Mon, 11 Feb 2013 13:19:59 +0530
Message-Id: <cover.1360568193.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
X-OriginalArrivalTime: 11 Feb 2013 07:50:20.0359 (UTC) FILETIME=[70C0CD70:01CE082C]
X-MC-Unique: 113021107502100701
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r1B7oRb0015026

This is targetted for 3.10-rc1 or linux-next just after the merge window.

All patches are pushed here for others to apply:
http://git.linaro.org/gitweb?p=people/vireshk/linux.git;a=shortlog;h=refs/heads/cpufreq-updates-3.10

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

V1->V2:
- Few patches from V1 are already picked up by Rafael for 3.9-rc1
- Last two patches are new
- Added dbs_data->exit() routines to free up memory used for struct tuners.

@Rafael: I don't really want to have following patch: "cpufreq: Add Kconfig
option to enable/disable have_multiple_policies" and added it because of comment
from Borislov against which nobody else replied :)

I still want to have your opinion on the same.

Viresh Kumar (4):
  cpufreq: Add per policy governor-init/exit infrastructure
  cpufreq: governor: Implement per policy instances of governors
  cpufreq: Add Kconfig option to enable/disable have_multiple_policies
  cpufreq: Get rid of "struct global_attr"

 drivers/cpufreq/Kconfig                |   3 +
 drivers/cpufreq/acpi-cpufreq.c         |   9 +-
 drivers/cpufreq/cpufreq.c              |  27 +++--
 drivers/cpufreq/cpufreq_conservative.c | 148 +++++++++++++---------
 drivers/cpufreq/cpufreq_governor.c     | 159 ++++++++++++++----------
 drivers/cpufreq/cpufreq_governor.h     |  43 +++++--
 drivers/cpufreq/cpufreq_ondemand.c     | 216 +++++++++++++++++++--------------
 drivers/cpufreq/intel_pstate.c         |  30 ++---
 include/linux/cpufreq.h                |  44 ++++---
 9 files changed, 402 insertions(+), 277 deletions(-)

-- 
1.7.12.rc2.18.g61b472e


