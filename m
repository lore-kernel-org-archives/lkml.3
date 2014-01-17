Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484AbaAQQb3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 11:31:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53866 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751973AbaAQQb1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 11:31:27 -0500
Date: Fri, 17 Jan 2014 17:31:11 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: check && lockdep_no_validate (Was: lockdep: Introduce
	wait-type checks)
Message-ID: <20140117163111.GA5764@redhat.com>
References: <20140116180944.GC9655@laptop.programming.kicks-ass.net> <Pine.LNX.4.44L0.1401161515190.1109-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1401161515190.1109-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16, Alan Stern wrote:
>
> On Thu, 16 Jan 2014, Peter Zijlstra wrote:
>
> > On Thu, Jan 16, 2014 at 06:43:48PM +0100, Oleg Nesterov wrote:
>
> > > Perhaps we should change the meaning of lockdep_set_novalidate_class?
> > > (perhaps with rename). What do you think about the patch below?
> > >
> > > With this patch __lockdep_no_validate__ means "automatically nested",
> >
> > Yes, I suppose that might work, it would allow some validation.
>
> I haven't seen the patch, but I'm not so sure it will work.  Suppose we
> have two devices, D1 and D2, and some other mutex, M.  Then the locking
> pattern:
>
> 	lock(D1);
> 	lock(M);
> 	unlock(M);
> 	unlock(D1);
>
> generally should not conflict with:
>
> 	lock(M);
> 	lock(D2);
> 	unlock(D2);
> 	unlock(M);

Yes, sure. This change assumes that the only problem in drivers/base is
dev->parent->mutex / dev->mutex dependency. If the locking is even more
"broken" (wrt lockdep), we can't replace lockdep_set_novalidate_class()
with lockdep_set_auto_nested().

And, otoh, with this change lockdep can miss the real problems too, for
example:

	func1(dev)
	{
		device_lock(dev->parent);
		mutex_lock(MUTEX);
		device_lock(dev);
		...
	}

	func2(dev)
	{
		device_lock(dev);
		mutex_lock(MUTEX);
		...
	}

lockdep will only notice dev -> MUTEX dependency.

I booted the kernel (under kvm) with this change and there is nothing
in dmesg, but of course this is not the real testing.

So do you think that dev->mutex should not be validated at all ?


Just in case... Of course, if we actually add auto_nested we should not
use a single class unless dev->mutex will be the only user.

Oleg.

