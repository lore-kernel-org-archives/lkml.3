Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757784AbaD2ObM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 10:31:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55252 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751521AbaD2ObK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 10:31:10 -0400
Date: Tue, 29 Apr 2014 16:31:07 +0200
From: Petr Tesarik <ptesarik@suse.cz>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Salman Qazi <sqazi@google.com>, Ingo Molnar <mingo@elte.hu>,
        Michal Hocko <mhocko@suse.cz>, Borislav Petkov <bp@alien8.de>,
        Vojtech Pavlik <vojtech@suse.cz>, Petr Mladek <pmladek@suse.cz>
Subject: Re: 64bit x86: NMI nesting still buggy?
Message-ID: <20140429163107.36599715@hananiah.suse.cz>
In-Reply-To: <535FA920.9080503@linux.intel.com>
References: <alpine.LNX.2.00.1404291150200.8903@pobox.suse.cz>
	<535FA920.9080503@linux.intel.com>
Organization: SUSE Linux, s.r.o.
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2014 06:29:04 -0700
"H. Peter Anvin" <hpa@linux.intel.com> wrote:

> On 04/29/2014 06:05 AM, Jiri Kosina wrote:
> > 
> > We were not able to come up with any other fix than avoiding using IST 
> > completely on x86_64, and instead going back to stack switching in 
> > software -- the same way 32bit x86 does.
> > 
> 
> This is not possible, though, because there are several windows during
> which if we were to take an exception which doesn't do IST, e.g. NMI, we
> are worse than dead -- we are in fact rootable.  Right after SYSCALL in
> particular.

Ah, right. SYSCALL does not update RSP. :-(
Hm, so anything that can fire up right after a SYSCALL must use IST.
It's possible to use an alternative IDT that gets loaded as the first
thing in an NMI handler, but this gets incredibly ugly...

> > So basically, I have two questions:
> > 
> > (1) is the above analysis correct? (if not, why?)
> > (2) if it is correct, is there any other option for fix than avoiding 
> >     using IST for exception stack switching, and having kernel do the 
> >     legacy task switching (the same way x86_32 is doing)?
> 
> It is not an option, see above.
> 
> > [1] http://www.intel.com/content/dam/www/public/us/en/documents/manuals/64-ia-32-architectures-software-developer-manual-325462.pdf
> > 
> > [2] 	"A special case can occur if an SMI handler nests inside an NMI 
> > 	 handler and then another NMI occurs. During NMI interrupt 
> > 	 handling, NMI interrupts are disabled, so normally NMI interrupts 
> >  	 are serviced and completed with an IRET instruction one at a 
> > 	 time. When the processor enters SMM while executing an NMI 
> > 	 handler, the processor saves the SMRAM state save map but does 
> > 	 not save the attribute to keep NMI interrupts disabled. 
> > 	 Potentially, an NMI could be latched (while in SMM or upon exit) 
> > 	 and serviced upon exit of SMM even though the previous NMI  
> > 	 handler has still not completed."
> 
> I believe [2] only applies if there is an IRET executing inside the SMM
> handler, which should not normally be the case.  It might also have been
> addressed since that was written, but I don't know.

The trouble here is that the official Intel documentation describes how
to do this and specifically requests the OS to cope with nested NMIs.

Petr T
