Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751546AbaHDHWK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 03:22:10 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:41784 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbaHDHWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 03:22:08 -0400
MIME-Version: 1.0
In-Reply-To: <20140803101539.GA7978@himangi-Dell>
References: <20140803101539.GA7978@himangi-Dell>
Date: Mon, 4 Aug 2014 12:52:07 +0530
Message-ID: <CAKohpommqaWtNrmsKHptB3W6-kufe-4ieLe5RA1fqLTCiQ7=qQ@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: integrator: Use set_cpus_allowed_ptr
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Himangi Saraogi <himangi774@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Julia Lawall <julia.lawall@lip6.fr>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 August 2014 15:45, Himangi Saraogi <himangi774@gmail.com> wrote:
> Several years ago there was an effort to convert all uses of
> set_cpus_allowed to use set_cpus_allowed_ptr with the goal of eventually
> removing the current definition of set_cpus_allowed and renaming
> set_cpus_allowed_ptr as set_cpus_allowed
> (https://lkml.org/lkml/2010/3/26/59). This is another step in this
> direction.
>
> The Coccinelle semantic patch that makes this change is as follows:
>
> // <smpl>
> @@
> expression E1,E2;
> @@
>
> - set_cpus_allowed(E1, cpumask_of_cpu(E2))
> + set_cpus_allowed_ptr(E1, cpumask_of(E2))
>
> @@
> expression E;
> identifier I;
> @@
>
> - set_cpus_allowed(E, I)
> + set_cpus_allowed_ptr(E, &I)
> // </smpl>
>
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>
> ---
>  drivers/cpufreq/integrator-cpufreq.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/cpufreq/integrator-cpufreq.c b/drivers/cpufreq/integrator-cpufreq.c
> index e5122f1..c132052 100644
> --- a/drivers/cpufreq/integrator-cpufreq.c
> +++ b/drivers/cpufreq/integrator-cpufreq.c
> @@ -92,7 +92,7 @@ static int integrator_set_target(struct cpufreq_policy *policy,
>          * Bind to the specified CPU.  When this call returns,
>          * we should be running on the right CPU.
>          */
> -       set_cpus_allowed(current, cpumask_of_cpu(cpu));
> +       set_cpus_allowed_ptr(current, cpumask_of(cpu));
>         BUG_ON(cpu != smp_processor_id());
>
>         /* get current setting */
> @@ -118,7 +118,7 @@ static int integrator_set_target(struct cpufreq_policy *policy,
>         freqs.new = icst_hz(&cclk_params, vco) / 1000;
>
>         if (freqs.old == freqs.new) {
> -               set_cpus_allowed(current, cpus_allowed);
> +               set_cpus_allowed_ptr(current, &cpus_allowed);
>                 return 0;
>         }
>
> @@ -141,7 +141,7 @@ static int integrator_set_target(struct cpufreq_policy *policy,
>         /*
>          * Restore the CPUs allowed mask.
>          */
> -       set_cpus_allowed(current, cpus_allowed);
> +       set_cpus_allowed_ptr(current, &cpus_allowed);
>
>         cpufreq_freq_transition_end(policy, &freqs, 0);
>
> @@ -157,7 +157,7 @@ static unsigned int integrator_get(unsigned int cpu)
>
>         cpus_allowed = current->cpus_allowed;
>
> -       set_cpus_allowed(current, cpumask_of_cpu(cpu));
> +       set_cpus_allowed_ptr(current, cpumask_of(cpu));
>         BUG_ON(cpu != smp_processor_id());
>
>         /* detect memory etc. */
> @@ -173,7 +173,7 @@ static unsigned int integrator_get(unsigned int cpu)
>
>         current_freq = icst_hz(&cclk_params, vco) / 1000; /* current freq */
>
> -       set_cpus_allowed(current, cpus_allowed);
> +       set_cpus_allowed_ptr(current, &cpus_allowed);
>
>         return current_freq;
>  }

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
