Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755746Ab3DVJbK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 05:31:10 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60443 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045Ab3DVJbI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 05:31:08 -0400
Message-ID: <1366623052.2721.6.camel@laptop>
Subject: Re: [PATCH v6] sched: fix init NOHZ_IDLE flag
From: Peter Zijlstra <peterz@infradead.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        mingo@kernel.org, fweisbec@gmail.com, pjt@google.com,
        rostedt@goodmis.org, efault@gmx.de
Date: Mon, 22 Apr 2013 11:30:52 +0200
In-Reply-To: <1366377044-23989-1-git-send-email-vincent.guittot@linaro.org>
References: <1366377044-23989-1-git-send-email-vincent.guittot@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-04-19 at 15:10 +0200, Vincent Guittot wrote:
> As suggested by Frederic Weisbecker, another solution is to have the
> same
> rcu lifecycle for both NOHZ_IDLE and sched_domain struct. I have
> introduce
> a new sched_domain_rq struct that is the entry point for both
> sched_domains
> and objects that must follow the same lifecycle like NOHZ_IDLE flags.
> They
> will share the same RCU lifecycle and will be always synchronized.
> 
> The synchronization is done at the cost of :
>  - an additional indirection for accessing the first sched_domain
> level
>  - an additional indirection and a rcu_dereference before accessing to
> the
>    NOHZ_IDLE flag.

> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index d35d2b6..61ad5f1 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -959,6 +959,18 @@ struct sched_domain {
>         unsigned long span[0];
>  };
>  
> +/*
> + * Some flags must stay synchronized with fields of sched_group_power
> and as a
> + * consequence they must follow the same lifecycle for the lockless
> scheme.
> + * sched_domain_rq encapsulates those flags and sched_domains in one
> RCU
> + * object.
> + */
> +struct sched_domain_rq {
> +       struct sched_domain *sd;
> +       unsigned long flags;
> +       struct rcu_head rcu;    /* used during destruction */
> +};

I'm not quite getting things.. what's wrong with adding this flags
thing to sched_domain itself? That's already RCU destroyed so why add a
second RCU layer?

We also have the root_domain for things that don't need to go in a
hierarchy but are once per cpu -- it sounds like this is one of those
things; iirc the root_domain life-time is the same as the entire
sched_domain tree so adding it to the root_domain is also an option.

