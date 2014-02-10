Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781AbaBJRwu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 12:52:50 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:6944 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752279AbaBJRws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 12:52:48 -0500
Date: Mon, 10 Feb 2014 12:52:45 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Nicholas Mc Guire <der.herr@hofr.at>
Cc: linux-rt-users@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Carsten Emde <C.Emde@osadl.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andreas Platschek <platschek@ict.tuwien.ac.at>
Subject: Re: allow preemption in check_task_state
Message-ID: <20140210125245.1afc834d@gandalf.local.home>
In-Reply-To: <20140210171712.GA17517@opentech.at>
References: <20140210153856.GD20017@opentech.at>
	<20140210111106.67438d1e@gandalf.local.home>
	<20140210171712.GA17517@opentech.at>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Feb 2014 18:17:12 +0100
Nicholas Mc Guire <der.herr@hofr.at> wrote:


> > 
> > In rtmutex.c we have:
> > 
> > 	pi_lock(&self->pi_lock);
> > 	__set_current_state(self->saved_state);
> > 	self->saved_state = TASK_RUNNING;
> > 	pi_unlock(&self->pi_lock);
> > 
> > As there is no wmb() here, it can be very possible that another CPU
> > will see saved_state as TASK_RUNNING, and current state as
> > TASK_RUNNING, and miss the update completely.
> > 
> > I would not want to add a wmb() unless there is a real bug with the
> > check state, as the above is in a very fast path and the check state is
> > in a slower path.
> >
> maybe I'm missing/missunderstanding something here but
> pi_unlock -> arch_spin_unlock is a full mb() 
> so once any task did an update of the state the loop should be catching
> this update ? if the loop exits before the updat takes effect (pi_unlock)
> would that be ncorrect ?

Even if the spin locks were full memory barriers, it is still buggy.
The fact that we set current_state to saved_state, and then saved_state
to TASK_RUNNING without any memory barriers in between those two
statements, means that the reader (even with a rmb()) can still see
both as TASK_RUNNING.

-- Steve
