Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759098Ab3EONhY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 09:37:24 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:53999 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758997Ab3EONhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 09:37:23 -0400
MIME-Version: 1.0
In-Reply-To: <20130503121256.230745028@chello.nl>
References: <20130503121122.931661809@chello.nl>
	<20130503121256.230745028@chello.nl>
Date: Wed, 15 May 2013 15:37:22 +0200
Message-ID: <CABPqkBTvcQAyXfeiJwpPsNtbs4ffsVguXE631dK_rbzHpwBdOg@mail.gmail.com>
Subject: Re: [PATCH 3/3] perf, x86, lbr: Demand proper privileges for PERF_SAMPLE_BRANCH_KERNEL
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 3, 2013 at 2:11 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> We should always have proper privileges when requesting kernel data.
>
> Cc: Andi Kleen <ak@linux.intel.com>
> Cc: eranian@google.com
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Link: http://lkml.kernel.org/n/tip-v0x9ky3ahzr6nm3c6ilwrili@git.kernel.org
> ---
>  arch/x86/kernel/cpu/perf_event_intel_lbr.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>
> --- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
> @@ -318,8 +318,11 @@ static void intel_pmu_setup_sw_lbr_filte
>         if (br_type & PERF_SAMPLE_BRANCH_USER)
>                 mask |= X86_BR_USER;
>
> -       if (br_type & PERF_SAMPLE_BRANCH_KERNEL)
> +       if (br_type & PERF_SAMPLE_BRANCH_KERNEL) {
> +               if (perf_paranoid_kernel() && !capable(CAP_SYS_ADMIN))
> +                       return -EACCES;
>                 mask |= X86_BR_KERNEL;
> +       }
>
This will prevent regular users from capturing kernel -> kernel branches.
But it won't prevent users from getting kernel -> user branches. Thus
some kernel address will still be captured. I guess they could be eliminated
by the sw_filter.

When using LBR priv level filtering, the filter applies to the branch target
only.
