Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776Ab3BVF4t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 00:56:49 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:38219 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866Ab3BVF4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 00:56:48 -0500
From: Kevin Hilman <khilman@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org
Subject: [PATCH 0/2] cpustat: use atomic operations to read/update stats
Date: Thu, 21 Feb 2013 21:56:42 -0800
Message-Id: <1361512604-2720-1-git-send-email-khilman@linaro.org>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 64-bit platforms, reads/writes of the various cpustat fields are
atomic due to native 64-bit loads/stores.  However, on non 64-bit
platforms, reads/writes of the cpustat fields are not atomic and could
lead to inconsistent statistics.

This problem was originally reported by Frederic Weisbecker as a
64-bit limitation with the nsec granularity cputime accounting for
full dynticks, but then we realized that it's a problem that's been
around for awhile and not specific to the new cputime accounting.

This series fixes this by first converting all access to the cputime
fields to use accessor functions, and then converting the accessor
functions to use the atomic64 functions.

Implemented based on idea proposed by Frederic Weisbecker.

Kevin Hilman (2):
  cpustat: use accessor functions for get/set/add
  cpustat: convert to atomic operations

 arch/s390/appldata/appldata_os.c   | 16 +++++++--------
 drivers/cpufreq/cpufreq_governor.c | 18 ++++++++---------
 drivers/cpufreq/cpufreq_ondemand.c |  2 +-
 drivers/macintosh/rack-meter.c     |  6 +++---
 fs/proc/stat.c                     | 40 +++++++++++++++++++-------------------
 fs/proc/uptime.c                   |  2 +-
 include/linux/kernel_stat.h        | 11 ++++++++++-
 kernel/sched/core.c                | 12 +++++-------
 kernel/sched/cputime.c             | 29 +++++++++++++--------------
 9 files changed, 70 insertions(+), 66 deletions(-)

-- 
1.8.1.2

