Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751696Ab3LLNiN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 08:38:13 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:50034 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab3LLNiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 08:38:09 -0500
Message-ID: <52A9BC3A.7010602@linaro.org>
Date: Thu, 12 Dec 2013 21:38:02 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>, Mel Gorman <mgorman@suse.de>
CC: H Peter Anvin <hpa@zytor.com>, Linux-X86 <x86@kernel.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 2/3] x86: mm: Change tlb_flushall_shift for IvyBridge
References: <1386849309-22584-1-git-send-email-mgorman@suse.de> <1386849309-22584-3-git-send-email-mgorman@suse.de> <20131212131309.GD5806@gmail.com>
In-Reply-To: <20131212131309.GD5806@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2013 09:13 PM, Ingo Molnar wrote:
> 
> * Mel Gorman <mgorman@suse.de> wrote:
> 
>> There was a large performance regression that was bisected to commit 611ae8e3
>> (x86/tlb: enable tlb flush range support for x86). This patch simply changes
>> the default balance point between a local and global flush for IvyBridge.
>>
>> Signed-off-by: Mel Gorman <mgorman@suse.de>
>> ---
>>  arch/x86/kernel/cpu/intel.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
>> index dc1ec0d..2d93753 100644
>> --- a/arch/x86/kernel/cpu/intel.c
>> +++ b/arch/x86/kernel/cpu/intel.c
>> @@ -627,7 +627,7 @@ static void intel_tlb_flushall_shift_set(struct cpuinfo_x86 *c)
>>  		tlb_flushall_shift = 5;
>>  		break;
>>  	case 0x63a: /* Ivybridge */
>> -		tlb_flushall_shift = 1;
>> +		tlb_flushall_shift = 2;
>>  		break;
> 
> I'd not be surprised if other CPU models showed similar weaknesses 
> under ebizzy as well.
> 
> I don't particularly like the tuning aspect of the whole feature: the 
> tunings are model specific and they seem to come out of thin air, 
> without explicit measurements visible.
> 
> In particular the first commit that added this optimization:
> 
>  commit c4211f42d3e66875298a5e26a75109878c80f15b
>  Date:   Thu Jun 28 09:02:19 2012 +0800
> 
>     x86/tlb: add tlb_flushall_shift for specific CPU
> 
> already had these magic tunings, with no explanation about what kind 
> of measurement was done to back up those tunings.
> 
> I don't think this is acceptable and until this is cleared up I think 
> we might be better off turning off this feature altogether, or making 
> a constant, very low tuning point.
> 
> The original code came via:
> 
>   611ae8e3f520 x86/tlb: enable tlb flush range support for x86
> 
> which references a couple of benchmarks, in particular a 
> micro-benchmark:
> 
>   My micro benchmark 'mummap' http://lkml.org/lkml/2012/5/17/59
>   show that the random memory access on other CPU has 0~50% speed up
>   on a 2P * 4cores * HT NHM EP while do 'munmap'.
> 
> if the tunings were done with the micro-benchmark then I think they 
> are bogus, because AFAICS it does not measure the adversarial case of 
> the optimization.
> 
> So I'd say at minimum we need to remove the per model tunings, and 
> need to use very conservative defaults, to make sure we don't slow 
> down reasonable workloads.

I also hate to depends on mysterious hardware differentiation. But there
do have some changes in tlb/cache part on different Intel CPU.(Guess HPA
know this more). And the different shift value get from testing not from
air. :)

> 
> ( In theory madvise() could give us information about the usage 
>   pattern of the vma - but in practice madvise() is rarely used and I 
>   doubt ebizzy or other real-world apps are using it, so it's 
>   meaningless. )
> 
> Thanks,
> 
> 	Ingo
> 


-- 
Thanks
    Alex
