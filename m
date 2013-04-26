Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752356Ab3DZNKQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 09:10:16 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:33500
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752769Ab3DZNKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 09:10:14 -0400
Date: Fri, 26 Apr 2013 15:08:35 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-kernel@lists.linaro.org, mingo@kernel.org,
        linux@arm.linux.org.uk, pjt@google.com, santosh.shilimkar@ti.com,
        Morten.Rasmussen@arm.com, chander.kashyap@linaro.org,
        cmetcalf@tilera.com, tony.luck@intel.com, alex.shi@intel.com,
        preeti@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de, len.brown@intel.com, arjan@linux.intel.com,
        amit.kucheria@linaro.org, corbet@lwn.net, l.majewski@samsung.com
Subject: Re: [PATCH 07/14] sched: agressively pack at wake/fork/exec
Message-ID: <20130426130835.GA13964@dyad.programming.kicks-ass.net>
References: <1366910611-20048-1-git-send-email-vincent.guittot@linaro.org>
 <1366910611-20048-8-git-send-email-vincent.guittot@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366910611-20048-8-git-send-email-vincent.guittot@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 25, 2013 at 07:23:23PM +0200, Vincent Guittot wrote:
> According to the packing policy, the scheduler can pack tasks at different
> step:
> -SCHED_PACKING_NONE level: we don't pack any task.
> -SCHED_PACKING_DEFAULT: we only pack small tasks at wake up when system is not
> busy.
> -SCHED_PACKING_FULL: we pack tasks at wake up until a CPU becomes full. During
> a fork or a exec, we assume that the new task is a full running one and we
> look for an idle CPU close to the buddy CPU.

This changelog is very short on explaining how it will go about achieving these
goals.

> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
> ---
>  kernel/sched/fair.c |   47 ++++++++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 42 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 98166aa..874f330 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -3259,13 +3259,16 @@ static struct sched_group *
>  find_idlest_group(struct sched_domain *sd, struct task_struct *p,


So for packing into power domains, wouldn't you typically pick the busiest non-
full domain to fill from other non-full?

Picking the idlest non-full seems like it would generate a ping-pong or not
actually pack anything.
