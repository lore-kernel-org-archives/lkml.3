Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757942AbaD2QJM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 12:09:12 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:55704 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751778AbaD2QJL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 12:09:11 -0400
Date: Tue, 29 Apr 2014 12:09:08 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Salman Qazi <sqazi@google.com>, Ingo Molnar <mingo@elte.hu>,
        Michal Hocko <mhocko@suse.cz>, Borislav Petkov <bp@alien8.de>,
        Vojtech Pavlik <vojtech@suse.cz>, Petr Tesarik <ptesarik@suse.cz>,
        Petr Mladek <pmladek@suse.cz>
Subject: Re: 64bit x86: NMI nesting still buggy?
Message-ID: <20140429120908.61ee947f@gandalf.local.home>
In-Reply-To: <alpine.LNX.2.00.1404291720440.16783@pobox.suse.cz>
References: <alpine.LNX.2.00.1404291150200.8903@pobox.suse.cz>
	<20140429100345.3f76a5bd@gandalf.local.home>
	<alpine.LNX.2.00.1404291720440.16783@pobox.suse.cz>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2014 17:24:32 +0200 (CEST)
Jiri Kosina <jkosina@suse.cz> wrote:

> On Tue, 29 Apr 2014, Steven Rostedt wrote:
> 
> > > According to 38.4 of [1], when SMM mode is entered while the CPU is 
> > > handling NMI, the end result might be that upon exit from SMM, NMIs will 
> > > be re-enabled and latched NMI delivered as nested [2].
> > 
> > Note, if this were true, then the x86_64 hardware would be extremely
> > buggy. That's because NMIs are not made to be nested. If SMM's come in
> > during an NMI and re-enables the NMI, then *all* software would break.
> > That would basically make NMIs useless.
> > 
> > The only time I've ever witness problems (and I stress NMIs all the
> > time), is when the NMI itself does a fault. Which my patch set handles
> > properly. 
> 
> Yes, it indeed does. 
> 
> In the scenario I have outlined, the race window is extremely small, plus 
> NMIs don't happen that often, plus SMIs don't happen that often, plus 
> (hopefully) many BIOSes don't enable NMIs upon SMM exit.
> 
> The problem is, that Intel documentation is clear in this respect, and 
> explicitly states it can happen. And we are violating that, which makes me 
> rather nervous -- it'd be very nice to know what is the background of 38.4 
> section text in the Intel docs.
> 

You keep saying 38.4, but I don't see any 38.4. Perhaps you meant 34.8?

Which BTW is this:

----
34.8 NMI HANDLING WHILE IN SMM

NMI interrupts are blocked upon entry to the SMI handler. If an NMI
request occurs during the SMI handler, it is latched and serviced after
the processor exits SMM. Only one NMI request will be latched during
the SMI handler. If an NMI request is pending when the processor
executes the RSM instruction, the NMI is serviced before the next
instruction of the interrupted code sequence. This assumes that NMIs
were not blocked before the SMI occurred. If NMIs were blocked before
the SMI occurred, they are blocked after execution of RSM.

Although NMI requests are blocked when the processor enters SMM, they
may be enabled through software by executing an IRET instruction. If
the SMI handler requires the use of NMI interrupts, it should invoke a
dummy interrupt service routine for the purpose of executing an IRET
instruction. Once an IRET instruction is executed, NMI interrupt
requests are serviced in the same “real mode” manner in which they are
handled outside of SMM.

A special case can occur if an SMI handler nests inside an NMI handler
and then another NMI occurs. During NMI interrupt handling, NMI
interrupts are disabled, so normally NMI interrupts are serviced and
completed with an IRET instruction one at a time. When the processor
enters SMM while executing an NMI handler, the processor saves the
SMRAM state save map but does not save the attribute to keep NMI
interrupts disabled. Potentially, an NMI could be latched (while in SMM
or upon exit) and serviced upon exit of SMM even though the previous
NMI handler has still not completed. One or more NMIs could thus be
nested inside the first NMI handler. The NMI interrupt handler should
take this possibility into consideration.

Also, for the Pentium processor, exceptions that invoke a trap or fault
handler will enable NMI interrupts from inside of SMM. This behavior is
implementation specific for the Pentium processor and is not part of
the IA-32 architecture.
----

Read the first paragraph. That sounds like normal operation. The SMM
should use the RSM to return and that does not re-enable NMIs if the
SMM triggered during an NMI.

The above is just stating that the SMM can enable NMIs if it wants to
by executing an IRET. Which to me sounds rather buggy to do.

Now the third paragraph is rather ambiguous. It sounds like it's still
talking about doing an IRET in the SMI handler. As the IRET will enable
NMIs, and if the SMI happened while an NMI was happening, the new NMI
will happen. In this case, the NMI handler needs to address this. But
this really sounds like if you have control of both SMM handlers and
NMI handlers, which the Linux kernel certainly does not. Again, I label
this as a bug in the BIOS.

And again, if the SMM were to trigger a fault, it too would enable
NMIs. That is something that the SMM handler should not do.


Can you reproduce your problem on different platforms, or is this just
one box that exhibits this behavior? If it's only one box, I'm betting
it has a BIOS doing nasty things.

No where in the Intel text do I see that the operating system is to
handle nested NMIs. It needs to handle it if you control the SMMs,
which the operating system does not. Sounds like they are talking to
the firmware folks.

-- Steve


