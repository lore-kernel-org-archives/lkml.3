Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025AbaLSBGE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 20:06:04 -0500
Received: from www.linutronix.de ([62.245.132.108]:60840 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbaLSBGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 20:06:02 -0500
Date: Fri, 19 Dec 2014 02:05:50 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Shaohua Li <shli@fb.com>
cc: linux-kernel@vger.kernel.org, x86@kernel.org, Kernel-team@fb.com,
        Andy Lutomirski <luto@amacapital.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v2 2/3] X86: add a generic API to let vdso code detect
 context switch
In-Reply-To: <ecaea9066b4b0ff320bc03f23db56a9c2403a6b0.1418857018.git.shli@fb.com>
Message-ID: <alpine.DEB.2.11.1412190153530.17382@nanos>
References: <8559794d3a1924408a811a2881ab916fffb6015b.1418857018.git.shli@fb.com> <ecaea9066b4b0ff320bc03f23db56a9c2403a6b0.1418857018.git.shli@fb.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Dec 2014, Shaohua Li wrote:
> vdso code can't disable preempt, so it can be preempted at any time.
> This makes a challenge to implement specific features. This patch adds a
> generic API to let vdso code detect context switch.

Please change this to:

 This adds a complete trainwreck into the scheduler hotpath.
 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index b5797b7..d8e882d 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -2232,6 +2232,11 @@ static struct rq *finish_task_switch(struct task_struct *prev)
>  	struct rq *rq = this_rq();
>  	struct mm_struct *mm = rq->prev_mm;
>  	long prev_state;
> +#ifdef CONFIG_VDSO_CS_DETECT

Ever heard about header files and CONFIG dependent inline functions?

> +	int cpu = smp_processor_id();

If you think hard enough the you might find an even more expensive way
to figure out on which cpu you are running on.

> +	vdso_set_cpu_cs_timestamp(cpu);

So we hand in the cpu we are running on to update percpu data in non
preemptible context instead of handing in the really relevant data,
i.e. the timestamp which is readily available right here for free. I
bet the completely misnomed function will go through loops and hoops
to figure that out.

Thanks,

	tglx



