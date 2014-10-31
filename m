Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759983AbaJaVsp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 17:48:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:38021 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759823AbaJaVso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 17:48:44 -0400
Date: Fri, 31 Oct 2014 22:48:36 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, peter@hurleysoftware.com,
        rjw@rjwysocki.net, torvalds@linux-foundation.org, tglx@linutronix.de,
        eparis@redhat.com, umgwanakikbuti@gmail.com, marcel@holtmann.org,
        ebiederm@xmission.com, davem@davemloft.net, fengguang.wu@intel.com
Subject: Re: [PATCH 2/7] wait: Reimplement wait_event_freezable()
Message-ID: <20141031214836.GQ10501@worktop.programming.kicks-ass.net>
References: <20141031111037.936236584@infradead.org>
 <20141031111549.551132563@infradead.org>
 <20141031213802.GA25881@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141031213802.GA25881@redhat.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 10:38:02PM +0100, Oleg Nesterov wrote:
> On 10/31, Peter Zijlstra wrote:
> >
> > Provide better implementations of wait_event_freezable() APIs.
> >
> > The problem is with freezer_do_not_count(), it hides the thread from
> > the freezer, even though this thread might not actually freeze/sleep
> > at all.
> 
> I agree, wait_event_freezable() is awful. But could you clarify "at all" ?
> 
> Sure, the task can be preempted right after it sets, it can do a lot
> of things before it calls schedule(), it can be woken after that and
> it can run again and do something else before freezer_count() calls
> try_to_freeze(), etc.
> 
> Is this what you meant?

Yes.

> > +#define __wait_event_freezable(wq, condition)				\
> > +	(void)___wait_event(wq, condition, TASK_INTERRUPTIBLE, 0, 0,	\
> > +			    schedule(); try_to_freeze())
> 
> I don't think this can work.

Yeah, that was horribly broken. defconfig didn't seem to find a usage
site. Wu's robot offered a .config quickly enough though ;-)
