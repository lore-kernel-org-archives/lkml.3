Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756289AbaGVQtN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 12:49:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51909 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755266AbaGVQtL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 12:49:11 -0400
Date: Tue, 22 Jul 2014 18:47:07 +0200
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
Message-ID: <20140722164707.GA15893@redhat.com>
References: <20140703200750.648550267@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140703200750.648550267@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/03, Steven Rostedt wrote:
>
> [ NOT READY FOR INCLUSION! ]
>
> Note, this is based off of my remove ftrace_start/stop() patch set.

So I simply pulled your tree. I can't really comment these changes simply
because I do not understand this code. But I am hunting for RHEL bug in
(probably) this area, so I decided to take a look in a hope that may be
this can help me to understand the current code ;)

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

But this is even worse or I missed something? I mean, currently even
if you trace nothing and then add a KPROBE_FLAG_FTRACE kprobe, then
kprobe_ftrace_handler() is called by ftrace_ops_list_func() ?

After these changes it seems that kprobe will use a trampoline.

And I can't understand even the basic code. Say, __ftrace_hash_rec_update:

		if (inc) {
			rec->flags++;
			if (FTRACE_WARN_ON(ftrace_rec_count(rec) == FTRACE_REF_MAX))
				return;

			/*
			 * If there's only a single callback registered to a
			 * function, and the ops has a trampoline registered
			 * for it, then we can call it directly.
			 */
			if (ftrace_rec_count(rec) == 1 && ops->trampoline) {
				rec->flags |= FTRACE_FL_TRAMP;
				ops->trampolines++;
			} else {
				/*
				 * If we are adding another function callback
				 * to this function, and the previous had a
				 * trampoline used, then we need to go back to
				 * the default trampoline.
				 */
				rec->flags &= ~FTRACE_FL_TRAMP;

				/* remove trampolines from any ops for this rec */
				ftrace_clear_tramps(rec);
			}

It seems that "else if (ftrace_rec_count(rec) == 2)" can avoid the unnecessary
ftrace_clear_tramps() ? And not only unnecessary, ftrace_clear_tramps() decrements
->trampolines, can't this break the accounting?

		} else {
			if (FTRACE_WARN_ON(ftrace_rec_count(rec) == 0))
				return;
			rec->flags--;

			if (ops->trampoline && !ftrace_rec_count(rec))
				ftrace_remove_tramp(ops, rec);

I am wondering what should we do if ftrace_rec_count() becomes 1 again...

ftrace_save_ops_tramp_hash():

	do_for_each_ftrace_rec(pg, rec) {
		if (ftrace_rec_count(rec) == 1 &&
		    ftrace_ops_test(ops, rec->ip, rec)) {

			/* This record had better have a trampoline */
			if (FTRACE_WARN_ON(!(rec->flags & FTRACE_FL_TRAMP_EN)))
				return -1;

Yes, but I can't understand how this can work.

This ops can have  ->trampolines > 0, but FTRACE_FL_TRAMP_EN can be cleared
by another ftrace_ops?

Suppose there is a single tracer of this function, rec->flags = TRAMP | TRAMP_EN.
Suppose also that it traces more than 1 function, so ->trampolines > 1.

Another tracer comes, __ftrace_hash_rec_update() clears TRAMP. But it should
also do ftrace_check_record() and this should clear TRAMP_EN?

And yes, I can trigger this bug if I simply do "echo function > current_tracer"
and then add/remove a KPROBE_FLAG_FTRACE kprobe.


And you know, when I try to read this code I can't distinguish ->trampoline
from ->trampolines ;)

Oleg.

