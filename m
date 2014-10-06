Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875AbaJFQYh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 12:24:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57451 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751343AbaJFQYf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 12:24:35 -0400
Date: Mon, 6 Oct 2014 18:21:09 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>, Jet Chen <jet.chen@intel.com>,
        Su Tao <tao.su@intel.com>, Yuanhan Liu <yuanhan.liu@intel.com>,
        LKP <lkp@01.org>, linux-kernel@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Peter Hurley <peter@hurleysoftware.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [rfcomm_run] WARNING: CPU: 1 PID: 79 at
	kernel/sched/core.c:7156 __might_sleep()
Message-ID: <20141006162109.GA29890@redhat.com>
References: <20141002110927.GE2849@worktop.programming.kicks-ass.net> <20141002123150.GC6324@worktop.programming.kicks-ass.net> <20141002124247.GD6324@worktop.programming.kicks-ass.net> <20141002201020.GA8907@redhat.com> <20141003115020.GG10583@worktop.programming.kicks-ass.net> <20141003175654.GA14952@redhat.com> <20141003193029.GA24399@redhat.com> <20141004084241.GT10583@worktop.programming.kicks-ass.net> <20141006002509.GA23955@redhat.com> <20141006091915.GC6758@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141006091915.GC6758@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06, Peter Zijlstra wrote:
>
> On Mon, Oct 06, 2014 at 02:25:09AM +0200, Oleg Nesterov wrote:
> >
> > Hmm. I specially checked Documentation/memory-barriers.txt,
> >
> >  (*) smp_mb__before_atomic();
> >  (*) smp_mb__after_atomic();
> >
> >      These are for use with atomic (such as add, subtract, increment and
> >      decrement) functions that don't return a value, especially when used for
> >      reference counting.  These functions do not imply memory barriers.
> >
> >      These are also used for atomic bitop functions that do not return a
> >      value (such as set_bit and clear_bit).
> >                     ^^^^^^^^^^^^^^^^^^^^^
> >
> > Either you or memory-barriers.txt should be fixed ;)

Heh.

> Its in there, just not explicitly. All those functions listed are
> read-modify-write ops, test_bit() is not, its just a read.

OOPS! I was hypnotized by "_bit" suffix, I guess.

Of course, of course, test_bit() must be a plain LOAD in any case, can't
understand what I was thinking about.

So in this particular case kthread_kill() needs smp_mb__AFTER_atomic(),
and "after" applies to set_bit(KTHREAD_SHOULD_STOP).

> --- a/Documentation/memory-barriers.txt
> +++ b/Documentation/memory-barriers.txt
> @@ -1594,12 +1594,9 @@ CPU from reordering them.
>   (*) smp_mb__before_atomic();
>   (*) smp_mb__after_atomic();
>
> -     These are for use with atomic (such as add, subtract, increment and
> -     decrement) functions that don't return a value, especially when used for
> -     reference counting.  These functions do not imply memory barriers.
> -
> -     These are also used for atomic bitop functions that do not return a
> -     value (such as set_bit and clear_bit).
> +     These are for use with atomic/bitop (r-m-w) functions that don't return
> +     a value (eg. atomic_{add,sub,inc,dec}(), {set,clear}_bit()). These
> +     functions do not imply memory barriers.

Thanks!

Oleg.

