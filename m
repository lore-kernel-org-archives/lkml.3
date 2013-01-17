Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758284Ab3AQBso (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 20:48:44 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:56369 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757865Ab3AQBsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 20:48:42 -0500
Message-ID: <50F75875.30909@linaro.org>
Date: Wed, 16 Jan 2013 17:48:37 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>,
        Arun Sharma <asharma@fb.com>, sanjay@google.com,
        Paul Turner <pjt@google.com>, David Rientjes <rientjes@google.com>,
        Christoph Lameter <cl@linux.com>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>, Dave Chinner <david@fromorbit.com>,
        Neil Brown <neilb@suse.de>, Mike Hommey <mh@glandium.org>,
        Taras Glek <tglek@mozilla.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC 1/8] Introduce new system call mvolatile
References: <1357187286-18759-1-git-send-email-minchan@kernel.org> <1357187286-18759-2-git-send-email-minchan@kernel.org>
In-Reply-To: <1357187286-18759-2-git-send-email-minchan@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/02/2013 08:27 PM, Minchan Kim wrote:
> This patch adds new system call m[no]volatile.
> If someone asks is_volatile system call, it could be added, too.

So some nits below from my initial playing around with this patchset.

> +/*
> + * Return -EINVAL if range doesn't include a right vma at all.
> + * Return -ENOMEM with interrupting range opeartion if memory is not enough to
> + * merge/split vmas.
> + * Return 0 if range consists of only proper vmas.
> + * Return 1 if part of range includes inavlid area(ex, hole/huge/ksm/mlock/
> + * special area)
> + */
> +SYSCALL_DEFINE2(mvolatile, unsigned long, start, size_t, len)
> +{
> +	unsigned long end, tmp;
> +	struct vm_area_struct *vma, *prev;
> +	bool invalid = false;
> +	int error = -EINVAL;
> +
> +	down_write(&current->mm->mmap_sem);
> +	if (start & ~PAGE_MASK)
> +		goto out;
> +
> +	len &= PAGE_MASK;
> +	if (!len)
> +		goto out;
> +
> +	end = start + len;
> +	if (end < start)
> +		goto out;
> +
> +	vma = find_vma_prev(current->mm, start, &prev);
> +	if (!vma)
> +		goto out;
> +
> +	if (start > vma->vm_start)
> +		prev = vma;
> +
> +	for (;;) {
> +		/* Here start < (end|vma->vm_end). */
> +		if (start < vma->vm_start) {
> +			start = vma->vm_start;
> +			if (start >= end)
> +				goto out;
> +			invalid = true;
> +		}
> +
> +		/* Here vma->vm_start <= start < (end|vma->vm_end) */
> +		tmp = vma->vm_end;
> +		if (end < tmp)
> +			tmp = end;
> +
> +		/* Here vma->vm_start <= start < tmp <= (end|vma->vm_end). */
> +		error = do_mvolatile(vma, &prev, start, tmp);
> +		if (error == -ENOMEM) {
> +			up_write(&current->mm->mmap_sem);
> +			return error;
> +		}
> +		if (error == -EINVAL)
> +			invalid = true;
> +		else
> +			error = 0;
> +		start = tmp;
> +		if (prev && start < prev->vm_end)
> +			start = prev->vm_end;
> +		if (start >= end)
> +			break;
> +
> +		vma = prev->vm_next;
> +		if (!vma)
> +			break;
> +	}
> +out:
> +	up_write(&current->mm->mmap_sem);
> +	return invalid ? 1 : 0;
> +}

The error logic here is really strange. If any of the early error cases 
are triggered (ie: (start & ~PAGE_MASK), etc), then we jump to out and 
return 0 (instead of EINVAL). I don't think that's what you intended.


> +/*
> + * Return -ENOMEM with interrupting range opeartion if memory is not enough
> + * to merge/split vmas.
> + * Return 1 if part of range includes purged's one, otherwise, return 0
> + */
> +SYSCALL_DEFINE2(mnovolatile, unsigned long, start, size_t, len)
> +{
> +	unsigned long end, tmp;
> +	struct vm_area_struct *vma, *prev;
> +	int ret, error = -EINVAL;
> +	bool is_purged = false;
> +
> +	down_write(&current->mm->mmap_sem);
> +	if (start & ~PAGE_MASK)
> +		goto out;
> +
> +	len &= PAGE_MASK;
> +	if (!len)
> +		goto out;
> +
> +	end = start + len;
> +	if (end < start)
> +		goto out;
> +
> +	vma = find_vma_prev(current->mm, start, &prev);
> +	if (!vma)
> +		goto out;
> +
> +	if (start > vma->vm_start)
> +		prev = vma;
> +
> +	for (;;) {
> +		/* Here start < (end|vma->vm_end). */
> +		if (start < vma->vm_start) {
> +			start = vma->vm_start;
> +			if (start >= end)
> +				goto out;
> +		}
> +
> +		/* Here vma->vm_start <= start < (end|vma->vm_end) */
> +		tmp = vma->vm_end;
> +		if (end < tmp)
> +			tmp = end;
> +
> +		/* Here vma->vm_start <= start < tmp <= (end|vma->vm_end). */
> +		error = do_mnovolatile(vma, &prev, start, tmp, &is_purged);
> +		if (error) {
> +			WARN_ON(error != -ENOMEM);
> +			goto out;
> +		}
> +		start = tmp;
> +		if (prev && start < prev->vm_end)
> +			start = prev->vm_end;
> +		if (start >= end)
> +			break;
> +
> +		vma = prev->vm_next;
> +		if (!vma)
> +			break;
> +	}

I'm still not sure how this logic improves over the madvise case. If we 
catch an error mid-way through setting a series of vmas to non-volatile, 
we end up exiting and losing state (ie: if only the first vma was 
purged, but half way through 10 vmas we get a ENOMEM error. So the first 
vma is now non-volatile, but we do not return the purged flag ).

If we're going to have a new syscall for this (which I'm not sure is the 
right approach), we should make use of multiple arguments so we can 
return if data was purged, even if we hit an error midway).

Alternatively, if we can find a way to allocate any necessary memory 
before we do any vma volatility state changes, then we can return ENOMEM 
then and be confident we won't end up with failed partial state change 
(this is the approach I used in my fallocate-volatile patches).

thanks
-john
