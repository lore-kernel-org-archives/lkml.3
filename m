Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934711AbaFTHiw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 03:38:52 -0400
Received: from mx2.parallels.com ([199.115.105.18]:56100 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934161AbaFTHiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 03:38:51 -0400
Date: Fri, 20 Jun 2014 11:38:38 +0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: <oleg@redhat.com>, <rientjes@google.com>, <cl@linux.com>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] fork: reset mm->pinned_vm
Message-ID: <20140620073838.GA5387@esperanza>
References: <fa98629155872c1b97ba4dcd00d509a1e467c1c3.1403168346.git.vdavydov@parallels.com>
 <63d594c88850aa64729fceec769681f9d1d6fa68.1403168346.git.vdavydov@parallels.com>
 <20140619135820.57c4934dd613c5e723f9ca82@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140619135820.57c4934dd613c5e723f9ca82@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 01:58:20PM -0700, Andrew Morton wrote:
> On Thu, 19 Jun 2014 13:07:47 +0400 Vladimir Davydov <vdavydov@parallels.com> wrote:
> 
> > mm->pinned_vm counts pages of mm's address space that were permanently
> > pinned in memory by increasing their reference counter. The counter was
> > introduced by commit bc3e53f682d9 ("mm: distinguish between mlocked and
> > pinned pages"), while before it locked_vm had been used for such pages.
> > 
> > Obviously, we should reset the counter on fork if !CLONE_VM, just like
> > we do with locked_vm, but currently we don't. Let's fix it.
> > 
> > ...
> >
> > --- a/kernel/fork.c
> > +++ b/kernel/fork.c
> > @@ -534,6 +534,7 @@ static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p)
> >  	atomic_long_set(&mm->nr_ptes, 0);
> >  	mm->map_count = 0;
> >  	mm->locked_vm = 0;
> > +	mm->pinned_vm = 0;
> >  	memset(&mm->rss_stat, 0, sizeof(mm->rss_stat));
> >  	spin_lock_init(&mm->page_table_lock);
> >  	mm_init_cpumask(mm);
> 
> What are the runtime effects of this?  I think it is only
> "/proc/pid/status:VmPin is screwed up", because we don't use vm_pinned
> in rlimit checks.  Yes?

Hmm, ib_umem_get[infiniband] and perf_mmap still check pinned_vm against
RLIMIT_MEMLOCK. It's left from the times when pinned pages were
accounted under locked_vm, but today it looks wrong. It isn't clear to
me how we should deal with it.

And BTW, we still have some drivers accounting pinned pages under
mm->locked_vm - this is what commit bc3e53f682d9 was fighting against.
It's infiniband/usnic and vfio.

Thanks.
