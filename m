Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935020Ab3IDOkt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 10:40:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54688 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934439Ab3IDOkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 10:40:33 -0400
Date: Wed, 4 Sep 2013 07:37:22 -0700
From: tip-bot for Stanislaw Gruszka <tipbot@zytor.com>
Message-ID: <tip-5a8e01f8fa51f5cbce8f37acc050eb2319d12956@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, sergey.senozhatsky@gmail.com, bp@alien8.de,
        paulmck@linux.vnet.ibm.com, fweisbec@gmail.com, tglx@linutronix.de,
        sgruszka@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, sergey.senozhatsky@gmail.com, bp@alien8.de,
        paulmck@linux.vnet.ibm.com, fweisbec@gmail.com, tglx@linutronix.de,
        sgruszka@redhat.com
In-Reply-To: <20130904131602.GC2564@redhat.com>
References: <20130904131602.GC2564@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/urgent] sched/cputime: Do not scale when utime == 0
Git-Commit-ID: 5a8e01f8fa51f5cbce8f37acc050eb2319d12956
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 04 Sep 2013 07:37:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5a8e01f8fa51f5cbce8f37acc050eb2319d12956
Gitweb:     http://git.kernel.org/tip/5a8e01f8fa51f5cbce8f37acc050eb2319d12956
Author:     Stanislaw Gruszka <sgruszka@redhat.com>
AuthorDate: Wed, 4 Sep 2013 15:16:03 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 4 Sep 2013 16:31:25 +0200

sched/cputime: Do not scale when utime == 0

scale_stime() silently assumes that stime < rtime, otherwise
when stime == rtime and both values are big enough (operations
on them do not fit in 32 bits), the resulting scaling stime can
be bigger than rtime. In consequence utime = rtime - stime
results in negative value.

User space visible symptoms of the bug are overflowed TIME
values on ps/top, for example:

 $ ps aux | grep rcu
 root         8  0.0  0.0      0     0 ?        S    12:42   0:00 [rcuc/0]
 root         9  0.0  0.0      0     0 ?        S    12:42   0:00 [rcub/0]
 root        10 62422329  0.0  0     0 ?        R    12:42 21114581:37 [rcu_preempt]
 root        11  0.1  0.0      0     0 ?        S    12:42   0:02 [rcuop/0]
 root        12 62422329  0.0  0     0 ?        S    12:42 21114581:35 [rcuop/1]
 root        10 62422329  0.0  0     0 ?        R    12:42 21114581:37 [rcu_preempt]

or overflowed utime values read directly from /proc/$PID/stat

Reference:

  https://lkml.org/lkml/2013/8/20/259

Reported-and-tested-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: stable@vger.kernel.org
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Borislav Petkov <bp@alien8.de>
Link: http://lkml.kernel.org/r/20130904131602.GC2564@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
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
