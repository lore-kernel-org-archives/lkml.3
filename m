Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159AbaIPNwD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 09:52:03 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:39414 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817AbaIPNwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 09:52:01 -0400
Message-ID: <54184078.4070505@redhat.com>
Date: Tue, 16 Sep 2014 15:51:52 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Andres Lagar-Cavilla <andreslc@google.com>, Gleb Natapov <gleb@redhat.com>,
        Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Mel Gorman <mgorman@suse.de>, Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Sasha Levin <sasha.levin@oracle.com>, Jianyu Zhan <nasa4836@gmail.com>,
        Paul Cassella <cassella@cray.com>, Hugh Dickins <hughd@google.com>,
        Peter Feiner <pfeiner@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] kvm: Faults which trigger IO release the mmap_sem
References: <1410811885-17267-1-git-send-email-andreslc@google.com>
In-Reply-To: <1410811885-17267-1-git-send-email-andreslc@google.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 15/09/2014 22:11, Andres Lagar-Cavilla ha scritto:
> +	if (!locked) {
> +		BUG_ON(npages != -EBUSY);

VM_BUG_ON perhaps?

> @@ -1177,9 +1210,15 @@ static int hva_to_pfn_slow(unsigned long addr, bool *async, bool write_fault,
>  		npages = get_user_page_nowait(current, current->mm,
>  					      addr, write_fault, page);
>  		up_read(&current->mm->mmap_sem);
> -	} else
> -		npages = get_user_pages_fast(addr, 1, write_fault,
> -					     page);
> +	} else {
> +		/*
> +		 * By now we have tried gup_fast, and possible async_pf, and we
> +		 * are certainly not atomic. Time to retry the gup, allowing
> +		 * mmap semaphore to be relinquished in the case of IO.
> +		 */
> +		npages = kvm_get_user_page_retry(current, current->mm, addr,
> +						 write_fault, page);

This is a separate logical change.  Was this:

	down_read(&mm->mmap_sem);
	npages = get_user_pages(NULL, mm, addr, 1, 1, 0, NULL, NULL);
	up_read(&mm->mmap_sem);

the intention rather than get_user_pages_fast?

I think a first patch should introduce kvm_get_user_page_retry ("Retry a
fault after a gup with FOLL_NOWAIT.") and the second would add
FOLL_TRIED ("This properly relinquishes mmap semaphore if the
filemap/swap has to wait on page lock (and retries the gup to completion
after that").

Apart from this, the patch looks good.  The mm/ parts are minimal, so I
think it's best to merge it through the KVM tree with someone's Acked-by.

Paolo
