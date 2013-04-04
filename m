Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761673Ab3DDOY1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 10:24:27 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:49855 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761248Ab3DDOYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 10:24:25 -0400
MIME-Version: 1.0
In-Reply-To: <1364996263-12198-1-git-send-email-vincent.guittot@linaro.org>
References: <1364996263-12198-1-git-send-email-vincent.guittot@linaro.org>
Date: Thu, 4 Apr 2013 16:24:23 +0200
Message-ID: <CAFTL4hwbANveEoY40fNhMt1CJpCoNYfAFj7NghPRTqixCeodHQ@mail.gmail.com>
Subject: Re: [PATCH Resend v5] sched: fix init NOHZ_IDLE flag
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linaro-kernel@lists.linaro.org,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Mike Galbraith <efault@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/4/3 Vincent Guittot <vincent.guittot@linaro.org>:
> On my smp platform which is made of 5 cores in 2 clusters, I have the
> nr_busy_cpu field of sched_group_power struct that is not null when the
> platform is fully idle. The root cause is:
> During the boot sequence, some CPUs reach the idle loop and set their
> NOHZ_IDLE flag while waiting for others CPUs to boot. But the nr_busy_cpus
> field is initialized later with the assumption that all CPUs are in the busy
> state whereas some CPUs have already set their NOHZ_IDLE flag.
>
> More generally, the NOHZ_IDLE flag must be initialized when new sched_domains
> are created in order to ensure that NOHZ_IDLE and nr_busy_cpus are aligned.
>
> This condition can be ensured by adding a synchronize_rcu between the
> destruction of old sched_domains and the creation of new ones so the NOHZ_IDLE
> flag will not be updated with old sched_domain once it has been initialized.
> But this solution introduces a additionnal latency in the rebuild sequence
> that is called during cpu hotplug.
>
> As suggested by Frederic Weisbecker, another solution is to have the same
> rcu lifecycle for both NOHZ_IDLE and sched_domain struct. I have introduce
> a new sched_domain_rq struct that is the entry point for both sched_domains
> and objects that must follow the same lifecycle like NOHZ_IDLE flags. They
> will share the same RCU lifecycle and will be always synchronized.
>
> The synchronization is done at the cost of :
>  - an additional indirection for accessing the first sched_domain level
>  - an additional indirection and a rcu_dereference before accessing to the
>    NOHZ_IDLE flag.
>
> Change since v4:
>  - link both sched_domain and NOHZ_IDLE flag in one RCU object so
>    their states are always synchronized.
>
> Change since V3;
>  - NOHZ flag is not cleared if a NULL domain is attached to the CPU
>  - Remove patch 2/2 which becomes useless with latest modifications
>
> Change since V2:
>  - change the initialization to idle state instead of busy state so a CPU that
>    enters idle during the build of the sched_domain will not corrupt the
>    initialization state
>
> Change since V1:
>  - remove the patch for SCHED softirq on an idle core use case as it was
>    a side effect of the other use cases.
>
> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
> ---
>  include/linux/sched.h |    6 +++
>  kernel/sched/core.c   |  105 ++++++++++++++++++++++++++++++++++++++++++++-----
>  kernel/sched/fair.c   |   35 +++++++++++------
>  kernel/sched/sched.h  |   24 +++++++++--
>  4 files changed, 145 insertions(+), 25 deletions(-)
>
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index d35d2b6..2a52188 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -959,6 +959,12 @@ struct sched_domain {
>         unsigned long span[0];
>  };
>
> +struct sched_domain_rq {
> +       struct sched_domain *sd;

Why not make it part of the structure content instead of pointing to it?

> +       unsigned long flags;
> +       struct rcu_head rcu;    /* used during destruction */
> +};
