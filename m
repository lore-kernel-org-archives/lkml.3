Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064AbaGWMKI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 08:10:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13009 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905AbaGWMKH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 08:10:07 -0400
Date: Wed, 23 Jul 2014 14:08:05 +0200
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
Message-ID: <20140723120805.GB21376@redhat.com>
References: <20140703200750.648550267@goodmis.org> <20140722164707.GA15893@redhat.com> <20140722150236.592662a6@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140722150236.592662a6@gandalf.local.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22, Steven Rostedt wrote:
>
> On Tue, 22 Jul 2014 18:47:07 +0200
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > On 07/03, Steven Rostedt wrote:
> >
> > > The way the function callback mechanism works in ftrace is that if there's
> > > only one function callback registered, it will set the mcount/fentry
> > > trampoline to call that function directly. But as soon as you register
> > > another callback, the mcount trampoline calls a loop function that iterates
> > > over all the registered callbacks (ftrace_ops) checking their hash tables
> > > to see if the called function matches the ops before calling its callback.
> > > This happens even if the two registered functions are not even tracing
> > > the same function!
> > >
> > > This really sucks if you are tracing all functions, and then add a kprobe
> > > or perf event that traces a single function. That will cause all the
> > > other functions being traced to perform the loop test.
> >
> > But this is even worse or I missed something? I mean, currently even
> > if you trace nothing and then add a KPROBE_FLAG_FTRACE kprobe, then
> > kprobe_ftrace_handler() is called by ftrace_ops_list_func() ?
>
> It shouldn't be. It should get called directly from the trampoline. The
> allocated trampoline should never call the list op. Well, it might
> during the conversion for safety, but after that, trampolines should
> only call the registered ftrace_ops->func directly.

I meant the current code (I am reading 3.16-rc2). Even if we have a single
KPROBE_FLAG_FTRACE kprobe, kprobe_ftrace_handler() won't be called directly.

Or I misunderstood your reply? Just in case, let me check...

With this stupid patch

	--- a/kernel/trace/ftrace.c
	+++ b/kernel/trace/ftrace.c
	@@ -4464,6 +4464,7 @@ __ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip,
					printk("op=%p %pS\n", op, op);
					goto out;
				}
	+			pr_crit("LIST_FUNC -> %pf()\n",  op->func);
				op->func(ip, parent_ip, op, regs);
			}
		} while_for_each_ftrace_op(op);

I do
	# cd /sys/kernel/debug/tracing/
	# echo "p:xx SyS_prctl+0x1c" >| kprobe_events
	# cat ../kprobes/list
	ffffffff81056c4c  k  SyS_prctl+0x1c    [DISABLED][FTRACE]
	# echo 1 >| events/kprobes/xx/enable
	#
	# perl -e 'syscall 157,-1'
	# dmesg
	LIST_FUNC -> kprobe_ftrace_handler()

so it is really called by the loop test code.

And I guess that after your patches kprobe_ftrace_handler() should be called
from the trampoline in this case.

> > ftrace_save_ops_tramp_hash():
> >
> > 	do_for_each_ftrace_rec(pg, rec) {
> > 		if (ftrace_rec_count(rec) == 1 &&
> > 		    ftrace_ops_test(ops, rec->ip, rec)) {
> >
> > 			/* This record had better have a trampoline */
> > 			if (FTRACE_WARN_ON(!(rec->flags & FTRACE_FL_TRAMP_EN)))
> > 				return -1;
> >
> > Yes, but I can't understand how this can work.
>
> I wanted the back to 1 case to happen after we get the up to one case
> working. That is, I don't want to worry about it now ;-)  As you can
> see, this code has enough things to try to keep straight without adding
> more complexity to the mix.

Yes, I see... but note that this WARN_ON() looks wrong in any case. At
least currently.

Oleg.

