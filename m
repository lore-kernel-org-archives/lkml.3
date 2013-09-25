Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523Ab3IYI41 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 04:56:27 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:56506 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237Ab3IYI4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 04:56:24 -0400
Message-ID: <1380099377.8523.9.camel@marge.simpson.net>
Subject: Re: [RFC][PATCH] sched: Avoid select_idle_sibling() for
 wake_affine(.sync=true)
From: Mike Galbraith <bitbucket@online.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Paul Turner <pjt@google.com>,
        Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org
Date: Wed, 25 Sep 2013 10:56:17 +0200
In-Reply-To: <20130925075341.GB3081@twins.programming.kicks-ass.net>
References: <20130925075341.GB3081@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:lbi1/+3K4O+2/1tn1gm3Ec7ZFfYImQhMz3DFgfjG/Vv
 liYxzuGNYdKZxm48DYD3syWK95Tnc35vbKuxRn0O6bTLlMPsPv
 /51gBi0UIY73fabR+ANlJDTtlXYUrRADR2A81WYWrG+4gbMEZU
 J9FU3ZQyRHxzpc53dP/wDS7tc9HhqH9TOqOyGdT+WBKRI04DBK
 pBKylQoEDVkKSDsoPDM41ZoV7WmAa7CYbistA91gB3We44Yx/n
 VGAEfvpgKGSL5T+NmByO44tsGD5meZZwc7q6PtmrSoXtmnVBaC
 DYh/sToOHoRbYlIVgW1GZdgjukdyxuxG+4MsDRzbV6b9B86BPe
 w9fAL8ZMDzMMtOG7SItb9aMnh04t73KVySW94azDQR7AtB4kL8
 1KLrqFtzqRetA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-09-25 at 09:53 +0200, Peter Zijlstra wrote: 
> Subject: sched: Avoid select_idle_sibling() for wake_affine(.sync=true)
> From: Peter Zijlstra <peterz@infradead.org>
> Date: Wed Sep 25 08:28:39 CEST 2013
> 
> When a task is the only running task and does a sync wakeup; avoid
> going through select_idle_sibling() as it doesn't know the current CPU
> is going to be idle shortly.
> 
> Without this two sync wakers will ping-pong between CPUs for no
> reason.

That will make pipe-test go fugly -> pretty, and help very fast/light
localhost network, but eat heavier localhost overlap recovery.  We need
a working (and cheap) overlap detector scheme, so we can know when there
is enough to be worth going after.

(I sent you some lmbench numbers offline a while back showing the
two-faced little <b-word> in action, doing both good and evil)
> Suggested-by: Rik van Riel <riel@redhat.com>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> ---
>  kernel/sched/fair.c |   10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -3461,6 +3461,16 @@ select_task_rq_fair(struct task_struct *
>  		if (cpu != prev_cpu && wake_affine(affine_sd, p, sync))
>  			prev_cpu = cpu;
>  
> +		/*
> +		 * Don't bother with select_idle_sibling() in the case of a sync wakeup
> +		 * where we know the only running task will soon go away. Going
> +		 * through select_idle_sibling will only lead to pointless ping-pong.
> +		 */
> +		if (sync && prev_cpu == cpu && cpu_rq(cpu)->nr_running == 1) {
> +			new_cpu = cpu;
> +			goto unlock;
> +		}
> +
>  		new_cpu = select_idle_sibling(p, prev_cpu);
>  		goto unlock;
>  	}


