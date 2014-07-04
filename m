Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753AbaGDOVq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 10:21:46 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:18618 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751554AbaGDOVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 10:21:45 -0400
Date: Fri, 4 Jul 2014 10:21:42 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Oleg Nesterov <oleg@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Seth Jennings <sjenning@redhat.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [RFC][PATCH 0/3] ftrace: Add dynamically allocated trampolines
Message-ID: <20140704102142.7d276e4b@gandalf.local.home>
In-Reply-To: <53B6AA0C.2080704@hitachi.com>
References: <20140703200750.648550267@goodmis.org>
	<53B6AA0C.2080704@hitachi.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 04 Jul 2014 22:20:12 +0900
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:

> (2014/07/04 5:07), Steven Rostedt wrote:
> > [ NOT READY FOR INCLUSION! ]
> > 
> > Note, this is based off of my remove ftrace_start/stop() patch set.
> > 
> > I've been wanting to do this for years, and just never gotten around to it.
> > But with all this talk of kpatch and kgraft live kernel patching using
> > the ftrace infrastructure, it seems like a good time to do it.
> > 
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
> Ah, I've thought that ftrace already had different trampoline for loop and
> single and replaced each mcount-call instruction to appropriate one. But
> this series actually does that, doesn't this? :)

Well, I guess the answer to that is what do you consider the
trampoline? I'm currently considering it to be the assembly code that
the mcount/fentry call jumps to. We only have two trampolines (three if
you count the function graph code that will be called directly come
3.17). Those two are the normal ftrace_caller and the
ftrace_regs_caller. Now what they call can be different. When only a
single ftrace_ops is registered, they call the ftrace_ops->func
directly. If there are more than one ftrace_ops registered, then they
call the loop function directly.


> 
> > Ideally, if only a single callback (ftrace_ops) is registered to a
> > function, than that function should call a trampoline that will only
> > call that one callback without doing any other tests.
> > 
> > This patch set adds this functionality to x86_64. If a callback is
> > registered to a function and there's no other callback registered to
> > that function that ftrace_ops will get its own trampoline allocated
> > for it that will call the function directly.
> > 
> > Note, for dynamically allocated ftrace_ops (kprobes, perf, instance
> > directory function tracing), the dynamic trampoline will only be created
> > if CONFIG_PREEMPT is not set. That's because, until Paul finishes his
> > rcu_call_task() code, there's no safe way to know if a task was preempted
> > while on the trampoline and is waiting to run on it some more.
> 
> Hmm, if we can declare "this ftrace_ops is permanent"(like finalizing) then
> we can allocate trampoline for such dynamic one. Since the kprobes actually
> doesn't need to free (or unregister) ftrace_ops, I can use it.

Yeah, if we add a ftrace_ops PERMANENT flag, then we could allow them
too.

> 
> 
> > I need to write up a bunch of tests for this code, but currently it works
> > on the few tests I did manually. I didn't even run this code yet under
> > my full test suite, so it may very well have bugs in it that might be
> > easily triggered. But I wanted to get the code out for review to see
> > if anyone has any other idea to help enhance this feature.
> 
> Yeah, I'll review it.

Thanks!

-- Steve


