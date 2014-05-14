Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755590AbaENPab (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 11:30:31 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:39121 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754188AbaENPaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 11:30:30 -0400
Date: Wed, 14 May 2014 08:30:08 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Vojtech Pavlik <vojtech@suse.cz>
Cc: Jiri Slaby <jslaby@suse.cz>, Tejun Heo <tj@kernel.org>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com, Michael Matz <matz@suse.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Dipankar Sarma <dipankar@in.ibm.com>
Subject: Re: [RFC 09/16] kgr: mark task_safe in some kthreads
Message-ID: <20140514153008.GD4570@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1398868249-26169-1-git-send-email-jslaby@suse.cz>
 <1398868249-26169-10-git-send-email-jslaby@suse.cz>
 <20140501142414.GA31611@htj.dyndns.org>
 <alpine.LNX.2.00.1405012206430.29834@pobox.suse.cz>
 <20140501210242.GA28948@mtj.dyndns.org>
 <20140501210943.GB28948@mtj.dyndns.org>
 <537384B9.5090907@suse.cz>
 <20140514151501.GA24142@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140514151501.GA24142@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14051415-0928-0000-0000-000001E22415
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 14, 2014 at 05:15:01PM +0200, Vojtech Pavlik wrote:
> On Wed, May 14, 2014 at 04:59:05PM +0200, Jiri Slaby wrote:
> 
> > I see the worst case scenario. (For curious readers, it is for example
> > this kthread body:
> > while (1) {
> >   some_paired_call(); /* invokes pre-patched code */
> >   if (kthread_should_stop()) { /* kgraft switches to the new code */
> >     its_paired_function(); /* invokes patched code (wrong) */
> >     break;
> >   }
> >   its_paired_function(); /* the same (wrong) */
> > })
> > 
> > What to do with that now? We have come up with a couple possibilities.
> > Would you consider try_to_freeze() a good state-defining function? As it
> > is called when a kthread expects weird things can happen, it should be
> > safe to switch to the patched version in our opinion.
> > 
> > The other possibility is to patch every kthread loop (~300) and insert
> > kgr_task_safe() semi-manually at some proper place.
> > 
> > Or if you have any other suggestions we would appreciate that?
> 
> A heretic idea would be to convert all kernel threads into functions
> that do not sleep and exit after a single iteration and are called from
> a central kthread main loop function. That would get all of
> kthread_should_stop() and try_to_freeze() and kgr_task_safe() nicely
> into one place and at the same time put enough constraint on what the
> thread function can do to prevent it from breaking the assumptions of
> each of these calls. 

Some substantial restructuring would be required for several of
the kthreads I am aware of, which contain kthread_should_stop()
inside loop bodies as well as on their conditions.  Also, a number
of them do things like wait_event() and the like, which would mean
that the central kthread main loop function would need to know
about the wait queues and wait conditions and handle them properly.
See for example rcu_torture_barrier_cbs() and rcu_torture_barrier()
in kernel/rcu/rcutorture.c [*], which wait on each other in order to
test RCU's rcu_barrier() primitives.

							Thanx, Paul

* In older kernels, this is kernel/rcu/torture.c or kernel/rcutorture.c.

