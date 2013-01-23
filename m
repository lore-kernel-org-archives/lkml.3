Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934Ab3AWDul (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 22:50:41 -0500
Received: from ozlabs.org ([203.10.76.45]:60787 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752351Ab3AWDuk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 22:50:40 -0500
Message-ID: <1358913038.29791.26.camel@concordia>
Subject: Re: [PATCH 1/6][v3] perf/Power7: Use macros to identify perf events
From: Michael Ellerman <michael@ellerman.id.au>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Andi Kleen <ak@linux.intel.com>,
        robert.richter@amd.com, Anton Blanchard <anton@au1.ibm.com>,
        linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        linuxppc-dev@ozlabs.org,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Olsa <jolsa@redhat.com>
Date: Wed, 23 Jan 2013 14:50:38 +1100
In-Reply-To: <20130110010347.GA32590@us.ibm.com>
References: <20130110010347.GA32590@us.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-09 at 17:03 -0800, Sukadev Bhattiprolu wrote:
> [PATCH 1/6][v3] perf/Power7: Use macros to identify perf events
> 
> Define and use macros to identify perf events codes. This would make it
> easier and more readable when these event codes need to be used in more
> than one place.
> 
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> ---
>  arch/powerpc/perf/power7-pmu.c |   28 ++++++++++++++++++++--------
>  1 files changed, 20 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/powerpc/perf/power7-pmu.c b/arch/powerpc/perf/power7-pmu.c
> index 441af08..44e70d2 100644
> --- a/arch/powerpc/perf/power7-pmu.c
> +++ b/arch/powerpc/perf/power7-pmu.c
> @@ -51,6 +51,18 @@
>  #define MMCR1_PMCSEL_MSK	0xff
>  
>  /*
> + * Power7 event codes.
> + */
> +#define	PME_PM_CYC			0x1e
> +#define	PME_PM_GCT_NOSLOT_CYC		0x100f8
> +#define	PME_PM_CMPLU_STALL		0x4000a
> +#define	PME_PM_INST_CMPL		0x2
> +#define	PME_PM_LD_REF_L1		0xc880
> +#define	PME_PM_LD_MISS_L1		0x400f0
> +#define	PME_PM_BRU_FIN			0x10068
> +#define	PME_PM_BRU_MPRED		0x400f6
> +
> +/*
>   * Layout of constraint bits:
>   * 6666555555555544444444443333333333222222222211111111110000000000
>   * 3210987654321098765432109876543210987654321098765432109876543210
> @@ -296,14 +308,14 @@ static void power7_disable_pmc(unsigned int pmc, unsigned long mmcr[])
>  }
>  
>  static int power7_generic_events[] = {
> -	[PERF_COUNT_HW_CPU_CYCLES] = 0x1e,
> -	[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND] = 0x100f8, /* GCT_NOSLOT_CYC */
> -	[PERF_COUNT_HW_STALLED_CYCLES_BACKEND] = 0x4000a,  /* CMPLU_STALL */
> -	[PERF_COUNT_HW_INSTRUCTIONS] = 2,
> -	[PERF_COUNT_HW_CACHE_REFERENCES] = 0xc880,	/* LD_REF_L1_LSU*/
> -	[PERF_COUNT_HW_CACHE_MISSES] = 0x400f0,		/* LD_MISS_L1	*/
> -	[PERF_COUNT_HW_BRANCH_INSTRUCTIONS] = 0x10068,	/* BRU_FIN	*/
> -	[PERF_COUNT_HW_BRANCH_MISSES] = 0x400f6,	/* BR_MPRED	*/
> +	[PERF_COUNT_HW_CPU_CYCLES] =			PME_PM_CYC,
> +	[PERF_COUNT_HW_STALLED_CYCLES_FRONTEND] =	PME_PM_GCT_NOSLOT_CYC,
> +	[PERF_COUNT_HW_STALLED_CYCLES_BACKEND] =	PME_PM_CMPLU_STALL,
> +	[PERF_COUNT_HW_INSTRUCTIONS] =			PME_PM_INST_CMPL,
> +	[PERF_COUNT_HW_CACHE_REFERENCES] =		PME_PM_LD_REF_L1,
> +	[PERF_COUNT_HW_CACHE_MISSES] =			PME_PM_LD_MISS_L1,


Your patch is good, but raises the question why we're using L1 events
for HW_CACHE.

AFAICS on Intel they use 0x42fe/0x412e, which are last-level-cache (LLC)
events.
        
        PMU name : ix86arch (Intel X86 architectural PMU)
        Name     : LLC_REFERENCES
        Desc     : count each request originating from the core to
        reference a cache line in the last level cache. The count may
        include speculation, but excludes cache line fills due to
        hardware prefetch
        Code     : 0x4f2e

        PMU name : ix86arch (Intel X86 architectural PMU)
        Name     : LLC_MISSES
        Desc     : count each cache miss condition for references to the
        last level cache. The event count may include speculation, but
        excludes cache line fills due to hardware prefetch
        Code     : 0x412e


That would seem to more closely match our PM_L3_LD_HIT/MISS?

cheers



