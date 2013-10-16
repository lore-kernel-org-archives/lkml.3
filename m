Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760611Ab3JPLyF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 07:54:05 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:49958 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760301Ab3JPLyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 07:54:03 -0400
Date: Wed, 16 Oct 2013 13:53:56 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Liu Chuansheng <chuansheng.liu@intel.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 2/3] core: Convert printk_once to use DO_ONCE
Message-ID: <20131016115354.GC12773@localhost.localdomain>
References: <1381870252-5430-1-git-send-email-fweisbec@gmail.com>
 <1381870252-5430-3-git-send-email-fweisbec@gmail.com>
 <1381870805.22110.37.camel@joe-AO722>
 <20131015211251.GE3269@localhost.localdomain>
 <1381872280.22110.41.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381872280.22110.41.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15, 2013 at 02:24:40PM -0700, Joe Perches wrote:
> On Tue, 2013-10-15 at 23:12 +0200, Frederic Weisbecker wrote:
> > On Tue, Oct 15, 2013 at 02:00:05PM -0700, Joe Perches wrote:
> > > On Tue, 2013-10-15 at 22:50 +0200, Frederic Weisbecker wrote:
> > > []
> > > > diff --git a/include/linux/printk.h b/include/linux/printk.h
> > > []
> > > > @@ -252,14 +253,7 @@ extern asmlinkage void dump_stack(void) __cold;
> > > >  
> > > >  #ifdef CONFIG_PRINTK
> > > >  #define printk_once(fmt, ...)			\
> > > > -({						\
> > > > -	static bool __print_once;		\
> > > > -						\
> > > > -	if (!__print_once) {			\
> > > > -		__print_once = true;		\
> > > > -		printk(fmt, ##__VA_ARGS__);	\
> > > > -	}					\
> > > > -})
> > > > +	DO_ONCE(printk(fmt, ##__VA_ARGS__));
> > > 
> > > It's hard to believe the overhead is worth it.
> > 
> > Which overhead?
> 
> The one you were proposing with xchg
> 
> Apparently the 1/3 series you submitted
> didn't use it.
> 
> Given that it didn't, does the indirection
> to DO_ONCE really help?

Yes, the diffstat has more "-" than "+" :o)
But we might get the xchg() in the end. Andrew proposed
a nice tradeoff against the performance issue:

if (!__warned)
    return;
__old_warned = xchg(__warned, 1);
if (!__old_warned)
    do_warning

> 
> btw:
> 
> https://lkml.org/lkml/2009/5/21/300
> 
> Perhaps Alan's comment still applies:
> 
> https://lkml.org/lkml/2009/5/21/305

Alan was right having such a macro handy is tempting to use in a driver or so,
and that would be most of the time for bad reasons. It's not an object synchronization.

Now I don't entirely agree with him because it consolidates existing code. It's a
good CPP library when something really needs a global state to execute something
only once.

It's especially useful for debugging. I mean I often miss such a macro. I use very
often the following pattern for debugging:

static int done;

if (!done) {
    trace_printk(something);
    trace_printk(something else);
    trace_dump_stack();
    done = 1;
}

Having a DO_ONCE() would help a lot I think.

Now we can rename it to __DO_ONCE() and put a big fat comment to avoid it
to be misused.

Hm?
