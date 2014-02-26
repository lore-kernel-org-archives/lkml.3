Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751677AbaBZAta (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 19:49:30 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:20602 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750724AbaBZAt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 19:49:29 -0500
Date: Tue, 25 Feb 2014 19:49:26 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC][PATCH] tracing: Warn and notify if tracepoints are not
 loaded due to module taint
Message-ID: <20140225194926.4eac5872@gandalf.local.home>
In-Reply-To: <188130295.30493.1393375141631.JavaMail.zimbra@efficios.com>
References: <20140225191505.32b56105@gandalf.local.home>
	<188130295.30493.1393375141631.JavaMail.zimbra@efficios.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Feb 2014 00:39:01 +0000 (UTC)
Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> ----- Original Message -----
> > From: "Steven Rostedt" <rostedt@goodmis.org>
> > To: "LKML" <linux-kernel@vger.kernel.org>
> > Cc: "Ingo Molnar" <mingo@kernel.org>, "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>, "Rusty Russell"
> > <rusty@rustcorp.com.au>, "Frederic Weisbecker" <fweisbec@gmail.com>, "Andrew Morton" <akpm@linux-foundation.org>,
> > "Peter Zijlstra" <peterz@infradead.org>
> > Sent: Tuesday, February 25, 2014 7:15:05 PM
> > Subject: [RFC][PATCH] tracing: Warn and notify if tracepoints are not loaded due to module taint
> > 
> > [ Posting this as an RFC, but I plan on pushing it as soon as I finish
> > testing it ]
> > 
> > If a module is loaded that is tainted with anything but OOT or CRAP, then
> > it will not create the traceoint infrastructure for the module. There should
> 
> traceoint -> tracepoint

Oops, thanks.

> 
> > be a big warning when this happens instead of exiting silently.
> > 
> > Fixes: 97e1c18e8d17 "tracing: Kernel Tracepoints"
> > Cc: stable@vger.kernel.org
> > Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> > Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> > ---
> >  kernel/tracepoint.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
> > index 29f2654..413bc06 100644
> > --- a/kernel/tracepoint.c
> > +++ b/kernel/tracepoint.c
> > @@ -641,7 +641,8 @@ static int tracepoint_module_coming(struct module *mod)
> >  	 * module headers (for forced load), to make sure we don't cause a crash.
> >  	 * Staging and out-of-tree GPL modules are fine.
> >  	 */
> > -	if (mod->taints & ~((1 << TAINT_OOT_MODULE) | (1 << TAINT_CRAP)))
> > +	if (WARN_ONCE(mod->taints & ~((1 << TAINT_OOT_MODULE) | (1 << TAINT_CRAP)),
> > +		      "Module is tainted, disabling tracepoints"))
> 
> Perhaps ever clearer with:
> 
>    "Module \"%s\" is tainted, disabling tracepoints", mod->name
> 
> ?

I originally had that with a simple WARN() instead of WARN_ONCE(), but
if you have that config which makes all modules not have sigs correct,
it spits out tens of these warnings and can cause more panic in users
than it deserves. I then switched it to WARN_ONCE(), and then thought,
that if it does it only once for the first module, it wont print the
warning again for the other affected modules. That means it may confuse
the user if they see a module had that warning, but the module they are
trying to trace isn't working either.

I then figured it would be good to remove the module name and just
state a general "Module is tainted, disabling tracepoints" and if the
user notices that the module isn't working, and then looks at their
dmesg, they'll see this message and just assume it was the module that
wasn't working.

Make sense?

-- Steve


> 
> Other than that, looks good to me!
> 

