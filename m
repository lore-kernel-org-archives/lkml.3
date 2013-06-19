Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934741Ab3FSMlb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 08:41:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11197 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934022Ab3FSMl3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 08:41:29 -0400
Message-ID: <51C1A6F0.6000603@redhat.com>
Date: Wed, 19 Jun 2013 14:41:20 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: gleb@redhat.com, avi.kivity@gmail.com, mtosatti@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 2/7] KVM: MMU: document clear_spte_count
References: <1371632965-20077-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1371632965-20077-3-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <51C196E9.2080508@redhat.com> <51C19BA6.2060501@linux.vnet.ibm.com> <51C19C4C.3000800@redhat.com> <51C1A34A.7080201@linux.vnet.ibm.com>
In-Reply-To: <51C1A34A.7080201@linux.vnet.ibm.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 19/06/2013 14:25, Xiao Guangrong ha scritto:
> On 06/19/2013 07:55 PM, Paolo Bonzini wrote:
>> Il 19/06/2013 13:53, Xiao Guangrong ha scritto:
>>> On 06/19/2013 07:32 PM, Paolo Bonzini wrote:
>>>> Il 19/06/2013 11:09, Xiao Guangrong ha scritto:
>>>>> Document it to Documentation/virtual/kvm/mmu.txt
>>>>
>>>> While reviewing the docs, I looked at the code.
>>>>
>>>> Why can't this happen?
>>>>
>>>>     CPU 1: __get_spte_lockless          CPU 2: __update_clear_spte_slow
>>>> ------------------------------------------------------------------------------
>>>>                                         write low
>>>>     read count
>>>>     read low
>>>>     read high
>>>>                                         write high
>>>>     check low and count
>>>>                                         update count
>>>>
>>>> The check passes, but CPU 1 read a "torn" SPTE.
>>>
>>> In this case, CPU 1 will read the "new low bits" and the "old high bits", right?
>>> the P bit in the low bits is cleared when do __update_clear_spte_slow, i.e, it is
>>> not present, so the whole value is ignored.
>>
>> Indeed that's what the comment says, too.  But then why do we need the
>> count at all?  The spte that is read is exactly the same before and
>> after the count is updated.
> 
> In order to detect repeatedly marking spte present to stop the lockless side
> to see present to present change, otherwise, we can get this:
> 
> Say spte = 0xa11110001 (high 32bits = 0xa, low 32bit = 0x11110001)
> 
> CPU 1: __get_spte_lockless          CPU 2: __update_clear_spte_slow
> ----------------------------------------------------------------------
> read low: low= 0x11110001
>                                     clear the spte, then spte = 0x0ull
> read high: high = 0x0
>                                     set spte to 0xb11110001 (high 32bits = 0xb,
>                                     low 32bit = 0x11110001)
> 
> read low: 0x11110001 and see
> it is not changed.
> 
> In this case, CPU 1 see the low bits are not changed, then it tries to access the memory at:
> 0x11110000.

Got it.  What about this in the comment to __get_spte_lockless:

 * The idea using the light way get the spte on x86_32 guest is from
 * gup_get_pte(arch/x86/mm/gup.c).
 *
 * An spte tlb flush may be pending, because kvm_set_pte_rmapp
 * coalesces them and we are running out of the MMU lock.  Therefore
 * we need to protect against in-progress updates of the spte.
 *
 * A race on changing present->non-present may get the old value for
 * the high part of the spte.  This is okay because the high part of
 * the spte is ignored for non-present spte.
 *
 * However, we must detect a present->present change and reread the
 * spte in case the change is in progress.  Because all such changes
 * are done in two steps (present->non-present and non-present->present),
 * it is enough to count the number of present->non-present updates,
 * which is done using clear_spte_count.

Paolo

> BTW, we are using tlb to protect lockless walking, the count can be drop after
> improving kvm_set_pte_rmapp where is the only place change spte from present to present
> without TLB flush.
> 

