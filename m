Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318Ab3FFUs0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 16:48:26 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:64859 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989Ab3FFUsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 16:48:24 -0400
Date: Thu, 6 Jun 2013 13:48:21 -0700
From: Tejun Heo <tj@kernel.org>
To: greearb@candelatech.com
Cc: linux-kernel@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: [PATCH v2] Fix lockup related to stop_machine being stuck in
 __do_softirq.
Message-ID: <20130606204821.GB5045@htj.dyndns.org>
References: <1370535006-3467-1-git-send-email-greearb@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370535006-3467-1-git-send-email-greearb@candelatech.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 06, 2013 at 09:10:06AM -0700, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> The stop machine logic can lock up if all but one of
> the migration threads make it through the disable-irq
> step and the one remaining thread gets stuck in
> __do_softirq.  The reason __do_softirq can hang is
> that it has a bail-out based on jiffies timeout, but
> in the lockup case, jiffies itself is not incremented.
> 
> To work around this, re-add the max_restart counter in __do_irq
> and stop processing irqs after 10 restarts.
> 
> Thanks to Tejun Heo and Rusty Russell and others for
> helping me track this down.
> 
> This was introduced in 3.9 by commit:  c10d73671ad30f5469
> (softirq:  reduce latencies).
> 
> It may be worth looking into ath9k to see if it has issues with
> it's irq handler at a later date.
> 
> The hang stack traces look something like this:

Oops, you already posted the second version.  :)

>  /*
> - * We restart softirq processing for at most 2 ms,
> - * and if need_resched() is not set.
> + * We restart softirq processing for at most MAX_SOFTIRQ_RESTART times,
> + * but break the loop if need_resched() is set or after 2 ms.
>   *
>   * These limits have been established via experimentation.
>   * The two things to balance is latency against fairness -
> @@ -204,6 +204,7 @@ EXPORT_SYMBOL(local_bh_enable_ip);
>   * should not be able to lock up the box.
>   */
>  #define MAX_SOFTIRQ_TIME  msecs_to_jiffies(2)
> +#define MAX_SOFTIRQ_RESTART 10

As wrote before, a brief explanation on why both are necessary would
be nice.  Something like - "the time limit prevents from introducing
excessive latency from softirq handling and the loop limit protects
against softirq runaway which may happen during stop_machine - see
XXX".

Please cc Linus and also cc stable@vger.kernel.org.  We definitely
want this backported.

Thanks a lot!

-- 
tejun
