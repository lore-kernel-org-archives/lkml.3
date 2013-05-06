Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602Ab3EFFXr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 01:23:47 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:35240 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613Ab3EFFXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 01:23:45 -0400
Message-ID: <518724D1.9040006@linux.vnet.ibm.com>
Date: Mon, 06 May 2013 11:34:41 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Alex Shi <alex.shi@intel.com>
CC: mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, bp@alien8.de, pjt@google.com,
        namhyung@kernel.org, efault@gmx.de, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org, preeti@linux.vnet.ibm.com,
        viresh.kumar@linaro.org, linux-kernel@vger.kernel.org, mgorman@suse.de,
        riel@redhat.com
Subject: Re: [PATCH v5 7/7] sched: consider runnable load average in effective_load
References: <1367804711-30308-1-git-send-email-alex.shi@intel.com> <1367804711-30308-8-git-send-email-alex.shi@intel.com>
In-Reply-To: <1367804711-30308-8-git-send-email-alex.shi@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050605-5140-0000-0000-000003250C19
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Alex

On 05/06/2013 09:45 AM, Alex Shi wrote:
> effective_load calculates the load change as seen from the
> root_task_group. It needs to engage the runnable average
> of changed task.
[snip]
>   */
> @@ -3045,7 +3045,7 @@ static long effective_load(struct task_group *tg, int cpu, long wl, long wg)
>  		/*
>  		 * w = rw_i + @wl
>  		 */
> -		w = se->my_q->load.weight + wl;
> +		w = se->my_q->tg_load_contrib + wl;

I've tested the patch set, seems like the last patch caused big
regression on pgbench:

			base	patch 1~6	patch 1~7
| db_size | clients |  tps  |   |  tps  |	|  tps  |
+---------+---------+-------+	+-------+	+-------+
| 22 MB   |      32 | 43420 |	| 53387 |	| 41625 |

I guess some magic thing happened in effective_load() while calculating
group decay combined with load decay, what's your opinion?

Regards,
Michael Wang

> 
>  		/*
>  		 * wl = S * s'_i; see (2)
> @@ -3066,7 +3066,7 @@ static long effective_load(struct task_group *tg, int cpu, long wl, long wg)
>  		/*
>  		 * wl = dw_i = S * (s'_i - s_i); see (3)
>  		 */
> -		wl -= se->load.weight;
> +		wl -= se->avg.load_avg_contrib;
> 
>  		/*
>  		 * Recursively apply this logic to all parent groups to compute
> @@ -3112,14 +3112,14 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
>  	 */
>  	if (sync) {
>  		tg = task_group(current);
> -		weight = current->se.load.weight;
> +		weight = current->se.avg.load_avg_contrib;
> 
>  		this_load += effective_load(tg, this_cpu, -weight, -weight);
>  		load += effective_load(tg, prev_cpu, 0, -weight);
>  	}
> 
>  	tg = task_group(p);
> -	weight = p->se.load.weight;
> +	weight = p->se.avg.load_avg_contrib;
> 
>  	/*
>  	 * In low-load situations, where prev_cpu is idle and this_cpu is idle
> 

