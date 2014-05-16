Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932166AbaEPJDx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 05:03:53 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:36650 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755851AbaEPJDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 05:03:50 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, arvind.chauhan@arm.com,
        swarren@nvidia.com, nicolas.pitre@linaro.org, swarren@wwwdotorg.org,
        dianders@chromium.org, linux@arm.linux.org.uk,
        thomas.abraham@linaro.org, pdeschrijver@nvidia.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V2 0/3] cpufreq: add support for intermediate (stable)
Date: Fri, 16 May 2014 14:33:33 +0530
Message-Id: <cover.1400230695.git.viresh.kumar@linaro.org>
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

This patchset also update Tegra to use this new infrastructure.

NOTE: Once set to intermediate frequency, driver isn't expected to fail for the
following ->target_index() call, if it fails core will issue a WARN().

@Stephen: Can you please test this? I haven't as I didn't had a board. :)

V1-V2: Almost changed completely, V1 was here: https://lkml.org/lkml/2014/5/15/40

Viresh Kumar (3):
  cpufreq: handle calls to ->target_index() in separate routine
  cpufreq: add support for intermediate (stable) frequencies
  cpufreq: Tegra: implement intermediate frequency callbacks

 Documentation/cpu-freq/cpu-drivers.txt | 19 +++++++-
 drivers/cpufreq/cpufreq.c              | 82 ++++++++++++++++++++++++----------
 drivers/cpufreq/tegra-cpufreq.c        | 81 ++++++++++++++++-----------------
 include/linux/cpufreq.h                | 15 +++++++
 4 files changed, 128 insertions(+), 69 deletions(-)

-- 
2.0.0.rc2

