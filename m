Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757403AbaFZCDT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 22:03:19 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:52718 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754810AbaFZCDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 22:03:18 -0400
Date: Wed, 25 Jun 2014 22:03:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Subbaraman Narayanamurthy <subbaram@codeaurora.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kthread: Fix the race condition when kthread is parked
Message-ID: <20140626020316.GB25209@home.goodmis.org>
References: <53AB2643.8050901@codeaurora.org>
 <alpine.DEB.2.10.1406260004110.5170@nanos>
 <20140626020022.GA25209@home.goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140626020022.GA25209@home.goodmis.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 10:00:22PM -0400, Steven Rostedt wrote:
> On Thu, Jun 26, 2014 at 02:43:56AM +0200, Thomas Gleixner wrote:
> > 
> > Subject: kthread: Plug park/ unplug race
> > From: Thomas Gleixner <tglx@linutronix.de>
> > Date: Thu, 26 Jun 2014 01:24:36 +0200
> > 
> > The kthread park/unpark logic has the following issue:
> > 
> > Task   CPU 0				CPU 1
> > 
> > T1     unplug cpu1
> >        kthread_park(T2)
> >        set_bit(KTHREAD_SHOULD_PARK);
> > 	  wait_for_completion()
> > T2					parkme(X)
> 
> But with your patch, isn't it possible for T1 to call thread_unpark here?

Let me answer that.... No, it can't.

I missed the wait_for_completion() above, which will prevent this from happening.

Nevermind, I'll go work on something less brain intensive.

-- Steve

> 
> Then looking at the code I see this turn of events:
> 
>   if (test_bit(KTHREAD_IS_PER_CPU, &kthread->flags))
>         __kthread_bind(k, kthread->cpu, TASK_PARKED);
> 
> Which in __kthread_bind() (state == TASK_PARKED)
> 
> 	if (!wait_task_inactive(p, state)) {
> 		WARN_ON(1);
> 		return;
> 	}
> 
> Where wait_task_inactive() does:
> 
> 		while (task_running(rq, p)) {
> 			if (match_state && unlikely(p->state != match_state))
> 				return 0;
> 
> As match_state is non zero and p->state != match_state because it hasn't been
> set yet. The wait_task_inactive() returns zero, and then we hit the WARN_ON()
> in __kthread_bind().
> 
> -- Steve
