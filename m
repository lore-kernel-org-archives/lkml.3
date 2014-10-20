Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368AbaJTJNW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 05:13:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:44135 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815AbaJTJNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 05:13:18 -0400
Date: Mon, 20 Oct 2014 11:13:11 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Kirill Tkhai <tkhai@yandex.ru>, Kirill Tkhai <ktkhai@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Vladimir Davydov <vdavydov@parallels.com>
Subject: Re: [PATCH] sched/numa: fix unsafe get_task_struct() in
 task_numa_assign()
Message-ID: <20141020091311.GC3219@twins.programming.kicks-ass.net>
References: <1413376300.24793.55.camel@tkhai>
 <20141017213641.GB32576@redhat.com>
 <4323181413620101@web21o.yandex.ru>
 <20141018205614.GA15934@redhat.com>
 <33631413674011@web7o.yandex.ru>
 <20141019192437.GA842@redhat.com>
 <20141019193744.GA3097@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141019193744.GA3097@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


OK, I think I'm finally awake enough to see what you're all talking
about :-)

On Sun, Oct 19, 2014 at 09:37:44PM +0200, Oleg Nesterov wrote:
> > > RT tree has:
> > >
> > > https://git.kernel.org/cgit/linux/kernel/git/paulg/3.10-rt-patches.git/
> > > tree/patches/sched-delay-put-task.patch

(answering the other email asking about this)

RT does this because we call put_task_struct() with preempt disabled and
on RT the memory allocator has sleeping locks.

> > Yes, and this obviously implies more rcu callbacks in flight, and another
> > gp before __put_task_struct(). but may be we will need to do this anyway...
> 
> Forgot to mention... Or we can make task_struct_cachep SLAB_DESTROY_BY_RCU,
> in this case ->curr (or any other "task_struct *" ponter) can not go away
> under rcu_read_lock(). task_numa_compare() still needs the PF_EXITING check,
> but we do not need to recheck ->curr or probe_kernel_read().

I think I would prefer SLAB_DESTROY_BY_RCU for this, because as you
pointed out, I'm not sure mainline would like the extra callbacks.
