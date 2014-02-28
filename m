Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862AbaB1Kvk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 05:51:40 -0500
Received: from relay.parallels.com ([195.214.232.42]:35943 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbaB1Kvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 05:51:39 -0500
Message-ID: <1393584643.3522.5.camel@tkhai>
Subject: Re: [PATCH]sched/core: Return possibility to set RT and DL classes
 back
From: Kirill Tkhai <ktkhai@parallels.com>
To: <linux-kernel@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        <tkhai@yandex.ru>
Date: Fri, 28 Feb 2014 14:50:43 +0400
In-Reply-To: <1393496657.3522.3.camel@tkhai>
References: <1393496657.3522.3.camel@tkhai>
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas, have you seen this?

Nothing works at the moment:

now

   21 root      20   0     0    0    0 S  0.0  0.0   0:00.00 watchdog/3                                                                                                                                            
   16 root      20   0     0    0    0 S  0.0  0.0   0:00.00 watchdog/2                                                                                                                                            
   11 root      20   0     0    0    0 S  0.0  0.0   0:00.00 watchdog/1                                                                                                                                            
   10 root      20   0     0    0    0 S  0.0  0.0   0:00.00 watchdog/0

   22 root      20   0     0    0    0 S  0.0  0.0   0:00.00 migration/3                                                                                                                                           
   17 root      20   0     0    0    0 S  0.0  0.0   0:00.00 migration/2                                                                                                                                           
   12 root      20   0     0    0    0 S  0.0  0.0   0:00.04 migration/1                                                                                                                                           
    9 root      20   0     0    0    0 S  0.0  0.0   0:00.20 migration/0

with fix

   21 root      RT   0     0    0    0 S  0.0  0.0   0:00.00 watchdog/3         
   16 root      RT   0     0    0    0 S  0.0  0.0   0:00.00 watchdog/2         
   11 root      RT   0     0    0    0 S  0.0  0.0   0:00.00 watchdog/1         
   10 root      RT   0     0    0    0 S  0.0  0.0   0:00.00 watchdog/0

   22 root      RT   0     0    0    0 S  0.0  0.0   0:00.00 migration/3                                                                                                                                           
   17 root      RT   0     0    0    0 S  0.0  0.0   0:00.03 migration/2                                                                                                                                           
   12 root      RT   0     0    0    0 S  0.0  0.0   0:00.00 migration/1                                                                                                                                           
    9 root      RT   0     0    0    0 S  0.0  0.0   0:00.24 migration/0

В Чт, 27/02/2014 в 14:24 +0400, Kirill Tkhai пишет:
> [PATCH]sched/core: Return possibility to set RT and DL classes back
> 
> I found that it's impossible to set RT policy for tasks at the moment.
> 
> This is regression after commit [sched: Consider pi boosting in setscheduler()]
> 				[c365c292d05908c6ea6f32708f331e21033fe71d     ]
> Fix that.
> 
> Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Peter Zijlstra <peterz@infradead.org>
> CC: Ingo Molnar <mingo@redhat.com>
> ---
>  kernel/sched/core.c | 4 ++++
>  1 file changed, 4 insertions(+)
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 84b23ce..30cf9ad 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -3193,6 +3193,10 @@ static void __setscheduler_params(struct task_struct *p,
>  	 * getparam()/getattr() don't report silly values for !rt tasks.
>  	 */
>  	p->rt_priority = attr->sched_priority;
> +
> +	p->normal_prio = normal_prio(p);
> +	p->prio = rt_mutex_getprio(p);
> +
>  	set_load_weight(p);
>  }
>  
> 


