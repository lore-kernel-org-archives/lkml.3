Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932471Ab3CLNGT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 09:06:19 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:46369 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755122Ab3CLNGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 09:06:16 -0400
MIME-Version: 1.0
In-Reply-To: <20130311191507.GA31827@phenom.dumpdata.com>
References: <20130311191507.GA31827@phenom.dumpdata.com>
Date: Tue, 12 Mar 2013 14:06:12 +0100
Message-ID: <CABPqkBQ66sAWKTMTxQ1QTkG5Zf0RAsanJxygGxODaOAJekyX9Q@mail.gmail.com>
Subject: Re: SNB-PEBS errate in perf code - omits stepping 2?
From: Stephane Eranian <eranian@google.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: jun.nakajima@intel.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 11, 2013 at 8:15 PM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
> Hey,
>
> I think quirk:
>
> +static int intel_snb_pebs_broken(int cpu)
> +{
> +       u32 rev = UINT_MAX; /* default to broken for unknown models */
> +
> +       switch (cpu_data(cpu).x86_model) {
> +       case 42: /* SNB */
> +               rev = 0x28;
> +               break;
> +
> +       case 45: /* SNB-EP */
> +               switch (cpu_data(cpu).x86_mask) {
> +               case 6: rev = 0x618; break;
> +               case 7: rev = 0x70c; break;
> +               }
> +       }
> +
> +       return (cpu_data(cpu).microcode < rev);
> +}
> +
>
>
> needs a bit of update? I've this CPU:
>
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 45
> model name      : Genuine Intel(R) CPU  @ 2.30GHz
> stepping        : 2
> cpu MHz         : 2294.534
> cache size      : 20480 KB
> ..
> microcode       : 0x8000020c
>
> and since the stepping is '2' and there are no 'default' case
> in the switch statement, it ends up failing b/c it is asking
> for revision UINT_MAX.
>
> Is there a specific microcode errate version for this type
> of CPU? Or am I a lucky recipient of an early development CPU?
>
I believe you have an early sample CPU.
But I think you comment is still valid. I think the kernel should print
a message once for your situation.

>
> Perhaps that check should also have this:
>
> diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
> index 529c893..287d43a 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> @@ -1845,6 +1845,9 @@ static int intel_snb_pebs_broken(int cpu)
>                 case 7: rev = 0x70c; break;
>                 }
>         }
> +       if (rev == UINT_MAX)
> +               pr_warn("Please contact Intel to update quirk as you have"
> +                       "an unknown CPU stepping: %d\n", cpu_data(cpu).x86_mask);
>
>         return (cpu_data(cpu).microcode < rev);
>  }
