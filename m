Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759271AbaD3THp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 15:07:45 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:54644 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbaD3THo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 15:07:44 -0400
Date: Wed, 30 Apr 2014 12:07:39 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Vojtech Pavlik <vojtech@suse.cz>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com, Michael Matz <matz@suse.de>,
        Jiri Kosina <jkosina@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Dipankar Sarma <dipankar@in.ibm.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [RFC 09/16] kgr: mark task_safe in some kthreads
Message-ID: <20140430190739.GT8754@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1398868249-26169-1-git-send-email-jslaby@suse.cz>
 <1398868249-26169-10-git-send-email-jslaby@suse.cz>
 <20140430165532.GS8754@linux.vnet.ibm.com>
 <20140430183327.GA3926@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140430183327.GA3926@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14043019-9332-0000-0000-000000A7DC69
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2014 at 08:33:27PM +0200, Vojtech Pavlik wrote:
> On Wed, Apr 30, 2014 at 09:55:32AM -0700, Paul E. McKenney wrote:
> > On Wed, Apr 30, 2014 at 04:30:42PM +0200, Jiri Slaby wrote:
> > > Some threads do not use kthread_should_stop. Before we enable a
> > > kthread support in kgr, we must make sure all those mark themselves
> > > safe explicitly.
> > 
> > Would it make sense to bury kgr_task_safe() in wait_event_interruptible()
> > and friends?  The kgr_task_safe() implementation looks pretty lightweight,
> > so it should not be a performance problem.
> 
> For userspace tasks, the kGraft in progress flag is cleared when
> entering or exiting userspace. At that point it is safe to switch the
> task to a post-patch world view.
> 
> For kernel threads, it's a bit more complicated: They never exit the
> kernel, they keep executing within the kernel continuously. The
> kgr_task_safe() call is thus inserted at a location within the main loop
> where a 'new loop' begins - where there are no dependencies on results
> of calls of functions from the previous loop.
> 
> Hence, putting kgr_task_safe() into every wait_event_interruptible()
> wouldn't work, only a few of them are at that strategic spot where a
> 'new loop' can be indicated to kGraft.
> 
> The reason kgr_task_safe() is called from within the condition
> evaluation statement in wait_event_interruptible() in this patch is
> because we want it to be called as soon as a new loop begins - even if
> that loop is empty because the condition to stop waiting has not been
> met.
> 
> This also means that kGraft currently cannot patch the main loops of
> kernel threads themselves as the thread of execution never exits them.
> 
> Jiří (Slabý) has some ideas about how to do without calling
> kgr_task_safe() from within the kernel thread main loops, but for now,
> the goal is to keep things simple and easy to understand.

OK, from an RCU perspective:

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> > One reason might this might be a bad idea is that there are calls to
> > wait_event_interruptible() all over the place, which might therefore
> > constrain where grafting could be safely done.  That would be fair enough,
> > but does that also imply new constraints on where kthread_should_stop()
> > can be invoked?  Any new constraints might not be a big deal given that
> > a very large fraction of the kthreads (and maybe all of them) invoke
> > kthread_should_stop() from their top-level function, but would be good
> > to call out.
> 
> > So, what is the story?
> 
> kGraft currently assumes that kthread_should_stop() is always in a part
> of the main loop which doesn't carry over effect dependencies from the
> previous iteration. This is currently true for all the uses of
> kthread_should_stop(), but indeed it is an additional constraint for the
> future.

Got it.  It would be good to document this.  ;-)

							Thanx, Paul

> Vojtech
> 

