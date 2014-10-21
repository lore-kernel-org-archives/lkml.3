Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518AbaJUJqE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 05:46:04 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:48080 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbaJUJqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 05:46:02 -0400
Date: Tue, 21 Oct 2014 11:45:58 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Kirill Tkhai <tkhai@yandex.ru>, Kirill Tkhai <ktkhai@parallels.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Vladimir Davydov <vdavydov@parallels.com>
Subject: Re: [PATCH v3] sched/numa: fix unsafe get_task_struct() in
 task_numa_assign()
Message-ID: <20141021094558.GQ23531@worktop.programming.kicks-ass.net>
References: <1413800145.19914.23.camel@tkhai>
 <20141020144757.GA10939@redhat.com>
 <20141020165614.GA16373@redhat.com>
 <20141020182748.GA20424@redhat.com>
 <54456E26.2000103@yandex.ru>
 <20141020205006.GA2500@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141020205006.GA2500@redhat.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2014 at 10:50:06PM +0200, Oleg Nesterov wrote:
> Let me explain what I personally dislike in v3:
> 
> 	- I think that we do not have enough reasons for
> 	  SLAB_DESTROY_BY_RCU. This is the serious change.

What exactly would the downsides be? SDBR has very limited space
overhead iirc.

> 	- Again, perhaps we should start we a simple and stupid fix.
> 	  We can do get_task_struct() under rq->lock or, if nothing
> 	  else, just
> 
> 	  	raw_spin_lock_irq(&rq->lock);
> 	  	cur = rq->curr;
> 	  	if (is_idle_task(cur) || (cur->flags & PF_EXITING))
> 	  		cur = NULL;
> 	  	raw_spin_unlock_irq(&rq->lock);

I think I agree with you, this is the simple safe option and is
something we can easily backport. After that we can add creative bits on
top.

I think I prefer the SLAB_DESTROY_BY_RCU thing over the probe_kernel
thing -- but we can take our time once we've fixed the immediate issue
with the simple option.
