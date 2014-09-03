Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932898AbaICNjs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 09:39:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30648 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932357AbaICNjg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 09:39:36 -0400
Date: Wed, 3 Sep 2014 15:36:40 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Kautuk Consul <consul.kautuk@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, David Rientjes <rientjes@google.com>,
        Ionut Alexa <ionut.m.alexa@gmail.com>,
        Guillaume Morin <guillaume@morinfr.org>, linux-kernel@vger.kernel.org,
        Kirill Tkhai <tkhai@yandex.ru>
Subject: Re: [PATCH 1/1] do_exit(): Solve possibility of BUG() due to race
	with try_to_wake_up()
Message-ID: <20140903133640.GA25439@redhat.com>
References: <1408964064-21447-1-git-send-email-consul.kautuk@gmail.com> <20140825155738.GA5944@redhat.com> <20140901153935.GQ27892@worktop.ger.corp.intel.com> <20140901175851.GA15210@redhat.com> <20140901190931.GD5806@worktop.ger.corp.intel.com> <20140902155208.GA28668@redhat.com> <20140902164714.GA17033@redhat.com> <20140902173910.GF27892@worktop.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140902173910.GF27892@worktop.ger.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter, sorry for slow responses.

On 09/02, Peter Zijlstra wrote:
>
> On Tue, Sep 02, 2014 at 06:47:14PM +0200, Oleg Nesterov wrote:
>
> > But since I already wrote v2 yesterday, let me show it anyway. Perhaps
> > you will notice something wrong immediately...
> >
> > So, once again, this patch adds the ugly "goto" into schedule(). OTOH,
> > it removes the ugly spin_unlock_wait(pi_lock).
>
> But schedule() is called _far_ more often than exit(). It would be
> really good not to have to do that.

Yes sure, performance-wise this is not a win. My point was, this way the
whole "last schedule" logic becomes very simple.

But OK, I buy your nack. I understand that we should not penalize
__schedule() if possible. Let's forget this patch.

> > TASK_DEAD can die. The only valid user is schedule_debug(), trivial to
> > change. The usage of TASK_DEAD in task_numa_fault() is wrong in any case.
> >
> > In fact, I think that the next change can change exit_schedule() to use
> > PREEMPT_ACTIVE, and then we can simply remove the TASK_DEAD check in
> > schedule_debug().
>
> So you worry about concurrent wakeups vs setting TASK_DEAD and thereby
> loosing it, right?
>
> Would not something like:
>
> 	spin_lock_irq(&current->pi_lock);
> 	__set_current_state(TASK_DEAD);
> 	spin_unlock_irq(&current->pi_lock);

Sure. This should obviously fix the problem.

And, I think, another mb() after unlock_wait should fix it as well.

> Not be race free and similarly expensive to the smp_mb() we have there
> now?

Ah, I simply do not know what is cheaper, even on x86. Well, we need
to enable/disable irqs, but again I do not really know how much does
this cost. I can even say what (imo) looks better, lock/unlock above
or

	// Ensure that the previous __set_current_state(RUNNING) can't
	// leak after spin_unlock_wait()
	smp_mb();
	spin_unlock_wait();
	// Another mb to ensure this too can't be reordered with unlock_wait
	set_current_state(TASK_DEAD);

What do you think looks better?

Oleg.

