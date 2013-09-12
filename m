Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693Ab3ILOrT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 10:47:19 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48019 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456Ab3ILOrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 10:47:18 -0400
Date: Thu, 12 Sep 2013 16:46:58 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, lttng-dev@lists.lttng.org
Subject: Re: [RFC PATCH] timekeeping: introduce timekeeping_is_busy()
Message-ID: <20130912144658.GY31370@twins.programming.kicks-ass.net>
References: <20130911150853.GA19800@Krystal>
 <52309D13.3020305@linaro.org>
 <20130911185441.GC23532@Krystal>
 <20130911203618.GH3966@linux.vnet.ibm.com>
 <20130912004811.GA6096@Krystal>
 <20130912012531.GS31370@twins.programming.kicks-ass.net>
 <20130912032252.GA8347@Krystal>
 <20130912120916.GW31370@twins.programming.kicks-ass.net>
 <20130912134816.GA26417@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130912134816.GA26417@Krystal>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 09:48:16AM -0400, Mathieu Desnoyers wrote:

> struct foo {
> 	...
> };
> 
> spinlock_t foo_lock;
> 
> struct latchfoo {
> 	unsigned int head, tail;
> 	struct foo data[2];
> };
> 
> /**
>  * foo_write_begin - begin foo update.
>  *
>  " @lf: struct latchfoo to update.
>  * @prev: pointer to previous element (output parameter).
>  * @next: pointer to next element (output parameter).
>  *
>  * The area pointed to by "next" should be considered uninitialized.
>  * The caller needs to have exclusive update access to struct latchfoo.
>  */
> static
> void foo_write_begin(struct latchfoo *lf, const struct foo **prev,
> 		struct foo **next)
> {
> 	lf->head++;
> 	smp_wmb();
> 	*prev = &lf->data[lf->tail & 1];
> 	*next = &lf->data[lf->head & 1];
> }
> 
> /**
>  * foo_write_end - end foo update.
>  *
>  " @lf: struct latchfoo.
>  *
>  * The caller needs to have exclusive update access to struct latchfoo.
>  */
> static void
> void foo_write_end(struct latchfoo *lf)
> {
> 	smp_wmb();
> 	lf->tail++;
> }
> 
> /**
>  * foo_read_begin - begin foo read.
>  *
>  " @lf: struct latchfoo to read.
>  * @tail: pointer to unsigned int containing tail position (output).
>  */
> static
> struct foo *foo_read_begin(struct latchfoo *lf, unsigned int *tail)
> {
> 	unsigned int ret;
> 
> 	ret = ACCESS_ONCE(lf->tail);
> 	smp_rmb();
> 	*tail = ret;
> 	return &lf->data[ret & 1];
> }
> 
> /**
>  * foo_read_retry - end foo read, trigger retry if needed.
>  *
>  " @lf: struct latchfoo read.
>  * @tail: tail position returned as output by foo_read_begin().
>  *
>  * If foo_read_retry() returns nonzero, the content of the read should
>  * be considered invalid, and the read should be performed again to
>  * reattempt reading coherent data, starting with foo_read_begin().
>  */
> static
> int foo_read_retry(struct latchfoo *lf, unsigned int tail)
> {
> 	smp_rmb();
> 	return (ACCESS_ONCE(lf->head) - tail >= 2);
> }

Yep, that's good. I suppose if there's multiple use sites we can jump
through another few hoops to get rid of the specific struct foo
assumptions by storing sizeof() whatever we do use and playing pointer
math games.

But for now with the time stuff as only user this looks ok.
