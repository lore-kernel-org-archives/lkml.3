Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254Ab3FYX1D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 19:27:03 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:34056 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774Ab3FYX1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 19:27:01 -0400
Date: Tue, 25 Jun 2013 16:26:57 -0700
From: Tejun Heo <tj@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Clark Williams <clark@redhat.com>,
        "Paul E. McKenney" <paulmck@us.ibm.com>
Subject: Re: question about disabling interrupts for workqueue pool?
Message-ID: <20130625232657.GC30407@mtj.dyndns.org>
References: <1372200754.18733.236.camel@gandalf.local.home>
 <20130625230129.GA30407@mtj.dyndns.org>
 <1372202344.18733.242.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372202344.18733.242.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Steven.

On Tue, Jun 25, 2013 at 07:19:04PM -0400, Steven Rostedt wrote:
> Why is that silly? It actually makes plenty of sense. Now if
> preempt_disable/enable was nested in spin_lock_irq_save/restore() now
> that would be pretty silly.

If you know you're gonna be disabling irq pretty soon, you don't need
to do that, so...

> Just looking at the first part of that function:
> 
> 	local_irq_disable();
> 	pool = get_work_pool(work);
> 	if (!pool) {
> 		local_irq_enable();
> 		return false;
> 	}
> 
> On the case of poll == NULL, we disabled interrupts for no reason.

It's much more likely that get_work_pool() there returns !NULL.  I
didn't think it'd matter enough to put likely().  Sure, it's nice to
not disable interrupts but really, in upstream, I don't think the
above matters in the upstream kernel.  The extra coverage is at the
worst idr_find() into single level idr.

> It may take a bit of understanding the code before I send a patch. But
> I'll start looking into it.

Wrapping from local_irq_disable() to spin_unlock_irq() with RCU sched
read lock/unlock should do, I think.

Thanks!

-- 
tejun
