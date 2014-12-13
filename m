Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790AbaLMEdM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 23:33:12 -0500
Received: from smtprelay0058.hostedemail.com ([216.40.44.58]:41806 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751644AbaLMEdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 23:33:11 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 73,5,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::::,RULES_HIT:41:69:355:379:541:800:960:967:968:973:982:988:989:1260:1277:1311:1313:1314:1345:1437:1515:1516:1518:1534:1544:1593:1594:1605:1711:1730:1747:1777:1792:1981:2194:2198:2199:2200:2393:2525:2553:2561:2564:2682:2685:2693:2731:2859:2861:2895:2901:2902:2911:2924:2926:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3743:3770:3865:3866:3867:3868:3870:3871:3872:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4250:4321:4401:4425:4605:5007:6119:6261:7266:7903:8599:8660:8957:9025:9121:10004:10226:10848:10913:11026:11233:11256:11257:11658:11876:11914:12043:12262:12266:12296:12438:12517:12519:12555:12679:12740:12783:13148:13161:13180:13229:13230:13255:13896:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: twig31_1b91ee12c3446
X-Filterd-Recvd-Size: 4964
Date: Fri, 12 Dec 2014 23:33:07 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Jiri Kosina <jkosina@suse.cz>,
        Petr Mladek <pmladek@suse.cz>
Subject: [GIT PULL v2] tracing/NMI/printk: Use seq_buf for safe printing
 from NMI context
Message-ID: <20141212233307.509234ad@gandalf.local.home>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus,

This code is a fork from the trace-3.19 pull as it needed the trace_seq
clean ups from that branch.

This code solves the issue of performing stack dumps from NMI context.
The issue is that printk() is not safe from NMI context as if the NMI
were to trigger when a printk() was being performed, the NMI could
deadlock from the printk() internal locks. This has been seen in practice.

With lots of review from Petr Mladek, this code went through several
iterations, and we feel that it is now at a point of quality to be
accepted into mainline.

Here's what is contained in this patch set:

 o Creates a "seq_buf" generic buffer utility that allows a descriptor
   to be passed around where functions can write their own "printk()"
   formatted strings into it. The generic version was pulled out of
   the trace_seq() code that was made specifically for tracing.

 o The seq_buf code was change to model the seq_file code. I have
   a patch (not included for 3.19) that converts the seq_file.c code
   over to use seq_buf.c like the trace_seq.c code does. This was done
   to make sure that seq_buf.c is compatible with seq_file.c. I may
   try to get that patch in for 3.20.

 o The seq_buf.c file was moved to lib/ to remove it from being dependent
   on CONFIG_TRACING.

 o The printk() was updated to allow for a per_cpu "override" of
   the internal calls. That is, instead of writing to the console, a call
   to printk() may do something else. This made it easier to allow the
   NMI to change what printk() does in order to call dump_stack() without
   needing to update that code as well.

 o Finally, the dump_stack from all CPUs via NMI code was converted to
   use the seq_buf code. The caller to trigger the NMI code would wait
   till all the NMIs finished, and then it would print the seq_buf
   data to the console safely from a non NMI context.

[ Updated to remove unnecessary preempt_disable in printk() ]


Note, I only showed the difference between V1, as that full diff was
already posted here:

  http://lkml.kernel.org/r/20141208100528.5f97106f@gandalf.local.home


Please pull the latest trace-seq-buf-3.19-v2 tree, which can be found at:


  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
trace-seq-buf-3.19-v2

Tag SHA1: b7a8e382200950f8f596376bfef82754569ccbaf
Head SHA1: 1fb8915b9876a80f43732980208b39d013f8da9d


Steven Rostedt (Red Hat) (1):
      printk: Do not disable preemption for accessing printk_func

----
 kernel/printk/printk.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)
---------------------------
commit 1fb8915b9876a80f43732980208b39d013f8da9d
Author: Steven Rostedt (Red Hat) <rostedt@goodmis.org>
Date:   Thu Dec 11 09:12:01 2014 -0500

    printk: Do not disable preemption for accessing printk_func
    
    As printk_func will either be the default function, or a per_cpu function
    for the current CPU, there's no reason to disable preemption to access
    it from printk. That's because if the printk_func is not the default
    then the caller had better disabled preemption as they were the one to
    change it.
    
    Link: http://lkml.kernel.org/r/CA+55aFz5-_LKW4JHEBoWinN9_ouNcGRWAF2FUA35u46FRN-Kxw@mail.gmail.com
    
    Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 5af2b8bc88f0..9b896e7a50a9 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -1859,10 +1859,16 @@ asmlinkage __visible int printk(const char *fmt, ...)
 	int r;
 
 	va_start(args, fmt);
-	preempt_disable();
+
+	/*
+	 * If a caller overrides the per_cpu printk_func, then it needs
+	 * to disable preemption when calling printk(). Otherwise
+	 * the printk_func should be set to the default. No need to
+	 * disable preemption here.
+	 */
 	vprintk_func = this_cpu_read(printk_func);
 	r = vprintk_func(fmt, args);
-	preempt_enable();
+
 	va_end(args);
 
 	return r;
