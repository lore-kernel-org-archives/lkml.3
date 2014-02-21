Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932861AbaBUQdz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 11:33:55 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52258 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932264AbaBUQdy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 11:33:54 -0500
Date: Fri, 21 Feb 2014 17:33:52 +0100
From: Petr =?iso-8859-1?Q?Ml=E1dek?= <pmladek@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH 0/4] x86: Fix ftrace recovery when code modification
 failed
Message-ID: <20140221163351.GA1833@pathway.suse.cz>
References: <1392650573-3390-1-git-send-email-pmladek@suse.cz>
 <20140220232308.3709bd83@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140220232308.3709bd83@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 20-02-14 23:23:08, Steven Rostedt wrote:
> On Mon, 17 Feb 2014 16:22:49 +0100
> Petr Mladek <pmladek@suse.cz> wrote:
> 
> > Ftrace modifies function calls using Int3 breakpoints on x86. It patches
> > all functions in parallel to reduce the number of sync() calls. There is
> > a code that removes pending Int3 breakpoints when something goes wrong.
> > 
> > The recovery does not work on x86_64. I simulated an error in
> > ftrace_replace_code() and the system got rebooted.
> 
> Thanks for the report, I just did the same and it caused a reboot too.
>  
> > The patch set is against linux/tip. Last commit is a5b3cca53c43c3ba7
> > (Merge tag 'v3.14-rc3')
> > 
> > Petr Mladek (4):
> >   x86: Clean up remove_breakpoint() in ftrace code
> >   x86: Fix ftrace patching recovery code to work on x86_64
> >   x86: BUG when ftrace patching recovery fails
> >   x86: Fix order of warning messages when ftrace modifies code
> > 
> >  arch/x86/kernel/ftrace.c | 67 ++++++++++++++++++++++++------------------------
> >  1 file changed, 34 insertions(+), 33 deletions(-)
> > 
> 
> That's quite a bit of changes. I did a quick debug analysis of it, and
> found two bugs.

The first commit did refactoring to make the code better readable.
The real fix was in the second patch.

> One, I shouldn't be using direct access to the ip with
> probe_kernel_write(), I need to do the within() magic (also have a
> ftrace_write() wrapper now).

Yup, this was the main reason why it failed. Huh, I missed that the
same problem was also in ftrace_modify_code().


> The second bug is that I need to do another run_sync() after the fix
> up. 

Great catch! I have missed the sync.

> Can you see if this patch fixes the issue?

Yes, it works but I would still do few more changes:

     + run_sync() also in ftrace_modify_code() in the recovery
       part; I would solve this by moving the "out" label.

     + print some warning in update_ftrace_func() when
       ftrace_modify_code() fails; otherwise, the error
       is silently ignored

     + BUG when the breakpoint cannot be removed; the system
       silently crash anyway because the breakpoint will not
       be handled

I wonder if we should call FTRACE_WARN_ON_ONCE that calls
"ftrace_kill" when update_ftrace_func() fails.

Anyway, here is a proposed patch that merges your changes and my
improvements. Let me know if I should improve, rework or split it.

--------

Subject: [PATCH] x86: Fix ftrace recovery code

Ftrace modifies function calls using Int3 breakpoints on x86. If some
function cannot be modified, it tries to recover and remove the pending
breakpoints.

The recovery currently does not work on x86_64 because the address
is read-only. We need to use ftrace_write() that gets write access
via the kernel identity mapping. It is used everywhere else in the
code.

Note that we need to modify remove_breakpoint() to return non-zero
value only when there is an error. The return value was ignored before,
so it does not cause any troubles.

In addition, we should print some warning when update_ftrace_func()
fails. Otherwise, ftrace does not work as expected but there is
no explanation.

Finally, we should BUG() when the breakpoint could not be removed.
Otherwise, the system silently crashes when the function finishes
the Int3 handler is disabled.

Signed-off-by: Petr Mladek <pmladek@suse.cz>
---
 arch/x86/kernel/ftrace.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index e6253195a301..dc3900d84b09 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -239,6 +239,7 @@ static int update_ftrace_func(unsigned long ip, void *new)
 	atomic_inc(&modifying_ftrace_code);
 
 	ret = ftrace_modify_code(ip, old, new);
+	WARN_ONCE(ret, "Failed to update ftrace function: %d\n", ret);
 
 	atomic_dec(&modifying_ftrace_code);
 
@@ -425,7 +426,7 @@ static int remove_breakpoint(struct dyn_ftrace *rec)
 
 	/* If this does not have a breakpoint, we are done */
 	if (ins[0] != brk)
-		return -1;
+		return 0;
 
 	nop = ftrace_nop_replace();
 
@@ -455,7 +456,7 @@ static int remove_breakpoint(struct dyn_ftrace *rec)
 	}
 
  update:
-	return probe_kernel_write((void *)ip, &nop[0], 1);
+	return ftrace_write(ip, nop, 1);
 }
 
 static int add_update_code(unsigned long ip, unsigned const char *new)
@@ -632,8 +633,14 @@ void ftrace_replace_code(int enable)
 	printk(KERN_WARNING "Failed on %s (%d):\n", report, count);
 	for_ftrace_rec_iter(iter) {
 		rec = ftrace_rec_iter_record(iter);
-		remove_breakpoint(rec);
+		/*
+		 * Breakpoints are handled only when this function is in
+		 * progress. The system could not work with them.
+		 */
+		if (remove_breakpoint(rec))
+			BUG();
 	}
+	run_sync();
 }
 
 static int
@@ -655,16 +662,20 @@ ftrace_modify_code(unsigned long ip, unsigned const char *old_code,
 	run_sync();
 
 	ret = ftrace_write(ip, new_code, 1);
-	if (ret) {
-		ret = -EPERM;
-		goto out;
-	}
-	run_sync();
+	/*
+	 * The breakpoint is handled only when this function is in progress.
+	 * The system could not work if we could not remove it.
+	 */
+	BUG_ON(ret);
  out:
+	run_sync();
+
 	return ret;
 
  fail_update:
-	probe_kernel_write((void *)ip, &old_code[0], 1);
+	/* Also here the system could not work with the breakpoint */
+	if (ftrace_write(ip, old_code, 1))
+		BUG();
 	goto out;
 }
 
-- 
1.8.4

