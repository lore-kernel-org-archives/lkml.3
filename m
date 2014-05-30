Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932953AbaE3Ndv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 09:33:51 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:41019 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbaE3Ndm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 09:33:42 -0400
Date: Fri, 30 May 2014 15:33:34 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Jacob Shin <jacob.w.shin@gmail.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, xiakaixu <xiakaixu@huawei.com>
Subject: Re: [PATCH 1/4] perf/x86/amd: AMD support for bp_len >
 HW_BREAKPOINT_LEN_8
Message-ID: <20140530133332.GC25555@localhost.localdomain>
References: <1401377213-24551-1-git-send-email-fweisbec@gmail.com>
 <1401377213-24551-2-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401377213-24551-2-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jacob, Suravee,

On Thu, May 29, 2014 at 05:26:50PM +0200, Frederic Weisbecker wrote:
> From: Jacob Shin <jacob.w.shin@gmail.com>
> 
> Implement hardware breakpoint address mask for AMD Family 16h and
> above processors. CPUID feature bit indicates hardware support for
> DRn_ADDR_MASK MSRs. These masks further qualify DRn/DR7 hardware
> breakpoint addresses to allow matching of larger addresses ranges.
> 
> Valuable advice and pseudo code from Oleg Nesterov <oleg@redhat.com>
> 
> Signed-off-by: Jacob Shin <jacob.w.shin@gmail.com>
> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Oleg Nesterov <oleg@redhat.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: xiakaixu <xiakaixu@huawei.com>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  arch/x86/include/asm/cpufeature.h     |  2 ++
>  arch/x86/include/asm/debugreg.h       |  5 +++++
>  arch/x86/include/asm/hw_breakpoint.h  |  1 +
>  arch/x86/include/uapi/asm/msr-index.h |  4 ++++
>  arch/x86/kernel/cpu/amd.c             | 19 +++++++++++++++++++
>  arch/x86/kernel/hw_breakpoint.c       | 20 ++++++++++++++++----
>  6 files changed, 47 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
> index e265ff9..6bd564d 100644
> --- a/arch/x86/include/asm/cpufeature.h
> +++ b/arch/x86/include/asm/cpufeature.h
> @@ -170,6 +170,7 @@
>  #define X86_FEATURE_TOPOEXT	(6*32+22) /* topology extensions CPUID leafs */
>  #define X86_FEATURE_PERFCTR_CORE (6*32+23) /* core performance counter extensions */
>  #define X86_FEATURE_PERFCTR_NB  (6*32+24) /* NB performance counter extensions */
> +#define X86_FEATURE_BPEXT	(6*32+26) /* data breakpoint extension */
>  #define X86_FEATURE_PERFCTR_L2	(6*32+28) /* L2 performance counter extensions */
>  
>  /*
> @@ -338,6 +339,7 @@ extern const char * const x86_power_flags[32];
>  #define cpu_has_cx16		boot_cpu_has(X86_FEATURE_CX16)
>  #define cpu_has_eager_fpu	boot_cpu_has(X86_FEATURE_EAGER_FPU)
>  #define cpu_has_topoext		boot_cpu_has(X86_FEATURE_TOPOEXT)
> +#define cpu_has_bpext		boot_cpu_has(X86_FEATURE_BPEXT)
>  
>  #ifdef CONFIG_X86_64
>  
> diff --git a/arch/x86/include/asm/debugreg.h b/arch/x86/include/asm/debugreg.h
> index 4b528a9..145b009 100644
> --- a/arch/x86/include/asm/debugreg.h
> +++ b/arch/x86/include/asm/debugreg.h
> @@ -114,5 +114,10 @@ static inline void debug_stack_usage_inc(void) { }
>  static inline void debug_stack_usage_dec(void) { }
>  #endif /* X86_64 */
>  
> +#ifdef CONFIG_CPU_SUP_AMD
> +extern void set_dr_addr_mask(unsigned long mask, int dr);
> +#else
> +static inline void set_dr_addr_mask(unsigned long mask, int dr) { }
> +#endif

I see this symbol in the code but it's not defined anywhere in a Kconfig file.
Maybe you (or I) forgot to include a file in your patches?

Thanks.
