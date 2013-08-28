Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812Ab3H1XL6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 19:11:58 -0400
Received: from mail-qe0-f44.google.com ([209.85.128.44]:64748 "EHLO
	mail-qe0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393Ab3H1XL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 19:11:56 -0400
MIME-Version: 1.0
In-Reply-To: <20130828213337.GC18971@mtj.dyndns.org>
References: <1377724032-12199-1-git-send-email-jamieliu@google.com>
	<20130828211312.GB18971@mtj.dyndns.org>
	<20130828213337.GC18971@mtj.dyndns.org>
Date: Wed, 28 Aug 2013 16:11:56 -0700
Message-ID: <CAKU+Ga_awbok9wTjbnrNbwqGcF0sagHpf729ZDxYdNVPMhc81A@mail.gmail.com>
Subject: Re: [PATCH] workqueue: cond_resched() after processing each work item
From: Jamie Liu <jamieliu@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On Wed, Aug 28, 2013 at 2:33 PM, Tejun Heo <tj@kernel.org> wrote:
> Would something like the following work?  Can you please verify it?

I confirm that this works.

> Thanks.
> ---- 8< ----
> If !PREEMPT, a kworker running work items back to back can hog CPU.
> This becomes dangerous when a self-requeueing work item which is
> waiting for something to happen races against stop_machine.  Such
> self-requeueing work item would requeue itself indefinitely hogging
> the kworker and CPU it's running on while stop_machine would wait for
> that CPU to enter stop_machine while preventing anything else from
> happening on all other CPUs.  The two would deadlock.
>
> Jmamie Liu reports that this deadlock scenario exists around

s/Jmamie/Jamie/

> scsi_requeue_run_queue() and libata port multiplier support, where one
> port may exclude command processing from other ports.  With the right
> timing, scsi_requeue_run_queue() can end up requeueing itself trying
> to execute an IO which is asked to be retried while another device has
> an exclusive access, which in turn can't make forward progress due to
> stop_machine.
>
> Fix it by invoking cond_resched() after executing each work item.
>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Jamie Liu <jamieliu@google.com>
> References: http://thread.gmane.org/gmane.linux.kernel/1552567
> Cc: stable@vger.kernel.org
> --
>  kernel/workqueue.c |    9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index f02c4a4..73b662b 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -2201,6 +2201,15 @@ __acquires(&pool->lock)
>                 dump_stack();
>         }
>
> +       /*
> +        * The following prevents a kworker from hogging CPU on !PREEMPT
> +        * kernels, where a requeueing work item waiting for something to
> +        * happen could deadlock with stop_machine as such work item could
> +        * indefinitely requeue itself while all other CPUs are trapped in
> +        * stop_machine.
> +        */
> +       cond_resched();
> +
>         spin_lock_irq(&pool->lock);
>
>         /* clear cpu intensive status */

Thanks,
Jamie
