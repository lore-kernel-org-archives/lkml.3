Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161Ab3KOO3K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 09:29:10 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:43286 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104Ab3KOO26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 09:28:58 -0500
Date: Fri, 15 Nov 2013 15:28:54 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Vince Weaver <vincent.weaver@maine.edu>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: perf/tracepoint: another fuzzer generated lockup
Message-ID: <20131115142851.GA17498@localhost.localdomain>
References: <alpine.DEB.2.10.1311081515210.16519@vincent-weaver-1.um.maine.edu>
 <20131108204839.GD14606@localhost.localdomain>
 <alpine.DEB.2.10.1311081612190.16519@vincent-weaver-1.um.maine.edu>
 <20131108223657.GF14606@localhost.localdomain>
 <20131109151014.GN16117@laptop.programming.kicks-ass.net>
 <20131114152304.GC5364@laptop.programming.kicks-ass.net>
 <20131114153301.GD5364@laptop.programming.kicks-ass.net>
 <528575E2.4000700@hitachi.com>
 <20131115122833.GE10456@twins.programming.kicks-ass.net>
 <20131115091521.3ad917fe@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131115091521.3ad917fe@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 09:15:21AM -0500, Steven Rostedt wrote:
> On Fri, 15 Nov 2013 13:28:33 +0100
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Fri, Nov 15, 2013 at 10:16:18AM +0900, Masami Hiramatsu wrote:
> > > Kprobes itself can detect nested call by using per-cpu current-running
> > > kprobe pointer. And if it is nested, it just skips calling handlers.
> > > Anyway, I don't recommend to probe inside the handlers, but yes,
> > > you can trace perf-handler by ftrace B). I actually traced a kprobe-bug
> > > by kprobe-tracer last night, that was amazing :)
> > 
> > Ah, ok, so that would avoid the worst problems. Good. Should we still
> > mark the entire perf swevent path as __kprobes just to be sure?
> 
> I wouldn't unless we can prove that it breaks. It's sometimes nice to
> be able to debug the debugging facilities with the debugging
> facilities ;-)

Even with the existing __kprobes annotations, I'm sure we can find many ways to
break the kernel.

We can reproduce that bug with irq_work recursion with setting a kprobe in
the end of the irq_work() arch low level handler for example. Or simply
somewhere in irq_exit().

I think we could do dangerous things with breakpoints as well. Setting breakpoints
in do_debug() or stuffs like that.

So keeping up with __kprobes annotations to every potential dangerous site
is not viable IMHO. It's important to maintain basic sanity with tagging sites
that are used by kprobes itself but we can't really prevent from any issue.

At some point it's up to the user to know what he's doing and avoid recursion.
As long as kprobes can be set only by root.

OTOH it would be nice to detect these kind of behaviour (thinking about irq_work for
example) and warn when something wrong is suspected.
