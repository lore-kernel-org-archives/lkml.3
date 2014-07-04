Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756951AbaGDNUW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 09:20:22 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:57131 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566AbaGDNUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 09:20:19 -0400
Message-ID: <53B6AA0C.2080704@hitachi.com>
Date: Fri, 04 Jul 2014 22:20:12 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Oleg Nesterov <oleg@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Seth Jennings <sjenning@redhat.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [RFC][PATCH 0/3] ftrace: Add dynamically allocated trampolines
References: <20140703200750.648550267@goodmis.org>
In-Reply-To: <20140703200750.648550267@goodmis.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/07/04 5:07), Steven Rostedt wrote:
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

Ah, I've thought that ftrace already had different trampoline for loop and
single and replaced each mcount-call instruction to appropriate one. But
this series actually does that, doesn't this? :)

> Ideally, if only a single callback (ftrace_ops) is registered to a
> function, than that function should call a trampoline that will only
> call that one callback without doing any other tests.
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

Hmm, if we can declare "this ftrace_ops is permanent"(like finalizing) then
we can allocate trampoline for such dynamic one. Since the kprobes actually
doesn't need to free (or unregister) ftrace_ops, I can use it.


> I need to write up a bunch of tests for this code, but currently it works
> on the few tests I did manually. I didn't even run this code yet under
> my full test suite, so it may very well have bugs in it that might be
> easily triggered. But I wanted to get the code out for review to see
> if anyone has any other idea to help enhance this feature.

Yeah, I'll review it.


Thank you,


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
> 
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com


