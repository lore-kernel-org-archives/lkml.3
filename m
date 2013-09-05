Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935688Ab3IELJ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 07:09:57 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:62768 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934153Ab3IELJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 07:09:55 -0400
Date: Thu, 5 Sep 2013 13:09:52 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: [GIT PULL] cputime fix
Message-ID: <20130905110952.GA23323@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers-urgent-for-linus

   HEAD: 5a8e01f8fa51f5cbce8f37acc050eb2319d12956 sched/cputime: Do not scale when utime == 0

This fixes a longer-standing cputime accounting bug that Stanislaw Gruszka 
finally managed to track down.

 Thanks,

	Ingo

------------------>
Stanislaw Gruszka (1):
      sched/cputime: Do not scale when utime == 0


 kernel/sched/cputime.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index c1d7493..5b03f5b 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -551,10 +551,7 @@ static void cputime_adjust(struct task_cputime *curr,
 			   struct cputime *prev,
 			   cputime_t *ut, cputime_t *st)
 {
-	cputime_t rtime, stime, utime, total;
-
-	stime = curr->stime;
-	total = stime + curr->utime;
+	cputime_t rtime, stime, utime;
 
 	/*
 	 * Tick based cputime accounting depend on random scheduling
@@ -576,13 +573,19 @@ static void cputime_adjust(struct task_cputime *curr,
 	if (prev->stime + prev->utime >= rtime)
 		goto out;
 
-	if (total) {
+	stime = curr->stime;
+	utime = curr->utime;
+
+	if (utime == 0) {
+		stime = rtime;
+	} else if (stime == 0) {
+		utime = rtime;
+	} else {
+		cputime_t total = stime + utime;
+
 		stime = scale_stime((__force u64)stime,
 				    (__force u64)rtime, (__force u64)total);
 		utime = rtime - stime;
-	} else {
-		stime = rtime;
-		utime = 0;
 	}
 
 	/*
