Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751761Ab3FDTcg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 15:32:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16879 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929Ab3FDTce (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 15:32:34 -0400
Date: Tue, 4 Jun 2013 21:28:18 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Dave Jones <davej@redhat.com>,
        David Howells <dhowells@redhat.com>, Imre Deak <imre.deak@intel.com>,
        Jens Axboe <axboe@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Lukas Czerner <lczerner@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wait: fix false timeouts when using
	wait_event_timeout()
Message-ID: <20130604192818.GA31316@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Just noticed this commit...

commit 4c663cfc523a88d97a8309b04a089c27dc57fd7e
Author: Imre Deak <imre.deak@intel.com>
Date:   Fri May 24 15:55:09 2013 -0700

    Many callers of the wait_event_timeout() and
    wait_event_interruptible_timeout() expect that the return value will be
    positive if the specified condition becomes true before the timeout
    elapses.  However, at the moment this isn't guaranteed.  If the wake-up
    handler is delayed enough, the time remaining until timeout will be
    calculated as 0 - and passed back as a return value - even if the
    condition became true before the timeout has passed.

OK, agreed.

	--- a/include/linux/wait.h
	+++ b/include/linux/wait.h
	@@ -217,6 +217,8 @@ do {						\
			if (!ret)						\
				break;						\
		}								\
	+	if (!ret && (condition))					\
	+		ret = 1;						\
		finish_wait(&wq, &__wait);					\
	 } while (0)

Well, this evaluates "condition" twice, perhaps it would be more
clean to do, say,

	#define __wait_event_timeout(wq, condition, ret)			\
	do {									\
		DEFINE_WAIT(__wait);						\
										\
		for (;;) {							\
			prepare_to_wait(&wq, &__wait, TASK_UNINTERRUPTIBLE);	\
			if (condition) {					\
				if (!ret)					\
					ret = 1;				\
				break;						\
			} else if (!ret)					\
				break;						\
			ret = schedule_timeout(ret);				\
		}								\
		finish_wait(&wq, &__wait);					\
	} while (0)

but this is minor.

	@@ -233,8 +235,9 @@ do {						\
	  * wake_up() has to be called after changing any variable that could
	  * change the result of the wait condition.
	  *
	- * The function returns 0 if the @timeout elapsed, and the remaining
	- * jiffies if the condition evaluated to true before the timeout elapsed.
	+ * The function returns 0 if the @timeout elapsed, or the remaining
	+ * jiffies (at least 1) if the @condition evaluated to %true before
	+ * the @timeout elapsed.

This is still not true if timeout == 0.

Shouldn't we also change wait_event_timeout() ? Say,

	#define wait_event_timeout(wq, condition, timeout)			\
	({									\
		long __ret = timeout;						\
		if (!(condition))						\
			__wait_event_timeout(wq, condition, __ret);		\
		else if (!__ret)						\
			__ret = 1;						\
		__ret;								\
	})

Or wait_event_timeout(timeout => 0) is not legal in a non-void context?

To me the code like

	long wait_for_something(bool nonblock)
	{
		timeout = nonblock ? 0 : DEFAULT_TIMEOUT;
		return wait_event_timeout(..., timeout);
	}

looks reasonable and correct. But it is not?

Oleg.

