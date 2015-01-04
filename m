Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754AbbADRl4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 12:41:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59366 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752648AbbADRlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 12:41:55 -0500
Date: Sun, 4 Jan 2015 18:41:05 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@redhat.com>,
        root <chenggang.qin@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        =?utf-8?B?56em5om/5YiaKOaJv+WImik=?= <chenggang.qcg@taobao.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Namhyung Kim <namhyung@gmail.com>, Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, Paul Mackerras <paulus@samba.org>,
        =?utf-8?B?56em5om/5YiaKOaJv+WImik=?= 
	<chenggang.qcg@alibaba-inc.com>,
        Yanmin Zhang <yanmin.zhang@intel.com>
Subject: Re: =?utf-8?B?562U5aSN77yaW1BBVENIXSBwZXJm?= =?utf-8?Q?_core=3A_Us?=
 =?utf-8?Q?e?= KSTK_ESP() instead of pt_regs->sp while output user regs
Message-ID: <20150104174105.GA29388@krava.brq.redhat.com>
References: <1419315745-20767-1-git-send-email-user@chenggang-laptop>
 <c027bde0-5f4f-441f-8d45-3e7f6f702231@alibaba-inc.com>
 <CALCETrVVvbnO-7bnyPCYhPbDoEg-hqmvVbfXL9ONbQPBTJNUZg@mail.gmail.com>
 <20141230190327.GB23965@worktop.programming.kicks-ass.net>
 <20150104161049.GB22707@krava.brq.redhat.com>
 <CALCETrVNPmMW_ZABfaEFX6pKN6JL-K-hpR-7xM4qJh+wAReO5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrVNPmMW_ZABfaEFX6pKN6JL-K-hpR-7xM4qJh+wAReO5g@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 04, 2015 at 09:18:59AM -0800, Andy Lutomirski wrote:
> On Jan 4, 2015 8:11 AM, "Jiri Olsa" <jolsa@redhat.com> wrote:
> >
> > On Tue, Dec 30, 2014 at 08:03:27PM +0100, Peter Zijlstra wrote:
> > > On Thu, Dec 25, 2014 at 07:48:28AM -0800, Andy Lutomirski wrote:
> > > > On a quick look, there are plenty of other bugs in there besides just
> > > > the stack pointer issue.  The ABI check that uses TIF_IA32 in the perf
> > > > core is completely wrong.  TIF_IA32 may be equal to the actual
> > > > userspace bitness by luck, but, if so, that's more or less just luck.
> > > > And there's a user_mode test that should be user_mode_vm.
> > > >
> > > > Also, it's not just sp that's wrong.  There are various places that
> > > > you can interrupt in which many of the registers have confusing
> > > > locations.  You could try using the cfi unwind data, but that's
> > > > unlikely to work for regs like cs and ss, and, during context switch,
> > > > this has very little chance of working.
> > > >
> > > > What's the point of this feature?  Honestly, my suggestion would be to
> > > > delete it instead of trying to fix it.  It's also not clear to me that
> > > > there aren't serious security problems here -- it's entirely possible
> > > > for sensitive *kernel* values to and up in task_pt_regs at certain
> > > > times, and if you run during context switch and there's no code to
> > > > suppress this dump during context switch, then you could be showing
> > > > regs that belong to the wrong task.
> > >
> > > Of course the people who actually wrote the code are not on CC :/
> > >
> > > There's two users of this iirc;
> > >
> > >  1) the dwarf stack unwinder thingy, which basically dumps the userspace
> > >  regs and the top of userspace stack on 'event'.
> >
> > looks like this solves the issue I was trying to fix
> > long time ago:
> >   http://marc.info/?l=linux-kernel&m=134934717011451&w=2
> >
> > this seems a lot simpler ;-) I'll test..
> 
> I suspect that, if it works, then it's pure luck.
> (task)->thread.usersp in KSTK_ESP is bogus -- your code was more
> accurate.
> 
> I think we should seriously consider making use of this feature by
> non-root users require an explicit sysctl.  Sending values to user
> code that are, at best, free of sensitive kernel data most of the time
> is IMO inappropriate for an unprivileged API.
> 
> I'm currently working on a patch to try to clean this up better.

ook.. well FWIW I tested and if I used KSTK_ESP as a perf user stack
pointer (attached patch) I've got all callchains resolved properly,
as when I tested my original patch

NOTE the patch from Chenggang Qin isnt enough to fix my issue for perf
     dwarf unwind, I needed to use attached change

I'd be happy to test any change you make for this,
because this has been pain for a long time :-\

thanks,
jirka


---
diff --git a/arch/x86/kernel/perf_regs.c b/arch/x86/kernel/perf_regs.c
index 5da8df8303cf..eb7c385a6f8e 100644
--- a/arch/x86/kernel/perf_regs.c
+++ b/arch/x86/kernel/perf_regs.c
@@ -66,6 +66,11 @@ u64 perf_reg_value(struct pt_regs *regs, int idx)
 	return regs_get_register(regs, pt_regs_offset[idx]);
 }
 
+unsigned long arch_perf_user_stack_pointer(struct pt_regs *regs)
+{
+	return KSTK_ESP(current);
+}
+
 #define REG_RESERVED (~((1ULL << PERF_REG_X86_MAX) - 1ULL))
 
 #ifdef CONFIG_X86_32
diff --git a/kernel/events/core.c b/kernel/events/core.c
index af0a5ba4e21d..d99236173f3b 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4486,6 +4486,19 @@ static void perf_sample_regs_intr(struct perf_regs *regs_intr,
 	regs_intr->abi  = perf_reg_abi(current);
 }
 
+#ifdef CONFIG_HAVE_PERF_USER_STACK_DUMP
+unsigned long __weak arch_perf_user_stack_pointer(struct pt_regs *regs)
+{
+        return user_stack_pointer(regs);
+}
+
+static unsigned long perf_user_stack_pointer(struct pt_regs *regs)
+{
+        return arch_perf_user_stack_pointer(regs);
+}
+#else
+#define perf_user_stack_pointer(regs) 0
+#endif /* CONFIG_HAVE_PERF_USER_STACK_DUMP */
 
 /*
  * Get remaining task size from user stack pointer.
diff --git a/kernel/events/internal.h b/kernel/events/internal.h
index 569b218782ad..b85e4fd52980 100644
--- a/kernel/events/internal.h
+++ b/kernel/events/internal.h
@@ -180,19 +180,17 @@ static inline void put_recursion_context(int *recursion, int rctx)
 }
 
 #ifdef CONFIG_HAVE_PERF_USER_STACK_DUMP
+unsigned long arch_perf_user_stack_pointer(struct pt_regs *regs);
+
 static inline bool arch_perf_have_user_stack_dump(void)
 {
 	return true;
 }
-
-#define perf_user_stack_pointer(regs) user_stack_pointer(regs)
 #else
 static inline bool arch_perf_have_user_stack_dump(void)
 {
 	return false;
 }
-
-#define perf_user_stack_pointer(regs) 0
 #endif /* CONFIG_HAVE_PERF_USER_STACK_DUMP */
 
 #endif /* _KERNEL_EVENTS_INTERNAL_H */
