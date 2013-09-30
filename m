Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932161Ab3I3Ubh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 16:31:37 -0400
Received: from mga02.intel.com ([134.134.136.20]:33002 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756504Ab3I3U3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 16:29:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1010,1371106800"; 
   d="scan'208";a="412029766"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@linux.intel.com>, tglx@linutronix.de
Subject: [PATCH 03/11] posix-timers: Initialize timer value to 0 for invalid timers.
Date: Mon, 30 Sep 2013 13:29:04 -0700
Message-Id: <1380572952-30729-4-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1380572952-30729-1-git-send-email-andi@firstfloor.org>
References: <1380572952-30729-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

cpu_clock_sample et.al. can fail with an invalid timer type.
For most callers this cannot happen because the timer has been
successfully initialized earlier, so they don't check
the return value, but still use the val output.

Unfortunately static checkers for uninitialied variables
don't understand this and always throw a warning in this case.

Initialize the timer value to 0 for the error case to
shut it up.

This doesn't fix any real bug, just reduces warning noise.

Cc: tglx@linutronix.de
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 kernel/posix-cpu-timers.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index c7f31aa..cc3c3f2 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -182,6 +182,7 @@ static int cpu_clock_sample(const clockid_t which_clock, struct task_struct *p,
 {
 	switch (CPUCLOCK_WHICH(which_clock)) {
 	default:
+		*sample = 0;
 		return -EINVAL;
 	case CPUCLOCK_PROF:
 		*sample = prof_ticks(p);
@@ -243,6 +244,7 @@ static int cpu_clock_sample_group(const clockid_t which_clock,
 
 	switch (CPUCLOCK_WHICH(which_clock)) {
 	default:
+		*sample = 0;
 		return -EINVAL;
 	case CPUCLOCK_PROF:
 		thread_group_cputime(p, &cputime);
-- 
1.8.3.1

