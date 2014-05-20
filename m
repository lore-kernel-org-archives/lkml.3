Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230AbaETM7z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 08:59:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7770 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752959AbaETM7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 08:59:51 -0400
Date: Tue, 20 May 2014 07:59:23 -0500
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Seth Jennings <sjenning@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 0/2] kpatch: dynamic kernel patching
Message-ID: <20140520125923.GA3771@treble.redhat.com>
References: <cover.1398958771.git.jpoimboe@redhat.com>
 <20140505085537.GA32196@gmail.com>
 <20140505132638.GA14432@treble.redhat.com>
 <20140505141038.GA27403@localhost.localdomain>
 <20140505184304.GA15137@gmail.com>
 <5368CB6E.3090105@hitachi.com>
 <20140506082604.31928cb9@gandalf.local.home>
 <alpine.LNX.2.00.1405161822050.16459@pobox.suse.cz>
 <20140516171430.GA15775@treble.redhat.com>
 <alpine.LNX.2.00.1405201134100.1615@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1405201134100.1615@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 11:37:16AM +0200, Jiri Kosina wrote:
> On Fri, 16 May 2014, Josh Poimboeuf wrote:
> 
> > > Consider this scenario:
> > > 
> > > 	void foo()
> > > 	{
> > > 		for (i=0; i<10000; i++) {
> > > 			bar(i);
> > > 			something_else(i);
> > > 		}
> > > 	}
> > > 
> > > Let's say you want to live-patch bar(). With stop_machine()-based aproach, 
> > > you can easily end-up with old bar() and new bar() being called in two 
> > > consecutive iterations before the loop is even exited, right? (especially 
> > > on preemptible kernel, or if something_else() goes to sleep).
> > 
> > Can you clarify why this would be a problem?  Is it because the new
> > bar() changed some data semantics which confused foo() or
> > something_else()?
> 
> I guess the example I used wasn't really completely illustrative, sorry 
> for that. But I guess this has been answered later in the thread already; 
> the thing is that you don't have a complete callgraph available (at least 
> I believe you don't ...?), so you don't really know where your patched 
> function will be called from, and thus you can't change function arguments 
> or return value semantics; with lazy aproach, you can do that.

If the patch changes return semantics, it would also need to change all
the affected callers to handle the new semantics.  But I think that's a
general statement for all patches, not just for the live patching case.
Otherwise it's just a bad patch in general.

For changed function arguments, the compiler will catch that and
recompile all the callers, so the kpatch tooling would detect that the
callers changed and patch them too.

But to be fair, here's an example where kGraft does better:

  foo = bar();
  something_else();
  baz(foo);

Let's say that bar()'s return semantics change, and baz() is also
patched to handle the new semantics.  If the stop_machine occurs in
something_else(), then the new baz() will be called with the old
"version" of foo.

If the user were smart enough to be aware of this potential scenario, it
could be solved with a kGraft-esque approach for data semantic changes,
where the patched baz() would need to handle both versions of foo.

This is another example of why changing return or data semantics is
tricky and should be avoided.

BTW, this is also an example of why the stop_machine and lazy approaches
aren't interchangeable.  The patch creator has to know which method will
be used to apply the patch in order to be able to determine whether a
patch is "safe".

-- 
Josh
