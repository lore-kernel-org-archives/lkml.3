Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762654Ab3IDNSY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 09:18:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21543 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753093Ab3IDNSW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 09:18:22 -0400
Date: Wed, 4 Sep 2013 15:16:03 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org
Subject: [PATCH -tip v2] sched/cputime: do not scale when utime == 0
Message-ID: <20130904131602.GC2564@redhat.com>
References: <20130830230402.GA14760@somewhere>
 <20130902122845.GA2457@swordfish.minsk.epam.com>
 <20130902130744.GB2378@somewhere>
 <20130902135033.GA1686@redhat.com>
 <20130902140015.GB2368@swordfish.minsk.epam.com>
 <20130903084306.GA2694@redhat.com>
 <20130903180912.GA2340@swordfish>
 <20130903183229.GB30757@gmail.com>
 <20130904120857.GB2564@redhat.com>
 <20130904123350.GA9773@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130904123350.GA9773@gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

scale_stime() silently assumes that stime < rtime, otherwise when
stime == rtime and both values are big enough (operations on them do
not fit in 32 bits), the resulting scaling stime can be bigger than
rtime. In consequence utime = rtime - stime results in negative value.

User space visible symptoms of the bug are overflowed TIME values on
ps/top, for example:

ps aux | grep rcu
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
Cc: stable@vger.kernel.org
Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
v1 -> v2 : describe user visible symptoms of the bug

 kernel/sched/cputime.c |   19 +++++++++++--------
 1 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index ace34f9..9994791 100644
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
-- 
1.7.1

