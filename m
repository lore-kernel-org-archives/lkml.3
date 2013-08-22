Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477Ab3HVI7C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 04:59:02 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:48011 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752127Ab3HVI67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 04:58:59 -0400
MIME-Version: 1.0
In-Reply-To: <20130819160425.088015040@infradead.org>
References: <20130819160058.539049611@infradead.org> <20130819160425.088015040@infradead.org>
From: Paul Turner <pjt@google.com>
Date: Thu, 22 Aug 2013 01:58:28 -0700
Message-ID: <CAPM31R+2pH9-g6O5EKi1FfgiRjKxAMiN6UW3VO=FpUq463Ji3Q@mail.gmail.com>
Subject: Re: [PATCH 01/10] sched: Remove one division operation in find_busiest_queue()
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Mike Galbraith <efault@gmx.de>,
        Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Namhyung Kim <namhyung@kernel.org>, Lei Wen <leiwen@marvell.com>,
        Joonsoo Kim <js1304@gmail.com>, Rik van Riel <riel@surriel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 19, 2013 at 9:00 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
>
> Remove one division operation in find_busiest_queue() by using
> crosswise multiplication:
>
>         wl_i / power_i > wl_j / power_j :=
>         wl_i * power_j > wl_j * power_i
>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> [peterz: expanded changelog]
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> Link: http://lkml.kernel.org/r/1375778203-31343-2-git-send-email-iamjoonsoo.kim@lge.com
> ---
>  kernel/sched/fair.c |    9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
>
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -5018,7 +5018,7 @@ static struct rq *find_busiest_queue(str
>                                      struct sched_group *group)
>  {
>         struct rq *busiest = NULL, *rq;
> -       unsigned long max_load = 0;
> +       unsigned long busiest_load = 0, busiest_power = SCHED_POWER_SCALE;

Initializing this to SCHED_POWER_SCALE assigns a meaning that isn't
really there.  How about just 1?

>         int i;
>
>         for_each_cpu(i, sched_group_cpus(group)) {
> @@ -5049,10 +5049,9 @@ static struct rq *find_busiest_queue(str
>                  * the load can be moved away from the cpu that is potentially
>                  * running at a lower capacity.
>                  */
> -               wl = (wl * SCHED_POWER_SCALE) / power;
> -
> -               if (wl > max_load) {
> -                       max_load = wl;

A comment wouldn't hurt here.

> +               if (wl * busiest_power > busiest_load * power) {
> +                       busiest_load = wl;
> +                       busiest_power = power;
>                         busiest = rq;
>                 }
>         }
>
>
