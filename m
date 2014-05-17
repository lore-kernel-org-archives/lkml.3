Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022AbaEQEve (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 00:51:34 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:48058 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbaEQEvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 00:51:32 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, arvind.chauhan@arm.com,
        swarren@nvidia.com, nicolas.pitre@linaro.org, swarren@wwwdotorg.org,
        dianders@chromium.org, linux@arm.linux.org.uk,
        thomas.abraham@linaro.org, pdeschrijver@nvidia.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V3 0/4] cpufreq: add support for intermediate (stable)
Date: Sat, 17 May 2014 10:21:19 +0530
Message-Id: <cover.1400302114.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.0.0.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Douglas Anderson, recently pointed out an interesting problem due to which
udelay() was expiring earlier than it should.

While transitioning between frequencies few platforms may temporarily switch to
a stable frequency, waiting for the main PLL to stabilize.

For example: When we transition between very low frequencies on exynos, like
between 200MHz and 300MHz, we may temporarily switch to a PLL running at 800MHz.
No CPUFREQ notification is sent for that. That means there's a period of time
when we're running at 800MHz but loops_per_jiffy is calibrated at between 200MHz
and 300MHz. And so udelay behaves badly.

To get this fixed in a generic way, lets introduce another set of callbacks
get_intermediate() and target_intermediate(), only for drivers with
target_index() and CPUFREQ_ASYNC_NOTIFICATION unset.

get_intermediate should return a stable intermediate frequency platform wants to
switch to, and target_intermediate() should set CPU to to that frequency, before
jumping to the frequency corresponding to 'index'. Core will take care of
sending notifications and driver doesn't have to handle them in
target_intermediate() or target_index().

This patchset also update Tegra to use this new infrastructure and is already
tested by Stephen.

NOTE: Once set to intermediate frequency, driver isn't expected to fail for the
following ->target_index() call, if it fails core will issue a WARN().

V2-V3:
- Fix spelling error: s/Uset/Used
- Update tegra with the changes Stephen suggested
- Include a dependency patch sent separately earlier (3/4)

V1-V2: Almost changed completely, V1 was here: https://lkml.org/lkml/2014/5/15/40

Viresh Kumar (4):
  cpufreq: handle calls to ->target_index() in separate routine
  cpufreq: add support for intermediate (stable) frequencies
  cpufreq: Tegra: drop wrapper around tegra_update_cpu_speed()
  cpufreq: Tegra: implement intermediate frequency callbacks

 Documentation/cpu-freq/cpu-drivers.txt | 19 +++++++-
 drivers/cpufreq/cpufreq.c              | 82 ++++++++++++++++++++++++----------
 drivers/cpufreq/tegra-cpufreq.c        | 80 ++++++++++++++++-----------------
 include/linux/cpufreq.h                | 15 +++++++
 4 files changed, 129 insertions(+), 67 deletions(-)

-- 
2.0.0.rc2

