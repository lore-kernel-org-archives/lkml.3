Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786AbaFWSES (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 14:04:18 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.228]:3138 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751210AbaFWSER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 14:04:17 -0400
Date: Mon, 23 Jun 2014 14:04:13 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Jiri Kosina <jkosina@suse.cz>,
        Michal Hocko <mhocko@suse.cz>, Jan Kara <jack@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Dave Anderson <anderson@redhat.com>, Petr Mladek <pmladek@suse.cz>
Subject: Re: [RFC][PATCH 1/3] trace_seq: Move the trace_seq code to lib/
Message-ID: <20140623140413.3cebe156@gandalf.local.home>
In-Reply-To: <1403545094.4418.32.camel@jlt4.sipsolutions.net>
References: <20140619213329.478113470@goodmis.org>
	<20140619213952.058255809@goodmis.org>
	<20140619220607.c6da2540.akpm@linux-foundation.org>
	<20140620125823.5acb12dd@gandalf.local.home>
	<1403422685.4418.4.camel@jlt4.sipsolutions.net>
	<20140623120805.1624e1db@gandalf.local.home>
	<1403545094.4418.32.camel@jlt4.sipsolutions.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jun 2014 19:38:14 +0200
Johannes Berg <johannes@sipsolutions.net> wrote:

> On Mon, 2014-06-23 at 12:08 -0400, Steven Rostedt wrote:
> > On Sun, 22 Jun 2014 09:38:05 +0200
> > Johannes Berg <johannes@sipsolutions.net> wrote:
> > 
> > 
> > > Looking at the code though, I'm not sure it's a pure optimisation - if
> > > you do say putc() after a failed puts(), without this code the putc()
> > > would succeed? I can't tell right now if that's really a problem, but it
> > > seems you could get some odd behaviour out of it.
> > 
> > How would putc() still succeed? We're just talking about the "full"
> > field. It would still do the length check:
> > 
> > 	if (s->len >= (PAGE_SIZE - 1))
> > 		return 0;
> 
> Right, but the puts() could fail if not all of the string fits, and a
> subsequent putc() might fit.
> 

Ah! I see what you are saying. You are saying that once you are full
you need to flush. Honestly, the trace_puts() should check the return.
Perhaps it wants to try again with a shorter string?

The full flag means that once we hit full, we are done, no more can be
written till the buffer is flushed.

Is that what we would want from this utility? Or do we want to allow
the user to try again with a smaller string?

I was thinking of reversing the error code and have the trace_seq_*()
return 0 as success and the remaining buffer size on error.

-- Steve
