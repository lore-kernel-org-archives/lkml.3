Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933753Ab3BLSmj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 13:42:39 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:11895 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933696Ab3BLSmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 13:42:38 -0500
X-Authority-Analysis: v=2.0 cv=f8jK9ZOM c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=lw7P3rMeAkAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=7SKAyaolg40A:10 a=nk20Mf1Gf-KEMKBRrDQA:9 a=PUjeQqilurYA:10 a=yxPpirLrVSMTiqQU:21 a=kZ5NY6noLmKVcfd8:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1360694555.21867.69.camel@gandalf.local.home>
Subject: Re: [RFC][PATCH] tracing/syscalls: Have ia32 compat syscalls show
 raw format
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Tue, 12 Feb 2013 13:42:35 -0500
In-Reply-To: <511A85E8.7030303@linux.intel.com>
References: <1360692087.21867.42.camel@gandalf.local.home>
	 <511A85E8.7030303@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-02-12 at 10:11 -0800, H. Peter Anvin wrote:
> What?
> 
> Seriously, this has got to be a bad joke.
> 
> Either I'm not getting something here or this is just a nonstarter.
> 
> This feels like a hack upon a kluge upon a wart, and something that we'd
> have to support forever.
> 
> No.  Realize that syscall number does not, and never have, been a unique
> identifier for the system call, instead that is the (syscall number, ABI).

And currently the output is just plain broken. This isn't a hack. You
should have seen my first attempt. Now THAT was a hack! My first attempt
was extremely intrusive, and required a lot of arch changes. But then I
realized it was too much, and found that I could do the same thing
pretty much completely contained within just the tracing code itself.

I know you feel that the syscall tracing is broken/hack/whatever. But it
exists as of today, and yes, there's lots of users out there depending
on it.

The problem: If a task runs in ia32 compat mode on an x86_64bit machine,
the recorded syscalls are garbage.

*NOTE* the garbage syscalls that are output DO NOT SHOW THE SYSCALL NR!

The solution: Change these ia32 compat syscalls to SHOW THE SYSCALL NR!

Really, I converted:

             lls-1127  [005] d...   936.409188: sys_recvfrom(fd: 0, ubuf: 4d560fc4, size: 0, flags: 8048034, addr: 8, addr_len: f7700420)
             lls-1127  [005] d...   936.409190: sys_recvfrom -> 0x8a77000
             lls-1127  [005] d...   936.409211: sys_lgetxattr(pathname: 0, name: 1000, value: 3, size: 22)
             lls-1127  [005] d...   936.409215: sys_lgetxattr -> 0xf76ff000
             lls-1127  [005] d...   936.409223: sys_dup2(oldfd: 4d55ae9b, newfd: 4)
             lls-1127  [005] d...   936.409228: sys_dup2 -> 0xfffffffffffffffe

To:
             lls-1100  [005] d...    97.051616: sys_compat_syscall(NR: 2d, arg1: 0, arg2: 4d560fc4, arg3: 0, arg4: 8048034, arg5: 8, arg6: f77bb420)
             lls-1100  [005] d...    97.051619: sys_compat_syscall -> 0x91fd000
             lls-1100  [005] d...    97.051640: sys_compat_syscall(NR: c0, arg1: 0, arg2: 1000, arg3: 3, arg4: 22, arg5: ffffffff, arg6: 0)
             lls-1100  [005] d...    97.051644: sys_compat_syscall -> 0xf77ba000
             lls-1100  [005] d...    97.051652: sys_compat_syscall(NR: 21, arg1: 4d55ae9b, arg2: 4, arg3: 4d560fc4, arg4: 4d55ae9b, arg5: 0, arg6: fff3ee78)
             lls-1100  [005] d...    97.051658: sys_compat_syscall -> 0xfffffffffffffffe

I basically did what you want. I now display the syscall number NR and
the args for the syscall. A userspace tool can now easily parse it,
where it could not before.

If you are uncomfortable with the use of:

+#define __SC_DECL7(t7, a7, ...) t7 a7, __SC_DECL6(__VA_ARGS__)
+#define __SC_STR_ADECL7(t, a, ...)     #a, __SC_STR_ADECL6(__VA_ARGS__)
+#define __SC_STR_TDECL7(t, a, ...)     #t, __SC_STR_TDECL6(__VA_ARGS__)
+#define SYSCALL_DEFINE7(name, ...) SYSCALL_DEFINEx(7, _##name, __VA_ARGS__)
+SYSCALL_DEFINE7(compat_syscall, int, NR, long, arg1, long, arg2,
+               long, arg3, long, arg4, long, arg5, long, arg6)
+{
+       return -ENOSYS;
+}

Don't be. That's really just a simple way of reusing code. The
alternative is to hand create the syscall_metadata. Something like:


static struct syscall_metadata __syscall_meta_compat_syscall;
static struct ftrace_event_call __used
event_enter_compat_syscall = {
	.name                   = "sys_enter"#sname,
	.class			= &event_class_syscall_enter,
	.event.funcs            = &enter_syscall_print_funcs,
	.data			= (void *)&__syscall_meta_compat_syscall,
	.flags			= TRACE_EVENT_FL_CAP_ANY,
};
static struct ftrace_event_call __used
__attribute__((section("_ftrace_events")))
	 *__event_enter_compat_syscall = &event_enter_compat_syscall;

static struct syscall_metadata __syscall_meta_compat_syscall;
static struct ftrace_event_call __used
event_exit_compat_syscall = {
	.name                   = "sys_exit_compat_syscall",
	.class			= &event_class_syscall_exit,
	.event.funcs		= &exit_syscall_print_funcs,
	.data			= (void *)&__syscall_meta_compat_syscall,
	.flags			= TRACE_EVENT_FL_CAP_ANY,
	};
static struct ftrace_event_call __used
__attribute__((section("_ftrace_events")))
*__event_exit_compat_syscall = &event_exit_compat_syscall;

static struct syscall_metadata __used
__syscall_meta_compat_syscall = {
	.name 		= "sys_compat_syscall",
	.syscall_nr	= -1,	/* Filled in at boot */
	.nb_args 	= nb,
	.types		= types_compat_syscall,
	.args		= args_compat_syscall,
	.enter_event	= &event_enter_compat_syscall,
	.exit_event	= &event_exit_compat_syscall,
	.enter_fields	= LIST_HEAD_INIT(__syscall_meta_compat_syscall.enter_fields),
};
static struct syscall_metadata __used
__attribute__((section("__syscalls_metadata")))
*__p_syscall_meta_compat_syscall = &__syscall_meta_compat_syscall;

static struct syscall_metadata __used
__syscall_meta__compat_syscall = {
	.name 		= "sys_compat_syscall",
	.syscall_nr	= -1,	/* Filled in at boot */
	.nb_args 	= 0,
	.enter_event	= &event_enter__compat_syscall,
	.exit_event	= &event_exit__compat_syscall,
	.enter_fields	= LIST_HEAD_INIT(__syscall_meta__compat_syscall.enter_fields),
};
static struct syscall_metadata __used
__attribute__((section("__syscalls_metadata")))
*__p_syscall_meta_compat_syscall = &__syscall_meta__compat_syscall;
asmlinkage long sys_compat_syscall(void)


Which is created by those few lines, if something changes, it will
automatically change for this metadata as well.

I don't know what your issue is. This change is contained solely to the
tracing system. The only arch change is to let the tracing system know
that the syscall that is being traced happens to need the compat format.

-- Steve


