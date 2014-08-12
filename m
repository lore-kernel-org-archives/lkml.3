Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108AbaHLFvP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 01:51:15 -0400
Received: from mail-oi0-f41.google.com ([209.85.218.41]:64923 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbaHLFvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 01:51:14 -0400
X-Greylist: delayed 333 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Aug 2014 01:51:14 EDT
MIME-Version: 1.0
In-Reply-To: <1407802290-619-1-git-send-email-andi@firstfloor.org>
References: <1407802290-619-1-git-send-email-andi@firstfloor.org>
Date: Tue, 12 Aug 2014 07:45:41 +0200
Message-ID: <CABPqkBSJEtH8tL7DM_fWAMgWL6X9oOnJTGF1rwxxBQ8dQK13sQ@mail.gmail.com>
Subject: Re: [PATCH] perf, x86: Use extended offcore mask on Haswell
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2014 at 2:11 AM, Andi Kleen <andi@firstfloor.org> wrote:
> From: Andi Kleen <ak@linux.intel.com>
>
> HSW-EP has a larger offcore mask than the client Haswell CPUs.
> It is the same mask as on Sandy/IvyBridge-EP. All of
> Haswell was using the client mask, so some bits were missing.
>
> On the client parts some bits were also missing compared
> to Sandy/IvyBridge, in particular the bits to match on a L4
> cache hit.
>
> The Haswell core in both client and server incarnations
> accepts the same bits (but some are nops), so we can use
> the same mask.
>
> So use the snbep extended mask, which is a superset of the
> client and the server, for all of Haswell.
>
> This allows specifying a number of extra offcore events, like
> for example for HSW-EP.
>
> % perf stat -e cpu/event=0xb7,umask=0x1,offcore_rsp=0x3fffc00100,name=offcore_response_pf_l3_rfo_l3_miss_any_response/ true
>
> which were <not supported> before.
>
I tested this on my HSW desktop including the bits only defined for
servers and everything is fine.
It does simplify the code,though desktop parts always come first, so
there will always be patching.
Also if this works on HSW/HSX, I wonder if we could not simplify the
same code for IVB/IVT and SNB/SNBEP.

Reviewed-by: Stephane Eranian <eranian@google.com>

> v2: Post correct patch.
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/perf_event_intel.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
> index 2502d0d..4648a1b 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> @@ -2552,7 +2552,7 @@ __init int intel_pmu_init(void)
>
>                 x86_pmu.event_constraints = intel_hsw_event_constraints;
>                 x86_pmu.pebs_constraints = intel_hsw_pebs_event_constraints;
> -               x86_pmu.extra_regs = intel_snb_extra_regs;
> +               x86_pmu.extra_regs = intel_snbep_extra_regs;
>                 x86_pmu.pebs_aliases = intel_pebs_aliases_snb;
>                 /* all extra regs are per-cpu when HT is on */
>                 x86_pmu.er_flags |= ERF_HAS_RSP_1;
> --
> 1.9.3
>
