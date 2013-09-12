Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788Ab3ILBZv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 21:25:51 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33289 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418Ab3ILBZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 21:25:50 -0400
Date: Thu, 12 Sep 2013 03:25:31 +0200
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
Message-ID: <20130912012531.GS31370@twins.programming.kicks-ass.net>
References: <20130911150853.GA19800@Krystal>
 <52309D13.3020305@linaro.org>
 <20130911185441.GC23532@Krystal>
 <20130911203618.GH3966@linux.vnet.ibm.com>
 <20130912004811.GA6096@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130912004811.GA6096@Krystal>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 08:48:11PM -0400, Mathieu Desnoyers wrote:
> Thoughts ?


struct foo {
	...
};

spinlock_t foo_lock;
unsigned int foo_head = 0;
unsigned int foo_tail = 0;
struct foo foo_array[2];

void foo_assign(struct foo f)
{
	spin_lock(&foo_lock);
	foo_head++;
	smp_wmb();
	foo_array[foo_head & 1] = f;
	smp_wmb();
	foo_tail++;
	spin_unlock(&foo_lock);
}

struct foo foo_get(void)
{
	unsigned int tail, head;
	struct foo ret;

again:
	tail = ACCESS_ONCE(foo_tail);
	smp_rmb();
	ret = foo_array[tail & 1];
	smp_rmb();
	head = ACCESS_ONCE(foo_head);
	if (head - tail >= 2)
		goto again;

	return ret;
}

Should work and get you the most recent 'complete' foo even when
foo_get() is called nested inside foo_assign().



