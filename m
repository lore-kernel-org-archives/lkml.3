Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987AbaCGPws (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 10:52:48 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:4218 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753620AbaCGPwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 10:52:45 -0500
Date: Fri, 7 Mar 2014 10:52:42 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Jesper Juhl <jesper.juhl@gmail.com>,
        Alexander van Heukelum <heukelum@fastmail.fm>
Subject: [PATCH] i386: Remove unneeded test of 'task' in dump_trace()
 (again)
Message-ID: <20140307105242.79a0befd@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Commit 028a690a1ebc8b "i386: Remove unneeded test of 'task' in dump_trace()"
correctly removed the unneeded 'task != NULL' check because it would
be set to current if it was NULL.

Commit 2bc5f927d489 "i386: split out dumpstack code from traps_32.c"
moved the code from traps_32.c to its own file dump_stack.c for
preparation of the i386 / x86_64 merge.

Commit 8a541665b906 "dumpstack: x86: various small unification steps"
worked to make i386 and x86_64 dump_stack logic similar. But this
actually reverted the correct change from 028a690a1ebc8b.

Commit d0caf292505d "x86/dumpstack: Remove unneeded check in dump_trace()"
removed the unneeded "task != NULL" check for x86_64 but left that same
unneeded check for i386, that was added because x86_64 had it!

This chain of events ironically had i386 add back the unneeded task != NULL
check because x86_64 did it, and then the fix for x86_64 was fixed
by Dan. And even more ironically, it was Dan's smatch bot that told
me that a change to dump_stack_32 I made may be wrong if current can
be NULL (it can't), as there was a check for it by assigning task to
current, and then checking if task is NULL.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/dumpstack_32.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/dumpstack_32.c b/arch/x86/kernel/dumpstack_32.c
index dca820b..5abd4cd 100644
--- a/arch/x86/kernel/dumpstack_32.c
+++ b/arch/x86/kernel/dumpstack_32.c
@@ -53,7 +53,7 @@ void dump_trace(struct task_struct *task, struct pt_regs *regs,
 		unsigned long dummy;
 
 		stack = &dummy;
-		if (task && task != current)
+		if (task != current)
 			stack = (unsigned long *)task->thread.sp;
 	}
 
-- 
1.8.1.4

