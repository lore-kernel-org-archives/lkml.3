Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657Ab3BQTUk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 14:20:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12049 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752189Ab3BQTUe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 14:20:34 -0500
Date: Sun, 17 Feb 2013 20:19:05 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@redhat.com>,
        Mandeep Singh Baines <msb@chromium.org>,
        Neil Horman <nhorman@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Roland McGrath <roland@hack.frob.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] coredump: sanitize the setting of
	signal->group_exit_code
Message-ID: <20130217191905.GA21820@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130217191819.GA21778@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that the coredumping process can be SIGKILL'ed, the setting of
->group_exit_code in do_coredump() can race with complete_signal()
and SIGKILL or 0x80 can be "lost", or wait(status) can report
status == SIGKILL | 0x80.

But the main problem is that it is not clear to me what should we
do if binfmt->core_dump() succeeds but SIGKILL was sent, that is
why this patch comes as a separate change.

This patch adds 0x80 if ->core_dump() succeeds and the process was
not killed. But perhaps we can (should?) re-set ->group_exit_code
changed by SIGKILL back to "siginfo->si_signo |= 0x80" in case when
core_dumped == T.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 fs/coredump.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index 835d731..5503d94 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -390,12 +390,14 @@ static int coredump_wait(int exit_code, struct core_state *core_state)
 	return core_waiters;
 }
 
-static void coredump_finish(struct mm_struct *mm)
+static void coredump_finish(struct mm_struct *mm, bool core_dumped)
 {
 	struct core_thread *curr, *next;
 	struct task_struct *task;
 
 	spin_lock_irq(&current->sighand->siglock);
+	if (core_dumped && !__fatal_signal_pending(current))
+		current->signal->group_exit_code |= 0x80;
 	current->signal->group_exit_task = NULL;
 	current->signal->flags = SIGNAL_GROUP_EXIT;
 	spin_unlock_irq(&current->sighand->siglock);
@@ -480,6 +482,7 @@ void do_coredump(siginfo_t *siginfo)
 	int ispipe;
 	struct files_struct *displaced;
 	bool need_nonrelative = false;
+	bool core_dumped = false;
 	static atomic_t core_dump_count = ATOMIC_INIT(0);
 	struct coredump_params cprm = {
 		.siginfo = siginfo,
@@ -632,9 +635,8 @@ void do_coredump(siginfo_t *siginfo)
 		goto close_fail;
 	if (displaced)
 		put_files_struct(displaced);
-	retval = binfmt->core_dump(&cprm);
-	if (retval)
-		current->signal->group_exit_code |= 0x80;
+
+	core_dumped = binfmt->core_dump(&cprm);
 
 	if (ispipe && core_pipe_limit)
 		wait_for_dump_helpers(cprm.file);
@@ -647,7 +649,7 @@ fail_dropcount:
 fail_unlock:
 	kfree(cn.corename);
 fail_corename:
-	coredump_finish(mm);
+	coredump_finish(mm, core_dumped);
 	revert_creds(old_cred);
 fail_creds:
 	put_cred(cred);
-- 
1.5.5.1

