Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497Ab3D0QNr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Apr 2013 12:13:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16553 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753425Ab3D0QNq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Apr 2013 12:13:46 -0400
Date: Sat, 27 Apr 2013 18:10:28 +0200
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
Message-ID: <20130427161028.GA27310@redhat.com>
References: <1367002666-6910-1-git-send-email-jacob.shin@amd.com> <1367002666-6910-2-git-send-email-jacob.shin@amd.com> <20130427150510.GA25109@redhat.com> <20130427154026.GA3529@jshin-Toonie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130427154026.GA3529@jshin-Toonie>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27, Jacob Shin wrote:
>
> On Sat, Apr 27, 2013 at 05:05:10PM +0200, Oleg Nesterov wrote:
> > ...
> > > +	if (info->mask)
> > > +		set_dr_addr_mask(0, i);
> >
> > I agree we should clear addr_mask anyway.
> >
> > But I am just curious, what if we do not? I mean what will the hardware
> > do if this breakpoint was already disabled but the mask wasn't cleared?
>
> Oh, it is fine if we don't and we are not using breakpoints, however I
> was trying to account for per-thread events sharing the same DR
> register, in that case we don't want previous event's mask value still
> in the MSR.

Aha, so CPU "remembers" the non-cleared mask and this can affect the
next "enable". Thanks.

> > Suppose that the kernel was compiled without CONFIG_CPU_SUP_AMD.
> > Then perf_event_open(attr => { .bp_len == 16 }) will succeed, but
> > this breakpoint won't actually work as expected?
>
> Well, on non-AMD, even if we have CONFIG_CPU_SUP_AMD=y or not,
> cpu_has_bpext (x86 CPUID check) will fail.
>
> On AMD, if we don't have CONFIG_CPU_SUP_AMD=y then we can't even boot.

Heh, I didn't know ;)

OK, I think the patch is fine then.

Except... cough, the last nit, I promise ;)

Currently this doesn't matter, the only caller of modify_user_hw_breakpoint()
is ptrace, and it can't use bp_len != HW_BREAKPOINT_LEN_*.

But still, I think your patch needs a small fixlet,

	- /* info->len == info->mask == 0 */
	+ info->mask = 0;

Or we can do this later.

And while this is purely cosmetic (feel free to ignore), perhaps we
can join the bp_len checks and move cpu_has_bpext from _validate to
_build, this looks a little bit cleaner imho. IOW,


	info->mask == 0;

	switch (bp->attr.bp_len) {
	default:
		if (!is_power_of_2(bp->attr.bp_len))
			return -EINVAL;
		if (!cpu_has_bpext)
			return -EOPNOTSUPP;
		info->mask = bp->attr.bp_len - 1;
		/* fallthrough */
	case HW_BREAKPOINT_LEN_1:
		info->len = X86_BREAKPOINT_LEN_1;
		break;
	case HW_BREAKPOINT_LEN_2:
		info->len = X86_BREAKPOINT_LEN_2;
		break;
	case HW_BREAKPOINT_LEN_4:
		info->len = X86_BREAKPOINT_LEN_4;
		break;
#ifdef CONFIG_X86_64
	case HW_BREAKPOINT_LEN_8:
		info->len = X86_BREAKPOINT_LEN_8;
		break;
#endif
	}

Then arch_validate_hwbkpt_settings() only needs

		case X86_BREAKPOINT_LEN_1:
			align = 0;
	+	if (info->mask)
	+		align = mask;

change.

Oleg.

