Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161093AbaDJSty (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 14:49:54 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:52562 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934295AbaDJStv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 14:49:51 -0400
Message-ID: <5346E7CB.2010500@linaro.org>
Date: Thu, 10 Apr 2014 11:49:47 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Robert Love <rlove@google.com>,
        Mel Gorman <mel@csn.ul.ie>, Hugh Dickins <hughd@google.com>,
        Dave Hansen <dave@sr71.net>, Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Neil Brown <neilb@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
        Mike Hommey <mh@glandium.org>, Taras Glek <tglek@mozilla.com>,
        Jan Kara <jack@suse.cz>, Michel Lespinasse <walken@google.com>,
        Minchan Kim <minchan@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 3/5] vrange: Add page purging logic & SIGBUS trap
References: <1395436655-21670-1-git-send-email-john.stultz@linaro.org> <1395436655-21670-4-git-send-email-john.stultz@linaro.org> <CAHGf_=q_1ZxDOdA7HCVUh2LYK9wwKbLsru__nXrXEQ2WEdjguQ@mail.gmail.com>
In-Reply-To: <CAHGf_=q_1ZxDOdA7HCVUh2LYK9wwKbLsru__nXrXEQ2WEdjguQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Kosaki-san,
  Just a few follow ups on your comments here in preparation for v13.

On 03/23/2014 04:44 PM, KOSAKI Motohiro wrote:
> On Fri, Mar 21, 2014 at 2:17 PM, John Stultz <john.stultz@linaro.org> wrote:
> @@ -683,6 +684,7 @@ enum page_references {
>         PAGEREF_RECLAIM,
>         PAGEREF_RECLAIM_CLEAN,
>         PAGEREF_KEEP,
> +       PAGEREF_DISCARD,
> "discard" is alread used in various place for another meanings.
> another name is better.

Any suggestions here? Is PAGEREF_PURGE better?


>
>>         PAGEREF_ACTIVATE,
>>  };
>>
>> @@ -703,6 +705,13 @@ static enum page_references page_check_references(struct page *page,
>>         if (vm_flags & VM_LOCKED)
>>                 return PAGEREF_RECLAIM;
>>
>> +       /*
>> +        * If volatile page is reached on LRU's tail, we discard the
>> +        * page without considering recycle the page.
>> +        */
>> +       if (vm_flags & VM_VOLATILE)
>> +               return PAGEREF_DISCARD;
>> +
>>         if (referenced_ptes) {
>>                 if (PageSwapBacked(page))
>>                         return PAGEREF_ACTIVATE;
>> @@ -930,6 +939,9 @@ static unsigned long shrink_page_list(struct list_head *page_list,
>>                 switch (references) {
>>                 case PAGEREF_ACTIVATE:
>>                         goto activate_locked;
>> +               case PAGEREF_DISCARD:
>> +                       if (may_enter_fs && !discard_vpage(page))
> Wny may-enter-fs is needed? discard_vpage never enter FS.

I think this is a hold over from the file based/shared volatility.
Thanks for pointing it out, I've dropped the may_enter_fs check.


>> +       /*
>> +        * During interating the loop, some processes could see a page as
>> +        * purged while others could see a page as not-purged because we have
>> +        * no global lock between parent and child for protecting vrange system
>> +        * call during this loop. But it's not a problem because the page is
>> +        * not *SHARED* page but *COW* page so parent and child can see other
>> +        * data anytime. The worst case by this race is a page was purged
>> +        * but couldn't be discarded so it makes unnecessary page fault but
>> +        * it wouldn't be severe.
>> +        */
>> +       anon_vma_interval_tree_foreach(avc, &anon_vma->rb_root, pgoff, pgoff) {
>> +               struct vm_area_struct *vma = avc->vma;
>> +
>> +               if (!(vma->vm_flags & VM_VOLATILE))
>> +                       continue;
> When you find !VM_VOLATILE vma, we have no reason to continue pte zapping.
> Isn't it?

Sounds reasonable. I'll switch to breaking out here and returning an
error if Minchan doesn't object.


>
>> +               try_to_discard_one(page, vma);
>> +       }
>> +       page_unlock_anon_vma_read(anon_vma);
>> +       return 0;
>> +}
>> +
>> +
>> +/**
>> + * discard_vpage - If possible, discard the specified volatile page
>> + *
>> + * Attempts to discard a volatile page, and if needed frees the swap page
>> + *
>> + * Returns 0 on success, -1 on error.
>> + */
>> +int discard_vpage(struct page *page)
>> +{
>> +       VM_BUG_ON(!PageLocked(page));
>> +       VM_BUG_ON(PageLRU(page));
>> +
>> +       /* XXX - for now we only support anonymous volatile pages */
>> +       if (!PageAnon(page))
>> +               return -1;
>> +
>> +       if (!try_to_discard_vpage(page)) {
>> +               if (PageSwapCache(page))
>> +                       try_to_free_swap(page);
> This looks strange. try_to_free_swap can't handle vpurge pseudo entry.

So I may be missing some of the subtleties of the swap code, but the
vpurge pseudo swp entry is on the pte, where as here we're just trying
to make sure that before we drop the page we disconnect any swap-backing
the page may have (if it were swapped out previously before being marked
volatile). Let me know if I'm just not understanding the code or your point.


>> +
>> +               if (page_freeze_refs(page, 1)) {
> Where is page_unfreeze_refs() for the pair of this?

Since we're about to free the page I don't think we need a unfreeze_refs
pair? Or am I just misunderstanding the rules here?

thanks
-john
