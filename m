Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187Ab3HEQzT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 12:55:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13326 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753621Ab3HEQzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 12:55:17 -0400
X-Authority-Analysis: v=2.0 cv=KJ7Y/S5o c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=7BGHm0XUPyoA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=J3gCLYyfqakA:10 a=D19gQVrFAAAA:8 a=njuz_zczJ5Nea503wJ8A:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1375721715.22073.80.camel@gandalf.local.home>
Subject: [RFC] gcc feature request: Moving blocks into sections
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, gcc <gcc@gcc.gnu.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Daney <ddaney.cavm@gmail.com>,
        Behan Webster <behanw@converseincode.com>,
        Peter Zijlstra <peterz@infradead.org>
Date: Mon, 05 Aug 2013 12:55:15 -0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ sent to both Linux kernel mailing list and to gcc list ]

I was looking at some of the old code I still have marked in my TODO
list, that I never pushed to get mainlined. One of them is to move trace
point logic out of the fast path to get rid of the stress that it
imposes on the icache.

Almost a full year ago, Mathieu suggested something like:

if (unlikely(x)) __attribute__((section(".unlikely"))) {
        ...
} else __attribute__((section(".likely"))) {
        ...
}

https://lkml.org/lkml/2012/8/9/658

Which got me thinking. How hard would it be to set a block in its own
section. Like what Mathieu suggested, but it doesn't have to be
".unlikely".

if (x) __attibute__((section(".foo"))) {
	/* do something */
}

Then have in the assembly, simply:

	test x
	beq	2f
1:
	/* continue */
	ret

2:
	jmp	foo1
3:
	jmp	1b


Then in section ".foo":

foo1:
	/* do something */
	jmp 3b

Perhaps we can't use the section attribute. We could create a new
attribute. Perhaps a __jmp_section__ or whatever (I'm horrible with
names).

Is this a possibility?

If this is possible, we can get a lot of code out of the fast path.
Things like stats and tracing, which is mostly default off. I would
imagine that we would get better performance by doing this. Especially
as tracepoints are being added all over the place.

Thanks,

-- Steve


