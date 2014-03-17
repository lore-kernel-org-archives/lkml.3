Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748AbaCQWTn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 18:19:43 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:50202 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923AbaCQWTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 18:19:41 -0400
Message-ID: <532774F5.5070001@linaro.org>
Date: Mon, 17 Mar 2014 15:19:33 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Robert Love <rlove@google.com>,
        Mel Gorman <mel@csn.ul.ie>, Hugh Dickins <hughd@google.com>,
        Dave Hansen <dave@sr71.net>, Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Neil Brown <neilb@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
        Mike Hommey <mh@glandium.org>, Taras Glek <tglek@mozilla.com>,
        Dhaval Giani <dgiani@mozilla.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Michel Lespinasse <walken@google.com>,
        Minchan Kim <minchan@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 1/3] vrange: Add vrange syscall and handle splitting/merging
 and marking vmas
References: <1394822013-23804-1-git-send-email-john.stultz@linaro.org> <1394822013-23804-2-git-send-email-john.stultz@linaro.org> <20140317092118.GA2210@quack.suse.cz>
In-Reply-To: <20140317092118.GA2210@quack.suse.cz>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/2014 02:21 AM, Jan Kara wrote:
> On Fri 14-03-14 11:33:31, John Stultz wrote:
>> This patch introduces the vrange() syscall, which allows for specifying
>> ranges of memory as volatile, and able to be discarded by the system.
>>
>> This initial patch simply adds the syscall, and the vma handling,
>> splitting and merging the vmas as needed, and marking them with
>> VM_VOLATILE.
>>
>> No purging or discarding of volatile ranges is done at this point.
>>
>> Example man page:
>>
>> NAME
>> 	vrange - Mark or unmark range of memory as volatile
>>
>> SYNOPSIS
>> 	int vrange(unsigned_long start, size_t length, int mode,
>> 			 int *purged);
>>
>> DESCRIPTION
>> 	Applications can use vrange(2) to advise the kernel how it should
>> 	handle paging I/O in this VM area.  The idea is to help the kernel
>> 	discard pages of vrange instead of reclaiming when memory pressure
>> 	happens. It means kernel doesn't discard any pages of vrange if
>> 	there is no memory pressure.
>   I'd say that the advantage is kernel doesn't have to swap volatile pages,
> it can just directly discard them on memory pressure. You should also
> mention somewhere vrange() is currently supported only for anonymous pages.
> So maybe we can have the description like:
> Applications can use vrange(2) to advise kernel that pages of anonymous
> mapping in the given VM area can be reclaimed without swapping (or can no
> longer be reclaimed without swapping). The idea is that application can
> help kernel with page reclaim under memory pressure by specifying data
> it can easily regenerate and thus kernel can discard the data if needed.

Good point. This man page description originated from previous patches
where we did handle file paging, so I'll try to update it and make it
more clear we currently don't (although I very much want to re-add that
functionality eventually).


>
>> 	mode:
>> 	VRANGE_VOLATILE
>> 		hint to kernel so VM can discard in vrange pages when
>> 		memory pressure happens.
>> 	VRANGE_NONVOLATILE
>> 		hint to kernel so VM doesn't discard vrange pages
>> 		any more.
>>
>> 	If user try to access purged memory without VRANGE_NONVOLATILE call,
>                 ^^^ tries
>
>> 	he can encounter SIGBUS if the page was discarded by kernel.
>>
>> 	purged: Pointer to an integer which will return 1 if
>> 	mode == VRANGE_NONVOLATILE and any page in the affected range
>> 	was purged. If purged returns zero during a mode ==
>> 	VRANGE_NONVOLATILE call, it means all of the pages in the range
>> 	are intact.
>>
>> RETURN VALUE
>> 	On success vrange returns the number of bytes marked or unmarked.
>> 	Similar to write(), it may return fewer bytes then specified
>> 	if it ran into a problem.
>   I believe you may need to better explain what is 'purged' argument good
> for. Because in my naive understanding *purged == 1 iff return value !=
> length.  I recall your discussion with Johannes about error conditions and
> the need to return error but also the state of the range, is that right?
> But that should be really explained somewhere so that poor application
> programmer is aware of those corner cases as well.

Right. So the purged flag is separate/independent from the byte/error
return. Basically we want to describe how much memory has been changed
from volatile to non-volatile state (or vice versa), as well as
providing if any of those pages were purged while they were volatile.
One could mark 1meg of previously volatile memory non-volatile, and find
purged == 0 if there was no memory pressure, or if there was pressure,
find purged == 1.

The error case is that should we run out of memory (or hit some other
error condition that prevents us from successfully marking all of the
specified memory as non-volatile) half way through, we need to return to
the user the purged state for the pages that we did change.

