Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756659Ab3FEQlG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 12:41:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65345 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755761Ab3FEQlE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 12:41:04 -0400
Date: Wed, 5 Jun 2013 18:37:02 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Imre Deak <imre.deak@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Dave Jones <davej@redhat.com>,
        David Howells <dhowells@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Lukas Czerner <lczerner@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wait: fix false timeouts when using
	wait_event_timeout()
Message-ID: <20130605163702.GA26135@redhat.com>
References: <20130604192818.GA31316@redhat.com> <1370381717.8432.14.camel@ideak-mobl> <1370382051.8432.16.camel@ideak-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370382051.8432.16.camel@ideak-mobl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05, Imre Deak wrote:
>
> On Wed, 2013-06-05 at 00:35 +0300, Imre Deak wrote:
> > On Tue, 2013-06-04 at 21:28 +0200, Oleg Nesterov wrote:
> > >
> > > Shouldn't we also change wait_event_timeout() ? Say,
> > >
> > > 	#define wait_event_timeout(wq, condition, timeout)			\
> > > 	({									\
> > > 		long __ret = timeout;						\
> > > 		if (!(condition))						\
> > > 			__wait_event_timeout(wq, condition, __ret);		\
> > > 		else if (!__ret)						\
> > > 			__ret = 1;						\
> > > 		__ret;								\
> > > 	})
> > >
> > > Or wait_event_timeout(timeout => 0) is not legal in a non-void context?
> > >
> > > To me the code like
> > >
> > > 	long wait_for_something(bool nonblock)
> > > 	{
> > > 		timeout = nonblock ? 0 : DEFAULT_TIMEOUT;
> > > 		return wait_event_timeout(..., timeout);
> > > 	}
> > >
> > > looks reasonable and correct. But it is not?
> >
> > I don't see why it would be not legal. Note though that in the above
> > form wait_event_timeout(cond, 0) would still schedule() if cond is
> > false, which is not what I'd expect from a non-blocking function.

Yes, if false. But what if it is true?

> Ah sorry, if you also rewrite __wait_event_timeout() then timeout=>0
> wouldn't schedule(), so things would work as expected.

Can't understand... probably you missed my point. Let me try again.

I think that wait_eveint_timeout(wq, COND, 0) should return !!(COND).
But it doesn't, for example wait_event_timeout(wq, true, 0) == 0, this
doesn'tlook right to me.

And, this is off-topic, but wait_eveint_timeout/__wait_eveint_timeout
do not match wait_event/__wait_event. IOW, you can't use
__wait_eveint_timeout() if you do not need the fast-path check.

So. How about

	#define __wait_event_timeout(wq, condition, timeout)			\
	({									\
		DEFINE_WAIT(__wait);						\
		long __ret = 0, __to = timeout;					\
										\
		for (;;) {							\
			prepare_to_wait(&wq, &__wait, TASK_UNINTERRUPTIBLE);	\
			if (condition) {					\
				__ret = __to ?: 1;				\
				break;						\
			}							\
			if (!__to)						\
				break;						\
			__to = schedule_timeout(__to);				\
		}								\
		finish_wait(&wq, &__wait);					\
		__ret;								\
	})

	#define wait_event_timeout(wq, condition, timeout)			\
	({									\
		long __ret;							\
		if (condition)							\
			__ret = (timeout) ?: 1;					\
		else								\
			__ret = __wait_event_timeout(wq, condition, timeout);	\
		__ret;								\
	})

?

Othwerwise we should document the fact that the caller should alvays verify
timeout != 0 if it checks the result of wait_event_timeout().

