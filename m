Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759497AbaGCRyn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 13:54:43 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:60005 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755457AbaGCRym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 13:54:42 -0400
Date: Thu, 3 Jul 2014 18:54:12 +0100
From: Will Deacon <will.deacon@arm.com>
To: Jean Pihet <jean.pihet@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Sneha Priya <sneha.cse@hotmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Subject: Re: [PATCH 3/3] ARM: perf: allow tracing with kernel tracepoints
 events
Message-ID: <20140703175412.GH17372@arm.com>
References: <1403881067-22690-1-git-send-email-jean.pihet@linaro.org>
 <1403881067-22690-4-git-send-email-jean.pihet@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403881067-22690-4-git-send-email-jean.pihet@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2014 at 03:57:47PM +0100, Jean Pihet wrote:
> When tracing with tracepoints events the IP and CPSR are set to 0,
> preventing the perf code to resolve the symbols:
> 
> ./perf record -e kmem:kmalloc cal
> [ perf record: Woken up 1 times to write data ]
> [ perf record: Captured and wrote 0.007 MB perf.data (~321 samples) ]
> 
> ./perf report
> Overhead Command Shared Object Symbol
> ........ ....... ............. ...........
> 40.78%   cal     [unknown]     [.]00000000
> 31.6%    cal     [unknown]     [.]00000000
> 
> The examination of the gathered samples (perf report -D) shows the IP
> is set to 0 and that the samples are considered as user space samples,
> while the IP should be set from the registers and the samples should be
> considered as kernel samples.
> 
> The fix is to implement perf_arch_fetch_caller_regs for ARM, which
> fills the necessary registers used for the callchain unwinding and
> to determine the user/kernel space property of the samples: ip, sp, fp
> and cpsr.
> 
> Tested with perf record and tracepoints triggering (-e <tracepoint>), with
> unwinding using fp (--call-graph fp) and dwarf info (--call-graph dwarf).
> 
> Reported by Sneha Priya on linaro-dev, cf.
> http://lists.linaro.org/pipermail/linaro-dev/2014-May/017151.html
> 
> Signed-off-by: Jean Pihet <jean.pihet@linaro.org>
> Cc: Will Deacon <will.deacon@arm.com>
> Reported-by: Sneha Priya <sneha.cse@hotmail.com>
> ---
>  arch/arm/include/asm/perf_event.h | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> diff --git a/arch/arm/include/asm/perf_event.h b/arch/arm/include/asm/perf_event.h
> index 7558775..b02b5d3 100644
> --- a/arch/arm/include/asm/perf_event.h
> +++ b/arch/arm/include/asm/perf_event.h
> @@ -26,6 +26,25 @@ struct pt_regs;
>  extern unsigned long perf_instruction_pointer(struct pt_regs *regs);
>  extern unsigned long perf_misc_flags(struct pt_regs *regs);
>  #define perf_misc_flags(regs)	perf_misc_flags(regs)
> +
> +/*
> + * Take a snapshot of the regs.
> + * We only need a few of the regs:
> + * - ip for PERF_SAMPLE_IP,
> + * - sp & fp for fp & dwarf based callchain unwinding,
> + * - cpsr for user_mode() tests.
> + */
> +#define perf_arch_fetch_caller_regs(regs, __ip) {	\
> +	instruction_pointer(regs)= (__ip);		\
> +	__asm__ (					\
> +		"str	sp, %[_ARM_sp]		\n\t"	\
> +		"str	fp, %[_ARM_fp]		\n\t"	\
> +		"mrs	%[_ARM_cpsr], cpsr	\n\t"	\
> +		: [_ARM_sp]   "=m" (regs->ARM_sp),	\
> +		  [_ARM_fp]   "=m" (regs->ARM_fp),	\
> +		  [_ARM_cpsr] "=r" (regs->ARM_cpsr)	\
> +	);						\
> +}

You don't appear to have addressed my comments from last time. What changed?

Will
