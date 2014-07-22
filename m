Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932076AbaGVTCm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 15:02:42 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:4508 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756616AbaGVTCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 15:02:40 -0400
Date: Tue, 22 Jul 2014 15:02:36 -0400
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
Message-ID: <20140722150236.592662a6@gandalf.local.home>
In-Reply-To: <20140722164707.GA15893@redhat.com>
References: <20140703200750.648550267@goodmis.org>
	<20140722164707.GA15893@redhat.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Jul 2014 18:47:07 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> On 07/03, Steven Rostedt wrote:
> >
> > [ NOT READY FOR INCLUSION! ]
> >
> > Note, this is based off of my remove ftrace_start/stop() patch set.
> 
> So I simply pulled your tree. I can't really comment these changes simply
> because I do not understand this code. But I am hunting for RHEL bug in
> (probably) this area, so I decided to take a look in a hope that may be
> this can help me to understand the current code ;)

Send me a ping on my RH email and I'll take a look at that BZ.

Note, I've played a little with this recently. I should make sure that
I push the latest. Warning, that trampoline branch will rebase.

> 
> > The way the function callback mechanism works in ftrace is that if there's
> > only one function callback registered, it will set the mcount/fentry
> > trampoline to call that function directly. But as soon as you register
> > another callback, the mcount trampoline calls a loop function that iterates
> > over all the registered callbacks (ftrace_ops) checking their hash tables
> > to see if the called function matches the ops before calling its callback.
> > This happens even if the two registered functions are not even tracing
> > the same function!
> >
> > This really sucks if you are tracing all functions, and then add a kprobe
> > or perf event that traces a single function. That will cause all the
> > other functions being traced to perform the loop test.
> 
> But this is even worse or I missed something? I mean, currently even
> if you trace nothing and then add a KPROBE_FLAG_FTRACE kprobe, then
> kprobe_ftrace_handler() is called by ftrace_ops_list_func() ?

It shouldn't be. It should get called directly from the trampoline. The
allocated trampoline should never call the list op. Well, it might
during the conversion for safety, but after that, trampolines should
only call the registered ftrace_ops->func directly.

> 
> After these changes it seems that kprobe will use a trampoline.
> 
> And I can't understand even the basic code. Say, __ftrace_hash_rec_update:

Well, to make you feel better, __ftrace_hash_rec_update() happens to
be one of the most complex functions in ftrace.

> 
> 		if (inc) {
> 			rec->flags++;
> 			if (FTRACE_WARN_ON(ftrace_rec_count(rec) == FTRACE_REF_MAX))
> 				return;
> 
> 			/*
> 			 * If there's only a single callback registered to a
> 			 * function, and the ops has a trampoline registered
> 			 * for it, then we can call it directly.
> 			 */
> 			if (ftrace_rec_count(rec) == 1 && ops->trampoline) {
> 				rec->flags |= FTRACE_FL_TRAMP;
> 				ops->trampolines++;
> 			} else {
> 				/*
> 				 * If we are adding another function callback
> 				 * to this function, and the previous had a
> 				 * trampoline used, then we need to go back to
> 				 * the default trampoline.
> 				 */
> 				rec->flags &= ~FTRACE_FL_TRAMP;
> 
> 				/* remove trampolines from any ops for this rec */
> 				ftrace_clear_tramps(rec);
> 			}
> 
> It seems that "else if (ftrace_rec_count(rec) == 2)" can avoid the unnecessary
> ftrace_clear_tramps() ? And not only unnecessary, ftrace_clear_tramps() decrements
> ->trampolines, can't this break the accounting?

Ug, you're right.

But I think it should be "else if (rec->flags & FTRACE_FL_TRAMP)"


> 
> 		} else {
> 			if (FTRACE_WARN_ON(ftrace_rec_count(rec) == 0))
> 				return;
> 			rec->flags--;
> 
> 			if (ops->trampoline && !ftrace_rec_count(rec))
> 				ftrace_remove_tramp(ops, rec);
> 
> I am wondering what should we do if ftrace_rec_count() becomes 1 again...
> 
> ftrace_save_ops_tramp_hash():
> 
> 	do_for_each_ftrace_rec(pg, rec) {
> 		if (ftrace_rec_count(rec) == 1 &&
> 		    ftrace_ops_test(ops, rec->ip, rec)) {
> 
> 			/* This record had better have a trampoline */
> 			if (FTRACE_WARN_ON(!(rec->flags & FTRACE_FL_TRAMP_EN)))
> 				return -1;
> 
> Yes, but I can't understand how this can work.

I wanted the back to 1 case to happen after we get the up to one case
working. That is, I don't want to worry about it now ;-)  As you can
see, this code has enough things to try to keep straight without adding
more complexity to the mix.


> 
> This ops can have  ->trampolines > 0, but FTRACE_FL_TRAMP_EN can be cleared
> by another ftrace_ops?
> 
> Suppose there is a single tracer of this function, rec->flags = TRAMP | TRAMP_EN.
> Suppose also that it traces more than 1 function, so ->trampolines > 1.
> 
> Another tracer comes, __ftrace_hash_rec_update() clears TRAMP. But it should
> also do ftrace_check_record() and this should clear TRAMP_EN?
> 
> And yes, I can trigger this bug if I simply do "echo function > current_tracer"
> and then add/remove a KPROBE_FLAG_FTRACE kprobe.
> 
> 
> And you know, when I try to read this code I can't distinguish ->trampoline
> from ->trampolines ;)

Good point. I'll rename trampolines to nr_trampolines. At least that
way it will stick out that it's a counter.


BTW, for someone that says they can't understand the code, you are
pretty good feedback.

-- Steve
