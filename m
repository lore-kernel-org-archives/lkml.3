Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751678Ab3CURlk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 13:41:40 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:33461 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941Ab3CURli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 13:41:38 -0400
Date: Thu, 21 Mar 2013 10:41:33 -0700
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <eag0628@gmail.com>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/21] workqueue: remove worker_maybe_bind_and_lock()
Message-ID: <20130321174133.GA20500@htj.dyndns.org>
References: <1363721306-2030-1-git-send-email-laijs@cn.fujitsu.com>
 <1363721306-2030-16-git-send-email-laijs@cn.fujitsu.com>
 <20130320181010.GA30484@htj.dyndns.org>
 <CACvQF512Ufz-Y2HjLKOGNW8A+9epcv6yvB8szyR4S9d4Uy41Sw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACvQF512Ufz-Y2HjLKOGNW8A+9epcv6yvB8szyR4S9d4Uy41Sw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Lai.

On Thu, Mar 21, 2013 at 07:03:30PM +0800, Lai Jiangshan wrote:
> On Thu, Mar 21, 2013 at 2:10 AM, Tejun Heo <tj@kernel.org> wrote:
> > On Wed, Mar 20, 2013 at 03:28:15AM +0800, Lai Jiangshan wrote:
> >>  static struct worker *alloc_worker(void)
> >>  {
> >>       struct worker *worker;
> >> @@ -2326,7 +2262,8 @@ repeat:
> >>               spin_unlock_irq(&wq_mayday_lock);
> >>
> >>               /* migrate to the target cpu if possible */
> >> -             worker_maybe_bind_and_lock(pool);
> >> +             set_cpus_allowed_ptr(current, pool->attrs->cpumask);
> >> +             spin_lock_irq(&pool->lock);
> >>               rescuer->pool = pool;
> >
> > You can't do this.  The CPU might go up between set_cpus_allowed_ptr()
> > and spin_lock_irq() and the rescuer can end up executing a work item
> > which was issued while the target CPU is up on the wrong CPU.
> 
> 
> Why it is wrong?
> It can be allowed if the wq has rescuer. (wq of work_on_cpu() don't has rescuer,
> it does not hurt to work_on_cpu() of something else.
> 
> Actually it was allowed by recent patches.
> If a cpu is up while a rescuer do process_scheduled_workers(),
> all the later work item will be running the wrong CPU while
>  the target CPU is up.(due to for_cpu_pool_workers() don't include
> active rescuer).

So,

* If the user wraps queueing and flushing inside get_online_cpus(), it
  better gets executed and finishes on the target CPU.

* Similarly, it must guaranteed that any work items queued and flushed
  by CPU_ONLINE or CPU_DOWN_PREP notifiers should start and finish
  execution on the target CPU.

Your patch breaks the above.

> I don't want to go back to make cpuhotplug nor rescuer_theread become
> complicated.
> so I prefer to allow work item can run on wrong cpu if the wq has rescuer.
> All just needs a comments.

It is explained in the comment.

> I guess you will agaist me...... let me rewrite it .....

It's not because I'm "against" you.  It's because it's buggy and we
wouldn't have any affinity guarantee with the proposed changes.  If
you can maintain the guarantees and remove
worker_maybe_bind_and_lock(), please be my guest.

Thanks.

-- 
tejun
