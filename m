Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758751Ab3EAKFm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 06:05:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39018 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759472Ab3EAKFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 06:05:25 -0400
Date: Wed, 1 May 2013 03:04:50 -0700
From: tip-bot for Stanislaw Gruszka <tipbot@zytor.com>
Message-ID: <tip-772c808a252594692972773f6ee41c289b8e0b2a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, dave@sr71.net,
        fweisbec@gmail.com, tglx@linutronix.de, sgruszka@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, dave@sr71.net,
        fweisbec@gmail.com, tglx@linutronix.de, sgruszka@redhat.com
In-Reply-To: <1367314507-9728-2-git-send-email-sgruszka@redhat.com>
References: <1367314507-9728-2-git-send-email-sgruszka@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Do not account bogus utime
Git-Commit-ID: 772c808a252594692972773f6ee41c289b8e0b2a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  772c808a252594692972773f6ee41c289b8e0b2a
Gitweb:     http://git.kernel.org/tip/772c808a252594692972773f6ee41c289b8e0b2a
Author:     Stanislaw Gruszka <sgruszka@redhat.com>
AuthorDate: Tue, 30 Apr 2013 11:35:05 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 30 Apr 2013 19:13:04 +0200

sched: Do not account bogus utime

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
---
 kernel/sched/cputime.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/kernel/sched/cputime.c b/kernel/sched/cputime.c
index e9198ab..1b7c216 100644
--- a/kernel/sched/cputime.c
+++ b/kernel/sched/cputime.c
@@ -581,6 +581,14 @@ static void cputime_adjust(struct task_cputime *curr,
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
@@ -598,6 +606,7 @@ static void cputime_adjust(struct task_cputime *curr,
 	prev->stime = max(prev->stime, stime);
 	prev->utime = max(prev->utime, rtime - prev->stime);
 
+out:
 	*ut = prev->utime;
 	*st = prev->stime;
 }
