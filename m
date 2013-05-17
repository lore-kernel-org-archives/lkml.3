Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758452Ab3EQWX1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 18:23:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54073 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756874Ab3EQVhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:37:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Hansen <dave@sr71.net>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, rostedt@goodmis.org
Subject: [ 021/102] sched: Do not account bogus utime
Date: Fri, 17 May 2013 14:35:36 -0700
Message-Id: <20130517213246.613748873@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517213244.277411019@linuxfoundation.org>
References: <20130517213244.277411019@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <sgruszka@redhat.com>

commit 772c808a252594692972773f6ee41c289b8e0b2a upstream.

Due to rounding in scale_stime(), for big numbers, scaled stime
values will grow in chunks. Since rtime grow in jiffies and we
calculate utime like below:

	prev->stime = max(prev->stime, stime);
	prev->utime = max(prev->utime, rtime - prev->stime);

we could erroneously account stime values as utime. To prevent
that only update prev->{u,s}time values when they are smaller
than current rtime.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: rostedt@goodmis.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Hansen <dave@sr71.net>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1367314507-9728-2-git-send-email-sgruszka@redhat.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/sched/cputime.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -591,6 +591,14 @@ static void cputime_adjust(struct task_c
 	 */
 	rtime = nsecs_to_cputime(curr->sum_exec_runtime);
 
+	/*
+	 * Update userspace visible utime/stime values only if actual execution
+	 * time is bigger than already exported. Note that can happen, that we
+	 * provided bigger values due to scaling inaccuracy on big numbers.
+	 */
+	if (prev->stime + prev->utime >= rtime)
+		goto out;
+
 	if (!rtime) {
 		stime = 0;
 	} else if (!total) {
@@ -608,6 +616,7 @@ static void cputime_adjust(struct task_c
 	prev->stime = max(prev->stime, stime);
 	prev->utime = max(prev->utime, rtime - prev->stime);
 
+out:
 	*ut = prev->utime;
 	*st = prev->stime;
 }


