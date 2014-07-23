Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932653AbaGWRU0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 13:20:26 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:4571 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757430AbaGWRUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 13:20:23 -0400
Date: Wed, 23 Jul 2014 13:20:20 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Namhyung Kim <namhyung@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Seth Jennings <sjenning@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: [RFC][PATCH 0/3] ftrace: Add dynamically allocated trampolines
Message-ID: <20140723132020.23a70e9b@gandalf.local.home>
In-Reply-To: <20140723170552.GA7820@redhat.com>
References: <20140703200750.648550267@goodmis.org>
	<20140722164707.GA15893@redhat.com>
	<20140722150236.592662a6@gandalf.local.home>
	<20140723120805.GB21376@redhat.com>
	<20140723114833.49170d63@gandalf.local.home>
	<20140723170552.GA7820@redhat.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jul 2014 19:05:52 +0200
Oleg Nesterov <oleg@redhat.com> wrote:


> > kprobe ftrace_ops are allocated which sets the FTRACE_OPS_FL_DYNAMIC
> > flag. You'll see that flag checked in update_ftrace_function(), and if
> > it is set, it forces the ftrace_ops_list_func() to be used.
> 
> No? __register_ftrace_function() sets if !core_kernel_data(ops), and
> kprobe_ftrace_ops is not dynamic?

Oh, you're right. I thought it was allocated.

What it is missing is the FTRACE_OPS_RECURSION_SAFE flag. Although, I'm
working on a patch that makes a non loop func that does the recursion
checks for just a single ftrace_ops->func if only one is registered.

> 
> > Why?
> >
> > [...snip..]
> 
> Yes, thanks, I understand why, at least to some degree.
> 
> > 	foo()
> > 	  [mcount called --> ftrace_caller trampoline]
> >            ftrace_caller
> >              load ftrace_ops into parameter
> >              <interrupt>
> >              preempt_schedule()
> >        [new task]
> >        kfree(kprobe ftrace_ops);
> 
> see above.
> 
> And to be sure, I compiled your rfc/trampoline kernel which I pulled
> yesterday with the same patch and did the same test. __ftrace_ops_list_func()
> prints nothing.

Note, I'm still working on fixes to that branch ;-)

> 
> So I also added WARN_ON(1) into kprobe_ftrace_handler() to ensure that
> it is actually called, and yes, dmesg reports
> 
> 	WARNING: ... kprobe_ftrace_handler+0x38/0x140()
> 	...
> 	Call Trace:
> 	 [<ffffffff8136a3eb>] dump_stack+0x5b/0xa8
> 	 [<ffffffff810423ec>] warn_slowpath_common+0x8c/0xc0
> 	 [<ffffffff8105772c>] ? SyS_prctl+0x1c/0x730
> 	 [<ffffffff8104243a>] warn_slowpath_null+0x1a/0x20
> 	 [<ffffffff810325c8>] kprobe_ftrace_handler+0x38/0x140
> 	 [<ffffffff8137148a>] ? retint_swapgs+0xe/0x13
> 	 [<ffffffff81057731>] ? SyS_prctl+0x21/0x730
> 	 [<ffffffff81057731>] ? SyS_prctl+0x21/0x730
> 	 [<ffffffff8122424e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> 	 [<ffffffff81370912>] ? system_call_fastpath+0x16/0x1b
> 

BTW, you may want to look at

/sys/kernel/debug/tracing/enabled_functions

as that has a lot of debug info for the trampolines in that branch.

> after "perl -e 'syscall 157,-1'".
> 
> and, as expected, if I do "echo SyS_prctl >| set_ftrace_filter" and
> "echo function >| current_tracer", then the command above also triggers
> 2 printk's in __ftrace_ops_list_func() :
> 
> 	LIST_FUNC -> function_trace_call()
> 	LIST_FUNC -> kprobe_ftrace_handler()
> 
> so it seems that your patches can potentially buy more than you think ;)
> 
> Oleg.


I'll play with this some more to understand everything you are stating.

Thanks,

-- Steve
