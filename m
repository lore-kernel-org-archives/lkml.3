Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946Ab3BRMgW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 07:36:22 -0500
Received: from mail-bk0-f49.google.com ([209.85.214.49]:60511 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569Ab3BRMgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 07:36:21 -0500
MIME-Version: 1.0
In-Reply-To: <1360346718-3313-2-git-send-email-vincent.guittot@linaro.org>
References: <1360346718-3313-1-git-send-email-vincent.guittot@linaro.org>
	<1360346718-3313-2-git-send-email-vincent.guittot@linaro.org>
Date: Mon, 18 Feb 2013 13:36:19 +0100
Message-ID: <CAKfTPtAxf57j4P-L1O0k=VdLOfgjSGqAmOGS71RD_TJ8wA0Rhw@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] sched: fix init NOHZ_IDLE flag
From: Vincent Guittot <vincent.guittot@linaro.org>
To: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        peterz@infradead.org, mingo@kernel.org, fweisbec@gmail.com,
        rostedt@goodmis.org, efault@gmx.de
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 February 2013 19:05, Vincent Guittot <vincent.guittot@linaro.org> wrote:
> On my smp platform which is made of 5 cores in 2 clusters, I have the
> nr_busy_cpu field of sched_group_power struct that is not null when the
> platform is fully idle. The root cause seems to be:
> During the boot sequence, some CPUs reach the idle loop and set their
> NOHZ_IDLE flag while waiting for others CPUs to boot. But the nr_busy_cpus
> field is initialized later with the assumption that all CPUs are in the busy
> state whereas some CPUs have already set their NOHZ_IDLE flag.
> We set the NOHZ_IDLE flag when nr_busy_cpus is initialized to 0 in order to
> have a coherent configuration.
>
> The patch 2/2 protects this init against an update of NOHZ_IDLE flag because
> a NULL sched_domain is attached to the CPU during the build of the new
> sched_domain so nohz_kick_needed and set_cpu_sd_state_busy are not called and
> can't clear the NOHZ_IDLE flag

Hi Frederic,

With this v3, the initialization of  NOHZ_IDLE and nr_busy_cpus is be
protected against any race condition because the initial state is the
idle state so if a cpu enters idle, it keeps the same state and we
can't set a busy state until the initialization is complete thanks to
the NULL domain.

Regards,
Vincent

>
> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
> ---
>  kernel/sched/core.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 26058d0..c730a4e 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -5884,7 +5884,9 @@ static void init_sched_groups_power(int cpu, struct sched_domain *sd)
>                 return;
>
>         update_group_power(sd, cpu);
> -       atomic_set(&sg->sgp->nr_busy_cpus, sg->group_weight);
> +       atomic_set(&sg->sgp->nr_busy_cpus, 0);
> +       set_bit(NOHZ_IDLE, nohz_flags(cpu));
> +
>  }
>
>  int __weak arch_sd_sibling_asym_packing(void)
> --
> 1.7.9.5
>
