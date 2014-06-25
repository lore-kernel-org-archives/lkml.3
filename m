Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232AbaFYFZc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 01:25:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63438 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753218AbaFYFZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 01:25:30 -0400
Message-ID: <53AA5D2C.9000401@redhat.com>
Date: Wed, 25 Jun 2014 01:25:00 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, chegu_vinod@hp.com, mgorman@suse.de,
        mingo@kernel.org
Subject: Re: [PATCH 9/7] sched,numa: remove task_h_load from task_numa_compare
References: <1403538095-31256-1-git-send-email-riel@redhat.com> <20140624151454.2a05082e@annuminas.surriel.com> <20140625050735.GB28774@twins.programming.kicks-ass.net> <20140625052144.GH3588@twins.programming.kicks-ass.net>
In-Reply-To: <20140625052144.GH3588@twins.programming.kicks-ass.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 06/25/2014 01:21 AM, Peter Zijlstra wrote:
> On Wed, Jun 25, 2014 at 07:07:35AM +0200, Peter Zijlstra wrote:
>> Shall I merge this into patch 3?
> 
> Which gets me the below; which is has a wrong changelog.
> 
> task_h_load() already computes the load as seen from the root
> group. effective_load() just does a better (and more expensive) job
> of computing the task movement implications of a move.
> 
> So the total effect of this patch shouldn't be very big; regular
> load balancing also only uses task_h_load(), see move_tasks().
> 
> Now, we don't run with preemption disabled, don't run as often,
> etc.., so maybe we can indeed use the more expensive variant just
> fine, but does it really matter?

In my testing, it appears to make a difference between workloads
converging, and workloads sitting with one last thread stuck on
another node that never gets moved...

> --- Subject: sched,numa: use effective_load to balance NUMA loads 
> From: Rik van Riel <riel@redhat.com> Date: Mon, 23 Jun 2014
> 11:46:14 -0400
> 
> When CONFIG_FAIR_GROUP_SCHED is enabled, the load that a task
> places on a CPU is determined by the group the task is in. This is
> conveniently calculated for us by effective_load(), which
> task_numa_compare should use.
> 
> The active groups on the source and destination CPU can be
> different, so the calculation needs to be done separately for each
> CPU.
> 
> Cc: mgorman@suse.de Cc: mingo@kernel.org Cc: chegu_vinod@hp.com 
> Signed-off-by: Rik van Riel <riel@redhat.com> Signed-off-by: Peter
> Zijlstra <peterz@infradead.org> Link:
> http://lkml.kernel.org/r/1403538378-31571-3-git-send-email-riel@redhat.com
>
> 
- ---
> kernel/sched/fair.c |   20 ++++++++++++++------ 1 file changed, 14
> insertions(+), 6 deletions(-)
> 
> --- a/kernel/sched/fair.c +++ b/kernel/sched/fair.c @@ -1151,6
> +1151,7 @@ static void task_numa_compare(struct tas struct rq
> *src_rq = cpu_rq(env->src_cpu); struct rq *dst_rq =
> cpu_rq(env->dst_cpu); struct task_struct *cur; +	struct task_group
> *tg; long src_load, dst_load; long load; long imp = (groupimp > 0)
> ? groupimp : taskimp; @@ -1225,14 +1226,21 @@ static void
> task_numa_compare(struct tas * In the overloaded case, try and keep
> the load balanced. */ balance: -	load = task_h_load(env->p); -
> dst_load = env->dst_stats.load + load; -	src_load =
> env->src_stats.load - load; +	src_load = env->src_stats.load; +
> dst_load = env->dst_stats.load; + +	/* Calculate the effect of
> moving env->p from src to dst. */ +	load = env->p->se.load.weight; 
> +	tg = task_group(env->p); +	src_load += effective_load(tg,
> env->src_cpu, -load, -load); +	dst_load += effective_load(tg,
> env->dst_cpu, load, load);
> 
> if (cur) { -		load = task_h_load(cur); -		dst_load -= load; -
> src_load += load; +		/* Cur moves in the opposite direction. */ +
> load = cur->se.load.weight; +		tg = task_group(cur); +		src_load +=
> effective_load(tg, env->src_cpu, load, load); +		dst_load +=
> effective_load(tg, env->dst_cpu, -load, -load); }
> 
> if (load_too_imbalanced(src_load, dst_load, env))
> 
> 


- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQEcBAEBAgAGBQJTql0sAAoJEM553pKExN6DUEsH/2a+gHC79Ywih7PmbvS8q3JF
AW5tOHrwNK4nU+12hpOuPgF7rK2SqDEMievxGI9oNf2zNx8JsKUFQes5WVHeN4JZ
dOeF1iCZV1KOTxsTOgnfR+dmbZAw3dRRVCysQae4Xm1PlXPgUef0HZSJ4rgdxARb
HqkKokfxDframBBnkeu8QMNzvygt8oZsXYmT2fjJ8lhXuaSIgIl5GWPb4hK5ntfs
0NjE3xPKV5nJxD6ut0gGSrWAaNTg3k7IAhAJf72pzs0gnIHqa0M4AV0NIPgS5QUd
qcCLYSVisdoOiMlHxqxESNhBYTnfmpJdcQ6Cj3CWkaKdiFCGEyu0391AY3Or+zg=
=udqV
-----END PGP SIGNATURE-----
