Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932534AbaCQJno (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 05:43:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34893 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756399AbaCQJnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 05:43:42 -0400
Date: Mon, 17 Mar 2014 10:43:39 +0100
From: Jan Kara <jack@suse.cz>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Robert Love <rlove@google.com>,
        Mel Gorman <mel@csn.ul.ie>, Hugh Dickins <hughd@google.com>,
        Dave Hansen <dave@sr71.net>, Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Neil Brown <neilb@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
        Mike Hommey <mh@glandium.org>, Taras Glek <tglek@mozilla.com>,
        Dhaval Giani <dgiani@mozilla.com>, Jan Kara <jack@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Michel Lespinasse <walken@google.com>,
        Minchan Kim <minchan@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 1/3] vrange: Add vrange syscall and handle
 splitting/merging and marking vmas
Message-ID: <20140317094339.GC2210@quack.suse.cz>
References: <1394822013-23804-1-git-send-email-john.stultz@linaro.org>
 <1394822013-23804-2-git-send-email-john.stultz@linaro.org>
 <20140317092118.GA2210@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140317092118.GA2210@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 17-03-14 10:21:18, Jan Kara wrote:
> On Fri 14-03-14 11:33:31, John Stultz wrote:
> > +	for (;;) {
> > +		unsigned long new_flags;
> > +		pgoff_t pgoff;
> > +		unsigned long tmp;
> > +
> > +		if (!vma)
> > +			goto out;
> > +
> > +		if (vma->vm_flags & (VM_SPECIAL|VM_LOCKED|VM_MIXEDMAP|
> > +					VM_HUGETLB))
> > +			goto out;
> > +
> > +		/* We don't support volatility on files for now */
> > +		if (vma->vm_file) {
> > +			ret = -EINVAL;
> > +			goto out;
> > +		}
> > +
> > +		new_flags = vma->vm_flags;
> > +
> > +		if (start < vma->vm_start) {
> > +			start = vma->vm_start;
> > +			if (start >= end)
> > +				goto out;
> > +		}
  One more question: This seems to silently skip any holes between VMAs. Is
that really intended? I'd expect that marking unmapped range as volatile /
non-volatile should return error... In any case what happens should be
defined in the description.

								Honza

> > +		tmp = vma->vm_end;
> > +		if (end < tmp)
> > +			tmp = end;
> > +
> > +		switch (mode) {
> > +		case VRANGE_VOLATILE:
> > +			new_flags |= VM_VOLATILE;
> > +			break;
> > +		case VRANGE_NONVOLATILE:
> > +			new_flags &= ~VM_VOLATILE;
> > +		}
> > +
> > +		pgoff = vma->vm_pgoff + ((start - vma->vm_start) >> PAGE_SHIFT);
> > +		prev = vma_merge(mm, prev, start, tmp, new_flags,
> > +					vma->anon_vma, vma->vm_file, pgoff,
> > +					vma_policy(vma));
> > +		if (prev)
> > +			goto success;
> > +
> > +		if (start != vma->vm_start) {
> > +			ret = split_vma(mm, vma, start, 1);
> > +			if (ret)
> > +				goto out;
> > +		}
> > +
> > +		if (tmp != vma->vm_end) {
> > +			ret = split_vma(mm, vma, tmp, 0);
> > +			if (ret)
> > +				goto out;
> > +		}
> > +
> > +		prev = vma;
> > +success:
> > +		vma->vm_flags = new_flags;
> > +		*purged = lpurged;
> > +
> > +		/* update count to distance covered so far*/
> > +		count = tmp - orig_start;
> > +
> > +		if (prev && start < prev->vm_end)
>   In which case 'prev' can be NULL? And when start >= prev->vm_end? In all
> the cases I can come up with this condition seems to be true...
> 
> > +			start = prev->vm_end;
> > +		if (start >= end)
> > +			goto out;
> > +		if (prev)
>   Ditto regarding 'prev'...
> 
> > +			vma = prev->vm_next;
> > +		else	/* madvise_remove dropped mmap_sem */
> > +			vma = find_vma(mm, start);
>   The comment regarding madvise_remove() looks bogus...
> 
> > +	}
> > +out:
> > +	up_read(&mm->mmap_sem);
> > +
> > +	/* report bytes successfully marked, even if we're exiting on error */
> > +	if (count)
> > +		return count;
> > +
> > +	return ret;
> > +}
> > +
> > +SYSCALL_DEFINE4(vrange, unsigned long, start,
> > +		size_t, len, int, mode, int __user *, purged)
> > +{
> > +	unsigned long end;
> > +	struct mm_struct *mm = current->mm;
> > +	ssize_t ret = -EINVAL;
> > +	int p = 0;
> > +
> > +	if (start & ~PAGE_MASK)
> > +		goto out;
> > +
> > +	len &= PAGE_MASK;
> > +	if (!len)
> > +		goto out;
> > +
> > +	end = start + len;
> > +	if (end < start)
> > +		goto out;
> > +
> > +	if (start >= TASK_SIZE)
> > +		goto out;
> > +
> > +	if (purged) {
> > +		/* Test pointer is valid before making any changes */
> > +		if (put_user(p, purged))
> > +			return -EFAULT;
> > +	}
> > +
> > +	ret = do_vrange(mm, start, end, mode, &p);
> > +
> > +	if (purged) {
> > +		if (put_user(p, purged)) {
> > +			/*
> > +			 * This would be bad, since we've modified volatilty
> > +			 * and the change in purged state would be lost.
> > +			 */
> > +			WARN_ONCE(1, "vrange: purge state possibly lost\n");
> > +		}
> > +	}
> > +
> > +out:
> > +	return ret;
> > +}
> 								Honza
> -- 
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
