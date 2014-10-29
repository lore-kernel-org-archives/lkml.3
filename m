Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934798AbaJ2Rga (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 13:36:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39386 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934130AbaJ2Rg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 13:36:28 -0400
Date: Wed, 29 Oct 2014 17:39:08 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andres Lagar-Cavilla <andreslc@google.com>,
        Gleb Natapov <gleb@kernel.org>, Radim Krcmar <rkrcmar@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>, Jianyu Zhan <nasa4836@gmail.com>,
        Paul Cassella <cassella@cray.com>, Hugh Dickins <hughd@google.com>,
        Peter Feiner <pfeiner@google.com>,
        "\\\"Dr. David Alan Gilbert\\\"" <dgilbert@redhat.com>
Subject: Re: [PATCH 2/4] mm: gup: add get_user_pages_locked and
 get_user_pages_unlocked
Message-ID: <20141029163908.GI19606@redhat.com>
References: <1412153797-6667-1-git-send-email-aarcange@redhat.com>
 <1412153797-6667-3-git-send-email-aarcange@redhat.com>
 <20141009105037.GM4750@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141009105037.GM4750@worktop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2014 at 12:50:37PM +0200, Peter Zijlstra wrote:
> On Wed, Oct 01, 2014 at 10:56:35AM +0200, Andrea Arcangeli wrote:
> 
> > +static inline long __get_user_pages_locked(struct task_struct *tsk,
> > +					   struct mm_struct *mm,
> > +					   unsigned long start,
> > +					   unsigned long nr_pages,
> > +					   int write, int force,
> > +					   struct page **pages,
> > +					   struct vm_area_struct **vmas,
> > +					   int *locked,
> > +					   bool notify_drop)
> > +{
> 
> > +	if (notify_drop && lock_dropped && *locked) {
> > +		/*
> > +		 * We must let the caller know we temporarily dropped the lock
> > +		 * and so the critical section protected by it was lost.
> > +		 */
> > +		up_read(&mm->mmap_sem);
> > +		*locked = 0;
> > +	}
> > +	return pages_done;
> > +}
> 
> > +long get_user_pages_locked(struct task_struct *tsk, struct mm_struct *mm,
> > +			   unsigned long start, unsigned long nr_pages,
> > +			   int write, int force, struct page **pages,
> > +			   int *locked)
> > +{
> > +	return __get_user_pages_locked(tsk, mm, start, nr_pages, write, force,
> > +				       pages, NULL, locked, true);
> > +}
> 
> > +long get_user_pages_unlocked(struct task_struct *tsk, struct mm_struct *mm,
> > +			     unsigned long start, unsigned long nr_pages,
> > +			     int write, int force, struct page **pages)
> > +{
> > +	long ret;
> > +	int locked = 1;
> > +	down_read(&mm->mmap_sem);
> > +	ret = __get_user_pages_locked(tsk, mm, start, nr_pages, write, force,
> > +				      pages, NULL, &locked, false);
> > +	if (locked)
> > +		up_read(&mm->mmap_sem);
> > +	return ret;
> > +}
> 
> >  long get_user_pages(struct task_struct *tsk, struct mm_struct *mm,
> >  		unsigned long start, unsigned long nr_pages, int write,
> >  		int force, struct page **pages, struct vm_area_struct **vmas)
> >  {
> > +	return __get_user_pages_locked(tsk, mm, start, nr_pages, write, force,
> > +				       pages, vmas, NULL, false);
> >  }
> 
> I'm wondering about that notify_drop parameter, what's the added
> benefit? If you look at these 3 callers we can do away with it, since in
> the second called where we have locked but !notify_drop we seem to do

The second (and third) caller pass notify_drop=false, so the
notify_drop parameter is always a noop for them. They certainly could
get away without it.

> the exact same thing afterwards anyway.

It makes a difference only to the first caller, if it wasn't for the
first caller notify_drop could be dropped. The first caller does this:

	return __get_user_pages_locked(tsk, mm, start, nr_pages, write, force,
				       pages, NULL, locked, true, FOLL_TOUCH);
				       	      	            ^ notify_drop = true

Without "notify_drop=true" the first caller could make its own
respective caller think the lock has never been dropped, just because
it is locked by the time get_user_pages_locked returned. But the
caller must be made aware that the lock has been dropped during the
call and in turn any "vma" it got before inside the mmap_sem critical
section is now stale. That's all notify_drop achieves.

Thanks,
Andrea
