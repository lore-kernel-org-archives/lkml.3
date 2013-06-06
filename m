Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266Ab3FFUH7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 16:07:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17069 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753212Ab3FFUH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 16:07:57 -0400
Date: Thu, 6 Jun 2013 22:02:57 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Dave Jones <davej@redhat.com>,
        David Howells <dhowells@redhat.com>, Imre Deak <imre.deak@intel.com>,
        Jens Axboe <axboe@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Lukas Czerner <lczerner@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] introduce wait_event_common()
Message-ID: <20130606200257.GA23628@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

To remind, I think that 4c663cfc "wait: fix false timeouts when using
wait_event_timeout()" is not enough, wait(wq, true, 0) still returns
zero.

But to me the main problem is that wait_event* macros duplicate the
same code again and again. Imho it would be nice to create a single
helper. To simplify the review, this is the code after 1/2:

	#define __wait_no_timeout(tout)	\
		(__builtin_constant_p(tout) && (tout) == MAX_SCHEDULE_TIMEOUT)

	/* uglified signal_pending_state() optimized for constant state */
	#define __wait_signal_pending(state)					\
		((state == TASK_INTERRUPTIBLE) ? signal_pending(current) :	\
		 (state == TASK_KILLABLE) ? fatal_signal_pending(current) :	\
		  0)

	#define __wait_event_common(wq, condition, state, tout)			\
	({									\
		DEFINE_WAIT(__wait);						\
		long __ret = 0, __tout = tout;					\
										\
		for (;;) {							\
			prepare_to_wait(&wq, &__wait, state);			\
			if (condition) {					\
				__ret = __wait_no_timeout(tout) ?: __tout ?: 1;	\
				break;						\
			}							\
										\
			if (__wait_signal_pending(state)) {			\
				__ret = -ERESTARTSYS;				\
				break;						\
			}							\
										\
			if (__wait_no_timeout(tout))				\
				schedule();					\
			else if (__tout)					\
				__tout = schedule_timeout(__tout);		\
			else							\
				break;						\
		}								\
		finish_wait(&wq, &__wait);					\
		__ret;								\
	})

	#define wait_event_common(wq, condition, state, tout)			\
	({									\
		long __ret;							\
		if (condition)							\
			__ret = __wait_no_timeout(tout) ?: (tout) ?: 1;		\
		else								\
			__ret = __wait_event_common(wq, condition, state, tout);\
		__ret;								\
	})

2/2 doesn't look like a cleanup. But personally I think that it makes
sense to shrink .text,

	-	4977769 2930984 10104832        18013585        112dd91 vmlinux
	+	4976847	2930984	10104832	18012663	112d9f7	vmlinux

on my build.

Please comment.

Oleg.

