Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352AbaJTVFf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 17:05:35 -0400
Received: from forward10l.mail.yandex.net ([84.201.143.143]:33407 "EHLO
	forward10l.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752835AbaJTVFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 17:05:34 -0400
X-Yandex-Uniq: b4604cd8-83fb-4117-b02c-d2fc520eb08c
Authentication-Results: smtp2h.mail.yandex.net; dkim=pass header.i=@yandex.ru
Message-ID: <54457918.8090006@yandex.ru>
Date: Tue, 21 Oct 2014 01:05:28 +0400
From: Kirill Tkhai <tkhai@yandex.ru>
Reply-To: tkhai@yandex.ru
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Kirill Tkhai <ktkhai@parallels.com>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Vladimir Davydov <vdavydov@parallels.com>
Subject: Re: [PATCH v3] sched/numa: fix unsafe get_task_struct() in task_numa_assign()
References: <1413800145.19914.23.camel@tkhai> <20141020144757.GA10939@redhat.com> <20141020165614.GA16373@redhat.com> <20141020182748.GA20424@redhat.com> <54456E26.2000103@yandex.ru> <20141020205006.GA2500@redhat.com>
In-Reply-To: <20141020205006.GA2500@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.10.2014 00:50, Oleg Nesterov wrote:
> On 10/21, Kirill Tkhai wrote:
>>
>> I think generic helper is a good idea. The prototype looks OK.
>>
>> But I'm a little doubt about retry loop. If this helper is generic and
>> one day it may move to ./include directory,
> 
> Well, if we add a generic helper I think it should be exported even if
> it has a single caller. But I agree this probably needs a justification
> too.
> 
>> isn't there a probability
>> people will use it wrong? This loop may bring delays or something bad.
> 
> Yes, I thought about livelock too. OK, we can remove it, just
> s/goto retry/return NULL/. Or, perhaps better, return ERR_PTR(-EAGAIN)
> so that the caller can know that retry is possible.
> 
> I do not really mind, and we can reconsider this later. And I will not
> argue if you prefer to add the rq->curr specific hack (like your patch
> does).
> 
>> And since we still depends on RCU, I'd suggest to add its lockdep assert.
> 
> Agreed.
> 
> Let me explain what I personally dislike in v3:
> 
> 	- I think that we do not have enough reasons for
> 	  SLAB_DESTROY_BY_RCU. This is the serious change.
> 
> 	  probe_kernel_read() looks better to me, and hopefully
> 	  IS_ENABLED(DEBUG_PAGEALLOC) can make it conditional.
> 
> 	- PF_EXITING was fine in task_numa_compare(), but if we
> 	  move this logic into a helper (even if it is not exported)
> 	  then I think we need a more specific check. sighand == NULL
> 	  looks better to me because it clearly connects to
> 	  release_task() which makes this task_struct "rcu-unsafe".
> 
> 	- Again, perhaps we should start we a simple and stupid fix.
> 	  We can do get_task_struct() under rq->lock or, if nothing
> 	  else, just
> 
> 	  	raw_spin_lock_irq(&rq->lock);
> 	  	cur = rq->curr;
> 	  	if (is_idle_task(cur) || (cur->flags & PF_EXITING))
> 	  		cur = NULL;
> 	  	raw_spin_unlock_irq(&rq->lock);
> 
> Either way, I hope you will send v4 ;)

No, I won't send. Please do this. Your idea and your patch is almost
ready. Thanks :)

> But probably you should wait for for Peter's opinion first.

Yeah.

Kirill
