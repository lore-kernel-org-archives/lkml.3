Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741Ab3I2Tkb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 15:40:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59752 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756011Ab3I2T3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 15:29:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>
Subject: [ 09/71] sched/cputime: Do not scale when utime == 0
Date: Sun, 29 Sep 2013 12:27:21 -0700
Message-Id: <20130929192644.175870021@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130929192643.539596256@linuxfoundation.org>
References: <20130929192643.539596256@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit 5a8e01f8fa51f5cbce8f37acc050eb2319d12956 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/sched/cputime.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -557,7 +557,7 @@ static void cputime_adjust(struct task_c
 			   struct cputime *prev,
 			   cputime_t *ut, cputime_t *st)
 {
-	cputime_t rtime, stime, utime, total;
+	cputime_t rtime, stime, utime;
 
 	if (vtime_accounting_enabled()) {
 		*ut = curr->utime;
@@ -565,9 +565,6 @@ static void cputime_adjust(struct task_c
 		return;
 	}
 
-	stime = curr->stime;
-	total = stime + curr->utime;
-
 	/*
 	 * Tick based cputime accounting depend on random scheduling
 	 * timeslices of a task to be interrupted or not by the timer.
@@ -588,13 +585,19 @@ static void cputime_adjust(struct task_c
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


