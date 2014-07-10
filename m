Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198AbaGJVgm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 17:36:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40531 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751431AbaGJVgk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:36:40 -0400
Date: Thu, 10 Jul 2014 16:36:20 -0500
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Oleg Nesterov <oleg@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Seth Jennings <sjenning@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: [RFC][PATCH 0/3] ftrace: Add dynamically allocated trampolines
Message-ID: <20140710213620.GA19858@treble.redhat.com>
References: <20140703200750.648550267@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140703200750.648550267@goodmis.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 03, 2014 at 04:07:50PM -0400, Steven Rostedt wrote:
> [ NOT READY FOR INCLUSION! ]
> 
> Note, this is based off of my remove ftrace_start/stop() patch set.
> 
> I've been wanting to do this for years, and just never gotten around to it.
> But with all this talk of kpatch and kgraft live kernel patching using
> the ftrace infrastructure, it seems like a good time to do it.
> 
> The way the function callback mechanism works in ftrace is that if there's
> only one function callback registered, it will set the mcount/fentry
> trampoline to call that function directly. But as soon as you register
> another callback, the mcount trampoline calls a loop function that iterates
> over all the registered callbacks (ftrace_ops) checking their hash tables
> to see if the called function matches the ops before calling its callback.
> This happens even if the two registered functions are not even tracing
> the same function!
> 
> This really sucks if you are tracing all functions, and then add a kprobe
> or perf event that traces a single function. That will cause all the
> other functions being traced to perform the loop test.
> 
> Ideally, if only a single callback (ftrace_ops) is registered to a
> function, than that function should call a trampoline that will only
> call that one callback without doing any other tests.

Hi Steven,

I did some testing with kpatch and I found one minor issue.  The dynamically
allocated trampoline seems to confuse dump_stack() somewhat.

I added a dump_stack() call in my ftrace_ops callback function
(kpatch_ftrace_handler) which had a filter on meminfo_proc_show().

Without this patch set (3.14):

  [ 1533.256720]  [<ffffffff816ef90e>] dump_stack+0x45/0x56
  [ 1533.256725]  [<ffffffff8125cc80>] ? meminfo_proc_open+0x30/0x30
  [ 1533.256731]  [<ffffffffa07d1494>] kpatch_ftrace_handler+0x14/0xf0 [kpatch]
  [ 1533.256734]  [<ffffffff8125cc80>] ? meminfo_proc_open+0x30/0x30
  [ 1533.256739]  [<ffffffff81137a76>] ftrace_ops_list_func+0xf6/0x110
  [ 1533.256744]  [<ffffffff816ff9c2>] ftrace_regs_call+0x5/0x77
  [ 1533.256748]  [<ffffffff8120d4ce>] ? seq_read+0x2de/0x3b0
  [ 1533.256751]  [<ffffffff8120d4ce>] ? seq_read+0x2de/0x3b0
  [ 1533.256755]  [<ffffffff8125cc85>] ? meminfo_proc_show+0x5/0x5e0
  [ 1533.256757]  [<ffffffff8125cc85>] ? meminfo_proc_show+0x5/0x5e0
  [ 1533.256760]  [<ffffffff8120d35a>] ? seq_read+0x16a/0x3b0
  [ 1533.256764]  [<ffffffff81253f1d>] proc_reg_read+0x3d/0x80
  [ 1533.256769]  [<ffffffff811e93cb>] vfs_read+0x9b/0x160
  [ 1533.256772]  [<ffffffff811e9ed5>] SyS_read+0x55/0xd0
  [ 1533.256776]  [<ffffffff816ffc29>] system_call_fastpath+0x16/0x1b

With this patch set:

  [  934.546013]  [<ffffffff81700312>] dump_stack+0x45/0x56
  [  934.546020]  [<ffffffff8125f5b0>] ? meminfo_proc_open+0x30/0x30
  [  934.546027]  [<ffffffffa080a494>] kpatch_ftrace_handler+0x14/0xf0 [kpatch]
  [  934.546058]  [<ffffffff812143ae>] ? seq_read+0x2de/0x3b0
  [  934.546062]  [<ffffffff812143ae>] ? seq_read+0x2de/0x3b0
  [  934.546067]  [<ffffffff8125f5b5>] ? meminfo_proc_show+0x5/0x5e0
  [  934.546071]  [<ffffffff8125f5b5>] ? meminfo_proc_show+0x5/0x5e0
  [  934.546075]  [<ffffffff8121423a>] ? seq_read+0x16a/0x3b0
  [  934.546081]  [<ffffffff8125768d>] ? proc_reg_read+0x3d/0x80
  [  934.546088]  [<ffffffff811f0668>] ? vfs_read+0x98/0x170
  [  934.546093]  [<ffffffff811f1345>] ? SyS_read+0x55/0xd0
  [  934.546099]  [<ffffffff81707969>] ? system_call_fastpath+0x16/0x1b

It correctly shows the traced function's callers, but they're shown as
unreliable (question marks).  I'm not sure why that happens, but if
something goes wrong in a callback, this could make the reported stack
traces confusing.  It could also cause trouble for code which relies on
reliable stack traces (e.g. kpatch).

> 
> This patch set adds this functionality to x86_64. If a callback is
> registered to a function and there's no other callback registered to
> that function that ftrace_ops will get its own trampoline allocated
> for it that will call the function directly.
> 
> Note, for dynamically allocated ftrace_ops (kprobes, perf, instance
> directory function tracing), the dynamic trampoline will only be created
> if CONFIG_PREEMPT is not set. That's because, until Paul finishes his
> rcu_call_task() code, there's no safe way to know if a task was preempted
> while on the trampoline and is waiting to run on it some more.
> 
> I need to write up a bunch of tests for this code, but currently it works
> on the few tests I did manually. I didn't even run this code yet under
> my full test suite, so it may very well have bugs in it that might be
> easily triggered. But I wanted to get the code out for review to see
> if anyone has any other idea to help enhance this feature.
> 
> If you want a git repo to play with this, you can get it from below.
> That repo will rebase often, so do not build against it.
> 
> Enjoy,
> 
> -- Steve
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git
> rfc/trampoline
> 
> Head SHA1: 4d781e010842a56f8e7c1bbe309e38075c277c45
> 
> 
> Steven Rostedt (Red Hat) (3):
>       ftrace/x86: Add dynamic allocated trampoline for ftrace_ops
>       ftrace/x86: Show trampoline call function in enabled_functions
>       ftrace/x86: Allow !CONFIG_PREEMPT dynamic ops to use allocated trampolines
> 
> ----
>  arch/x86/kernel/ftrace.c    | 240 ++++++++++++++++++++++++++++++++++++++++++--
>  arch/x86/kernel/mcount_64.S |  26 ++++-
>  include/linux/ftrace.h      |   8 ++
>  kernel/trace/ftrace.c       |  86 +++++++++++++++-
>  4 files changed, 344 insertions(+), 16 deletions(-)
> 

-- 
Josh
