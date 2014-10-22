Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893AbaJVJKK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 05:10:10 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:58124 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754354AbaJVJKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 05:10:01 -0400
Date: Wed, 22 Oct 2014 11:09:54 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Kirill Tkhai <tkhai@yandex.ru>, Kirill Tkhai <ktkhai@parallels.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Vladimir Davydov <vdavydov@parallels.com>, cl@linux.com
Subject: Re: [PATCH v3] sched/numa: fix unsafe get_task_struct() in
 task_numa_assign()
Message-ID: <20141022090954.GF12706@worktop.programming.kicks-ass.net>
References: <1413800145.19914.23.camel@tkhai>
 <20141020144757.GA10939@redhat.com>
 <20141020165614.GA16373@redhat.com>
 <20141020182748.GA20424@redhat.com>
 <54456E26.2000103@yandex.ru>
 <20141020205006.GA2500@redhat.com>
 <20141021094558.GQ23531@worktop.programming.kicks-ass.net>
 <20141021190335.GA12851@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141021190335.GA12851@redhat.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 09:03:35PM +0200, Oleg Nesterov wrote:
> > I think I prefer the SLAB_DESTROY_BY_RCU thing over the probe_kernel
> > thing
> 
> I won't really insist, but let me try to explain why I dislike it in
> this particular case.
> 
> - It is not clear who else (except task_numa_compare) will need it.
>   And it looks at bit strange to make task_struct SLAB_DESTROY_BY_RCU
>   just to read a word in task_numa_compare().
> 
> - In some sense, the usage of SDBR looks simply "wrong" in this case.
>   IOW, I agree that probe_kernel_read() is ugly, but in this case
>   SDBR acts exactly the same way as probe_kernel_read().
> 
>   SDBR does not make the object rcu-safe, it only protects the object
>   type plus ensures that this memory can't go away. It was designed
>   for the case when you read the stable members initialized in ctor
>   (usually a lock) and verify/lock the object.
> 
>   But in this case we can not detect that the object is still alive
>   without the additional trick, so when you read ->sighand or ->flags,
>   the fact that this memory is still "struct task_struct" doesn't help
>   and doesn't matter at all. Only the subsequent "task == rq->curr"
>   check proves that yes, this is task_struct.
> 
>   OTOH, (afaics) we only need probe_kernel_read() if CONFIG_DEBUG_SLAB.
>   And in fact I think that "read the valid but potentially freed kernel
>   pointer" deserves another helper, it can have more users. For example,
>   please look at get_freepointer_safe().
> 
>   What if we add get_kernel(x, ptr) macro to factor out the IS_ENABLED()
>   of ifdef hack? Or inline function... This way the new xxx() helper we
>   discussed won't look that bad.
> 
> But again, I agree that this subjective, I won't really argue.

So I worry about cache aliasing (not an issue on x86), so by touching
'random' pages that might be freed and reissued to back userspace, we
could be accessing the one page through multiple virtual mappings which
therefore result in aliases.

SDBR avoids this issue by guaranteeing the page is not reissued for
another purpose.

I'm not sure I can convince myself SLUB is correct here. How do we avoid
cache aliasing.
