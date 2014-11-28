Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516AbaK1SY2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 13:24:28 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:56237 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbaK1SY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 13:24:26 -0500
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Tony Luck <tony.luck@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Ingo Molnar <mingo@kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [RFC PATCH 09/30] alpha: Fix jiffies based cputime assumption
Date: Fri, 28 Nov 2014 19:23:39 +0100
Message-Id: <1417199040-21044-10-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417199040-21044-1-git-send-email-fweisbec@gmail.com>
References: <1417199040-21044-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That code wrongly assumes that cputime_t wraps jiffies_t. Lets use
the correct accessors/mutators.

In practice there should be no harm yet because alpha currently
only support tick based cputime accounting which is always jiffies
based.

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/alpha/kernel/osf_sys.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/alpha/kernel/osf_sys.c b/arch/alpha/kernel/osf_sys.c
index f9c732e..6358718 100644
--- a/arch/alpha/kernel/osf_sys.c
+++ b/arch/alpha/kernel/osf_sys.c
@@ -1138,6 +1138,7 @@ SYSCALL_DEFINE2(osf_getrusage, int, who, struct rusage32 __user *, ru)
 {
 	struct rusage32 r;
 	cputime_t utime, stime;
+	unsigned int utime_jiffies, stime_jiffies;
 
 	if (who != RUSAGE_SELF && who != RUSAGE_CHILDREN)
 		return -EINVAL;
@@ -1146,14 +1147,18 @@ SYSCALL_DEFINE2(osf_getrusage, int, who, struct rusage32 __user *, ru)
 	switch (who) {
 	case RUSAGE_SELF:
 		task_cputime(current, &utime, &stime);
-		jiffies_to_timeval32(utime, &r.ru_utime);
-		jiffies_to_timeval32(stime, &r.ru_stime);
+		utime_jiffies = cputime_to_jiffies(utime);
+		stime_jiffies = cputime_to_jiffies(stime);
+		jiffies_to_timeval32(utime_jiffies, &r.ru_utime);
+		jiffies_to_timeval32(stime_jiffies, &r.ru_stime);
 		r.ru_minflt = current->min_flt;
 		r.ru_majflt = current->maj_flt;
 		break;
 	case RUSAGE_CHILDREN:
-		jiffies_to_timeval32(current->signal->cutime, &r.ru_utime);
-		jiffies_to_timeval32(current->signal->cstime, &r.ru_stime);
+		utime_jiffies = cputime_to_jiffies(current->signal->cutime);
+		stime_jiffies = cputime_to_jiffies(current->signal->cstime);
+		jiffies_to_timeval32(utime_jiffies, &r.ru_utime);
+		jiffies_to_timeval32(stime_jiffies, &r.ru_stime);
 		r.ru_minflt = current->signal->cmin_flt;
 		r.ru_majflt = current->signal->cmaj_flt;
 		break;
-- 
2.1.3

