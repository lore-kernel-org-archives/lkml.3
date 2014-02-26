Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751839AbaBZI7i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 03:59:38 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38371 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbaBZI7h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 03:59:37 -0500
Date: Wed, 26 Feb 2014 09:59:26 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH] tracing: Warn and notify if tracepoints are not
 loaded due to module taint
Message-ID: <20140226085926.GF18404@twins.programming.kicks-ass.net>
References: <20140225191505.32b56105@gandalf.local.home>
 <188130295.30493.1393375141631.JavaMail.zimbra@efficios.com>
 <20140225194926.4eac5872@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140225194926.4eac5872@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 25, 2014 at 07:49:26PM -0500, Steven Rostedt wrote:
> > > -	if (mod->taints & ~((1 << TAINT_OOT_MODULE) | (1 << TAINT_CRAP)))
> > > +	if (WARN_ONCE(mod->taints & ~((1 << TAINT_OOT_MODULE) | (1 << TAINT_CRAP)),
> > > +		      "Module is tainted, disabling tracepoints"))

> I originally had that with a simple WARN() instead of WARN_ONCE(), but
> if you have that config which makes all modules not have sigs correct,
> it spits out tens of these warnings and can cause more panic in users
> than it deserves. I then switched it to WARN_ONCE(), and then thought,
> that if it does it only once for the first module, it wont print the
> warning again for the other affected modules. That means it may confuse
> the user if they see a module had that warning, but the module they are
> trying to trace isn't working either.
> 
> I then figured it would be good to remove the module name and just
> state a general "Module is tainted, disabling tracepoints" and if the
> user notices that the module isn't working, and then looks at their
> dmesg, they'll see this message and just assume it was the module that
> wasn't working.
> 
> Make sense?

How about instead of a WARN, you use a normal KERN_ERR printk(). There's
no point to the entire WARN state dump, that's needlessly verbose.

When you have a normal error print you can have as many as are required
and put the mod name back in.
