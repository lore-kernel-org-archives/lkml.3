Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228AbaEAVLf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 17:11:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58289 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247AbaEAVLd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 17:11:33 -0400
Date: Thu, 1 May 2014 17:11:28 -0400
From: Don Zickus <dzickus@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, Ben Zhang <benzh@chromium.org>
Subject: Re: [PATCH] watchdog: print all locks on a softlock
Message-ID: <20140501211128.GC198341@redhat.com>
References: <1398970535-6880-1-git-send-email-eparis@redhat.com>
 <20140501191720.GA198341@redhat.com>
 <20140501200858.GA27787@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140501200858.GA27787@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2014 at 10:09:01PM +0200, Frederic Weisbecker wrote:
> On Thu, May 01, 2014 at 03:17:20PM -0400, Don Zickus wrote:
> > On Thu, May 01, 2014 at 02:55:35PM -0400, Eric Paris wrote:
> > > If the CPU hits a softlockup this patch will also have it print the
> > > information about all locks being held on the system.  This might help
> > > determine if a lock is being held too long leading to this problem.
> > 
> > I am not sure this helps you.  A softlockup is the result of pre-emption
> > disabled, ie the scheduler not being called after 60 seconds.  Holding a
> > lock does not disable pre-emption usually.  So I don't think this is going
> > to add anything.
> > 
> > Are you trying to debug a hung task?  The the hung_task thread checks to
> > see if a task hasn't scheduled in 2 minutes or so.  That could be the
> > result of long lock (but that output already dumps the lockdep stuff).
> 
> There may be some deadlocks that lockdep doesn't detect yet. 2 example:
> 
> 1) spinlock <-> IPI dependency
> 
> 
>         CPU 0                                            CPU 1
>         --------------------------------------------------------
>         spin_lock_irq(A)
>         smp_send_function_single_async(CPU 1, func)
>                                                          //IPI
>                                                          func {
>                                                             spin_lock(1)
>                                                          }
> 
> But this should be resolved with a virtual lock on the IPI functions.
> I should try that.
> 
> 2) rwlock <-> IPI
> 
>         CPU 0                                            CPU 1
>         --------------------------------------------------------
>         read_lock(A)
>                                                          write_lock_irq(A)
>         smp_send_function_single(CPU 1, func)
>                                                          //IPI never happens

The hardlockup detector would go off here.  And dumping all the cpus in
the system (something we don't do today), would show this scenario.  I see
this scenario a lot during page flushes on RHEL (a lot being once every
other month or so).

Cheers,
Don

> 
> This one is much trickier.
> 
> Anyway those are the only scenario I know of but there may be more. When possible
> we want to extend lockdep to detect new scenarios of deadlock but we don't have the
> guarantee that it can detect everything.
> 
> So, could be useful...
