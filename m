Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754989AbaJWLD7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 07:03:59 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:39597 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210AbaJWLD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 07:03:58 -0400
Date: Thu, 23 Oct 2014 13:03:46 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: torvalds@linux-foundation.org, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, akpm@linux-foundation.org, riel@redhat.com,
        mgorman@suse.de, oleg@redhat.com, mingo@redhat.com, minchan@kernel.org,
        kamezawa.hiroyu@jp.fujitsu.com, viro@zeniv.linux.org.uk,
        dave@stgolabs.net, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC][PATCH 4/6] SRCU free VMAs
Message-ID: <20141023110346.GP21513@worktop.programming.kicks-ass.net>
References: <20141020215633.717315139@infradead.org>
 <20141020222841.419869904@infradead.org>
 <5448D515.90006@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5448D515.90006@cn.fujitsu.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 06:14:45PM +0800, Lai Jiangshan wrote:
> 
> >  
> > +struct vm_area_struct *find_vma_srcu(struct mm_struct *mm, unsigned long addr)
> > +{
> > +	struct vm_area_struct *vma;
> > +	unsigned int seq;
> > +
> > +	WARN_ON_ONCE(!srcu_read_lock_held(&vma_srcu));
> > +
> > +	do {
> > +		seq = read_seqbegin(&mm->mm_seq);
> > +		vma = __find_vma(mm, addr);
> 
> will the __find_vma() loops for ever due to the rotations in the RBtree?

No, a rotation takes a tree and generates a tree, furthermore the
rotation has a fairly strict fwd progress guarantee seeing how its now
done with preemption disabled.

Therefore, even if we're in a node that's being rotated up, we can only
'loop' for as long as it takes for the new pointer stores to become
visible on our CPU.

Thus we have a tree descent termination guarantee.
