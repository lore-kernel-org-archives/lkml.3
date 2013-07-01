Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204Ab3GAOHs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 10:07:48 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:50947 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916Ab3GAOHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 10:07:47 -0400
MIME-Version: 1.0
In-Reply-To: <1372682002-15373-3-git-send-email-leiwen@marvell.com>
References: <1372662634-12833-1-git-send-email-leiwen@marvell.com>
 <1372682002-15373-1-git-send-email-leiwen@marvell.com> <1372682002-15373-3-git-send-email-leiwen@marvell.com>
From: Paul Turner <pjt@google.com>
Date: Mon, 1 Jul 2013 07:07:15 -0700
Message-ID: <CAPM31R+4ysf6xZ84G=JMhx=X9pcFuRPfUX5Q0-4CTKdVPeVA1w@mail.gmail.com>
Subject: Re: [V2 2/2] sched: update cfs_rq weight earlier in enqueue_entity
To: Lei Wen <leiwen@marvell.com>
Cc: Alex Shi <alex.shi@intel.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, Ingo Molnar <mingo@redhat.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Could you please restate the below?

On Mon, Jul 1, 2013 at 5:33 AM, Lei Wen <leiwen@marvell.com> wrote:
> Since we are going to calculate cfs_rq's average ratio by
> runnable_load_avg/load.weight

I don't understand what you mean by this.

>, if not increase the load.weight prior to
> enqueue_entity_load_avg, it may lead to one cfs_rq's avg ratio higher
> than 100%.
>

Or this.

> Adjust the sequence, so that all ratio is kept below 100%.
>
> Signed-off-by: Lei Wen <leiwen@marvell.com>
> ---
>  kernel/sched/fair.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 07bd74c..d1eee84 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -1788,8 +1788,8 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
>          * Update run-time statistics of the 'current'.
>          */
>         update_curr(cfs_rq);
> -       enqueue_entity_load_avg(cfs_rq, se, flags & ENQUEUE_WAKEUP);
>         account_entity_enqueue(cfs_rq, se);
> +       enqueue_entity_load_avg(cfs_rq, se, flags & ENQUEUE_WAKEUP);

account_entity_enqueue is independent of enqueue_entity_load_avg;
their order should not matter.

Further, should we restore the reverted amortization commit (improves
context switch times) enqueue_entity_load_avg needs to precede
account_entity_enqueue as it may update se->load.weight.

>         update_cfs_shares(cfs_rq);
>
>         if (flags & ENQUEUE_WAKEUP) {
> --
> 1.7.10.4
>
