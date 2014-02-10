Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993AbaBJKKI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 05:10:08 -0500
Received: from mail-oa0-f51.google.com ([209.85.219.51]:61321 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147AbaBJKEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 05:04:30 -0500
MIME-Version: 1.0
In-Reply-To: <1391728237-4441-4-git-send-email-daniel.lezcano@linaro.org>
References: <1391728237-4441-1-git-send-email-daniel.lezcano@linaro.org>
	<1391728237-4441-4-git-send-email-daniel.lezcano@linaro.org>
Date: Mon, 10 Feb 2014 15:34:29 +0530
Message-ID: <CAM4v1pPPOE9xrH3AKc6sHAThPq43Ws_L_KuicRa5Ktr5nMBmtQ@mail.gmail.com>
Subject: Re: [PATCH V2 3/3] sched: Move idle_stamp up to the core
From: Preeti Murthy <preeti.lkml@gmail.com>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@kernel.org,
        alex.shi@linaro.org, LKML <linux-kernel@vger.kernel.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On Fri, Feb 7, 2014 at 4:40 AM, Daniel Lezcano
<daniel.lezcano@linaro.org> wrote:
> The idle_balance modifies the idle_stamp field of the rq, making this
> information to be shared across core.c and fair.c. As we can know if the
> cpu is going to idle or not with the previous patch, let's encapsulate the
> idle_stamp information in core.c by moving it up to the caller. The
> idle_balance function returns true in case a balancing occured and the cpu
> won't be idle, false if no balance happened and the cpu is going idle.
>
> Cc: mingo@kernel.org
> Cc: alex.shi@linaro.org
> Cc: peterz@infradead.org
> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> ---
>  kernel/sched/core.c  |   13 +++++++++++--
>  kernel/sched/fair.c  |   14 ++++++--------
>  kernel/sched/sched.h |    8 +-------
>  3 files changed, 18 insertions(+), 17 deletions(-)
>
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 16b97dd..428ee4c 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -2704,8 +2704,17 @@ need_resched:
>
>         pre_schedule(rq, prev);
>
> -       if (unlikely(!rq->nr_running))
> -               idle_balance(rq);
> +#ifdef CONFIG_SMP
> +       if (unlikely(!rq->nr_running)) {
> +               /*
> +                * We must set idle_stamp _before_ calling idle_balance(), such
> +                * that we measure the duration of idle_balance() as idle time.

Should not this be "such that we *do not* measure the duration of idle_balance()
as idle time?"

Thanks

Regards
Preeti U Murthy
