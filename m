Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804AbaDNPUz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 11:20:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25854 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751589AbaDNPUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 11:20:51 -0400
Date: Mon, 14 Apr 2014 17:20:25 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, David Woodhouse <dwmw2@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Ingo Molnar <mingo@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Richard Weinberger <richard@nod.at>,
        Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH RESEND 11/11] signals: change wait_for_helper() to use
	kernel_sigaction()
Message-ID: <20140414152025.GA22032@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140414151929.GA21470@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have kernel_sigaction() we can change wait_for_helper()
to use it and cleanups the code a bit.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/kmod.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/kernel/kmod.c b/kernel/kmod.c
index 6b375af..c18c891 100644
--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -285,10 +285,7 @@ static int wait_for_helper(void *data)
 	pid_t pid;
 
 	/* If SIGCLD is ignored sys_wait4 won't populate the status. */
-	spin_lock_irq(&current->sighand->siglock);
-	current->sighand->action[SIGCHLD-1].sa.sa_handler = SIG_DFL;
-	spin_unlock_irq(&current->sighand->siglock);
-
+	kernel_sigaction(SIGCHLD, SIG_DFL);
 	pid = kernel_thread(____call_usermodehelper, sub_info, SIGCHLD);
 	if (pid < 0) {
 		sub_info->retval = pid;
-- 
1.5.5.1

