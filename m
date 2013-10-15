Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933573Ab3JOUVx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 16:21:53 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:47330 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759600Ab3JOUVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 16:21:40 -0400
Date: Tue, 15 Oct 2013 22:21:36 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>
Subject: Re: [PATCH] bug: Use xchg() to update WARN_ON_ONCE() static variable
Message-ID: <20131015202134.GB3269@localhost.localdomain>
References: <20131015155806.04e2613f@gandalf.local.home>
 <20131015131259.3051743890ce9b1b9dae9763@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131015131259.3051743890ce9b1b9dae9763@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15, 2013 at 01:12:59PM -0700, Andrew Morton wrote:
> On Tue, 15 Oct 2013 15:58:06 -0400 Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > The WARN_ON_ONCE() code is to trigger a waring only once when some
> > condition happens. But due to the way it is written it is racy.
> > 
> > 	if (unlikely(condition)) {
> > 		if (WARN(!__warned))
> > 			__warned = true;
> > 	}
> > 
> > The problem is that multiple CPUs could hit the same warning and
> > produce multiple output dumps of the same warning, or an interrupt could
> > happen and hit the same warning and do the warning in the middle of a
> > previous one, especially since the WARN() does a dump of the current
> > stack.
> > 
> > Even more of a problem, a recent WARN_ON_ONCE() that was in the page
> > fault handler triggered and the stack dump of the WARN() caused the
> > same WARN_ON_ONCE() get hit again. Since the __warned = true is not
> > updated until after the WARN() is completed, each WARN() triggered
> > another page fault causing the stack to be filled and crashed the box.
> > 
> > The point of WARN_ON() is to warn the user and not to crash the box.
> > 
> > The easy fix is to update the __warned variable with a xchg(). This way
> > only one WARN_ON_ONCE() will actually happen, and prevents any issues
> > of the WARN() causing the same WARN() to be hit and crash the system.
> 
> printk_once() has the same issue, and probably other places.
> 
> Is there some sneaky way of doing this operation as a common thing,
> rather than open-coding it everywhere?  Something like
> 
> #define ONCE() ({
> 	static int state;
> 	int ret;
> 
> 	ret = !xchg(&state, 1);
> 	ret;
> })

Oh, I have a pending patchset that I worked on a few weeks ago which does that.
I did not post it because it made WARN_ONCE using the unlikely text section, but
the diffstat was nice.

I'm going to post that as RFC just in case.
