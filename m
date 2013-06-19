Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757145Ab3FSQUi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 12:20:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32050 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756845Ab3FSQUh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 12:20:37 -0400
Date: Wed, 19 Jun 2013 18:14:56 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Samuel Ortiz <samuel@sortiz.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, Dave Jones <davej@redhat.com>,
        David Howells <dhowells@redhat.com>, Imre Deak <imre.deak@intel.com>,
        Jens Axboe <axboe@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Lukas Czerner <lczerner@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] wait: introduce wait_event_common(wq, condition,
	state, timeout)
Message-ID: <20130619161456.GC9176@redhat.com>
References: <20130606200257.GA23628@redhat.com> <20130606200316.GB23628@redhat.com> <20130618150656.3266771d49f68f86fdb5e3f3@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130618150656.3266771d49f68f86fdb5e3f3@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18, Andrew Morton wrote:
>
> On Thu, 6 Jun 2013 22:03:16 +0200 Oleg Nesterov <oleg@redhat.com> wrote:
> > -#define __wait_event_interruptible(wq, condition, ret)
> > +#define __wait_event_interruptible(wq, condition)
>
> net/irda/af_irda.c:2568:13: error: macro "__wait_event_interruptible" passed 3 arguments, but takes just 2

Aaah. Thanks.

> waddup with that?

Will read "man grep" again.

> __wait_event_interruptible() has several callsites.  I think I'll go
> zap and await v2 ;)

Yes, will do, thanks.

And note that one of the reasons for this patch was to make
wait_event_interruptible() and __wait_event_interruptible()
interchangeable, like wait_event() and __wait_event().
irda_getsockopt() uses __wait* exactly because it has already
checked the condition.



Samuel, will you agree with the patch below?

Yes, this adds the unnecessary check. We will remove it later,
after we change wait_event* macros, just

	- err = wait_event_interruptible(...);
	+ err = __wait_event_interruptible(...);

Otherwise, this patch should also change af_irda.c (and probably
other callers), not good.

Oleg.

--- x/net/irda/af_irda.c
+++ x/net/irda/af_irda.c
@@ -2563,9 +2563,8 @@ bed:
 				  jiffies + msecs_to_jiffies(val));
 
 			/* Wait for IR-LMP to call us back */
-			__wait_event_interruptible(self->query_wait,
-			      (self->cachedaddr != 0 || self->errno == -ETIME),
-						   err);
+			err = wait_event_interruptible(self->query_wait,
+			      (self->cachedaddr != 0 || self->errno == -ETIME));
 
 			/* If watchdog is still activated, kill it! */
 			del_timer(&(self->watchdog));

