Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440Ab3CRQ11 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 12:27:27 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54962 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859Ab3CRQ1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 12:27:23 -0400
Date: Mon, 18 Mar 2013 09:27:18 -0700
From: Tejun Heo <tj@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
        Clark Williams <clark@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: workqueue code needing preemption disabled
Message-ID: <20130318162718.GB20133@mtj.dyndns.org>
References: <1363617383.25967.152.camel@gandalf.local.home>
 <20130318160652.GA20133@mtj.dyndns.org>
 <1363623799.25967.172.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363623799.25967.172.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Steven.

On Mon, Mar 18, 2013 at 12:23:19PM -0400, Steven Rostedt wrote:
> > Maybe I'm confused but I can't really see how the above would be a
> > problem to workqueue in itself.  Both rq->lock and gcwq->lock are
> > irq-safe, so spin_lock() not disabling preemption shouldn't be a
> > problem.  Are CPU hotplug operations involved?
> 
> No CPU hotplug is involved here. But I will note that gcwq->lock in -rt
> is not irq -safe. That is, in rt the spin_lock_irq(&gcwq->lock) really
> becomes a special "mutex_lock(&gcwq->lock)". Because, in -rt, interrupts
> (except for the timer interrupt) are run as threads, and anything that
> isn't marked as raw_spin_lock() turns into a mutex. I don't believe it's
> safe to turn the gcwq->lock into a raw_spin_lock either, or at least not
> short enough to hold it. Anything that holds a spin_lock() for more than
> a microsecond is too much for a raw lock.

Does that mean that a task holding gcwq->lock may be preempted?  If
so, that sure could lead to weird problems.  Maybe gcwq->lock should
be marked non-preemptible somehow?

Thanks.

-- 
tejun
