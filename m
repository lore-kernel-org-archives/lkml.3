Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209Ab3LNLBp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 06:01:45 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:53164 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126Ab3LNLBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 06:01:43 -0500
Message-ID: <52AC3A8E.7040603@linaro.org>
Date: Sat, 14 Dec 2013 19:01:34 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Mel Gorman <mgorman@suse.de>, H Peter Anvin <hpa@zytor.com>,
        Linux-X86 <x86@kernel.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Fengguang Wu <fengguang.wu@intel.com>
Subject: Re: [PATCH 2/3] x86: mm: Change tlb_flushall_shift for IvyBridge
References: <1386849309-22584-1-git-send-email-mgorman@suse.de> <1386849309-22584-3-git-send-email-mgorman@suse.de> <20131212131309.GD5806@gmail.com> <52A9BC3A.7010602@linaro.org> <20131212141147.GB17059@gmail.com> <52AA5C92.7030207@linaro.org> <52AA6CB9.60302@linaro.org> <20131213134304.GB11176@gmail.com>
In-Reply-To: <20131213134304.GB11176@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2013 09:43 PM, Ingo Molnar wrote:
> 
> * Alex Shi <alex.shi@linaro.org> wrote:
> 
>> On 12/13/2013 09:02 AM, Alex Shi wrote:
>>>>> You have not replied to this concern of mine: if my concern is valid 
>>>>> then that invalidates much of the current tunings.
>>> The benefit from pretend flush range is not unconditional, since invlpg
>>> also cost time. And different CPU has different invlpg/flush_all
>>> execution time. 
>>
>> TLB refill time is also different on different kind of cpu.
>>
>> BTW,
>> A bewitching idea is till attracting me.
>> https://lkml.org/lkml/2012/5/23/148
>> Even it was sentenced to death by HPA.
>> https://lkml.org/lkml/2012/5/24/143
> 
> I don't think it was sentenced to death by HPA. What do the hardware 
> guys say, is this safe on current CPUs?

This talking is fully public, no any other info I known.
At that time, I tried core2, nhm, wsm, snd, ivb, all kinds of machine I
can get. No issue found.

And assuming a rebase patch is testing in Fengguang's testing system
from last Friday, no bad news till now.
Fengugang, x86-tlb branch on my github tree.
> 
> If yes then as long as we only activate this optimization for known 
> models (and turn it off for unknown models) we should be pretty safe, 
> even if the hw guys (obviously) don't want to promise this 
> indefinitely for all Intel HT implementations in the future, right?

Agree with you.
> 
>> That is that just flush one of thread TLB is enough for SMT/HT, 
>> seems TLB is still shared in core on Intel CPU. This benefit is 
>> unconditional, and if my memory right, Kbuild testing can improve 
>> about 1~2% in average level.
> 
> Oh, a 1-2% kbuild speedup is absolutely _massive_. Don't even think 
> about dropping this idea ... it needs to be explored.
> 
> Alas, that for_each_cpu() loop is obviously disgusting, these values 
> should be precalculated into percpu variables and such.

yes, pr-calcucatied variable would save much time.
> 
>> So could you like to accept some ugly quirks to do this lazy TLB 
>> flush on known working CPU?
> 
> it's not really 'lazy TLB flush' AFAICS but a genuine optimization: 
> only flush the TLB on the logical CPUs that need it, right? I.e. do 
> only one flush per pair of siblings.
> 
>> Forgive me if it's stupid.
> 
> I'd say measurable speedups that are safe are never ever stupid.

Thanks a lot!
> 
> And even the range-flush TLB optimization we are talking about here 
> could still be used IMO, just tone it down a bit and make it less 
> model dependent.
> 
> Thanks,
> 
> 	Ingo
> 


-- 
Thanks
    Alex
