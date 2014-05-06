Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757603AbaEFOF2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 10:05:28 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:53742 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189AbaEFOF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 10:05:26 -0400
Date: Tue, 6 May 2014 16:05:21 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, Seth Jennings <sjenning@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 0/2] kpatch: dynamic kernel patching
Message-ID: <20140506140516.GF2099@localhost.localdomain>
References: <cover.1398958771.git.jpoimboe@redhat.com>
 <20140505085537.GA32196@gmail.com>
 <20140505132638.GA14432@treble.redhat.com>
 <20140505141038.GA27403@localhost.localdomain>
 <20140505184304.GA15137@gmail.com>
 <20140505214919.GE2099@localhost.localdomain>
 <20140506121211.GA4125@treble.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140506121211.GA4125@treble.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2014 at 07:12:11AM -0500, Josh Poimboeuf wrote:
> On Mon, May 05, 2014 at 11:49:23PM +0200, Frederic Weisbecker wrote:
> > On Mon, May 05, 2014 at 08:43:04PM +0200, Ingo Molnar wrote:
> > > If a kernel refuses to patch with certain threads running, that will 
> > > drive those kernel threads being fixed and such. It's a deterministic, 
> > > recoverable, reportable bug situation, so fixing it should be fast.
> > > 
> > > We learned these robustness lessons the hard way with kprobes and 
> > > ftrace dynamic code patching... which are utterly simple compared to 
> > > live kernel patching!
> > 
> > Yeah, agreed. More rationale behind: we want to put the kthreads into
> > semantic sleeps, not just random sleeping point. This way we lower the
> > chances to execute new code messing up living state that is expecting old
> > code after random preemption or sleeping points.
> > 
> > But by semantic sleeps I mean more than just explicit calls to schedule()
> > as opposed to preemption points.
> > It also implies shutting down as well the living states handled by the kthread
> > such that some sort of re-initialization of the state is also needed when
> > the kthread gets back to run.
> > 
> > And that's exactly what good implementations of kthread park provide.
> > 
> > Consider kernel/watchdog.c as an example: when we park the lockup
> > detector kthread, it disables the perf event and the hrtimer before it goes
> > to actually park and sleep. When the kthread is later unparked, the kthread
> > restarts the hrtimer and the perf event.
> > 
> > If we live patch code that has obscure relations with perf or hrtimer here,
> > we lower a lot the chances for a crash when the watchdog kthread is parked.
> > 
> > So I'm in favour of parking all possible kthreads before live patching. Freezing
> > alone doesn't provide the same state shutdown than parking.
> > 
> > Now since parking looks more widely implemented than kthread freezing, we could
> > even think about implementing kthread freezing using parking as backend.
> 
> The vast majority of kernel threads on my system don't seem to know
> anything about parking or freezing.  I see one kthread function which
> calls kthread_should_park(), which is smpboot_thread_fn(), used for
> ksoftirqd/*, migration/* and watchdog/*.  But there are many other
> kthread functions which seem to be parking ignorant, including:
> 
>   cpu_idle_loop
>   kthreadd
>   rcu_gp_kthread
>   worker_thread
>   rescuer_thread
>   devtmpfsd
>   hub_thread
>   kswapd
>   ksm_scan_thread
>   khugepaged
>   fsnotify_mark_destroy
>   scsi_error_handler
>   kauditd_thread
>   kjournald2
>   irq_thread
>   rfcomm_run

Yeah I now realize that only very few of them can park. Only infiniband, rcu,
stop_machine and the watchdog...

But that's still a good direction to take if we want to make the kernel
step by step more robust against live patching.

> 
> Maybe we could modify all these thread functions (and probably more) to
> be park and/or freezer capable.  But really it wouldn't make much of a
> difference IMO.  It would only protect careless users from a tiny
> percentage of all possible havoc that a careless user could create.
> 
> Live patching is a very sensitive and risky operation, and from a kernel
> standpoint we should make it as safe as we reasonably can.  But we can't
> do much about careless users.  Ultimately the risk is in the hands of
> the user and their choice of patches.  They need to absolutely
> understand all the implications of patching a particular function.

Kernel developers will be a tiny minority of users of live patching.

Very few sysadmins know about kernel internals. You can't really ask them
to judge if a patch is reasonably live patchable or not.

It's possible to appreciate a patch wrt. its size, or the fact that it came
through a stable tree, so it's at worst mildly invasive.

The only thing that could make live patching safe is that a community
eventually builds around it and carefully inspect patches in a stable release
then provide a selection of safely live patchable pieces.

Other than that, expect people to do crazy things.

> If the patch changes the way a function interacts with some external data,
> then they're starting to tempt fate and they need to be extra careful.
> This care needs to be taken for *all* kernel functions, not just for the
> few that are called from kernel threads.

It's actually very hard to tell if a given function isn't called by any
kernel thread.

> 
> Also, the top level kernel thread functions (like those listed above)
> will never be patchable anyway, because we never patch an in-use
> function (these functions are always in the threads' backtraces).  This
> further diminishes the benefit of parking/freezing kernel threads.

You're right to do some basic prevention. It's the bare minimum.

But keep in mind it's a tiny protection if you consider the top level
function is only a small part of what is called by a kernel thread. And
there is still a risk that the patched part is incompatible with previously
executed code. For example when a patched function depends on a patched
initialization but we executed the old version of the initialization already
and we are going to execute the new patched function. It's actually a common
pattern. And careful implementation of kthreads parking can help. But this is
something that we can do step by step.

Ah this reminds me when we chased kprobes dangerous spots and we tried to
declare __kprobes the functions which were too dangerous to hot patch.

We eventually gave up because it was impossible to fix everything. And that
was only for kprobes!

So you can never tell if a given patch will impact a given kthread.
