Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918Ab3HFOTr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 10:19:47 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:25607 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753250Ab3HFOTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 10:19:46 -0400
X-Authority-Analysis: v=2.0 cv=aqMw+FlV c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=pFOAptgLnqcA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=pvQ05lsfB1wA:10 a=zgKs8koD26uDSAQZ7l0A:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1375798783.25420.30.camel@gandalf.local.home>
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
Date: Tue, 06 Aug 2013 10:19:43 -0400
In-Reply-To: <CA+55aFyfvifCu=jDBH8LPmEHtvooVyo25dvJ+T6SQLhVidBBdQ@mail.gmail.com>
References: <1375721715.22073.80.camel@gandalf.local.home>
	 <CA+55aFw_o=D-j_SRn=Y4LhHm-tEyuP1Je5ZHVTYxbVyLyDcLEg@mail.gmail.com>
	 <1375725328.22073.101.camel@gandalf.local.home>
	 <CA+55aFwRHpL-3YObZfw6NxxDxMqQbiwp0=NnpotGj2RHDNF3iw@mail.gmail.com>
	 <1375727977.22073.112.camel@gandalf.local.home>
	 <CA+55aFyfvifCu=jDBH8LPmEHtvooVyo25dvJ+T6SQLhVidBBdQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-08-05 at 11:49 -0700, Linus Torvalds wrote:

> Ugh. Why the crazy update_jump_label script stuff?

After playing with the patches again, I now understand why I did that.
It wasn't just for optimization.

Currently the way jump labels work is that we use asm goto() and place a
5 byte nop in the assembly, with some labels. The location of the nop is
stored in the __jump_table section.

In order to use either 2 or 5 byte jumps, I had to put in the actual
jump and let the assembler place the correct op code in. This changes
the default switch for jump labels. Instead of being default off, it is
now default on. To handle this, I had to convert all the jumps back to
nops before the kernel runs. This was done at compile time with the
update_jump_label script/program.

Now, we can just do the update in early boot, but is this the best way?
This means that the update must happen before any jump label is used.
This may not be an issue, but as jump labels can be used for anything
(not just tracing), it may be hard to know when the first instance is
actually used.

Also, if there is any issue with the op codes as Mathieu has been
pointing out, it would only be caught at run time (boot time).


The update_jump_label program isn't really that complex. Yes it parses
the elf tables, but that's rather standard and that method is used by
ftrace with the mcount locations (instead of that nasty daemon). It
finds the __jump_table section and runs down the list of locations just
like the boot up code does, and modifies the jumps to nops. If the
compiler does something strange, it would be caught at compile time not
boot time.

Anyway, if you feel that update_jump_label is too complex, I can go the
"update at early boot" route and see how that goes.

-- Steve


