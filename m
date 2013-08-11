Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669Ab3HKR7F (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 13:59:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22440 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754331Ab3HKR7C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 13:59:02 -0400
Date: Sun, 11 Aug 2013 19:53:25 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@amacapital.net>,
        Ben Woodard <woodard@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Mark Grondona <mgrondona@llnl.gov>, linux-kernel@vger.kernel.org
Subject: [PATCH] __ptrace_may_access() should not deny sub-threads
Message-ID: <20130811175325.GA12587@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mark Grondona <mgrondona@llnl.gov>

__ptrace_may_access() checks get_dumpable/ptrace_has_cap/etc
if task != current, this can can lead to surprising results.

For example, a sub-thread can't readlink("/proc/self/exe") if
the executable is not readable. setup_new_exec()->would_dump()
notices that inode_permission(MAY_READ) fails and then it does
set_dumpable(suid_dumpable). After that get_dumpable() fails.

(It is not clear why proc_pid_readlink() checks get_dumpable(),
 perhaps we could add PTRACE_MODE_NODUMPABLE)

Change __ptrace_may_access() to use same_thread_group() instead
of "task == current". Any security check is pointless when the
tasks share the same ->mm.

Signed-off-by: Mark Grondona <mgrondona@llnl.gov>
Signed-off-by: Ben Woodard <woodard@redhat.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/ptrace.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index a146ee3..dd562e9 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -236,7 +236,7 @@ static int __ptrace_may_access(struct task_struct *task, unsigned int mode)
 	 */
 	int dumpable = 0;
 	/* Don't let security modules deny introspection */
-	if (task == current)
+	if (same_thread_group(task, current))
 		return 0;
 	rcu_read_lock();
 	tcred = __task_cred(task);
-- 
1.5.5.1


