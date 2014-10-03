Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753275AbaJCF2L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 01:28:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60815 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552AbaJCF2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 01:28:06 -0400
Date: Thu, 2 Oct 2014 22:27:13 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-9c2b9d30e28559a78c9e431cdd7f2c6bf5a9ee67@git.kernel.org>
Cc: mingo@kernel.org, torvalds@linux-foundation.org, peterz@infradead.org,
        acme@kernel.org, atomlin@redhat.com, riel@redhat.com,
        akpm@linux-foundation.org, sylvain.hitier@gmail.com,
        tglx@linutronix.de, oleg@redhat.com, vdavydov@parallels.com,
        rientjes@google.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        paulus@samba.org, daeseok.youn@gmail.com, stable@vger.kernel.org,
        keescook@chromium.org
Reply-To: mingo@kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, atomlin@redhat.com, acme@kernel.org,
        riel@redhat.com, akpm@linux-foundation.org, sylvain.hitier@gmail.com,
        oleg@redhat.com, tglx@linutronix.de, rientjes@google.com,
        vdavydov@parallels.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        paulus@samba.org, daeseok.youn@gmail.com, stable@vger.kernel.org,
        keescook@chromium.org
In-Reply-To: <20140929101201.GE5430@worktop>
References: <20140929101201.GE5430@worktop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Fix perf bug in fork()
Git-Commit-ID: 9c2b9d30e28559a78c9e431cdd7f2c6bf5a9ee67
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

Commit-ID:  9c2b9d30e28559a78c9e431cdd7f2c6bf5a9ee67
Gitweb:     http://git.kernel.org/tip/9c2b9d30e28559a78c9e431cdd7f2c6bf5a9ee67
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Mon, 29 Sep 2014 12:12:01 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 3 Oct 2014 05:41:08 +0200

perf: Fix perf bug in fork()

Oleg noticed that a cleanup by Sylvain actually uncovered a bug; by
calling perf_event_free_task() when failing sched_fork() we will not yet
have done the memset() on ->perf_event_ctxp[] and will therefore try and
'free' the inherited contexts, which are still in use by the parent
process.

This is bad and might explain some outstanding fuzzer failures ...

Suggested-by: Oleg Nesterov <oleg@redhat.com>
Reported-by: Oleg Nesterov <oleg@redhat.com>
Reported-by: Sylvain 'ythier' Hitier <sylvain.hitier@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Aaron Tomlin <atomlin@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Daeseok Youn <daeseok.youn@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Cc: <stable@vger.kernel.org>
Link: http://lkml.kernel.org/r/20140929101201.GE5430@worktop
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/core.c | 4 +++-
 kernel/fork.c        | 5 +++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index afdd9e1..658f232 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7956,8 +7956,10 @@ int perf_event_init_task(struct task_struct *child)
 
 	for_each_task_context_nr(ctxn) {
 		ret = perf_event_init_context(child, ctxn);
-		if (ret)
+		if (ret) {
+			perf_event_free_task(child);
 			return ret;
+		}
 	}
 
 	return 0;
diff --git a/kernel/fork.c b/kernel/fork.c
index 0cf9cdb..a91e47d 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1360,7 +1360,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 		goto bad_fork_cleanup_policy;
 	retval = audit_alloc(p);
 	if (retval)
-		goto bad_fork_cleanup_policy;
+		goto bad_fork_cleanup_perf;
 	/* copy all the process information */
 	shm_init_task(p);
 	retval = copy_semundo(clone_flags, p);
@@ -1566,8 +1566,9 @@ bad_fork_cleanup_semundo:
 	exit_sem(p);
 bad_fork_cleanup_audit:
 	audit_free(p);
-bad_fork_cleanup_policy:
+bad_fork_cleanup_perf:
 	perf_event_free_task(p);
+bad_fork_cleanup_policy:
 #ifdef CONFIG_NUMA
 	mpol_put(p->mempolicy);
 bad_fork_cleanup_threadgroup_lock:
