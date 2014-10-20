Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604AbaJTKgT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 06:36:19 -0400
Received: from relay.parallels.com ([195.214.232.42]:52320 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495AbaJTKgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 06:36:16 -0400
Message-ID: <1413801373.19914.28.camel@tkhai>
Subject: Re: [PATCH] sched/numa: fix unsafe get_task_struct() in
 task_numa_assign()
From: Kirill Tkhai <ktkhai@parallels.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Oleg Nesterov <oleg@redhat.com>, Kirill Tkhai <tkhai@yandex.ru>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        "Vladimir Davydov" <vdavydov@parallels.com>
Date: Mon, 20 Oct 2014 14:36:13 +0400
In-Reply-To: <20141020091311.GC3219@twins.programming.kicks-ass.net>
References: <1413376300.24793.55.camel@tkhai>
	 <20141017213641.GB32576@redhat.com> <4323181413620101@web21o.yandex.ru>
	 <20141018205614.GA15934@redhat.com> <33631413674011@web7o.yandex.ru>
	 <20141019192437.GA842@redhat.com> <20141019193744.GA3097@redhat.com>
	 <20141020091311.GC3219@twins.programming.kicks-ass.net>
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

В Пн, 20/10/2014 в 11:13 +0200, Peter Zijlstra пишет:
> OK, I think I'm finally awake enough to see what you're all talking
> about :-)
> 
> On Sun, Oct 19, 2014 at 09:37:44PM +0200, Oleg Nesterov wrote:
> > > > RT tree has:
> > > >
> > > > https://git.kernel.org/cgit/linux/kernel/git/paulg/3.10-rt-patches.git/
> > > > tree/patches/sched-delay-put-task.patch
> 
> (answering the other email asking about this)
> 
> RT does this because we call put_task_struct() with preempt disabled and
> on RT the memory allocator has sleeping locks.

Now it's clearly for me. I though it's because task_struct freeing is slow.
Thanks!

> > > Yes, and this obviously implies more rcu callbacks in flight, and another
> > > gp before __put_task_struct(). but may be we will need to do this anyway...
> > 
> > Forgot to mention... Or we can make task_struct_cachep SLAB_DESTROY_BY_RCU,
> > in this case ->curr (or any other "task_struct *" ponter) can not go away
> > under rcu_read_lock(). task_numa_compare() still needs the PF_EXITING check,
> > but we do not need to recheck ->curr or probe_kernel_read().
> 
> I think I would prefer SLAB_DESTROY_BY_RCU for this, because as you
> pointed out, I'm not sure mainline would like the extra callbacks.

I've sent one more patch with this:

"[PATCH v3] sched/numa: fix unsafe get_task_struct() in
task_numa_assign()"

Kirill

