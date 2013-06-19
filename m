Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934391Ab3FSI7z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 04:59:55 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:43838 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934376Ab3FSIxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 04:53:23 -0400
From: Viresh Kumar <viresh.kumar@linaro.org>
To: rjw@sisk.pl
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        dave.martin@arm.com, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 00/13] CPUFreq: Fix {PRE|POST}CHANGE notification sequence
Date: Wed, 19 Jun 2013 14:22:54 +0530
Message-Id: <cover.1371630975.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 1.7.12.rc2.18.g61b472e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PRECHANGE and POSTCHANGE notifiers must be called in groups, i.e either both
should be called or both shouldn't be.

In case we have started PRECHANGE notifier and found an error, we must call
POSTCHANGE notifier with freqs.new = freqs.old to guarantee that sequence of
calling notifiers is complete.

This isn't obeyed by many of the drivers and core wasn't forcing it.

This patchset first fixes all the driver to follow it strictly and then adds
some protection against this. Now, we keep track of the last transaction and see
if something went wrong.

Last patch is intentionally kept towards the end, so that git bisect still works
well for all the faulty drivers.

This is pushed here and a pull request for 3.11 would be sent after few days.

git://git.linaro.org/people/vireshk/linux.git cpufreq-fix-notification

Viresh Kumar (13):
  cpufreq: acpi: call CPUFREQ_POSTCHANGE notfier in error cases
  cpufreq: arm-big-little: call CPUFREQ_POSTCHANGE notfier in error
    cases
  cpufreq: davinci: call CPUFREQ_POSTCHANGE notfier in error cases
  cpufreq: dbx500: call CPUFREQ_POSTCHANGE notfier in error cases
  cpufreq: e_powersave: call CPUFREQ_POSTCHANGE notfier in error cases
  cpufreq: exynos: call CPUFREQ_POSTCHANGE notfier in error cases
  cpufreq: imx6q: call CPUFREQ_POSTCHANGE notfier in error cases
  cpufreq: omap: call CPUFREQ_POSTCHANGE notfier in error cases
  cpufreq: pcc: call CPUFREQ_POSTCHANGE notfier in error cases
  cpufreq: powernow-k8: call CPUFREQ_POSTCHANGE notfier in error cases
  cpufreq: s3c64xx: call CPUFREQ_POSTCHANGE notfier in error cases
  cpufreq: tegra: call CPUFREQ_POSTCHANGE notfier in error cases
  cpufreq: make sure frequency transitions are serialized

 drivers/cpufreq/acpi-cpufreq.c    |  6 ++++--
 drivers/cpufreq/arm_big_little.c  |  4 +---
 drivers/cpufreq/cpufreq.c         |  9 +++++++++
 drivers/cpufreq/davinci-cpufreq.c |  3 +++
 drivers/cpufreq/dbx500-cpufreq.c  |  4 ++--
 drivers/cpufreq/e_powersaver.c    |  3 +++
 drivers/cpufreq/exynos-cpufreq.c  | 10 ++++++++--
 drivers/cpufreq/imx6q-cpufreq.c   | 17 +++++++++++------
 drivers/cpufreq/omap-cpufreq.c    |  6 +++---
 drivers/cpufreq/pcc-cpufreq.c     |  2 ++
 drivers/cpufreq/powernow-k8.c     |  6 +++---
 drivers/cpufreq/s3c64xx-cpufreq.c |  8 ++++++--
 drivers/cpufreq/tegra-cpufreq.c   |  4 ++--
 13 files changed, 57 insertions(+), 25 deletions(-)

-- 
1.7.12.rc2.18.g61b472e

