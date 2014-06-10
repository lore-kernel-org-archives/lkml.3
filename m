Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752931AbaFJRrs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 13:47:48 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:6243 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752690AbaFJRrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 13:47:47 -0400
Date: Tue, 10 Jun 2014 13:47:45 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Jason Low <jason.low2@hp.com>, Brad Mouring <bmouring@ni.com>
Subject: Re: [patch V3 7/7] rtmutex: Avoid pointless requeueing in the
 deadlock detection chain walk
Message-ID: <20140610134745.668c8a4e@gandalf.local.home>
In-Reply-To: <alpine.DEB.2.10.1406101630350.31315@nanos>
References: <20140609201118.387571774@linutronix.de>
	<20140609202336.506044876@linutronix.de>
	<20140609212033.1cff0999@gandalf.local.home>
	<alpine.DEB.2.10.1406101630350.31315@nanos>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2014 19:41:39 +0200 (CEST)
Thomas Gleixner <tglx@linutronix.de> wrote:

 
> > On the loop back around, have something like:
> > 
> > 	if (top_waiter) {
> > 		if (!task_has_pi_waiters(task))
> > 			goto out_unlock_pi;
> 
> 	The task has at least one pi waiter.
>  
> > 		if (!requeue &&
> > 		    top_waiter != task_top_pi_waiter(task)) {
> > 			if (!detect_deadlock)
> > 				goto out_unlock_pi;
> > 			else
> > 				requeue = false;
> > 		}
> 
> 	Errm? if requeue is off we are in deadlock detection chainwalk
> 	mode. So all we care about is whether task is blocked on
> 	next_lock or not.

Actually that was a typo on my part. That should have been:

	if (requeue &&
		...

As we don't need to read the task_top_pi_waiter() again.

-- Steve

