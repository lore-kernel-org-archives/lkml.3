Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752737AbaBUEXM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 23:23:12 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:64770 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752456AbaBUEXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 23:23:10 -0500
Date: Thu, 20 Feb 2014 23:23:08 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Petr Mladek <pmladek@suse.cz>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: [PATCH 0/4] x86: Fix ftrace recovery when code modification
 failed
Message-ID: <20140220232308.3709bd83@gandalf.local.home>
In-Reply-To: <1392650573-3390-1-git-send-email-pmladek@suse.cz>
References: <1392650573-3390-1-git-send-email-pmladek@suse.cz>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Feb 2014 16:22:49 +0100
Petr Mladek <pmladek@suse.cz> wrote:

> Ftrace modifies function calls using Int3 breakpoints on x86. It patches
> all functions in parallel to reduce the number of sync() calls. There is
> a code that removes pending Int3 breakpoints when something goes wrong.
> 
> The recovery does not work on x86_64. I simulated an error in
> ftrace_replace_code() and the system got rebooted.

Thanks for the report, I just did the same and it caused a reboot too.

> 
> This patch set fixes the recovery code, improves debugging of this
> type of problem, and does some clean up.
> 
> BTW: It is an echo from the patch set that tried to use text_poke_bp()
> instead of the ftrace-specific Int3 based patching code. Ftrace has
> some specific restrictions. I did not find a way how to make the 
> universal text_poke_bp effective, safe, and clean to be usable
> there.
> 
> The patch set is against linux/tip. Last commit is a5b3cca53c43c3ba7
> (Merge tag 'v3.14-rc3')
> 
> Petr Mladek (4):
>   x86: Clean up remove_breakpoint() in ftrace code
>   x86: Fix ftrace patching recovery code to work on x86_64
>   x86: BUG when ftrace patching recovery fails
>   x86: Fix order of warning messages when ftrace modifies code
> 
>  arch/x86/kernel/ftrace.c | 67 ++++++++++++++++++++++++------------------------
>  1 file changed, 34 insertions(+), 33 deletions(-)
> 

That's quite a bit of changes. I did a quick debug analysis of it, and
found two bugs.

One, I shouldn't be using direct access to the ip with
probe_kernel_write(), I need to do the within() magic (also have a
ftrace_write() wrapper now).

The second bug is that I need to do another run_sync() after the fix
up. Can you see if this patch fixes the issue?

-- Steve

 ftrace.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index e625319..6b566c8 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -455,7 +455,7 @@ static int remove_breakpoint(struct dyn_ftrace *rec)
 	}
 
  update:
-	return probe_kernel_write((void *)ip, &nop[0], 1);
+	return ftrace_write(ip, nop, 1);
 }
 
 static int add_update_code(unsigned long ip, unsigned const char *new)
@@ -634,6 +634,7 @@ void ftrace_replace_code(int enable)
 		rec = ftrace_rec_iter_record(iter);
 		remove_breakpoint(rec);
 	}
+	run_sync();
 }
 
 static int
@@ -664,7 +665,7 @@ ftrace_modify_code(unsigned long ip, unsigned const
char *old_code, return ret;
 
  fail_update:
-	probe_kernel_write((void *)ip, &old_code[0], 1);
+	ftrace_write(ip, old_code, 1);
 	goto out;
 }
 

