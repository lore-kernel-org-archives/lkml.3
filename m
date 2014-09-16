Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940AbaIPSaD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 14:30:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53586 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754250AbaIPSaB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 14:30:01 -0400
Message-ID: <54188179.7010705@redhat.com>
Date: Tue, 16 Sep 2014 20:29:13 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Andres Lagar-Cavilla <andreslc@google.com>
CC: Gleb Natapov <gleb@redhat.com>, Rik van Riel <riel@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Sasha Levin <sasha.levin@oracle.com>, Jianyu Zhan <nasa4836@gmail.com>,
        Paul Cassella <cassella@cray.com>, Hugh Dickins <hughd@google.com>,
        Peter Feiner <pfeiner@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] kvm: Faults which trigger IO release the mmap_sem
References: <1410811885-17267-1-git-send-email-andreslc@google.com>	<54184078.4070505@redhat.com> <CAJu=L5_w+u6komiZB6RE1+9H5MiL+8RJBy_GYO6CmjqkhaG5Zg@mail.gmail.com>
In-Reply-To: <CAJu=L5_w+u6komiZB6RE1+9H5MiL+8RJBy_GYO6CmjqkhaG5Zg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 16/09/2014 18:52, Andres Lagar-Cavilla ha scritto:
> Was this:
> 
>         down_read(&mm->mmap_sem);
>         npages = get_user_pages(NULL, mm, addr, 1, 1, 0, NULL, NULL);
>         up_read(&mm->mmap_sem);
> 
> the intention rather than get_user_pages_fast?

I meant the intention of the original author, not yours.

> By that point in the call chain I felt comfortable dropping the _fast.
> All paths that get there have already tried _fast (and some have tried
> _NOWAIT).

Yes, understood.

>     I think a first patch should introduce kvm_get_user_page_retry ("Retry a
>     fault after a gup with FOLL_NOWAIT.") and the second would add
>     FOLL_TRIED ("This properly relinquishes mmap semaphore if the
>     filemap/swap has to wait on page lock (and retries the gup to completion
>     after that").
> 
> That's not what FOLL_TRIED does. The relinquishing of mmap semaphore is
> done by this patch minus the FOLL_TRIED bits. FOLL_TRIED will let the
> fault handler (e.g. filemap) know that we've been there and waited on
> the IO already, so in the common case we won't need to redo the IO.

Yes, that's not what FOLL_TRIED does.  But it's the difference between
get_user_pages and kvm_get_user_page_retry, right?

Paolo
