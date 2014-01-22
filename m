Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755254AbaAVK7P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 05:59:15 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:50916 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754704AbaAVK7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 05:59:12 -0500
Date: Wed, 22 Jan 2014 10:58:40 +0000
From: Will Deacon <will.deacon@arm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Neil Leeder <nleeder@codeaurora.org>,
        Ashwin Chaugule <ashwinc@codeaurora.org>
Subject: Re: [PATCH v2 5/7] ARM: perf_event: Fully support Krait CPU PMU
 events
Message-ID: <20140122105840.GD1621@mudshark.cambridge.arm.com>
References: <1389808535-23852-1-git-send-email-sboyd@codeaurora.org>
 <1389808535-23852-6-git-send-email-sboyd@codeaurora.org>
 <20140121180711.GN30706@mudshark.cambridge.arm.com>
 <52DEBE6B.7000904@codeaurora.org>
 <52DEEDDA.4060302@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52DEEDDA.4060302@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 09:59:54PM +0000, Stephen Boyd wrote:
> On 01/21/14 10:37, Stephen Boyd wrote:
> > On 01/21/14 10:07, Will Deacon wrote:
> >> Finally, I'd really like to see this get some test coverage, but I don't
> >> want to try running mainline on my phone :) Could you give your patches a
> >> spin with Vince's perf fuzzer please?
> >>
> >>   https://github.com/deater/perf_event_tests.git
> >>
> >> (then build the contents of the fuzzer directory and run it for as long as
> >> you can).
> >>
> > Ok. I'll see what I can do.
> 
> Neat. This quickly discovered a problem.

Yeah, the fuzzer is good at that!

> BUG: using smp_processor_id() in preemptible [00000000] code: perf_fuzzer/70
> caller is krait_pmu_get_event_idx+0x58/0xd8
> CPU: 2 PID: 70 Comm: perf_fuzzer Not tainted 3.13.0-rc7-next-20140108-00041-gb038353c8516-dirty #58
> [<c02165dc>] (unwind_backtrace) from [<c0212ffc>] (show_stack+0x10/0x14)
> [<c0212ffc>] (show_stack) from [<c06ad5fc>] (dump_stack+0x6c/0xb8)
> [<c06ad5fc>] (dump_stack) from [<c04b0928>] (debug_smp_processor_id+0xc4/0xe8)
> [<c04b0928>] (debug_smp_processor_id) from [<c021a19c>] (krait_pmu_get_event_idx+0x58/0xd8)
> [<c021a19c>] (krait_pmu_get_event_idx) from [<c021833c>] (validate_event+0x2c/0x54)
> [<c021833c>] (validate_event) from [<c02186b4>] (armpmu_event_init+0x264/0x2dc)
> [<c02186b4>] (armpmu_event_init) from [<c02b28e4>] (perf_init_event+0x138/0x194)
> [<c02b28e4>] (perf_init_event) from [<c02b2c04>] (perf_event_alloc+0x2c4/0x348)
> [<c02b2c04>] (perf_event_alloc) from [<c02b37e4>] (SyS_perf_event_open+0x7b8/0x9cc)
> [<c02b37e4>] (SyS_perf_event_open) from [<c020ef80>] (ret_fast_syscall+0x0/0x48)
> 
> This is happening because the pmresrn_used mask is per-cpu but
> validate_group() is called in preemptible context. It looks like we'll
> need to add another unsigned long * field to struct pmu_hw_events just
> for Krait purposes? Or we could use the upper 16 bits of the used_mask
> bitmap to hold the pmresr_used values? Sounds sort of hacky but it
> avoids adding another bitmap for every PMU user and there aren't any
> Krait CPUs with more than 5 counters anyway.

I'm fine with that approach, but a comment saying what we're doing with
those upper bits wouldn't go amiss.

> This is the diff for the latter version. I'll let the fuzzer run overnight.

Cheers,

Will
