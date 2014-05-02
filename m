Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241AbaEBN34 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 09:29:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14652 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752048AbaEBN3y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 09:29:54 -0400
Date: Fri, 2 May 2014 08:29:46 -0500
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Seth Jennings <sjenning@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Slaby <jslaby@suse.cz>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] kpatch: dynamic kernel patching
Message-ID: <20140502132946.GA4556@treble.redhat.com>
References: <cover.1398958771.git.jpoimboe@redhat.com>
 <alpine.LRH.2.00.1405021030540.22053@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1405021030540.22053@twin.jikos.cz>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 02, 2014 at 10:37:53AM +0200, Jiri Kosina wrote:
> On Thu, 1 May 2014, Josh Poimboeuf wrote:
> 
> > Since Jiri posted the kGraft patches [1], I wanted to share an
> > alternative live patching solution called kpatch, which is something
> > we've been working on at Red Hat for quite a while.
> 
> Hi Josh, Seth,
> 
> thanks a lot for following up to our RFC with your submission, I am pretty 
> sure this will help to energize the discussion and will provoke ideas for 
> further improvements.

Hi Jiri!

Thanks for your comments.  I'm pretty sure we have the same basic goals
and we definitely want to find something that works for everybody.

> 
> [ ... snip ... ]
> > kpatch vs kGraft
> > ----------------
> > 
> > I think the biggest difference between kpatch and kGraft is how they
> > ensure that the patch is applied atomically and safely.
> > 
> > kpatch checks the backtraces of all tasks in stop_machine() to ensure
> > that no instances of the old function are running when the new function
> > is applied.  I think the biggest downside of this approach is that
> > stop_machine() has to idle all other CPUs during the patching process,
> > so it inserts a small amount of latency (a few ms on an idle system).
> 
> Completely agreed with your comparative analysis, thanks for a nice 
> summary.
> 
> Additional thing that I believe is important to add here: with the 
> "stop-machine / check all tasks" aproach, there might be situations where 
> you'll always fail to patch the system; if there is a long-time sleeper in 
> the patched callchain, such a single sleeper is enough to make the 
> patching of the whole system impossible.

Yeah, this is true with our current implementation.  With
stop_machine(), functions which are always on the stack of at least one
process in the system can't be patched.  In practice this means
functions like schedule(), poll(), select() and nanosleep().

Here are all the top-level sleeping functions on my system:

  $ for i in /proc/*/wchan; do cat $i; echo; done | sort |uniq |egrep -v '^0$'
  devtmpfsd
  do_sigtimedwait
  do_wait
  ep_poll
  fsnotify_mark_destroy
  futex_wait_queue_me
  hrtimer_nanosleep
  hub_thread
  inotify_read
  irq_thread
  kauditd_thread
  khugepaged
  kjournald2
  ksm_scan_thread
  kswapd
  kthreadd
  n_tty_read
  pipe_wait
  poll_schedule_timeout
  rcu_gp_kthread
  rescuer_thread
  rfcomm_run
  scsi_error_handler
  smpboot_thread_fn
  unix_stream_recvmsg
  worker_thread

In addition to these functions, their call chain path down to schedule()
also can't be patched.  But it works out to be a tiny ratio of
unpatchable-to-patchable.

I think this is a very minor limitation, but if it turned out to be a
problem, we could do something like installing an ftrace handler for the
blocking function, waking the sleeping task, and looping in the ftrace
handler until the patching process is complete.

> 
> With the lazy/gradual aproach implemented in kGraft, the whole system is 
> gradually moving towards "fully patched" state and once all the sleepers 
> blocking the process wake up, it ultimately converges to the fully patched 
> state.
> 
> Thanks,
> 
> -- 
> Jiri Kosina
> SUSE Labs
> 

-- 
Josh
