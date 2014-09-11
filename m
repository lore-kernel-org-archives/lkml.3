Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562AbaIKWQ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 18:16:28 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:36740 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbaIKWQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 18:16:27 -0400
Date: Thu, 11 Sep 2014 15:16:12 -0700
From: Darren Hart <dvhart@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Darren Hart <darren@dvhart.com>
Subject: Re: futex_wait_setup sleeping while atomic bug.
Message-ID: <20140911221611.GA18425@vmdeb7>
References: <20140911151040.GB3008@redhat.com>
 <alpine.DEB.2.10.1409112318500.4178@nanos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1409112318500.4178@nanos>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 11:52:02PM +0200, Thomas Gleixner wrote:
> On Thu, 11 Sep 2014, Dave Jones wrote:
> 
> > Hit this overnight on Linus tree from yesterday.
> > 
> > BUG: sleeping function called from invalid context at include/linux/freezer.h:56
> > in_atomic(): 1, irqs_disabled(): 0, pid: 31948, name: trinity-c121
> > Preemption disabled at:[<ffffffffb90f2512>] futex_wait_setup+0xb2/0x140
> 
> Huch? So we are in a preempt disabled region in futex_wait_setup and
> we get interrupted and end up in the signal delivery path?
> 
> I really love that futex stuff....
> 
> But fortunately the preemption disabled hint made it into mainline so
> looking at the callsites of futex_wait_setup() makes it pretty clear
> where the shit hits the fan. Patch below.
> 
> Thanks,
> 
> 	tglx
> 
> ------------------->
> From: Thomas Gleixner <tglx@linutronix.de>
> Date: Thu, 11 Sep 2014 23:44:35 +0200
> Subject: futex: Unlock hb->lock in futex_wait_requeue_pi() error path
> 
> futex_wait_requeue_pi() calls futex_wait_setup(). If
> futex_wait_setup() succeeds it returns with hb->lock held and
> preemption disabled. Now the sanity check after this does:
> 
>         if (match_futex(&q.key, &key2)) {
> 	   	ret = -EINVAL;
> 		goto out_put_keys;
> 	}
> 
> which releases the keys but does not release hb->lock. So we happily
> return to user space with hb->lock held and therefor preemption
> disabled.
> 
> Unlock hb->lock before taking the exit route.
> 
> Reported-by: Dave "Trinity" Jones <davej@redhat.com>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
> diff --git a/kernel/futex.c b/kernel/futex.c
> index d3a9d946d0b7..815d7af2ffe8 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -2592,6 +2592,7 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, unsigned int flags,
>  	 * shared futexes. We need to compare the keys:
>  	 */
>  	if (match_futex(&q.key, &key2)) {
> +		queue_unlock(hb);
>  		ret = -EINVAL;
>  		goto out_put_keys;
>  	}

I was hoping to move this before the key equivalence test so we could exit as
early as possible, but some idgit (that would be me) embedded the
get_futex_key() for uaddr into futex_wait_setup() to avoid so much duplication
of code... sigh.

Thomas's fix is the best immediate solution in my opinion.

Reviewed-by: Darren Hart <dvhart@linux.intel.com>

-- 
Darren Hart
Intel Open Source Technology Center
