Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923Ab3HLJR0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 05:17:26 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50113 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755261Ab3HLJRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 05:17:24 -0400
Date: Mon, 12 Aug 2013 11:17:07 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, gcc <gcc@gcc.gnu.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Daney <ddaney.cavm@gmail.com>,
        Behan Webster <behanw@converseincode.com>
Subject: Re: [RFC] gcc feature request: Moving blocks into sections
Message-ID: <20130812091707.GB27162@twins.programming.kicks-ass.net>
References: <1375721715.22073.80.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375721715.22073.80.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 05, 2013 at 12:55:15PM -0400, Steven Rostedt wrote:
> [ sent to both Linux kernel mailing list and to gcc list ]
> 

Let me hijack this thread for something related...

I've been wanting to 'abuse' static_key/asm-goto to sort-of JIT
if-forest functions like perf_prepare_sample() and perf_output_sample().

They are of the form:

void func(obj, args..)
{
	unsigned long f = ...;

	if (f & F1)
		do_f1();

	if (f & F2)
		do_f2();

	...

	if (f & FN)
		do_fn();
}

Where f is constant for the entire lifetime of the particular object.

So I was thinking of having these functions use static_key/asm-goto;
then write the proper static key values unsafe so as to avoid all
trickery (as these functions would never actually be used) and copy the
end result into object private memory. The object will then use indirect
calls into these functions.

The advantage of using something like this is that it would work for all
architectures that now support the asm-goto feature. For arch/gcc
combinations that do not we'd simply revert to the current state of
affairs.

I suppose the question is, do people strenuously object to creativity
like that and or is there something GCC can do to make this
easier/better still?

