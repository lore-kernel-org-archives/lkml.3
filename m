Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715AbaKQTkF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 14:40:05 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:20977 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752663AbaKQTkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 14:40:04 -0500
Date: Mon, 17 Nov 2014 14:39:45 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: "pang.xunlei" <pang.xunlei@linaro.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Juri Lelli <juri.lelli@gmail.com>
Subject: Re: [PATCH 1/2] sched/deadline: Modify cpudl.free_cpus to reflect
 rd->span
Message-ID: <20141117143945.25d4d7d0@gandalf.local.home>
In-Reply-To: <1416240664-7200-1-git-send-email-pang.xunlei@linaro.org>
References: <1416240664-7200-1-git-send-email-pang.xunlei@linaro.org>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Nov 2014 00:11:03 +0800

> index 539ca3c..9a69353
> --- a/kernel/sched/cpudeadline.c
> +++ b/kernel/sched/cpudeadline.c
> @@ -107,7 +107,9 @@ int cpudl_find(struct cpudl *cp, struct task_struct *p,
>  	int best_cpu = -1;
>  	const struct sched_dl_entity *dl_se = &p->dl;
>  
> -	if (later_mask && cpumask_and(later_mask, later_mask, cp->free_cpus)) {
> +	if (later_mask && cpumask_and(later_mask, cp->free_cpus,
> +			&p->cpus_allowed) && cpumask_and(later_mask,
> +			later_mask, cpu_active_mask)) {

I did a quick review of this patch, and it looks fine to me. But the
above looks ugly. Please change it to something more readable like:

	if (later_mask &&
	    cpumask_and(later_mask, cp->free_cpus, &p->cpus_allowed) &&
	    cpumask_and(later_mask, later_mask, cpu_active_mask)) {

Thanks,

-- Steve


>  		best_cpu = cpumask_any(later_mask);
>  		goto out;
>  	} else if (cpumask_test_cpu(cpudl_maximum(cp), &p->cpus_allowed) &&
> @@ -186,6 +188,17 @@ out:
>  }
>  

