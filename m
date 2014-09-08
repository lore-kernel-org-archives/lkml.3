Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753998AbaIHPNi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 11:13:38 -0400
Received: from service87.mimecast.com ([91.220.42.44]:33828 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753070AbaIHPNg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 11:13:36 -0400
Message-ID: <540DC7B2.6000000@arm.com>
Date: Mon, 08 Sep 2014 16:13:54 +0100
From: Juri Lelli <juri.lelli@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Daniel Wagner <daniel.wagner@bmw-carit.de>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
CC: "juri.lelli@gmail.com" <juri.lelli@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: Reset bandwith on task when switching from SCHED_DEADLINE
 away
References: <1409747397-23653-1-git-send-email-daniel.wagner@bmw-carit.de>
In-Reply-To: <1409747397-23653-1-git-send-email-daniel.wagner@bmw-carit.de>
X-OriginalArrivalTime: 08 Sep 2014 15:13:31.0635 (UTC) FILETIME=[73800430:01CFCB77]
X-MC-Unique: 114090816133305301
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

thanks a lot for your patch. I'd actually have a slightly different fix
for the same problem. I'm actually baking a small patchset that I should
be able to release in the next few days. I'd say we could wait for that
to happen and then discuss which approach is better, ok?

Thanks again,

- Juri

On 03/09/14 13:29, Daniel Wagner wrote:
> Withouth reseting dl_bw the effect is any *new* task to switch
> SCHED_DEADLINE will be prevented. You will get EBUSY for new tasks.
> 
> sched_setattr()
>    if (... dl_overflow(p, policy, attr) ...)
>    __setscheduler()
>       __setscheduler_params()
>         __setparam_dl()
> 
> sched_setattr() verifies if there is enough bandwith available before allowing
> to switch to SCHED_DEALINE. Because we do not set p->dl.dl_bw back to 0 after
> switching from SCHED_DEADLINE to any other scheduler we end up in dl_overflow()
> to underflow the total bandwith (dl_b->total_bw). This can be triggered by
> toggling between SCHED_DEADLINE and SCHED_OTHER.
> 
> kernel/sched/core.c:
> @@ -2039,8 +2039,12 @@ static int dl_overflow(struct task_struct *p, int policy,
>  	u64 new_bw = dl_policy(policy) ? to_ratio(period, runtime) : 0;
>  	int cpus, err = -1;
> 
> -	if (new_bw == p->dl.dl_bw)
> +	printk("dl_b->bw %llu dl_b->total_bw %llu p->dl.dl_bw %llu period %llu runtime %llu new_bw %llu -> ",
> +			 dl_b->bw, dl_b->total_bw, p->dl.dl_bw, period, runtime, new_bw);
> +
> +	if (new_bw == p->dl.dl_bw) {
> +		printk("1\n");
>  		return 0;
> +	}
> 
>  	/*
>  	 * Either if a task, enters, leave, or stays -deadline but changes
> @@ -2053,14 +2057,17 @@ static int dl_overflow(struct task_struct *p, int policy,
>  	    !__dl_overflow(dl_b, cpus, 0, new_bw)) {
>  		__dl_add(dl_b, new_bw);
>  		err = 0;
> +		printk("2\n");
>  	} else if (dl_policy(policy) && task_has_dl_policy(p) &&
>  		   !__dl_overflow(dl_b, cpus, p->dl.dl_bw, new_bw)) {
>  		__dl_clear(dl_b, p->dl.dl_bw);
>  		__dl_add(dl_b, new_bw);
>  		err = 0;
> +		printk("3\n");
>  	} else if (!dl_policy(policy) && task_has_dl_policy(p)) {
>  		__dl_clear(dl_b, p->dl.dl_bw);
>  		err = 0;
> +		printk("4\n");
>  	}
>  	raw_spin_unlock(&dl_b->lock);
> 
> [   19.506909] dl_b->bw 996147 dl_b->total_bw 0 p->dl.dl_bw 0 period 200000 runtime 100000 new_bw 524288 -> 2
> [   19.507906] dl_b->bw 996147 dl_b->total_bw 524288 p->dl.dl_bw 524288 period 0 runtime 0 new_bw 0 -> 4
> [   19.508906] dl_b->bw 996147 dl_b->total_bw 0 p->dl.dl_bw 524288 period 200000 runtime 100000 new_bw 524288 -> 1
> [   19.509908] dl_b->bw 996147 dl_b->total_bw 0 p->dl.dl_bw 524288 period 0 runtime 0 new_bw 0 -> 4
> [   19.510993] dl_b->bw 996147 dl_b->total_bw 18446744073709027328 p->dl.dl_bw 524288 period 200000 runtime 100000 new_bw 524288 -> 1
> [   19.513583] dl_b->bw 996147 dl_b->total_bw 18446744073709027328 p->dl.dl_bw 524288 period 0 runtime 0 new_bw 0 -> 4
> [   19.515686] dl_b->bw 996147 dl_b->total_bw 18446744073708503040 p->dl.dl_bw 524288 period 200000 runtime 100000 new_bw 524288 -> 1
> [   19.517532] dl_b->bw 996147 dl_b->total_bw 18446744073708503040 p->dl.dl_bw 524288 period 0 runtime 0 new_bw 0 -> 4
> [   19.518503] dl_b->bw 996147 dl_b->total_bw 18446744073707978752 p->dl.dl_bw 524288 period 200000 runtime 100000 new_bw 524288 -> 1
> [   19.519231] dl_b->bw 996147 dl_b->total_bw 18446744073707978752 p->dl.dl_bw 524288 period 0 runtime 0 new_bw 0 -> 4
> [   19.520027] dl_b->bw 996147 dl_b->total_bw 18446744073707454464 p->dl.dl_bw 524288 period 200000 runtime 100000 new_bw 524288 -> 1
> [   19.520759] dl_b->bw 996147 dl_b->total_bw 18446744073707454464 p->dl.dl_bw 524288 period 0 runtime 0 new_bw 0 -> 4
> [   19.521460] dl_b->bw 996147 dl_b->total_bw 18446744073706930176 p->dl.dl_bw 524288 period 200000 runtime 100000 new_bw 524288 -> 1
> [   19.522154] dl_b->bw 996147 dl_b->total_bw 18446744073706930176 p->dl.dl_bw 524288 period 0 runtime 0 new_bw 0 -> 4
> [   19.522809] dl_b->bw 996147 dl_b->total_bw 18446744073706405888 p->dl.dl_bw 524288 period 200000 runtime 100000 new_bw 524288 -> 1
> [   19.523729] dl_b->bw 996147 dl_b->total_bw 18446744073706405888 p->dl.dl_bw 524288 period 0 runtime 0 new_bw 0 -> 4
> [   19.524569] dl_b->bw 996147 dl_b->total_bw 18446744073705881600 p->dl.dl_bw 524288 period 200000 runtime 100000 new_bw 524288 -> 1
> [   19.525434] dl_b->bw 996147 dl_b->total_bw 18446744073705881600 p->dl.dl_bw 524288 period 0 runtime 0 new_bw 0 -> 4
> [   19.526224] dl_b->bw 996147 dl_b->total_bw 18446744073705357312 p->dl.dl_bw 524288 period 200000 runtime 100000 new_bw 524288 -> 1
> [   19.527077] dl_b->bw 996147 dl_b->total_bw 18446744073705357312 p->dl.dl_bw 524288 period 0 runtime 0 new_bw 0 -> 4
> 
>  With the patch applied I get this result:
> 
> [   17.345812] dl_b->bw 996147 dl_b->total_bw 0 p->dl.dl_bw 0 period 200000 runtime 100000 new_bw 524288 -> 2
> [   17.346664] dl_b->bw 996147 dl_b->total_bw 524288 p->dl.dl_bw 524288 period 0 runtime 0 new_bw 0 -> 4
> [   17.347333] dl_b->bw 996147 dl_b->total_bw 0 p->dl.dl_bw 0 period 200000 runtime 100000 new_bw 524288 -> 2
> [   17.347832] dl_b->bw 996147 dl_b->total_bw 524288 p->dl.dl_bw 524288 period 0 runtime 0 new_bw 0 -> 4
> [   17.348369] dl_b->bw 996147 dl_b->total_bw 0 p->dl.dl_bw 0 period 200000 runtime 100000 new_bw 524288 -> 2
> [   17.348868] dl_b->bw 996147 dl_b->total_bw 524288 p->dl.dl_bw 524288 period 0 runtime 0 new_bw 0 -> 4
> [   17.349456] dl_b->bw 996147 dl_b->total_bw 0 p->dl.dl_bw 0 period 200000 runtime 100000 new_bw 524288 -> 2
> [   17.349953] dl_b->bw 996147 dl_b->total_bw 524288 p->dl.dl_bw 524288 period 0 runtime 0 new_bw 0 -> 4
> [   17.350598] dl_b->bw 996147 dl_b->total_bw 0 p->dl.dl_bw 0 period 200000 runtime 100000 new_bw 524288 -> 2
> [   17.351107] dl_b->bw 996147 dl_b->total_bw 524288 p->dl.dl_bw 524288 period 0 runtime 0 new_bw 0 -> 4
> [   17.351637] dl_b->bw 996147 dl_b->total_bw 0 p->dl.dl_bw 0 period 200000 runtime 100000 new_bw 524288 -> 2
> [   17.352144] dl_b->bw 996147 dl_b->total_bw 524288 p->dl.dl_bw 524288 period 0 runtime 0 new_bw 0 -> 4
> [   17.352805] dl_b->bw 996147 dl_b->total_bw 0 p->dl.dl_bw 0 period 200000 runtime 100000 new_bw 524288 -> 2
> [   17.353366] dl_b->bw 996147 dl_b->total_bw 524288 p->dl.dl_bw 524288 period 0 runtime 0 new_bw 0 -> 4
> [   17.353867] dl_b->bw 996147 dl_b->total_bw 0 p->dl.dl_bw 0 period 200000 runtime 100000 new_bw 524288 -> 2
> [   17.354458] dl_b->bw 996147 dl_b->total_bw 524288 p->dl.dl_bw 524288 period 0 runtime 0 new_bw 0 -> 4
> [   17.355066] dl_b->bw 996147 dl_b->total_bw 0 p->dl.dl_bw 0 period 200000 runtime 100000 new_bw 524288 -> 2
> [   17.355716] dl_b->bw 996147 dl_b->total_bw 524288 p->dl.dl_bw 524288 period 0 runtime 0 new_bw 0 -> 4
> [   17.356414] dl_b->bw 996147 dl_b->total_bw 0 p->dl.dl_bw 0 period 200000 runtime 100000 new_bw 524288 -> 2
> [   17.356961] dl_b->bw 996147 dl_b->total_bw 524288 p->dl.dl_bw 524288 period 0 runtime 0 new_bw 0 -> 4
> 
> Signed-off-by: Daniel Wagner <daniel.wagner@bmw-carit.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: linux-kernel@vger.kernel.org
> ---
> This patch is based on mainline 3.17-rc3
> 
> And here my simple test program which triggers the problem.
> Run it twice on your machine to see the error.
> 
> /*
>  * Switch between SCHED_OTHER and SCHED_DEADLINE test.
>  *
>  * Parts stolen from libdl
>  *  (C) Dario Faggioli <raistlin@linux.it>, 2009, 2010
>  *
>  * This program is free software; you can redistribute it and/or modify
>  * it under the terms of the GNU General Public License as published by
>  * the Free Software Foundation version 2 of the License.
>  *
>  * This program is distributed in the hope that it will be useful,
>  * but WITHOUT ANY WARRANTY; without even the implied warranty of
>  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>  * GNU General Public License (COPYING file) for more details.
>  */
> 
> struct sched_attr {
> 	__u32 size;
> 
> 	__u32 sched_policy;
> 	__u64 sched_flags;
> 
> 	/* SCHED_NORMAL, SCHED_BATCH */
> 	__s32 sched_nice;
> 
> 	/* SCHED_FIFO, SCHED_RR */
> 	__u32 sched_priority;
> 
> 	/* SCHED_DEADLINE */
> 	__u64 sched_runtime;
> 	__u64 sched_deadline;
> 	__u64 sched_period;
> };
> 
> static int sched_setattr(pid_t pid, const struct sched_attr *attr,
> 			unsigned int flags)
> {
> 	return syscall(__NR_sched_setattr, pid, attr, flags);
> }
> 
> static void handle_err(const char *str)
> {
> 	perror(str);
> 	exit(EXIT_FAILURE);
> }
> 
> int main(int argc, char *argv[])
> {
> 	struct sched_attr other;
> 	struct sched_attr dl;
> 	int i, err;
> 
> 	dl.size = sizeof(struct sched_attr);
> 	dl.sched_policy = SCHED_DEADLINE;
> 	dl.sched_flags = 0;
> 	dl.sched_nice = 0;
> 	dl.sched_priority = 0;
> 	dl.sched_runtime =  100000;
> 	dl.sched_deadline = 200000;
> 	dl.sched_period =   200000;
> 
> 	other.size = sizeof(struct sched_attr);
> 	other.sched_policy = SCHED_OTHER;
> 	other.sched_flags = 0;
> 	other.sched_nice = 0;
> 	other.sched_priority = 0;
> 	other.sched_runtime =  0;
> 	other.sched_deadline = 0;
> 	other.sched_period = 0;
> 
> 	for (i = 0; i < 10; i++) {
> 		err = sched_setattr(0, &dl, 0);
> 		if (err < 0)
> 			handle_err("Could not set SCHED_DEADLINE attributes");
> 
> 		err = sched_setattr(0, &other, 0);
> 		if (err < 0)
> 			handle_err("Could not set SCHED_OTHER attributes");
> 	}
> 
> 	return 0;
> }
> ---
>  kernel/sched/core.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index ec1a286..1ce935e 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -3236,6 +3236,9 @@ static void __setscheduler_params(struct task_struct *p,
>  {
>  	int policy = attr->sched_policy;
>  
> +	if (!dl_policy(policy) && task_has_dl_policy(p))
> +		p->dl.dl_bw = 0;
> +
>  	if (policy == SETPARAM_POLICY)
>  		policy = p->policy;
>  
> 

