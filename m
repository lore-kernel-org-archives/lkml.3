Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104AbaEVFho (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 01:37:44 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:56772 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203AbaEVFhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 01:37:43 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, arvind.chauhan@arm.com,
        inderpal.s@samsung.com, nm@ti.com, chander.kashyap@linaro.org,
        pavel@ucw.cz, len.brown@intel.com, sudeep.holla@arm.com,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Shawn Guo <shawn.guo@linaro.org>
Subject: [PATCH V3 0/8] CPUFreq: Initialize CPU's OPP tables from CPU core
Date: Thu, 22 May 2014 11:07:24 +0530
Message-Id: <cover.1400736536.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.0.0.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is third attempt to initialize CPU's OPPs from CPU core code. First two are
here: https://lkml.org/lkml/2014/5/19/57 and https://lkml.org/lkml/2014/5/21/199

Drivers expecting CPU's OPPs from device tree initialize OPP table themselves by
calling of_init_opp_table() and there is nothing driver specific in that. They
all do it in the same redundant way.

It would be better if we can get rid of redundancy by initializing CPU OPPs from
CPU core code for all CPUs (that have a "operating-points" property defined in
their node).

This patchset is all about that.

The idea was initially discussed here: https://lkml.org/lkml/2014/5/17/123

V2->V3:
- s/dev_info/dev_dbg
- Fixed changelogs

V1->V2:
- Addition of two new patches: 1/2 & 2/2
- Created separate routine of_init_cpu_opp_table() which wouldn't add any
  overhead for the platforms which don't have OPP or OF enabled.
- Added a print for success case as well
- Added Acks from Shawn
- Got rid of extra indentation level by returning early from register_cpu().

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Amit Daniel Kachhap <amit.daniel@samsung.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: Shawn Guo <shawn.guo@linaro.org>

Viresh Kumar (8):
  cpufreq: cpufreq-cpu0: remove dependency on thermal
  opp: of_init_opp_table(): return -ENOSYS when feature isn't
    implemented
  opp: call of_node_{get|put}() from of_init_opp_table()
  driver/core: cpu: initialize opp table
  cpufreq: arm_big_little: don't initialize opp table
  cpufreq: imx6q: don't initialize opp table
  cpufreq: cpufreq-cpu0: don't initialize opp table
  cpufreq: exynos5440: don't initialize opp table

 arch/arm/mach-imx/mach-imx6q.c       | 36 ++++++++----------------------------
 drivers/base/cpu.c                   | 30 ++++++++++++++++++++++++++----
 drivers/base/power/opp.c             |  4 ++++
 drivers/cpufreq/Kconfig              |  2 +-
 drivers/cpufreq/arm_big_little.c     | 12 +++++++-----
 drivers/cpufreq/arm_big_little_dt.c  | 18 ------------------
 drivers/cpufreq/cpufreq-cpu0.c       |  6 ------
 drivers/cpufreq/exynos5440-cpufreq.c |  6 ------
 drivers/cpufreq/imx6q-cpufreq.c      | 20 +-------------------
 include/linux/pm_opp.h               |  2 +-
 10 files changed, 48 insertions(+), 88 deletions(-)

-- 
2.0.0.rc2

