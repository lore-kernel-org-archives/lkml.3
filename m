Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161007AbaDPSnz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 14:43:55 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:63433 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756425AbaDPSnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 14:43:51 -0400
MIME-Version: 1.0
In-Reply-To: <20140414025150.GC30991@bbox>
References: <1397247340-3365-1-git-send-email-john.stultz@linaro.org>
	<1397247340-3365-5-git-send-email-john.stultz@linaro.org>
	<20140414025150.GC30991@bbox>
Date: Wed, 16 Apr 2014 11:43:50 -0700
Message-ID: <CALAqxLXqEhBDdzbq4iNa81w1fzTudL3o3ny4nGOOQdoM-DK=qA@mail.gmail.com>
Subject: Re: [PATCH 4/4] mvolatile: Add page purging logic & SIGBUS trap
From: John Stultz <john.stultz@linaro.org>
To: Minchan Kim <minchan@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Robert Love <rlove@google.com>,
        Mel Gorman <mel@csn.ul.ie>, Hugh Dickins <hughd@google.com>,
        Dave Hansen <dave@sr71.net>, Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Neil Brown <neilb@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
        Mike Hommey <mh@glandium.org>, Taras Glek <tglek@mozilla.com>,
        Jan Kara <jack@suse.cz>, KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Michel Lespinasse <walken@google.com>,
        Keith Packard <keithp@keithp.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 13, 2014 at 7:51 PM, Minchan Kim <minchan@kernel.org> wrote:
> On Fri, Apr 11, 2014 at 01:15:40PM -0700, John Stultz wrote:
>> @@ -3643,6 +3644,8 @@ static int handle_pte_fault(struct mm_struct *mm,
>>
>>       entry = *pte;
>>       if (!pte_present(entry)) {
>> +             swp_entry_t mvolatile_entry;
>> +
>>               if (pte_none(entry)) {
>>                       if (vma->vm_ops) {
>>                               if (likely(vma->vm_ops->fault))
>> @@ -3652,6 +3655,11 @@ static int handle_pte_fault(struct mm_struct *mm,
>>                       return do_anonymous_page(mm, vma, address,
>>                                                pte, pmd, flags);
>>               }
>> +
>> +             mvolatile_entry = pte_to_swp_entry(entry);
>> +             if (unlikely(is_purged_entry(mvolatile_entry)))
>> +                     return VM_FAULT_SIGBUS;
>> +
>
> There is no pte lock so that is_purged_entry isn't safe so if race happens,
> do_swap_page could have a problem so it would be better to handle it
> do_swap_page with pte lock because we used swp_pte to indicate purged pte.
>
> I tried to solve it while we were in Napa(you could remember I sent
> crap patchset to you privately but failed to fix and I still didn't get
> a time to fix it :( ) but I'd like to inform this problem.

Thanks for the review and the reminder! I'll move the check appropriately.

thanks
-john
