Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751100AbaFBRTl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 13:19:41 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:52316 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723AbaFBRTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 13:19:39 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@rjwysocki.net
Cc: linaro-kernel@lists.linaro.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, arvind.chauhan@arm.com,
        swarren@nvidia.com, dianders@chromium.org, linux@arm.linux.org.uk,
        nicolas.pitre@linaro.org, thomas.abraham@linaro.org,
        pdeschrijver@nvidia.com, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH V5 0/2] cpufreq: add support for intermediate (stable) frequencies
Date: Mon,  2 Jun 2014 22:49:27 +0530
Message-Id: <cover.1401728994.git.viresh.kumar@linaro.org>
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

get_intermediate() should return a stable intermediate frequency platform wants
to switch to, and target_intermediate() should set CPU to to that frequency,
before jumping to the frequency corresponding to 'index'. Core will take care of
sending notifications and driver doesn't have to handle them in
target_intermediate() or target_index().

This patchset also update Tegra to use this new infrastructure and is already
tested by Stephen.

V4->V5:
- Moved setting old frequency to __target_index() from __target_intermediate()
- Replaced retval with 0 during call to cpufreq_freq_transition_end() for
  restoring to restored freq.
- Fix important issues with Tegra driver as reported by Stephen.
- Dropped patch 1, already applied: "cpufreq: handle calls to ->target_index()
  in separate routine"

V3->V4:
- Allow get_intermediate() to return zero when we don't need to switch to
  intermediate first
- Get rid of 'goto' and create another routine for handling intermediate freqs
- Allow target_index() to fail, its not a crime :)
- Fix tegra driver to return zero from get_intermediate() for few situations
  (refer to patch 3/4)
- Fix issues with tegra's patch, like s/rate/rate * 1000
- Overall there are more modifications that what Doug requested as I felt we
  need better support from core.
- Looks much better now, thanks Doug :)

V2-V3:
- Fix spelling error: s/Uset/Used
- Update tegra with the changes Stephen suggested
- Include a dependency patch sent separately earlier (3/4)

V1-V2: Almost changed completely, V1 was here: https://lkml.org/lkml/2014/5/15/40

Viresh Kumar (2):
  cpufreq: add support for intermediate (stable) frequencies
  cpufreq: Tegra: implement intermediate frequency callbacks

 Documentation/cpu-freq/cpu-drivers.txt | 29 +++++++++-
 drivers/cpufreq/cpufreq.c              | 67 ++++++++++++++++++++---
 drivers/cpufreq/tegra-cpufreq.c        | 97 ++++++++++++++++++++++------------
 include/linux/cpufreq.h                | 25 +++++++++
 4 files changed, 174 insertions(+), 44 deletions(-)

-- 
2.0.0.rc2

