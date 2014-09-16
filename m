Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466AbaIPVBU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 17:01:20 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:60639 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631AbaIPVBQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 17:01:16 -0400
MIME-Version: 1.0
In-Reply-To: <20140916205110.GA1273@potion.brq.redhat.com>
References: <1410811885-17267-1-git-send-email-andreslc@google.com>
	<54184078.4070505@redhat.com>
	<20140916205110.GA1273@potion.brq.redhat.com>
Date: Tue, 16 Sep 2014 14:01:15 -0700
Message-ID: <CAJu=L59f6ODMDOiKEGGSGg+0RhYw3FDy5D7AJcCOrHD5xL_iwQ@mail.gmail.com>
Subject: Re: [PATCH] kvm: Faults which trigger IO release the mmap_sem
From: Andres Lagar-Cavilla <andreslc@google.com>
To: =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Mel Gorman <mgorman@suse.de>, Andy Lutomirski <luto@amacapital.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Sasha Levin <sasha.levin@oracle.com>, Jianyu Zhan <nasa4836@gmail.com>,
        Paul Cassella <cassella@cray.com>, Hugh Dickins <hughd@google.com>,
        Peter Feiner <pfeiner@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2014 at 1:51 PM, Radim Krčmář <rkrcmar@redhat.com> wrote:
> 2014-09-15 13:11-0700, Andres Lagar-Cavilla:
>> +int kvm_get_user_page_retry(struct task_struct *tsk, struct mm_struct *mm,
>
> The suffix '_retry' is not best suited for this.
> On first reading, I imagined we will be retrying something from before,
> possibly calling it in a loop, but we are actually doing the first and
> last try in one call.

We are doing ... the second and third in most scenarios. async_pf did
the first with _NOWAIT. We call this from the async pf retrier, or if
async pf couldn't be notified to the guest.

>
> Hard to find something that conveys our lock-dropping mechanic,
> '_polite' is my best candidate at the moment.

I'm at a loss towards finding a better name than '_retry'.

>
>> +     int flags = FOLL_TOUCH | FOLL_HWPOISON |
>
> (FOLL_HWPOISON wasn't used before, but it's harmless.)

Ok. Wasn't 100% sure TBH.

>
> 2014-09-16 15:51+0200, Paolo Bonzini:
>> Il 15/09/2014 22:11, Andres Lagar-Cavilla ha scritto:
>> > @@ -1177,9 +1210,15 @@ static int hva_to_pfn_slow(unsigned long addr, bool *async, bool write_fault,
>> >             npages = get_user_page_nowait(current, current->mm,
>> >                                           addr, write_fault, page);
>> >             up_read(&current->mm->mmap_sem);
>> > -   } else
>> > -           npages = get_user_pages_fast(addr, 1, write_fault,
>> > -                                        page);
>> > +   } else {
>> > +           /*
>> > +            * By now we have tried gup_fast, and possible async_pf, and we
>                                         ^
> (If we really tried get_user_pages_fast, we wouldn't be here, so I'd
>  prepend two underscores here as well.)

Yes, async pf tries and fails to do fast, and then we fallback to
slow, and so on.

>
>> > +            * are certainly not atomic. Time to retry the gup, allowing
>> > +            * mmap semaphore to be relinquished in the case of IO.
>> > +            */
>> > +           npages = kvm_get_user_page_retry(current, current->mm, addr,
>> > +                                            write_fault, page);
>>
>> This is a separate logical change.  Was this:
>>
>>       down_read(&mm->mmap_sem);
>>       npages = get_user_pages(NULL, mm, addr, 1, 1, 0, NULL, NULL);
>>       up_read(&mm->mmap_sem);
>>
>> the intention rather than get_user_pages_fast?
>
> I believe so as well.
>
> (Looking at get_user_pages_fast and __get_user_pages_fast made my
>  abstraction detector very sad.)

It's clunky, but a separate battle.

>
>> I think a first patch should introduce kvm_get_user_page_retry ("Retry a
>> fault after a gup with FOLL_NOWAIT.") and the second would add
>> FOLL_TRIED ("This properly relinquishes mmap semaphore if the
>> filemap/swap has to wait on page lock (and retries the gup to completion
>> after that").
>
> Not sure if that would help to understand the goal ...
>
>> Apart from this, the patch looks good.  The mm/ parts are minimal, so I
>> think it's best to merge it through the KVM tree with someone's Acked-by.
>
> I would prefer to have the last hunk in a separate patch, but still,
>
> Acked-by: Radim Krčmář <rkrcmar@redhat.com>
Awesome, thanks much.

I'll recut with the VM_BUG_ON from Paolo and your Ack. LMK if anything
else from this email should go into the recut.

Andres


-- 
Andres Lagar-Cavilla | Google Kernel Team | andreslc@google.com
