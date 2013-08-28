Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816Ab3H1UXh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 16:23:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52050 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381Ab3H1UXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 16:23:35 -0400
Date: Wed, 28 Aug 2013 13:23:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kent Overstreet <kmo@daterainc.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        target-devel <target-devel@vger.kernel.org>,
        lf-virt <virtualization@lists.linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, Asias He <asias@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Christoph Lameter <cl@gentwo.org>, Oleg Nesterov <oleg@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH-v3 1/4] idr: Percpu ida
Message-Id: <20130828132332.6d5263ee9622235ae0fcc615@linux-foundation.org>
In-Reply-To: <20130828195317.GE8032@kmo-pixel>
References: <1376694549-20609-1-git-send-email-nab@linux-iscsi.org>
	<1376694549-20609-2-git-send-email-nab@linux-iscsi.org>
	<20130820143157.f91bf59d16352989b54e431e@linux-foundation.org>
	<20130828195317.GE8032@kmo-pixel>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Aug 2013 12:53:17 -0700 Kent Overstreet <kmo@daterainc.com> wrote:

> > > +	while (1) {
> > > +		spin_lock(&pool->lock);
> > > +
> > > +		/*
> > > +		 * prepare_to_wait() must come before steal_tags(), in case
> > > +		 * percpu_ida_free() on another cpu flips a bit in
> > > +		 * cpus_have_tags
> > > +		 *
> > > +		 * global lock held and irqs disabled, don't need percpu lock
> > > +		 */
> > > +		prepare_to_wait(&pool->wait, &wait, TASK_UNINTERRUPTIBLE);
> > > +
> > > +		if (!tags->nr_free)
> > > +			alloc_global_tags(pool, tags);
> > > +		if (!tags->nr_free)
> > > +			steal_tags(pool, tags);
> > > +
> > > +		if (tags->nr_free) {
> > > +			tag = tags->freelist[--tags->nr_free];
> > > +			if (tags->nr_free)
> > > +				set_bit(smp_processor_id(),
> > > +					pool->cpus_have_tags);
> > > +		}
> > > +
> > > +		spin_unlock(&pool->lock);
> > > +		local_irq_restore(flags);
> > > +
> > > +		if (tag >= 0 || !(gfp & __GFP_WAIT))
> > > +			break;
> > > +
> > > +		schedule();
> > > +
> > > +		local_irq_save(flags);
> > > +		tags = this_cpu_ptr(pool->tag_cpu);
> > > +	}
> > 
> > What guarantees that this wait will terminate?
> 
> It seems fairly clear to me from the break statement a couple lines up;
> if we were passed __GFP_WAIT we terminate iff we succesfully allocated a
> tag. If we weren't passed __GFP_WAIT we never actually sleep.

OK ;)  Let me rephrase.  What guarantees that a tag will become available?

If what we have here is an open-coded __GFP_NOFAIL then that is
potentially problematic.
