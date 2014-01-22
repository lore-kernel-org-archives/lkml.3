Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965AbaAVXxY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 18:53:24 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:55941 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbaAVXxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 18:53:23 -0500
MIME-Version: 1.0
In-Reply-To: <20140122210814.GC9481@laptop.programming.kicks-ass.net>
References: <20140122120757.GL31570@twins.programming.kicks-ass.net>
	<20140122122609.GA392@x4>
	<20140122123022.GN31570@twins.programming.kicks-ass.net>
	<20140122131456.GA389@x4>
	<52DFD50E.800@oracle.com>
	<20140122183538.GA389@x4>
	<20140122184253.GN30183@twins.programming.kicks-ass.net>
	<20140122190905.GA391@x4>
	<20140122191254.GA390@x4>
	<20140122201605.GU11314@laptop.programming.kicks-ass.net>
	<20140122210814.GC9481@laptop.programming.kicks-ass.net>
Date: Wed, 22 Jan 2014 18:53:22 -0500
X-Google-Sender-Auth: Mb6ZaDsxQ4R6X3mdWiOLigxj_jw
Message-ID: <CA+5PVA7FBcO3KbvM1vPJVtpdWN6jaSGF9LJW89iY_Uio9aM8ZQ@mail.gmail.com>
Subject: Re: [PATCH 13/15] sched: Use a static_key for sched_clock_stable
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Sasha Levin <sasha.levin@oracle.com>,
        Arjan van de Ven <arjan@linux.intel.com>, Len Brown <lenb@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Eliezer Tamir <eliezer.tamir@linux.intel.com>,
        Zhang Rui <rui.zhang@intel.com>, jacob.jun.pan@linux.intel.com,
        Mike Galbraith <bitbucket@online.de>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>,
        Andy Lutomirski <luto@amacapital.net>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Dave Young <dyoung@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 22, 2014 at 4:08 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>>
>> I think its the right region to look through. My current suspect is the
>> linear continuity fit with the initial 'random' multiplier.
>>
>> That initial 'random' multiplier can get us quite high, and we'll fit
>> the function to match that but continue at a sane rate.
>>
>> I'll try and prod a little more later this evening as time permits.
>
> Does this cure things?

This seems to correct the time jump I was seeing on my i7 box as well.

josh

>
> ---
>  arch/x86/kernel/tsc.c | 11 +++++++----
>  1 file changed, 7 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
> index a3acbac2ee72..bb04148c5fe0 100644
> --- a/arch/x86/kernel/tsc.c
> +++ b/arch/x86/kernel/tsc.c
> @@ -237,7 +237,7 @@ static inline unsigned long long cycles_2_ns(unsigned long long cyc)
>  /* XXX surely we already have this someplace in the kernel?! */
>  #define DIV_ROUND(n, d) (((n) + ((d) / 2)) / (d))
>
> -static void set_cyc2ns_scale(unsigned long cpu_khz, int cpu)
> +static void set_cyc2ns_scale(unsigned long cpu_khz, int cpu, bool origin)
>  {
>         unsigned long long tsc_now, ns_now;
>         struct cyc2ns_data *data;
> @@ -252,7 +252,10 @@ static void set_cyc2ns_scale(unsigned long cpu_khz, int cpu)
>         data = cyc2ns_write_begin(cpu);
>
>         rdtscll(tsc_now);
> -       ns_now = cycles_2_ns(tsc_now);
> +       if (origin)
> +               ns_now = 0;
> +       else
> +               ns_now = cycles_2_ns(tsc_now);
>
>         /*
>          * Compute a new multiplier as per the above comment and ensure our
> @@ -926,7 +929,7 @@ static int time_cpufreq_notifier(struct notifier_block *nb, unsigned long val,
>                         mark_tsc_unstable("cpufreq changes");
>         }
>
> -       set_cyc2ns_scale(tsc_khz, freq->cpu);
> +       set_cyc2ns_scale(tsc_khz, freq->cpu, false);
>
>         return 0;
>  }
> @@ -1199,7 +1202,7 @@ void __init tsc_init(void)
>          */
>         for_each_possible_cpu(cpu) {
>                 cyc2ns_init(cpu);
> -               set_cyc2ns_scale(cpu_khz, cpu);
> +               set_cyc2ns_scale(cpu_khz, cpu, true);
>         }
>
>         if (tsc_disabled > 0)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
