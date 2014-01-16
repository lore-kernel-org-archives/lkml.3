Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751272AbaAPSJ7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 13:09:59 -0500
Received: from merlin.infradead.org ([205.233.59.134]:44118 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbaAPSJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 13:09:57 -0500
Date: Thu, 16 Jan 2014 19:09:44 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: check && lockdep_no_validate (Was: lockdep: Introduce wait-type
 checks)
Message-ID: <20140116180944.GC9655@laptop.programming.kicks-ass.net>
References: <20140109111516.GE7572@laptop.programming.kicks-ass.net>
 <20140109163120.GA8038@redhat.com>
 <20140109170823.GF7572@laptop.programming.kicks-ass.net>
 <20140109175448.GA17673@redhat.com>
 <20140112205814.GP7572@laptop.programming.kicks-ass.net>
 <20140113160705.GA7616@redhat.com>
 <20140116174348.GA17614@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140116174348.GA17614@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 16, 2014 at 06:43:48PM +0100, Oleg Nesterov wrote:
> But with or without this change the following code
> 
> 		static DEFINE_MUTEX(m1);
> 		static DEFINE_MUTEX(mx);
> 
> 		lockdep_set_novalidate_class(&mx);
> 
> 		// m1 -> mx
> 		mutex_lock(&m1);
> 		mutex_lock(&mx);
> 		mutex_unlock(&mx);
> 		mutex_unlock(&m1);
> 
> 		// mx -> m1 ; should trigger the warning ???
> 		mutex_lock(&mx);
> 		mutex_lock(&m1);
> 		mutex_unlock(&m1);
> 		mutex_unlock(&mx);
> 
> doesn't trigger the warning too. This is correct because
> lockdep_set_novalidate_class() means, well, no-validate.
> The question is: do we really want to avoid all validations?

Good question.

> Why lockdep_set_novalidate_class() was added? Unlees I missed
> something the problem is that (say) __driver_attach() can take
> the "same" lock twice, drivers/base/ lacks annotations.

Indeed, the driver model locking always slips my mind but yes its
creative. Alan Stern seems to have a good grasp on it though.

> Perhaps we should change the meaning of lockdep_set_novalidate_class?
> (perhaps with rename). What do you think about the patch below?
> 
> With this patch __lockdep_no_validate__ means "automatically nested",

Yes, I suppose that might work, it would allow some validation.

> although I have to remind I can hardly understand the code I am
> trying to change ;)

You don't seem to be doing too badly ;-)