Now, its true that if we ran out of memory, its likely that the memory
pressure caused pages to be purged before being marked, but one could
imagine a situation were we got half way through marking non-purged
pages and memory pressure suddenly went up, causing an allocation to
fail. Thus in that case, you would see the return value != length, and
purged == 0.

But thank you for the feedback, I'll try to rework that part to be more
clear. Any suggestions would also be welcome, as I worry my head is a
bit too steeped in this to see what would make it more clear to fresh eyes.


[snip]
>> diff --git a/mm/vrange.c b/mm/vrange.c
>> new file mode 100644
>> index 0000000..acb4356
>> --- /dev/null
>> +++ b/mm/vrange.c
>> @@ -0,0 +1,150 @@
>> +#include <linux/syscalls.h>
>> +#include <linux/vrange.h>
>> +#include <linux/mm_inline.h>
>> +#include <linux/pagemap.h>
>> +#include <linux/rmap.h>
>> +#include <linux/hugetlb.h>
>> +#include <linux/mmu_notifier.h>
>> +#include <linux/mm_inline.h>
>> +#include "internal.h"
>> +
>> +static ssize_t do_vrange(struct mm_struct *mm, unsigned long start,
>> +				unsigned long end, int mode, int *purged)
>> +{
>> +	struct vm_area_struct *vma, *prev;
>> +	unsigned long orig_start = start;
>> +	ssize_t count = 0, ret = 0;
>> +	int lpurged = 0;
>> +
>> +	down_read(&mm->mmap_sem);
>> +
>> +	vma = find_vma_prev(mm, start, &prev);
>> +	if (vma && start > vma->vm_start)
>> +		prev = vma;
>> +
>> +	for (;;) {
>> +		unsigned long new_flags;
>> +		pgoff_t pgoff;
>> +		unsigned long tmp;
>> +
>> +		if (!vma)
>> +			goto out;
>> +
>> +		if (vma->vm_flags & (VM_SPECIAL|VM_LOCKED|VM_MIXEDMAP|
>> +					VM_HUGETLB))
>> +			goto out;
>> +
>> +		/* We don't support volatility on files for now */
>> +		if (vma->vm_file) {
>> +			ret = -EINVAL;
>> +			goto out;
>> +		}
>> +
>> +		new_flags = vma->vm_flags;
>> +
>> +		if (start < vma->vm_start) {
>> +			start = vma->vm_start;
>> +			if (start >= end)
>> +				goto out;
>> +		}
>> +		tmp = vma->vm_end;
>> +		if (end < tmp)
>> +			tmp = end;
>> +
>> +		switch (mode) {
>> +		case VRANGE_VOLATILE:
>> +			new_flags |= VM_VOLATILE;
>> +			break;
>> +		case VRANGE_NONVOLATILE:
>> +			new_flags &= ~VM_VOLATILE;
>> +		}
>> +
>> +		pgoff = vma->vm_pgoff + ((start - vma->vm_start) >> PAGE_SHIFT);
>> +		prev = vma_merge(mm, prev, start, tmp, new_flags,
>> +					vma->anon_vma, vma->vm_file, pgoff,
>> +					vma_policy(vma));
>> +		if (prev)
>> +			goto success;
>> +
>> +		if (start != vma->vm_start) {
>> +			ret = split_vma(mm, vma, start, 1);
>> +			if (ret)
>> +				goto out;
>> +		}
>> +
>> +		if (tmp != vma->vm_end) {
>> +			ret = split_vma(mm, vma, tmp, 0);
>> +			if (ret)
>> +				goto out;
>> +		}
>> +
>> +		prev = vma;
>> +success:
>> +		vma->vm_flags = new_flags;
>> +		*purged = lpurged;
>> +
>> +		/* update count to distance covered so far*/
>> +		count = tmp - orig_start;
>> +
>> +		if (prev && start < prev->vm_end)
>   In which case 'prev' can be NULL? And when start >= prev->vm_end? In all
> the cases I can come up with this condition seems to be true...
>
>> +			start = prev->vm_end;
>> +		if (start >= end)
>> +			goto out;
>> +		if (prev)
>   Ditto regarding 'prev'...

I haven't had the chance to look closely here today, but I'll double
check on these two.


>> +			vma = prev->vm_next;
>> +		else	/* madvise_remove dropped mmap_sem */
>> +			vma = find_vma(mm, start);
>   The comment regarding madvise_remove() looks bogus...

Yep. Thanks for pointing it out, that's from my starting with the
madvise logic and reworking it.


Thanks so much for the feedback here! I really appreciate it, and will
rework things appropriately.

thanks again!
-john
