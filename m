Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805AbaGOAln (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 20:41:43 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:45416 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255AbaGOAll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 20:41:41 -0400
MIME-Version: 1.0
In-Reply-To: <1405123575-17113-1-git-send-email-andi@firstfloor.org>
References: <1405123575-17113-1-git-send-email-andi@firstfloor.org>
Date: Tue, 15 Jul 2014 02:41:40 +0200
Message-ID: <CABPqkBS0GB0bu2xRH2B+xc9DU88kfOc8z-T+hDv3_kc+644NjA@mail.gmail.com>
Subject: Re: [PATCH] perf, x86: Widen Haswell OFFCORE mask
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 12, 2014 at 2:06 AM, Andi Kleen <andi@firstfloor.org> wrote:
> From: Andi Kleen <ak@linux.intel.com>
>
> Haswell supports more bits in the offcore_rsp_* MSRs than Sandy
> Bridge. Previously the Haswell code was using the Sandy Bridge
> extra register definitions, which prevented users from setting
> all of these bits. This in term did not allow to set some valid
> SNOOP_* bits, among others.
>
> I allowed all bits the CPU does not #GP on. This is ok because
> it's protected by a model check.
>
> Add a new extra_regs table for Haswell and use. Except for the
> widened mask it is identical to Sandy Bridge.
>
You're adding an extra_regs[] array which is identical to the one
used by SNB-EP. So why not use that one instead of defining yet
another extra_regs array?


> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  arch/x86/kernel/cpu/perf_event_intel.c | 10 +++++++++-
>  1 file changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
> index adb02aa..5d41e2b 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> @@ -189,6 +189,14 @@ static struct extra_reg intel_snbep_extra_regs[] __read_mostly = {
>         EVENT_EXTRA_END
>  };
>
> +static struct extra_reg intel_hsw_extra_regs[] __read_mostly = {
> +       /* must define OFFCORE_RSP_X first, see intel_fixup_er() */
> +       INTEL_UEVENT_EXTRA_REG(0x01b7, MSR_OFFCORE_RSP_0, 0x3fffff8fffull, RSP_0),
> +       INTEL_UEVENT_EXTRA_REG(0x01bb, MSR_OFFCORE_RSP_1, 0x3fffff8fffull, RSP_1),
> +       INTEL_UEVENT_PEBS_LDLAT_EXTRA_REG(0x01cd),
> +       EVENT_EXTRA_END
> +};
> +
>  EVENT_ATTR_STR(mem-loads,      mem_ld_nhm,     "event=0x0b,umask=0x10,ldlat=3");
>  EVENT_ATTR_STR(mem-loads,      mem_ld_snb,     "event=0xcd,umask=0x1,ldlat=3");
>  EVENT_ATTR_STR(mem-stores,     mem_st_snb,     "event=0xcd,umask=0x2");
> @@ -2504,7 +2512,7 @@ __init int intel_pmu_init(void)
>
>                 x86_pmu.event_constraints = intel_hsw_event_constraints;
>                 x86_pmu.pebs_constraints = intel_hsw_pebs_event_constraints;
> -               x86_pmu.extra_regs = intel_snb_extra_regs;
> +               x86_pmu.extra_regs = intel_hsw_extra_regs;
>                 x86_pmu.pebs_aliases = intel_pebs_aliases_snb;
>                 /* all extra regs are per-cpu when HT is on */
>                 x86_pmu.er_flags |= ERF_HAS_RSP_1;
> --
> 1.9.3
>
