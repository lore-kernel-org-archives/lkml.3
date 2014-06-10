Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038AbaFJPTq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 11:19:46 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:5823 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753009AbaFJPTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 11:19:45 -0400
Date: Tue, 10 Jun 2014 11:19:42 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Brad Mouring" <bmouring@ni.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jason Low <jason.low2@hp.com>
Subject: Re: [patch V3 7/7] rtmutex: Avoid pointless requeueing in the
 deadlock detection chain walk
Message-ID: <20140610111942.668d4058@gandalf.local.home>
In-Reply-To: <20140610145725.GA29976@linuxgetsreal>
References: <20140609201118.387571774@linutronix.de>
	<20140609202336.506044876@linutronix.de>
	<20140610145725.GA29976@linuxgetsreal>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2014 09:57:25 -0500
"Brad Mouring" <bmouring@ni.com> wrote:


> > +		/* Store whether owner is blocked itself and drop locks */
> > +		next_lock = task_blocked_on(task);
> task_blocked_on(task) is not clear to me, the recipient of the
> return is the only clue that hints at what the function does.

Well, this is more than confusing, it's the only user, all other users
are task_blocked_on_lock(), and this causes the code not to compile.

-- Steve


> > +		raw_spin_unlock_irqrestore(&task->pi_lock, flags);
> > +		raw_spin_unlock(&lock->wait_lock);
> > +
> > +		/* If owner is not blocked, end of chain. */
> > +		if (!next_lock)
> > +			goto out_put_task;
> > +		goto again;
> > +	}
> > +
> > +	/*
> >  	 * Store the current top waiter before doing the requeue
> >  	 * operation on @lock. We need it for the boost/deboost
> >  	 * decision below.
> > 
> > 

