Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755757Ab3D0Pki (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 11:40:38 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:31040 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755278Ab3D0Pkh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 11:40:37 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dI1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzzz2dh668h839h944hd25hd2bhf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1155h)
X-WSS-ID: 0MLX7JG-02-3AA-02
X-M-MSG: 
Date: Sat, 27 Apr 2013 10:40:26 -0500
From: Jacob Shin <jacob.shin@amd.com>
To: Oleg Nesterov <oleg@redhat.com>
CC: Ingo Molnar <mingo@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        <x86@kernel.org>, Stephane Eranian <eranian@google.com>,
        Jiri Olsa <jolsa@redhat.com>, <linux-kernel@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 1/3] perf/x86/amd: AMD support for bp_len >
 HW_BREAKPOINT_LEN_8
Message-ID: <20130427154026.GA3529@jshin-Toonie>
References: <1367002666-6910-1-git-send-email-jacob.shin@amd.com>
 <1367002666-6910-2-git-send-email-jacob.shin@amd.com>
 <20130427150510.GA25109@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130427150510.GA25109@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 27, 2013 at 05:05:10PM +0200, Oleg Nesterov wrote:
> On 04/26, Jacob Shin wrote:
> >
> > Implement hardware breakpoint address mask for AMD Family 16h and
> > above processors. CPUID feature bit indicates hardware support for
> > DRn_ADDR_MASK MSRs. These masks further qualify DRn/DR7 hardware
> > breakpoint addresses to allow matching of larger addresses ranges.
> 
> Imho, looks good.
> 
> Just one nit and one question below.
> 
> > @@ -163,29 +165,8 @@ void arch_uninstall_hw_breakpoint(struct perf_event *bp)
> >  	*dr7 &= ~__encode_dr7(i, info->len, info->type);
> ...
> > +	if (info->mask)
> > +		set_dr_addr_mask(0, i);
> 
> I agree we should clear addr_mask anyway.
> 
> But I am just curious, what if we do not? I mean what will the hardware
> do if this breakpoint was already disabled but the mask wasn't cleared?

Oh, it is fine if we don't and we are not using breakpoints, however I
was trying to account for per-thread events sharing the same DR
register, in that case we don't want previous event's mask value still
in the MSR.

So it was either clear on uninstall, or unconditionally set (even if
the new event's mask should be 0)

> 
> > @@ -314,11 +300,14 @@ int arch_validate_hwbkpt_settings(struct perf_event *bp)
> >  	if (ret)
> >  		return ret;
> >  
> > -	ret = -EINVAL;
> > -
> >  	switch (info->len) {
> >  	case X86_BREAKPOINT_LEN_1:
> >  		align = 0;
> > +		if (info->mask) {
> > +			if (!cpu_has_bpext)
> > +				return -EOPNOTSUPP;
> > +			align = info->mask;
> 
> OK. But it seems we need a CONFIG_CPU_SUP_AMD-dependant helper for
> this cpu_has_bpext check? (like we have the nop set_dr_addr_mask()
> variant if !CONFIG_CPU_SUP_AMD).
> 
> Suppose that the kernel was compiled without CONFIG_CPU_SUP_AMD.
> Then perf_event_open(attr => { .bp_len == 16 }) will succeed, but
> this breakpoint won't actually work as expected?

Well, on non-AMD, even if we have CONFIG_CPU_SUP_AMD=y or not,
cpu_has_bpext (x86 CPUID check) will fail.

On AMD, if we don't have CONFIG_CPU_SUP_AMD=y then we can't even boot.
So I think ... its fine.


> 
> Oleg.
> 
> 

