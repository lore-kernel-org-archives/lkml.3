Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751679Ab3IZO02 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 10:26:28 -0400
Received: from us01smtp2.synopsys.com ([198.182.44.80]:42809 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab3IZO01 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 10:26:27 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: "arc-linux-dev@synopsys.com" <arc-linux-dev@synopsys.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Mischa Jonker <Mischa.Jonker@synopsys.com>
Subject: Re: [arc-linux-dev] [PATCH] ARC: Fix array-out-of-bounds issue in
 tlb overlap handler
Thread-Topic: [arc-linux-dev] [PATCH] ARC: Fix array-out-of-bounds issue in
 tlb overlap handler
Thread-Index: AQHOusGKLl2fRh2O10CHc4PAGOZKfQ==
Date: Thu, 26 Sep 2013 14:26:22 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA2307514E9B0@IN01WEMBXA.internal.synopsys.com>
References: <1380203182-5982-1-git-send-email-mjonker@synopsys.com>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.12.239.235]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/26/2013 07:36 PM, Mischa Jonker wrote:
> Even after fixing the issue, GCC 4.8 still complains with a warning,
> but with the fix, I think it's a false positive. Therefore I have
> also added a #pragma to ignore the warning.
>
> Signed-off-by: Mischa Jonker <mjonker@synopsys.com>
> ---
>  arch/arc/mm/tlb.c |    9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arc/mm/tlb.c b/arch/arc/mm/tlb.c
> index 129af50..5af7c98 100644
> --- a/arch/arc/mm/tlb.c
> +++ b/arch/arc/mm/tlb.c
> @@ -635,13 +635,20 @@ void do_tlb_overlap_fault(unsigned long cause, unsigned long address,
>  			continue;
>  
>  		/* Scan the set for duplicate ways: needs a nested loop */
> -		for (way = 0; way < mmu->ways; way++) {
> +		for (way = 0; way < (mmu->ways - 1); way++) {
>  			if (!pd0[way])
>  				continue;

While the fix is correct, it's not fixing out-of-bound array access since that is
not what was happening. For the last way, the nested loop will not enter at all -
your fix prevents it from trying to do that - so please fix the changlog.

>  			for (n = way + 1; n < mmu->ways; n++) {
> +/*
> + * GCC 4.8 does not understand that way < (mmu->ways - 1), and as such
> + * n < mmu->ways. So, ignore the warning
> + */
> +#pragma GCC diagnostic push
> +#pragma GCC diagnostic ignored "-Warray-bounds"
>  				if ((pd0[way] & PAGE_MASK) ==
>  				    (pd0[n] & PAGE_MASK)) {
> +#pragma GCC diagnostic pop
>  
>  					if (dup_pd_verbose) {
>  						pr_info("Duplicate PD's @"

I'd prefer the following as it's less uglier.

-       unsigned int pd0[4], pd1[4];    /* assume max 4 ways */
        unsigned long flags, is_valid;
        struct cpuinfo_arc_mmu *mmu = &cpuinfo_arc700[smp_processor_id()].mmu;
+      unsigned int pd0[mmu->ways], pd1[mmu->ways];
 
-Vineet
