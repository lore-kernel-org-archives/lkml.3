Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608AbaJBNmG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 09:42:06 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:58478 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbaJBNmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 09:42:03 -0400
Date: Thu, 2 Oct 2014 15:41:56 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, Jet Chen <jet.chen@intel.com>,
        Su Tao <tao.su@intel.com>, Yuanhan Liu <yuanhan.liu@intel.com>,
        LKP <lkp@01.org>, linux-kernel@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [rfcomm_run] WARNING: CPU: 1 PID: 79 at kernel/sched/core.c:7156
 __might_sleep()
Message-ID: <20141002134156.GA10583@worktop.programming.kicks-ass.net>
References: <20140930080228.GD9561@wfg-t540p.sh.intel.com>
 <20141002110927.GE2849@worktop.programming.kicks-ass.net>
 <20141002123150.GC6324@worktop.programming.kicks-ass.net>
 <542D4756.4030100@hurleysoftware.com>
 <20141002125409.GG2849@worktop.programming.kicks-ass.net>
 <542D4DA6.2090607@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <542D4DA6.2090607@hurleysoftware.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 02, 2014 at 09:05:42AM -0400, Peter Hurley wrote:

> >>> While at it, rename rfcomm_schedule to rfcomm_wake, since that is what
> >>> it actually does.
> >>
> >> rfcomm_schedule() as in schedule_work(), which is how it's used.
> > 
> > Not really, all it does is wake the rfcomm_thread. The thread then does
> > a linear walk of all known sessions looking for work -- which is clearly
> > suboptimal as well, but I didn't feel like fixing that.
> > 
> > Also, the current implementation already disagrees with you, all it
> > basically does it call wake_up_process() which is a big clue right
> > there.
> 
> You're thinking of it from the point of view of the scheduler, so to you
> it should be named what it does.

Of course I am, that thing is called 'schedule' so its natural to think
about the scheduler :-)

> However, from the users' point of view, it's an abstraction of work
> dispatching; the fact that a kthread (which needs waking) does the work
> is irrelevant.

Still a misnomer, see below.

> Consider if the kthread is converted to work_structs instead and your now-
> renamed rfcomm_wake() is calling schedule_work().

Then it would probably be less buggy and more efficient -- where I'm
assuming it would queue work per session and avoid the endless scanning
of sessions.

Also schedule_work() is somewhat sanely named in that you schedule the
work for later execution, so here we can use the term. The thread
however might already be scheduled or even running, so there it is not
appropriate.
