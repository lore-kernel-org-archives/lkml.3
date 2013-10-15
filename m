Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759618Ab3JOUND (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 16:13:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52817 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759341Ab3JOUNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 16:13:01 -0400
Date: Tue, 15 Oct 2013 13:12:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>
Subject: Re: [PATCH] bug: Use xchg() to update WARN_ON_ONCE() static
 variable
Message-Id: <20131015131259.3051743890ce9b1b9dae9763@linux-foundation.org>
In-Reply-To: <20131015155806.04e2613f@gandalf.local.home>
References: <20131015155806.04e2613f@gandalf.local.home>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Oct 2013 15:58:06 -0400 Steven Rostedt <rostedt@goodmis.org> wrote:

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

printk_once() has the same issue, and probably other places.

Is there some sneaky way of doing this operation as a common thing,
rather than open-coding it everywhere?  Something like

#define ONCE() ({
	static int state;
	int ret;

	ret = !xchg(&state, 1);
	ret;
})

Also, is xchg() better than test_and_set_bit()?  (test_and_set_bit()
requires a long, so more storage).

Also, we're now incurring an atomic op for every "call".  Presumably
these calls are rare, but not necessarily - one can envisage uses of a
generic ONCE() which are called at high frequency.  Should we avoid
that with

#define ONCE() ({
	static int state;
	int ret;

	if (likely(state))
		ret = 0;
	else
		ret = !xchg(&state, 1);
	ret;
})

