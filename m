Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610Ab3FKRqp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 13:46:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19170 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754507Ab3FKRqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 13:46:43 -0400
Date: Tue, 11 Jun 2013 19:42:38 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, akpm@linux-foundation.org,
        Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 17/21] Percpu tag allocator
Message-ID: <20130611174238.GA8139@redhat.com>
References: <1368494338-7069-1-git-send-email-koverstreet@google.com> <1368494338-7069-18-git-send-email-koverstreet@google.com> <20130514134859.GA17587@redhat.com> <20130515092543.GE16164@moria.home.lan> <20130515154121.GA21932@redhat.com> <20130610232030.GA6151@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130610232030.GA6151@google.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10, Kent Overstreet wrote:
>
> On Wed, May 15, 2013 at 05:41:21PM +0200, Oleg Nesterov wrote:
> >
> > Do you really think that, say,
> >
> > 	unsigned tag_alloc(struct tag_pool *pool, bool wait)
> > 	{
> > 		struct tag_cpu_freelist *tags;
> > 		unsigned ret = 0;
> > 	retry:
> > 		tags = get_cpu_ptr(pool->tag_cpu);
> > 		local_irq_disable();
> > 		if (!tags->nr_free && pool->nr_free) {
> > 			spin_lock(&pool->wq.lock);
> > 			if (pool->nr_free)
> > 				move_tags(...);
> > 			spin_unlock(&pool->wq.lock);
> > 		}
> >
> > 		if (tags->nr_free)
> > 			ret = tags->free[--tags->nr_free];
> > 		local_irq_enable();
> > 		put_cpu_var(pool->tag_cpu);
> >
> > 		if (ret || !wait)
> > 			return ret;
> >
> > 		__wait_event(&pool->wq, pool->nr_free);
> > 		goto retry;
> > 	}
> >
> > will be much slower?
>
> The overhead from doing nested irqsave/restore() sucks. I've had it bite
> me hard with the recent aio work.

Not sure I understand... Only __wait_event() does irqsave/restore and
we are going to sleep anyway.

> But screw it, it's not going to matter
> that much here.

Yes.

And, imho, even if we need some optimizations here, it would be better
to make a separate patch backed by the numbers or at least the detailed
explanation.

> > Question. tag_free() does move_tags+wakeup if nr_free = pool->watermark * 2.
> > Perhaps it should should also take waitqueue_active() into account ?
> > tag_alloc() can sleep more than necessary, it seems.
>
> No.
>
> By "sleeping more than necessary" you mean sleeping when there's tags
> available on other percpu freelists.

Yes,

> That's just unavoidable if the thing's to be percpu - efficient use of
> available tags requires global knowledge. Sleeping less would require
> more global cacheline contention, and would defeat the purpose of this
> code.

Yes, yes, I understand, there is a tradeoff. Just it is still not clear
to me what would be better "in practice"... So,

> So when you're deciding how many tag structs to allocate, you just
> double the number you'd allocate otherwise when you're using this code.

I am not sure this is really needed.

But OK, I see your point, thanks.

Oleg.

