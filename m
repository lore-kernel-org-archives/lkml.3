Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754868Ab3HETj2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 15:39:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14969 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754773Ab3HETjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 15:39:24 -0400
X-Authority-Analysis: v=2.0 cv=KJ7Y/S5o c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=pFOAptgLnqcA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=pvQ05lsfB1wA:10 a=D19gQVrFAAAA:8 a=zKNs-NhhuknOBlxRiBwA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1375731563.22073.149.camel@gandalf.local.home>
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
Date: Mon, 05 Aug 2013 15:39:23 -0400
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
> On Mon, Aug 5, 2013 at 11:39 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > I had patches that did exactly this:
> >
> >  https://lkml.org/lkml/2012/3/8/461
> >
> > But it got dropped for some reason. I don't remember why. Maybe because
> > of the complexity?
> 
> Ugh. Why the crazy update_jump_label script stuff? I'd go "Eww" at
> that too, it looks crazy. The assembler already knows to make short
> 2-byte "jmp" instructions for near jumps, and you can just look at the
> opcode itself to determine size, why is all that other stuff required?

Hmm, I probably added that "optimization" in there because I was doing a
bunch of jump label work and just included it in. It's been over a year
since I've worked on this so I don't remember all the details. That
update_jump_label program may have just been to do the conversion of
nops at compile time and not during boot. It may not be needed. Also, it
was based on the record-mcount code that the function tracer uses, which
is also done at compile time, to get all the mcount locations.

> 
> IOW, 5/7 looks sane, but 4/7 makes me go "there's something wrong with
> that series".

I just quickly looked at the changes again. I think I can redo them and
send them again for 3.12. What do you think about keeping all but patch
4?

1 - Use a default nop at boot. I had help from hpa on this. Currently,
    jump labels use a jmp instead of a nop on boot.

2 - On boot, the jump label nops (jump before patch 1) looks at the best
    run time nop, and converts them. Since it is likely that the current
    nop is already ideal, skip the conversion. Again, this is just a
    boot up optimization.

3 - Add a test to see what we are converting. Adds safety checks like
there
    is in the function tracer, where if it updates a location, and does
not
    find what it expects to find, output a nasty bug.

< will skip patch 4 >

5 - Does what you want, with the 2 and 5 byte nops.

6 - When/if a failure does trigger. Print out information to what went
    wrong. Helps debugging splats caused by patch 3.

7 - needs to go before patch 3. As patch 3 can trigger if the default
nop
    is not the ideal nop for the box that is running. <reported by Ingo>


If I take out patch 4, would that solution look fine for you? I can get
this ready for 3.12.

-- Steve


