Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751805AbaKFQeh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 11:34:37 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57104 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751762AbaKFQef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 11:34:35 -0500
Date: Thu, 6 Nov 2014 17:34:30 +0100
From: Borislav Petkov <bp@suse.de>
To: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@kernel.org, tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Len Brown <len.brown@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: Re: [PATCH] perf, amd, ibs: Update IBS MSRs and feature definitions
Message-ID: <20141106163430.GB4737@pd.tnic>
References: <1415291182-4324-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1415291182-4324-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 10:26:22AM -0600, Aravind Gopalakrishnan wrote:
> New Fam15h models carry extra feature bits and extend
> the MSR register space for IBS ops. Adding them here.
> 
> While at it, add functionality to read IbsBrTarget and
> OpData4 depending on their availability if user wants a
> PERF_SAMPLE_RAW.
> 
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Borislav Petkov <bp@suse.de>
> Cc: Jan Kiszka <jan.kiszka@siemens.com>
> Cc: Len Brown <len.brown@intel.com>
> Cc: Fenghua Yu <fenghua.yu@intel.com>
> Signed-off-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
> ---
>  arch/x86/include/asm/perf_event.h        |  3 +++
>  arch/x86/include/uapi/asm/msr-index.h    |  2 ++
>  arch/x86/kernel/cpu/perf_event_amd_ibs.c | 15 +++++++++++++++
>  3 files changed, 20 insertions(+)
> 
> diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
> index 8dfc9fd..dc0f6ed 100644
> --- a/arch/x86/include/asm/perf_event.h
> +++ b/arch/x86/include/asm/perf_event.h
> @@ -177,6 +177,9 @@ struct x86_pmu_capability {
>  #define IBS_CAPS_BRNTRGT		(1U<<5)
>  #define IBS_CAPS_OPCNTEXT		(1U<<6)
>  #define IBS_CAPS_RIPINVALIDCHK		(1U<<7)
> +#define IBS_CAPS_OPBRNFUSE		(1U<<8)
> +#define IBS_CAPS_FETCHCTLEXTD		(1U<<9)
> +#define IBS_CAPS_OPDATA4		(1U<<10)
>  
>  #define IBS_CAPS_DEFAULT		(IBS_CAPS_AVAIL		\
>  					 | IBS_CAPS_FETCHSAM	\
> diff --git a/arch/x86/include/uapi/asm/msr-index.h b/arch/x86/include/uapi/asm/msr-index.h
> index e21331c..ba7b609 100644
> --- a/arch/x86/include/uapi/asm/msr-index.h
> +++ b/arch/x86/include/uapi/asm/msr-index.h
> @@ -206,6 +206,8 @@
>  #define MSR_AMD64_IBSOP_REG_MASK	((1UL<<MSR_AMD64_IBSOP_REG_COUNT)-1)
>  #define MSR_AMD64_IBSCTL		0xc001103a
>  #define MSR_AMD64_IBSBRTARGET		0xc001103b
> +#define MSR_AMD64_IBS_FETCH_EXTD_CTL	0xc001103c
> +#define MSR_AMD64_IBSOPDATA4		0xc001103d
>  #define MSR_AMD64_IBS_REG_COUNT_MAX	8 /* includes MSR_AMD64_IBSBRTARGET */
>  
>  /* Fam 16h MSRs */
> diff --git a/arch/x86/kernel/cpu/perf_event_amd_ibs.c b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
> index cbb1be3e..a61f5c6 100644
> --- a/arch/x86/kernel/cpu/perf_event_amd_ibs.c
> +++ b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
> @@ -565,6 +565,21 @@ static int perf_ibs_handle_irq(struct perf_ibs *perf_ibs, struct pt_regs *iregs)
>  				       perf_ibs->offset_max,
>  				       offset + 1);
>  	} while (offset < offset_max);
> +	if (event->attr.sample_type & PERF_SAMPLE_RAW) {
> +		/*
> +		 * Read IbsBrTarget and IbsOpData4 separately
> +		 * depending on their availability.
> +		 * Can't add to offset_max as they are staggered
> +		 */
> +		if (ibs_caps & IBS_CAPS_BRNTRGT) {
> +			rdmsrl(MSR_AMD64_IBSBRTARGET, *buf++);

Are those MSRs present on everything that supports IBS and if not, you
probably should do rdmsr_safe() here instead and handle the error case.
Or do something with f/m/s checking or so...

> +			size++;
> +		}
> +		if (ibs_caps & IBS_CAPS_OPDATA4) {
> +			rdmsrl(MSR_AMD64_IBSOPDATA4, *buf++);
> +			size++;
> +		}
> +	}
>  	ibs_data.size = sizeof(u64) * size;
>  
>  	regs = *iregs;
> -- 
> 1.9.1
> 

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
