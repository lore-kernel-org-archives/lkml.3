Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943Ab3LPI0k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 03:26:40 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:36881 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636Ab3LPI0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 03:26:39 -0500
Message-ID: <52AEB937.6050704@linaro.org>
Date: Mon, 16 Dec 2013 16:26:31 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, Mel Gorman <mgorman@suse.de>,
        H Peter Anvin <hpa@zytor.com>, Linux-X86 <x86@kernel.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH 2/3] x86: mm: Change tlb_flushall_shift for IvyBridge
References: <1386849309-22584-1-git-send-email-mgorman@suse.de> <1386849309-22584-3-git-send-email-mgorman@suse.de> <20131212131309.GD5806@gmail.com> <52A9BC3A.7010602@linaro.org> <20131212141147.GB17059@gmail.com> <52AA5C92.7030207@linaro.org> <52AA6CB9.60302@linaro.org> <20131214141902.GA16438@laptop.programming.kicks-ass.net>
In-Reply-To: <20131214141902.GA16438@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2013 10:19 PM, Peter Zijlstra wrote:
> On Fri, Dec 13, 2013 at 10:11:05AM +0800, Alex Shi wrote:
>> BTW,
>> A bewitching idea is till attracting me.
>> https://lkml.org/lkml/2012/5/23/148
>> Even it was sentenced to death by HPA.
>> https://lkml.org/lkml/2012/5/24/143
>>
>> That is that just flush one of thread TLB is enough for SMT/HT, seems
>> TLB is still shared in core on Intel CPU. This benefit is unconditional,
>> and if my memory right, Kbuild testing can improve about 1~2% in average
>> level.
>>
>> So could you like to accept some ugly quirks to do this lazy TLB flush
>> on known working CPU?
>> Forgive me if it's stupid.
> 
> I think there's a further problem with that patch -- aside of it being
> right from a hardware point of view.
> 
> We currently rely on the tlb flush IPI to synchronize with lockless page
> table walkers like gup_fast().

I am sorry if I miss sth. :)

But if my understand correct, in the example of gup_fast, wait_split_huge_page
will never goes to BUG_ON(). Since the flush TLB IPI still be sent out to clear
each of _PAGE_SPLITTING on each CPU core. This patch just stop repeat TLB flush
in another SMT on same core. If there only noe SMT affected, the flush still be 
executed on it.

#define wait_split_huge_page(__anon_vma, __pmd)                         \
        do {                                                            \
                pmd_t *____pmd = (__pmd);                               \
                anon_vma_lock_write(__anon_vma);                        \
                anon_vma_unlock_write(__anon_vma);                      \
                BUG_ON(pmd_trans_splitting(*____pmd) ||                 \
                       pmd_trans_huge(*____pmd));                       \
        } while (0)

> 
> By not sending an IPI to all CPUs you can get into trouble and crash the
> kernel.
> 
> We absolutely must keep sending the IPI to all relevant CPUs, we can
> choose not to actually do the flush on some CPUs, but we must keep
> sending the IPI.
> 


-- 
Thanks
    Alex
