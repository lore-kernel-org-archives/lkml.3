Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688AbaIOTP5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 15:15:57 -0400
Received: from service87.mimecast.com ([91.220.42.44]:42908 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754633AbaIOTPz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:15:55 -0400
Date: Mon, 15 Sep 2014 20:15:41 +0100
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "riel@redhat.com" <riel@redhat.com>, "efault@gmx.de" <efault@gmx.de>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>
Subject: Re: [PATCH v5 09/12] sched: add usage_load_avg
Message-ID: <20140915191541.GA28083@e103687>
References: <1409051215-16788-1-git-send-email-vincent.guittot@linaro.org>
 <1409051215-16788-10-git-send-email-vincent.guittot@linaro.org>
MIME-Version: 1.0
In-Reply-To: <1409051215-16788-10-git-send-email-vincent.guittot@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 15 Sep 2014 19:15:52.0053 (UTC) FILETIME=[7727FA50:01CFD119]
X-MC-Unique: 114091520155201901
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 12:06:52PM +0100, Vincent Guittot wrote:
> Add new statistics which reflect the average time a task is running on the
> CPU and the sum of the tasks' running on a runqueue. The latter is named
> usage_avg_contrib.
> 
> This patch is based on the usage metric that was proposed in the 1st
> versions of the per-entity load tracking patchset but that has be removed
> afterward. This version differs from the original one in the sense that it's
> not linked to task_group.
> 
> The rq's usage_avg_contrib will be used to check if a rq is overloaded or not
> instead of trying to compute how many task a group of CPUs can handle
> 
> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>

I should have read this patch before I did almost the same patch for as
part a series to introduce scale-invariance which I am about to post :(

The only difference I see is slightly different naming and that, AFAICT,
task group usage is not accounted for in this patch. Can we add the
support for task groups as well? I can provide a patch based on this one
if you want.

Also, since more than half this patch comes directly from PJT's original
patch I would add "by Paul Turner <pjt@google.com>" somewhere in the
text above.

[...]

> +static inline void __update_task_entity_usage(struct sched_entity *se)
> +{
> +	u32 contrib;
> +
> +	/* avoid overflowing a 32-bit type w/ SCHED_LOAD_SCALE */
> +	contrib = se->avg.running_avg_sum * scale_load_down(SCHED_LOAD_SCALE);
> +	contrib /= (se->avg.runnable_avg_period + 1);
> +	se->avg.usage_avg_contrib = scale_load(contrib);
> +}
> +
> +static long __update_entity_usage_avg_contrib(struct sched_entity *se)
> +{
> +	long old_contrib = se->avg.usage_avg_contrib;
> +
> +	if (entity_is_task(se))
> +		__update_task_entity_usage(se);

Groups are never updated?

As said above. I have code that does it.

Morten

> +
> +	return se->avg.usage_avg_contrib - old_contrib;
> +}
> +

