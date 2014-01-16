Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998AbaAPU0J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 15:26:09 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:35318 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751449AbaAPU0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 15:26:05 -0500
Date: Thu, 16 Jan 2014 15:26:03 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Peter Zijlstra <peterz@infradead.org>
cc: Oleg Nesterov <oleg@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: check && lockdep_no_validate (Was: lockdep: Introduce wait-type
 checks)
In-Reply-To: <20140116180944.GC9655@laptop.programming.kicks-ass.net>
Message-ID: <Pine.LNX.4.44L0.1401161515190.1109-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jan 2014, Peter Zijlstra wrote:

> On Thu, Jan 16, 2014 at 06:43:48PM +0100, Oleg Nesterov wrote:
> > But with or without this change the following code
> > 
> > 		static DEFINE_MUTEX(m1);
> > 		static DEFINE_MUTEX(mx);
> > 
> > 		lockdep_set_novalidate_class(&mx);
> > 
> > 		// m1 -> mx
> > 		mutex_lock(&m1);
> > 		mutex_lock(&mx);
> > 		mutex_unlock(&mx);
> > 		mutex_unlock(&m1);
> > 
> > 		// mx -> m1 ; should trigger the warning ???
> > 		mutex_lock(&mx);
> > 		mutex_lock(&m1);
> > 		mutex_unlock(&m1);
> > 		mutex_unlock(&mx);
> > 
> > doesn't trigger the warning too. This is correct because
> > lockdep_set_novalidate_class() means, well, no-validate.
> > The question is: do we really want to avoid all validations?
> 
> Good question.
> 
> > Why lockdep_set_novalidate_class() was added? Unlees I missed
> > something the problem is that (say) __driver_attach() can take
> > the "same" lock twice, drivers/base/ lacks annotations.
> 
> Indeed, the driver model locking always slips my mind but yes its
> creative. Alan Stern seems to have a good grasp on it though.

Mostly my "grasp" is just a firm belief that trying to manage locking
throughout the entire driver tree is hopeless.  Individual sub-portions
of it are usually well behaved, but the thing as a whole is a mess.

> > Perhaps we should change the meaning of lockdep_set_novalidate_class?
> > (perhaps with rename). What do you think about the patch below?
> > 
> > With this patch __lockdep_no_validate__ means "automatically nested",
> 
> Yes, I suppose that might work, it would allow some validation.

I haven't seen the patch, but I'm not so sure it will work.  Suppose we
have two devices, D1 and D2, and some other mutex, M.  Then the locking
pattern:

	lock(D1);
	lock(M);
	unlock(M);
	unlock(D1);

generally should not conflict with:

	lock(M);
	lock(D2);
	unlock(D2);
	unlock(M);

even though D1's and D2's locks belong to the same class.  For example,
M might be a mutex embedded in the private data associated with D1, and
D2 might be a child of D1.

Alan Stern

