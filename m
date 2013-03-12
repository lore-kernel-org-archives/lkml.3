Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702Ab3CLVOR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 17:14:17 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:48476 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754527Ab3CLVOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 17:14:16 -0400
Message-ID: <513F9AA4.10005@linaro.org>
Date: Tue, 12 Mar 2013 14:14:12 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Feng Tang <feng.tang@intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, x86@kernel.org,
        Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org, gong.chen@linux.intel.com
Subject: Re: [PATCH v4 1/4] x86: Add cpu capability flag X86_FEATURE_NONSTOP_TSC_S3
References: <1363060608-22657-1-git-send-email-feng.tang@intel.com> <1363060608-22657-2-git-send-email-feng.tang@intel.com>
In-Reply-To: <1363060608-22657-2-git-send-email-feng.tang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2013 08:56 PM, Feng Tang wrote:
> On some new Intel Atom processors (Penwell and Cloverview), there is
> a feature that the TSC won't stop in S3 state, say the TSC value
> won't be reset to 0 after resume. This feature makes TSC a more reliable
> clocksource and could benefit the timekeeping code during system
> suspend/resume cycle, so add a flag for it.
>
> Signed-off-by: Feng Tang <feng.tang@intel.com>
> ---
>   arch/x86/include/asm/cpufeature.h |    1 +
>   arch/x86/kernel/cpu/intel.c       |   12 ++++++++++++
>   2 files changed, 13 insertions(+)
>
> diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
> index 93fe929..a8466f2 100644
> --- a/arch/x86/include/asm/cpufeature.h
> +++ b/arch/x86/include/asm/cpufeature.h
> @@ -100,6 +100,7 @@
>   #define X86_FEATURE_AMD_DCM     (3*32+27) /* multi-node processor */
>   #define X86_FEATURE_APERFMPERF	(3*32+28) /* APERFMPERF */
>   #define X86_FEATURE_EAGER_FPU	(3*32+29) /* "eagerfpu" Non lazy FPU restore */
> +#define X86_FEATURE_NONSTOP_TSC_S3 (3*32+30) /* TSC doesn't stop in S3 state */
>   
>   /* Intel-defined CPU features, CPUID level 0x00000001 (ecx), word 4 */
>   #define X86_FEATURE_XMM3	(4*32+ 0) /* "pni" SSE-3 */
> diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
> index 1905ce9..fe57544 100644
> --- a/arch/x86/kernel/cpu/intel.c
> +++ b/arch/x86/kernel/cpu/intel.c
> @@ -96,6 +96,18 @@ static void __cpuinit early_init_intel(struct cpuinfo_x86 *c)
>   			sched_clock_stable = 1;
>   	}
>   
> +	/* Penwell and Cloverview have the TSC which doesn't sleep on S3 */
> +	if (c->x86 == 6) {
> +		switch (c->x86_model) {
> +		case 0x27:	/* Penwell */
> +		case 0x35:	/* Cloverview */
> +			set_cpu_cap(c, X86_FEATURE_NONSTOP_TSC_S3);
> +			break;
> +		default:
> +			;

Just FYI, checkpatch.sh complains that this should be
     default:
         break;

I've gone ahead and fixed that, but you might be sure to run checkpatch 
in the future before submitting.

thanks
-john

