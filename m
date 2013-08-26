Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529Ab3HZC4m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Aug 2013 22:56:42 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:55703 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755320Ab3HZC4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Aug 2013 22:56:41 -0400
MIME-Version: 1.0
In-Reply-To: <20130819160425.230612223@infradead.org>
References: <20130819160058.539049611@infradead.org>
	<20130819160425.230612223@infradead.org>
Date: Mon, 26 Aug 2013 10:56:39 +0800
Message-ID: <CALZhoSRtyS1G6jpKwxqyx=GxFP8dvo0Qq=wGfNkw=Kya3yBEow@mail.gmail.com>
Subject: Re: [PATCH 03/10] sched: Clean-up struct sd_lb_stat
From: Lei Wen <adrian.wenl@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
        Paul Turner <pjt@google.com>, Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>, Lei Wen <leiwen@marvell.com>,
        Rik van Riel <riel@surriel.com>, Joonsoo Kim <js1304@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 12:01 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
>
> There is no reason to maintain separate variables for this_group
> and busiest_group in sd_lb_stat, except saving some space.
> But this structure is always allocated in stack, so this saving
> isn't really benificial [peterz: reducing stack space is good; in this
> case readability increases enough that I think its still beneficial]
>
> This patch unify these variables, so IMO, readability may be improved.
>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> [peterz: lots of style edits, a few fixes and a rename]
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> Link: http://lkml.kernel.org/r/1375778203-31343-4-git-send-email-iamjoonsoo.kim@lge.com
> ---
>  kernel/sched/fair.c |  225 +++++++++++++++++++++++++---------------------------
>  1 file changed, 112 insertions(+), 113 deletions(-)
>
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4277,36 +4277,6 @@ static unsigned long task_h_load(struct
>
[snip]...
> -       env->imbalance = DIV_ROUND_CLOSEST(
> -               sds->max_load * sds->busiest->sgp->power, SCHED_POWER_SCALE);
> +       env->imbalance = DIV_ROUND_CLOSEST(sds->busiest_stat.avg_load *
> +                               sds->busiest->sgp->power, SCHED_POWER_SCALE);
>

I am wondering whether we could change this line as below is more appropriate,
since it would avoid the division here:
       env->imbalance = (sds->busiest_stat.avg_load * sds->busiest->sgp->power)
                                      >> SCHED_POWER_SHIFT;

I am not sure whether compiler would be smarter enough to covert into
>> operation,
if it see SCHED_POWER_SCALE is 1024 here.

Thanks,
Lei
