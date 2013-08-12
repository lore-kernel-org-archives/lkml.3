Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821Ab3HLO4R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 10:56:17 -0400
Received: from mga11.intel.com ([192.55.52.93]:13680 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756332Ab3HLO4M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 10:56:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,862,1367996400"; 
   d="scan'208";a="385038587"
Message-ID: <5208F78A.3000708@linux.intel.com>
Date: Mon, 12 Aug 2013 07:56:10 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        gcc <gcc@gcc.gnu.org>, Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Daney <ddaney.cavm@gmail.com>,
        Behan Webster <behanw@converseincode.com>
Subject: Re: [RFC] gcc feature request: Moving blocks into sections
References: <1375721715.22073.80.camel@gandalf.local.home> <20130812091707.GB27162@twins.programming.kicks-ass.net>
In-Reply-To: <20130812091707.GB27162@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/2013 02:17 AM, Peter Zijlstra wrote:
> 
> I've been wanting to 'abuse' static_key/asm-goto to sort-of JIT
> if-forest functions like perf_prepare_sample() and perf_output_sample().
> 
> They are of the form:
> 
> void func(obj, args..)
> {
> 	unsigned long f = ...;
> 
> 	if (f & F1)
> 		do_f1();
> 
> 	if (f & F2)
> 		do_f2();
> 
> 	...
> 
> 	if (f & FN)
> 		do_fn();
> }
> 

Am I reading this right that f can be a combination of any of these?

> Where f is constant for the entire lifetime of the particular object.
> 
> So I was thinking of having these functions use static_key/asm-goto;
> then write the proper static key values unsafe so as to avoid all
> trickery (as these functions would never actually be used) and copy the
> end result into object private memory. The object will then use indirect
> calls into these functions.

I'm really not following what you are proposing here, especially not
"copy the end result into object private memory."

With asm goto you end up with at minimum a jump or NOP for each of these
function entries, whereas an actual JIT can elide that as well.

On the majority of architectures, including x86, you cannot simply copy
a piece of code elsewhere and have it still work.  You end up doing a
bunch of the work that a JIT would do anyway, and would end up with
considerably higher complexity and worse results than a true JIT.  You
also say "the object will then use indirect calls into these
functions"... you mean the JIT or pseudo-JIT generated functions, or the
calls inside them?

> I suppose the question is, do people strenuously object to creativity
> like that and or is there something GCC can do to make this
> easier/better still?

I think it would be much easier to just write a minimal JIT for this,
even though it is per architecture.  However, I would really like to
understand what the value is.

	-hpa

