Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755461AbaJWMQY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 08:16:24 -0400
Received: from mail.skyhub.de ([78.46.96.112]:43764 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755237AbaJWMQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 08:16:23 -0400
Date: Thu, 23 Oct 2014 14:16:19 +0200
From: Borislav Petkov <bp@alien8.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@kernel.org, tglx@linutronix.de, ak@linux.intel.com,
        eranian@google.com, dzickus@redhat.com, andi@firstfloor.org,
        jmario@redhat.com, acme@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] perf,x86: De-obfuscate HSW offcore bits
Message-ID: <20141023121619.GB4643@pd.tnic>
References: <20141023105119.173457103@infradead.org>
 <20141023105658.111371548@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141023105658.111371548@infradead.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 12:51:20PM +0200, Peter Zijlstra wrote:
> Andi introduced the HSW cache events array, but used magic constants
> against convention as set by all the other uarchs. Try and deobfuscate
> these a bit.
> 
> This patch should not change the actual values generated; however
> weird they seems.
> 
> In that patch Andi also said there were differences between the
> SNB/IVB and HSW/BDW offcore tables but failed to specify which and
> why.
> 
> Fixes: 86a349a28b24 ("perf/x86/intel: Add Broadwell core support")
> Cc: Andi Kleen <ak@linux.intel.com>
> Cc: Stephane Eranian <eranian@google.com>
> Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> Link: http://lkml.kernel.org/n/tip-@git.kernel.org

This link looks funny.

> ---
>  arch/x86/kernel/cpu/perf_event_intel.c |   48 +++++++++++++++++++++++++++------
>  1 file changed, 40 insertions(+), 8 deletions(-)
> 
> --- a/arch/x86/kernel/cpu/perf_event_intel.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> @@ -247,6 +247,7 @@ static u64 intel_pmu_event_map(int hw_ev
>  #define SNB_BUS_LOCKS		(1ULL << 10)
>  #define SNB_STRM_ST		(1ULL << 11)
>  #define SNB_OTHER		(1ULL << 15)
> +
>  #define SNB_RESP_ANY		(1ULL << 16)
>  #define SNB_NO_SUPP		(1ULL << 17)
>  #define SNB_LLC_HITM		(1ULL << 18)
> @@ -255,6 +256,7 @@ static u64 intel_pmu_event_map(int hw_ev
>  #define SNB_LLC_HITF		(1ULL << 21)
>  #define SNB_LOCAL		(1ULL << 22)
>  #define SNB_REMOTE		(0xffULL << 23)
> +
>  #define SNB_SNP_NONE		(1ULL << 31)
>  #define SNB_SNP_NOT_NEEDED	(1ULL << 32)
>  #define SNB_SNP_MISS		(1ULL << 33)
> @@ -519,6 +521,40 @@ static __initconst const u64 hsw_hw_cach
>   },
>  };
>  
> +/* HSW Request type */
> +#define HSW_DMND_DATA_RD	(1ULL << 0)
> +#define HSW_DMND_RFO		(1ULL << 1)
> +#define HSW_DMND_IFETCH		(1ULL << 2)
> +
> +#define HSW_PF_DATA_RD		(1ULL << 4)
> +#define HSW_PF_RFO		(1ULL << 5)
> +#define HSW_PF_IFETCH		(1ULL << 6)
> +
> +#define HSW_OTHER		(1ULL << 15)
> +
> +/* HSW Supplier info := SNB Supplier info */
> +/* HSW Snoop Info := SNB Snoop Info */
> +
> +/*
> + * SNB_LLC_* is specified as 'reserved' in the SDM
> + * but Andi added it anyhow, suggesting HSW/BDW have it just fine
> + *
> + * XXX NHM/WSM/SNB/IVB don't have the PF/IFETCH bits set
> + */
> +#define HSW_DMND_READ		(HSW_DMND_DATA_RD|HSW_DMND_IFETCH| \
> +				 HSW_PF_DATA_RD|HSW_PF_IFETCH| \
> +				 SNB_LLC_DATA_RD|SNB_LLC_IFETCH)
> +
> +/* XXX NHM/WSM/SNB/IVB dont have the PF bits set */
> +#define HSW_DMND_WRITE		(HSW_DMND_RFO|HSW_PF_RFO|SNB_LLC_RFO)
> +
> +#define HSW_DMND_PREFETCH	(0) /* XXX broken ? */
> +
> +#define HSW_DRAM_ANY		(SNB_NO_SUPP|SNB_SNP_ANY|(0x78ULL << 23)) /* WTF */
> +
> +#define HSW_L3_ACCESS		(0) /* XXX no supplier! */
> +#define NSW_L3_MISS		(HSW_DRAM_ANY|SNB_NON_DRAM)

You probably mean HSW and not NSW here...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
