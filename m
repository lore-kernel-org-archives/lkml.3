Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421Ab3HETEd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 15:04:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26998 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753771Ab3HETEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 15:04:32 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=pFOAptgLnqcA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=pvQ05lsfB1wA:10 a=Z4Rwk6OoAAAA:8 a=6FMxr96NY7dMbMNNUMYA:9 a=QEXdDO2ut3YA:10 a=jbrJJM5MRmoA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1375729469.22073.130.camel@gandalf.local.home>
Subject: Re: [RFC] gcc feature request: Moving blocks into sections
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, gcc <gcc@gcc.gnu.org>,
        Ingo Molnar <mingo@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Daney <ddaney.cavm@gmail.com>,
        Behan Webster <behanw@converseincode.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Date: Mon, 05 Aug 2013 15:04:29 -0400
In-Reply-To: <CA+55aFyzmGzv3C9gy5Xi=pSmAOzpYMNAqrrrZmsvNbt4LdrorQ@mail.gmail.com>
References: <1375721715.22073.80.camel@gandalf.local.home>
	 <CA+55aFw_o=D-j_SRn=Y4LhHm-tEyuP1Je5ZHVTYxbVyLyDcLEg@mail.gmail.com>
	 <1375725328.22073.101.camel@gandalf.local.home>
	 <CA+55aFwRHpL-3YObZfw6NxxDxMqQbiwp0=NnpotGj2RHDNF3iw@mail.gmail.com>
	 <CA+55aFw=OX3Zz_PJc7NUGwFLAE1RYUsPe9Dn8qHDN0nZeW2R5A@mail.gmail.com>
	 <CA+55aFyzmGzv3C9gy5Xi=pSmAOzpYMNAqrrrZmsvNbt4LdrorQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-08-05 at 11:34 -0700, Linus Torvalds wrote:
> On Mon, Aug 5, 2013 at 11:24 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > Ugh. I can see the attraction of your section thing for that case, I
> > just get the feeling that we should be able to do better somehow.
> 
> Hmm.. Quite frankly, Steven, for your use case I think you actually
> want the C goto *labels* associated with a section. Which sounds like
> it might be a cleaner syntax than making it about the basic block
> anyway.

I would love to. But IIRC, the asm_goto() has some strict constraints.
We may be able to jump to a different section, but we have no way of
coming back. Not to mention, you must tell the asm goto() what label you
may be jumping to.

I don't know how safe something like this may be:


static inline trace_sched_switch(prev, next)
{
	asm goto("jmp foo1\n" : : foo2);
 foo1:
	return;

	asm goto(".pushsection\n"
		"section \".foo\"\n");
 foo2:
	__trace_sched_switch(prev, next);
	asm goto("jmp foo1"
		".popsection\n" : : foo1);
}


The above looks too fragile for my taste. I'm afraid gcc will move stuff
out of those "asm goto" locations, and make things just fail. But I can
play with this, but I don't like it.

-- Steve


