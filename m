Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759926Ab3JOUS4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 16:18:56 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:40345 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759911Ab3JOUSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 16:18:52 -0400
Date: Tue, 15 Oct 2013 22:18:48 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>
Subject: Re: [PATCH] bug: Use xchg() to update WARN_ON_ONCE() static variable
Message-ID: <20131015201816.GA3269@localhost.localdomain>
References: <20131015155806.04e2613f@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131015155806.04e2613f@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15, 2013 at 03:58:06PM -0400, Steven Rostedt wrote:
> The WARN_ON_ONCE() code is to trigger a waring only once when some
> condition happens. But due to the way it is written it is racy.
> 
> 	if (unlikely(condition)) {
> 		if (WARN(!__warned))
> 			__warned = true;
> 	}
> 
> The problem is that multiple CPUs could hit the same warning and
> produce multiple output dumps of the same warning, or an interrupt could
> happen and hit the same warning and do the warning in the middle of a
> previous one, especially since the WARN() does a dump of the current
> stack.
> 
> Even more of a problem, a recent WARN_ON_ONCE() that was in the page
> fault handler triggered and the stack dump of the WARN() caused the
> same WARN_ON_ONCE() get hit again. Since the __warned = true is not
> updated until after the WARN() is completed, each WARN() triggered
> another page fault causing the stack to be filled and crashed the box.
> 
> The point of WARN_ON() is to warn the user and not to crash the box.
> 
> The easy fix is to update the __warned variable with a xchg(). This way
> only one WARN_ON_ONCE() will actually happen, and prevents any issues
> of the WARN() causing the same WARN() to be hit and crash the system.

How about just updating __warned without a cmpxchg. It's not that critical
if the update is not seen immediately to other CPUs. OTOH it's critical
that's it is visible immediately to the current CPU

I mean some warrning can be hard to reproduce and happen to some users
while staying for several kernel releases. If it's repetitive, the xchg
might impact the performance.

I may be overly paranoid, but I think barrier() (so that at least
we don't recurse locally) alone would be better.
