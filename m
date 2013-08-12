Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757097Ab3HLQKL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 12:10:11 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58825 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073Ab3HLQKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 12:10:07 -0400
Date: Mon, 12 Aug 2013 18:09:50 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        gcc <gcc@gcc.gnu.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Daney <ddaney.cavm@gmail.com>,
        Behan Webster <behanw@converseincode.com>
Subject: Re: [RFC] gcc feature request: Moving blocks into sections
Message-ID: <20130812160950.GT3008@twins.programming.kicks-ass.net>
References: <1375721715.22073.80.camel@gandalf.local.home>
 <20130812091707.GB27162@twins.programming.kicks-ass.net>
 <5208F78A.3000708@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5208F78A.3000708@linux.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 12, 2013 at 07:56:10AM -0700, H. Peter Anvin wrote:
> On 08/12/2013 02:17 AM, Peter Zijlstra wrote:
> > 
> > I've been wanting to 'abuse' static_key/asm-goto to sort-of JIT
> > if-forest functions like perf_prepare_sample() and perf_output_sample().
> > 
> > They are of the form:
> > 
> > void func(obj, args..)
> > {
> > 	unsigned long f = ...;
> > 
> > 	if (f & F1)
> > 		do_f1();
> > 
> > 	if (f & F2)
> > 		do_f2();
> > 
> > 	...
> > 
> > 	if (f & FN)
> > 		do_fn();
> > }
> > 
> 
> Am I reading this right that f can be a combination of any of these?

Correct.

> > Where f is constant for the entire lifetime of the particular object.
> > 
> > So I was thinking of having these functions use static_key/asm-goto;
> > then write the proper static key values unsafe so as to avoid all
> > trickery (as these functions would never actually be used) and copy the
> > end result into object private memory. The object will then use indirect
> > calls into these functions.
> 
> I'm really not following what you are proposing here, especially not
> "copy the end result into object private memory."
> 
> With asm goto you end up with at minimum a jump or NOP for each of these
> function entries, whereas an actual JIT can elide that as well.
> 
> On the majority of architectures, including x86, you cannot simply copy
> a piece of code elsewhere and have it still work.

I thought we used -fPIC which would allow just that.

> You end up doing a
> bunch of the work that a JIT would do anyway, and would end up with
> considerably higher complexity and worse results than a true JIT.  

Well, less complexity but worse result, yes. We'd only poke the specific
static_branch sites with either NOPs or the (relative) jump target for
each of these branches. Then copy the result.

> You
> also say "the object will then use indirect calls into these
> functions"... you mean the JIT or pseudo-JIT generated functions, or the
> calls inside them?

The calls to these pseudo-JIT generated functions.

> > I suppose the question is, do people strenuously object to creativity
> > like that and or is there something GCC can do to make this
> > easier/better still?
> 
> I think it would be much easier to just write a minimal JIT for this,
> even though it is per architecture.  However, I would really like to
> understand what the value is.

Removing a lot of the conditionals from the sample path. Depending on
the configuration these can be quite expensive.
