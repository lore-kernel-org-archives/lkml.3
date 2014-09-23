Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756357AbaIWREa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 13:04:30 -0400
Received: from mail-yk0-f177.google.com ([209.85.160.177]:36563 "EHLO
	mail-yk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756304AbaIWREZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 13:04:25 -0400
MIME-Version: 1.0
In-Reply-To: <542125F1.3080607@redhat.com>
References: <1411410865-3603-1-git-send-email-andreslc@google.com>
	<1411422882-16245-1-git-send-email-andreslc@google.com>
	<542125F1.3080607@redhat.com>
Date: Tue, 23 Sep 2014 10:04:24 -0700
Message-ID: <CAJu=L58L4XrACYieQuM412TJuJoD+QYBb=qOcN1MtwdVAPzn2Q@mail.gmail.com>
Subject: Re: [PATCH v4] kvm: Fix page ageing bugs
From: Andres Lagar-Cavilla <andreslc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Gleb Natapov <gleb@kernel.org>, Radim Krcmar <rkrcmar@redhat.com>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Peter Feiner <pfeiner@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andres Lagar-Cavilla <andreslc@gooogle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 12:49 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
> Il 22/09/2014 23:54, Andres Lagar-Cavilla ha scritto:
>> @@ -1406,32 +1406,24 @@ static int kvm_age_rmapp(struct kvm *kvm, unsigned long *rmapp,
>>       struct rmap_iterator uninitialized_var(iter);
>>       int young = 0;
>>
>> -     /*
>> -      * In case of absence of EPT Access and Dirty Bits supports,
>> -      * emulate the accessed bit for EPT, by checking if this page has
>> -      * an EPT mapping, and clearing it if it does. On the next access,
>> -      * a new EPT mapping will be established.
>> -      * This has some overhead, but not as much as the cost of swapping
>> -      * out actively used pages or breaking up actively used hugepages.
>> -      */
>> -     if (!shadow_accessed_mask) {
>> -             young = kvm_unmap_rmapp(kvm, rmapp, slot, data);
>> -             goto out;
>> -     }
>> +     BUG_ON(!shadow_accessed_mask);
>>
>>       for (sptep = rmap_get_first(*rmapp, &iter); sptep;
>>            sptep = rmap_get_next(&iter)) {
>> +             struct kvm_mmu_page *sp;
>> +             gfn_t gfn;
>>               BUG_ON(!is_shadow_present_pte(*sptep));
>> +             /* From spte to gfn. */
>> +             sp = page_header(__pa(sptep));
>> +             gfn = kvm_mmu_page_get_gfn(sp, sptep - sp->spt);
>>
>>               if (*sptep & shadow_accessed_mask) {
>>                       young = 1;
>>                       clear_bit((ffs(shadow_accessed_mask) - 1),
>>                                (unsigned long *)sptep);
>>               }
>> +             trace_kvm_age_page(gfn, slot, young);
>
> Yesterday I couldn't think of a way to avoid the
> page_header/kvm_mmu_page_get_gfn on every iteration, but it's actually
> not hard.  Instead of passing hva as datum, you can pass (unsigned long)
> &start.  Then you can add PAGE_SIZE to it at the end of every call to
> kvm_age_rmapp, and keep the old tracing logic.

I'm not sure. The addition is not always by PAGE_SIZE, since it
depends on the current level we are iterating at in the outer
kvm_handle_hva_range(). IOW, could be PMD_SIZE or even PUD_SIZE, and
is_large_pte() enough to tell?

This is probably worth a general fix, I can see all the callbacks
benefiting from knowing the gfn (passed down by
kvm_handle_hva_range()) without any additional computation, and adding
that to a tracing call if they don't already.

Even passing the level down to the callback would help by cutting down
to one arithmetic op (subtract rmapp from slot rmap base pointer for
that level)

Andres
>
>
> Paolo



-- 
Andres Lagar-Cavilla | Google Kernel Team | andreslc@google.com
