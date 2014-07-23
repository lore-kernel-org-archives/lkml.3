Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932606AbaGWRHr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 13:07:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19683 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932201AbaGWRHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 13:07:46 -0400
Date: Wed, 23 Jul 2014 19:05:52 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Seth Jennings <sjenning@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: [RFC][PATCH 0/3] ftrace: Add dynamically allocated trampolines
Message-ID: <20140723170552.GA7820@redhat.com>
References: <20140703200750.648550267@goodmis.org> <20140722164707.GA15893@redhat.com> <20140722150236.592662a6@gandalf.local.home> <20140723120805.GB21376@redhat.com> <20140723114833.49170d63@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140723114833.49170d63@gandalf.local.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23, Steven Rostedt wrote:
>
> On Wed, 23 Jul 2014 14:08:05 +0200
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > With this stupid patch
> >
> > 	--- a/kernel/trace/ftrace.c
> > 	+++ b/kernel/trace/ftrace.c
> > 	@@ -4464,6 +4464,7 @@ __ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip,
> > 					printk("op=%p %pS\n", op, op);
> > 					goto out;
> > 				}
> > 	+			pr_crit("LIST_FUNC -> %pf()\n",  op->func);
> > 				op->func(ip, parent_ip, op, regs);
> > 			}
> > 		} while_for_each_ftrace_op(op);
> >
> > I do
> > 	# cd /sys/kernel/debug/tracing/
> > 	# echo "p:xx SyS_prctl+0x1c" >| kprobe_events
> > 	# cat ../kprobes/list
> > 	ffffffff81056c4c  k  SyS_prctl+0x1c    [DISABLED][FTRACE]
> > 	# echo 1 >| events/kprobes/xx/enable
> > 	#
> > 	# perl -e 'syscall 157,-1'
> > 	# dmesg
> > 	LIST_FUNC -> kprobe_ftrace_handler()
> >
> > so it is really called by the loop test code.
> >
> > And I guess that after your patches kprobe_ftrace_handler() should be called
> > from the trampoline in this case.
>
> No it wont be. Not until we have Paul McKenney's task_rcu code that
> will return after all tasks have either gone through userspace or a
> schedule. Hmm, maybe on a !CONFIG_PREEMPT it will be OK. Oh, I can have
> that be OK now on !CONFIG_PREEMPT. Maybe I'll do that too.
>
> kprobe ftrace_ops are allocated which sets the FTRACE_OPS_FL_DYNAMIC
> flag. You'll see that flag checked in update_ftrace_function(), and if
> it is set, it forces the ftrace_ops_list_func() to be used.

No? __register_ftrace_function() sets if !core_kernel_data(ops), and
kprobe_ftrace_ops is not dynamic?

> Why?
>
> [...snip..]

Yes, thanks, I understand why, at least to some degree.

> 	foo()
> 	  [mcount called --> ftrace_caller trampoline]
>            ftrace_caller
>              load ftrace_ops into parameter
>              <interrupt>
>              preempt_schedule()
>        [new task]
>        kfree(kprobe ftrace_ops);

see above.

And to be sure, I compiled your rfc/trampoline kernel which I pulled
yesterday with the same patch and did the same test. __ftrace_ops_list_func()
prints nothing.

So I also added WARN_ON(1) into kprobe_ftrace_handler() to ensure that
it is actually called, and yes, dmesg reports

	WARNING: ... kprobe_ftrace_handler+0x38/0x140()
	...
	Call Trace:
	 [<ffffffff8136a3eb>] dump_stack+0x5b/0xa8
	 [<ffffffff810423ec>] warn_slowpath_common+0x8c/0xc0
	 [<ffffffff8105772c>] ? SyS_prctl+0x1c/0x730
	 [<ffffffff8104243a>] warn_slowpath_null+0x1a/0x20
	 [<ffffffff810325c8>] kprobe_ftrace_handler+0x38/0x140
	 [<ffffffff8137148a>] ? retint_swapgs+0xe/0x13
	 [<ffffffff81057731>] ? SyS_prctl+0x21/0x730
	 [<ffffffff81057731>] ? SyS_prctl+0x21/0x730
	 [<ffffffff8122424e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
	 [<ffffffff81370912>] ? system_call_fastpath+0x16/0x1b

after "perl -e 'syscall 157,-1'".

and, as expected, if I do "echo SyS_prctl >| set_ftrace_filter" and
"echo function >| current_tracer", then the command above also triggers
2 printk's in __ftrace_ops_list_func() :

	LIST_FUNC -> function_trace_call()
	LIST_FUNC -> kprobe_ftrace_handler()

so it seems that your patches can potentially buy more than you think ;)

Oleg.

