Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751450Ab3FDVlV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 17:41:21 -0400
Received: from mga02.intel.com ([134.134.136.20]:59003 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751186Ab3FDVlT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 17:41:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,802,1363158000"; 
   d="scan'208";a="348153887"
Message-ID: <1370382051.8432.16.camel@ideak-mobl>
Subject: Re: [PATCH] wait: fix false timeouts when using wait_event_timeout()
From: Imre Deak <imre.deak@intel.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Dave Jones <davej@redhat.com>,
        David Howells <dhowells@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Lukas Czerner <lczerner@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Date: Wed, 05 Jun 2013 00:40:51 +0300
In-Reply-To: <1370381717.8432.14.camel@ideak-mobl>
References: <20130604192818.GA31316@redhat.com>
	 <1370381717.8432.14.camel@ideak-mobl>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-05 at 00:35 +0300, Imre Deak wrote:
> On Tue, 2013-06-04 at 21:28 +0200, Oleg Nesterov wrote:
> > Hello,
> > 
> > Just noticed this commit...
> > 
> > commit 4c663cfc523a88d97a8309b04a089c27dc57fd7e
> > Author: Imre Deak <imre.deak@intel.com>
> > Date:   Fri May 24 15:55:09 2013 -0700
> > 
> >     Many callers of the wait_event_timeout() and
> >     wait_event_interruptible_timeout() expect that the return value will be
> >     positive if the specified condition becomes true before the timeout
> >     elapses.  However, at the moment this isn't guaranteed.  If the wake-up
> >     handler is delayed enough, the time remaining until timeout will be
> >     calculated as 0 - and passed back as a return value - even if the
> >     condition became true before the timeout has passed.
> > 
> > OK, agreed.
> > 
> > 	--- a/include/linux/wait.h
> > 	+++ b/include/linux/wait.h
> > 	@@ -217,6 +217,8 @@ do {						\
> > 			if (!ret)						\
> > 				break;						\
> > 		}								\
> > 	+	if (!ret && (condition))					\
> > 	+		ret = 1;						\
> > 		finish_wait(&wq, &__wait);					\
> > 	 } while (0)
> > 
> > Well, this evaluates "condition" twice, perhaps it would be more
> > clean to do, say,
> > 
> > 	#define __wait_event_timeout(wq, condition, ret)			\
> > 	do {									\
> > 		DEFINE_WAIT(__wait);						\
> > 										\
> > 		for (;;) {							\
> > 			prepare_to_wait(&wq, &__wait, TASK_UNINTERRUPTIBLE);	\
> > 			if (condition) {					\
> > 				if (!ret)					\
> > 					ret = 1;				\
> > 				break;						\
> > 			} else if (!ret)					\
> > 				break;						\
> > 			ret = schedule_timeout(ret);				\
> > 		}								\
> > 		finish_wait(&wq, &__wait);					\
> > 	} while (0)
> > 
> > but this is minor.
> > 
> > 	@@ -233,8 +235,9 @@ do {						\
> > 	  * wake_up() has to be called after changing any variable that could
> > 	  * change the result of the wait condition.
> > 	  *
> > 	- * The function returns 0 if the @timeout elapsed, and the remaining
> > 	- * jiffies if the condition evaluated to true before the timeout elapsed.
> > 	+ * The function returns 0 if the @timeout elapsed, or the remaining
> > 	+ * jiffies (at least 1) if the @condition evaluated to %true before
> > 	+ * the @timeout elapsed.
> > 
> > This is still not true if timeout == 0.
> > 
> > Shouldn't we also change wait_event_timeout() ? Say,
> > 
> > 	#define wait_event_timeout(wq, condition, timeout)			\
> > 	({									\
> > 		long __ret = timeout;						\
> > 		if (!(condition))						\
> > 			__wait_event_timeout(wq, condition, __ret);		\
> > 		else if (!__ret)						\
> > 			__ret = 1;						\
> > 		__ret;								\
> > 	})
> > 
> > Or wait_event_timeout(timeout => 0) is not legal in a non-void context?
> > 
> > To me the code like
> > 
> > 	long wait_for_something(bool nonblock)
> > 	{
> > 		timeout = nonblock ? 0 : DEFAULT_TIMEOUT;
> > 		return wait_event_timeout(..., timeout);
> > 	}
> > 
> > looks reasonable and correct. But it is not?
> 
> I don't see why it would be not legal. Note though that in the above
> form wait_event_timeout(cond, 0) would still schedule() if cond is
> false, which is not what I'd expect from a non-blocking function.

Ah sorry, if you also rewrite __wait_event_timeout() then timeout=>0
wouldn't schedule(), so things would work as expected.

--Imre


