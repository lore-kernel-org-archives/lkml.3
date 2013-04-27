Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630Ab3D0PId (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 11:08:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1496 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753549Ab3D0PIc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 11:08:32 -0400
Date: Sat, 27 Apr 2013 17:05:10 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Jacob Shin <jacob.shin@amd.com>
Cc: Ingo Molnar <mingo@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org, Stephane Eranian <eranian@google.com>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 1/3] perf/x86/amd: AMD support for bp_len >
	HW_BREAKPOINT_LEN_8
Message-ID: <20130427150510.GA25109@redhat.com>
References: <1367002666-6910-1-git-send-email-jacob.shin@amd.com> <1367002666-6910-2-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367002666-6910-2-git-send-email-jacob.shin@amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26, Jacob Shin wrote:
>
> Implement hardware breakpoint address mask for AMD Family 16h and
> above processors. CPUID feature bit indicates hardware support for
> DRn_ADDR_MASK MSRs. These masks further qualify DRn/DR7 hardware
> breakpoint addresses to allow matching of larger addresses ranges.

Imho, looks good.

Just one nit and one question below.

> @@ -163,29 +165,8 @@ void arch_uninstall_hw_breakpoint(struct perf_event *bp)
>  	*dr7 &= ~__encode_dr7(i, info->len, info->type);
...
> +	if (info->mask)
> +		set_dr_addr_mask(0, i);

I agree we should clear addr_mask anyway.

But I am just curious, what if we do not? I mean what will the hardware
do if this breakpoint was already disabled but the mask wasn't cleared?

> @@ -314,11 +300,14 @@ int arch_validate_hwbkpt_settings(struct perf_event *bp)
>  	if (ret)
>  		return ret;
>  
> -	ret = -EINVAL;
> -
>  	switch (info->len) {
>  	case X86_BREAKPOINT_LEN_1:
>  		align = 0;
> +		if (info->mask) {
> +			if (!cpu_has_bpext)
> +				return -EOPNOTSUPP;
> +			align = info->mask;

OK. But it seems we need a CONFIG_CPU_SUP_AMD-dependant helper for
this cpu_has_bpext check? (like we have the nop set_dr_addr_mask()
variant if !CONFIG_CPU_SUP_AMD).

Suppose that the kernel was compiled without CONFIG_CPU_SUP_AMD.
Then perf_event_open(attr => { .bp_len == 16 }) will succeed, but
this breakpoint won't actually work as expected?

Oleg.

