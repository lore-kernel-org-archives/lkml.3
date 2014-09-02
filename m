Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886AbaIBRjW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 13:39:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:35305 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754827AbaIBRjV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 13:39:21 -0400
Date: Tue, 2 Sep 2014 19:39:10 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Kautuk Consul <consul.kautuk@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, David Rientjes <rientjes@google.com>,
        Ionut Alexa <ionut.m.alexa@gmail.com>,
        Guillaume Morin <guillaume@morinfr.org>, linux-kernel@vger.kernel.org,
        Kirill Tkhai <tkhai@yandex.ru>
Subject: Re: [PATCH 1/1] do_exit(): Solve possibility of BUG() due to race
 with try_to_wake_up()
Message-ID: <20140902173910.GF27892@worktop.ger.corp.intel.com>
References: <1408964064-21447-1-git-send-email-consul.kautuk@gmail.com>
 <20140825155738.GA5944@redhat.com>
 <20140901153935.GQ27892@worktop.ger.corp.intel.com>
 <20140901175851.GA15210@redhat.com>
 <20140901190931.GD5806@worktop.ger.corp.intel.com>
 <20140902155208.GA28668@redhat.com>
 <20140902164714.GA17033@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20140902164714.GA17033@redhat.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, 2014 at 06:47:14PM +0200, Oleg Nesterov wrote:

> But since I already wrote v2 yesterday, let me show it anyway. Perhaps
> you will notice something wrong immediately...
> 
> So, once again, this patch adds the ugly "goto" into schedule(). OTOH,
> it removes the ugly spin_unlock_wait(pi_lock).

But schedule() is called _far_ more often than exit(). It would be
really good not to have to do that. 

> TASK_DEAD can die. The only valid user is schedule_debug(), trivial to
> change. The usage of TASK_DEAD in task_numa_fault() is wrong in any case.
> 
> In fact, I think that the next change can change exit_schedule() to use
> PREEMPT_ACTIVE, and then we can simply remove the TASK_DEAD check in
> schedule_debug().

So you worry about concurrent wakeups vs setting TASK_DEAD and thereby
loosing it, right?

Would not something like:

	spin_lock_irq(&current->pi_lock);
	__set_current_state(TASK_DEAD);
	spin_unlock_irq(&current->pi_lock);

Not be race free and similarly expensive to the smp_mb() we have there
now?

> -	BUG();
> -	/* Avoid "noreturn function does return".  */
> -	for (;;)
> -		cpu_relax();	/* For when BUG is null */


> +void exit_schedule(void)
> +{
> +	current->state = TASK_DEAD; /* TODO: kill TASK_DEAD altogether */
> +	task_rq(current)->prev_dead = true;
> +	__schedule();
> +	BUG();

you lost that for loop.
