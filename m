Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923Ab3KAOJb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 10:09:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:53797 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753009Ab3KAOJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 10:09:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,617,1378882800"; 
   d="scan'208";a="426489594"
Date: Fri, 1 Nov 2013 22:09:17 +0800
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Michel Lespinasse <walken@google.com>
Subject: Re: [PATCH 1/4] mm/rmap: per anon_vma lock
Message-ID: <20131101140917.GF30123@yliu-dev.sh.intel.com>
References: <1383292467-28922-1-git-send-email-yuanhan.liu@linux.intel.com>
 <1383292467-28922-2-git-send-email-yuanhan.liu@linux.intel.com>
 <20131101084329.GB19466@laptop.lan>
 <20131101093844.GA30123@yliu-dev.sh.intel.com>
 <20131101102224.GE19466@laptop.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131101102224.GE19466@laptop.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 01, 2013 at 11:22:24AM +0100, Peter Zijlstra wrote:
> On Fri, Nov 01, 2013 at 05:38:44PM +0800, Yuanhan Liu wrote:
> > On Fri, Nov 01, 2013 at 09:43:29AM +0100, Peter Zijlstra wrote:
> > > On Fri, Nov 01, 2013 at 03:54:24PM +0800, Yuanhan Liu wrote:
> > > > @@ -497,15 +495,20 @@ static void vma_rb_erase(struct vm_area_struct *vma, struct rb_root *root)
> > > >   * anon_vma_interval_tree_post_update_vma().
> > > >   *
> > > >   * The entire update must be protected by exclusive mmap_sem and by
> > > > - * the root anon_vma's mutex.
> > > > + * the anon_vma's mutex.
> > > >   */
> > > >  static inline void
> > > >  anon_vma_interval_tree_pre_update_vma(struct vm_area_struct *vma)
> > > >  {
> > > >  	struct anon_vma_chain *avc;
> > > >  
> > > > -	list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)
> > > > -		anon_vma_interval_tree_remove(avc, &avc->anon_vma->rb_root);
> > > > +	list_for_each_entry(avc, &vma->anon_vma_chain, same_vma) {
> > > > +		struct anon_vma *anon_vma = avc->anon_vma;
> > > > +
> > > > +		anon_vma_lock_write(anon_vma);
> > > > +		anon_vma_interval_tree_remove(avc, &anon_vma->rb_root);
> > > > +		anon_vma_unlock_write(anon_vma);
> > > > +	}
> > > >  }
> > > >  
> > > >  static inline void
> > > > @@ -513,8 +516,13 @@ anon_vma_interval_tree_post_update_vma(struct vm_area_struct *vma)
> > > >  {
> > > >  	struct anon_vma_chain *avc;
> > > >  
> > > > -	list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)
> > > > -		anon_vma_interval_tree_insert(avc, &avc->anon_vma->rb_root);
> > > > +	list_for_each_entry(avc, &vma->anon_vma_chain, same_vma) {
> > > > +		struct anon_vma *anon_vma = avc->anon_vma;
> > > > +
> > > > +		anon_vma_lock_write(anon_vma);
> > > > +		anon_vma_interval_tree_insert(avc, &anon_vma->rb_root);
> > > > +		anon_vma_unlock_write(anon_vma);
> > > > +	}
> > > >  }
> > > >  
> > > >  static int find_vma_links(struct mm_struct *mm, unsigned long addr,
> > > > @@ -781,7 +789,6 @@ again:			remove_next = 1 + (end > next->vm_end);
> > > >  	if (anon_vma) {
> > > >  		VM_BUG_ON(adjust_next && next->anon_vma &&
> > > >  			  anon_vma != next->anon_vma);
> > > > -		anon_vma_lock_write(anon_vma);
> > > >  		anon_vma_interval_tree_pre_update_vma(vma);
> > > >  		if (adjust_next)
> > > >  			anon_vma_interval_tree_pre_update_vma(next);
> > > > @@ -845,7 +852,6 @@ again:			remove_next = 1 + (end > next->vm_end);
> > > >  		anon_vma_interval_tree_post_update_vma(vma);
> > > >  		if (adjust_next)
> > > >  			anon_vma_interval_tree_post_update_vma(next);
> > > > -		anon_vma_unlock_write(anon_vma);
> > > >  	}
> > > >  	if (mapping)
> > > >  		mutex_unlock(&mapping->i_mmap_mutex);
> > > 
> > > AFAICT this isn't correct at all. We used to protect the vma interval
> > > tree with the root lock, now we don't.
> > 
> > We still use lock to protect anon_vma interval tree, but we lock our own
> > interval tree this time.
> 
> Which lock? What protects the chain you're iterating in
> anon_vma_interval_tree_{pre,post}_update_vma() ?

Sorry, I may be wrong again this time. But, isn't vma->anon_vma_chain
list being protect by mmap_sem & page_table_lock?
struct vm_area_struct {
        ...
        struct list_head anon_vma_chain; /* Serialized by mmap_sem &
                                          * page_table_lock */
        ...
}

So, my understanding was you don't need extra lock to iterate
vma->anon_vma_chain list. However, you need acquire avc->anon_vma's lock
to insert/remove avc from it.

Thanks.

	--yliu
> 
> > > All we've got left is the
> > > mmap_sem, but anon_vma chains can cross address-spaces and thus we're up
> > > some creek without no paddle.
> > 
> > Yep, however, you still need acquire the address-space crossed anon_vma's lock
> > to modify something.
> 
> -ENOPARSE.
