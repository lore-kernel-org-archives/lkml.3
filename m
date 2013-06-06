Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756646Ab3FFBpQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 21:45:16 -0400
Received: from mail-qe0-f48.google.com ([209.85.128.48]:60182 "EHLO
	mail-qe0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756258Ab3FFBpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 21:45:14 -0400
Date: Wed, 5 Jun 2013 18:45:07 -0700
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Imre Deak <imre.deak@intel.com>, Andrew Morton <akpm@linux-foundation.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Dave Jones <davej@redhat.com>,
        David Howells <dhowells@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Lukas Czerner <lczerner@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wait: fix false timeouts when using wait_event_timeout()
Message-ID: <20130606014507.GR10693@mtj.dyndns.org>
References: <20130604192818.GA31316@redhat.com>
 <1370381717.8432.14.camel@ideak-mobl>
 <1370382051.8432.16.camel@ideak-mobl>
 <20130605163702.GA26135@redhat.com>
 <20130605190723.GA4957@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130605190723.GA4957@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Oleg.

On Wed, Jun 05, 2013 at 09:07:23PM +0200, Oleg Nesterov wrote:
> And in fact, perhaps we can implement wait_event_common() and avoid the
> code duplications?
> 
> 	#define __wait_no_timeout(timeout)	\
> 		(__builtin_constant_p(timeout) && (timeout) == MAX_SCHEDULE_TIMEOUT)
> 
> 	/* uglified signal_pending_state() */
> 	#define __wait_signal_pending(state)					\
> 		((state == TASK_INTERRUPTIBLE) ? signal_pending(current) :	\
> 		 (state == TASK_KILLABLE) ? fatal_signal_pending(current) :	\
> 		  0)
> 
> 	#define __wait_event_common(wq, condition, state, tout)			\
> 	({									\
> 		DEFINE_WAIT(__wait);						\
> 		long __ret = 0, __tout = tout;					\
> 										\
> 		for (;;) {							\
> 			prepare_to_wait(&wq, &__wait, state);			\
> 			if (condition) {					\
> 				__ret = __wait_no_timeout(tout) ?: __tout ?: 1;	\
> 				break;						\
> 			}							\
> 										\
> 			if (__wait_signal_pending(state)) {			\
> 				__ret = -ERESTARTSYS;				\
> 				break;						\
> 			}							\
> 										\
> 			if (__wait_no_timeout(tout))				\
> 				schedule();					\
> 			else if (__tout)					\
> 				__tout = schedule_timeout(__tout);		\
> 			else							\
> 				break;						\
> 		}								\
> 		finish_wait(&wq, &__wait);					\
> 		__ret;								\
> 	})

Heh, yeah, this looks good to me and a lot better than trying to do
the same thing over and over again and ending up with subtle
differences.

> Hmm. I compiled the kernel with the patch below,
> 
> 		$ size vmlinux
> 		   text	   data	    bss	    dec	    hex	filename
> 	-	4978601	2935080	10104832	18018513	112f0d1	vmlinux
> 	+	4977769	2930984	10104832	18013585	112dd91	vmlinux

Nice.  Provided you went over assembly outputs of at least some
combinations, please feel free to add

 Reviewed-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
