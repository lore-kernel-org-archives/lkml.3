Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245AbaD2NGA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 09:06:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52828 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751540AbaD2NF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 09:05:58 -0400
Date: Tue, 29 Apr 2014 15:05:55 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Steven Rostedt <rostedt@goodmis.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Salman Qazi <sqazi@google.com>, Ingo Molnar <mingo@elte.hu>,
        Michal Hocko <mhocko@suse.cz>, Borislav Petkov <bp@alien8.de>,
        Vojtech Pavlik <vojtech@suse.cz>, Petr Tesarik <ptesarik@suse.cz>,
        Petr Mladek <pmladek@suse.cz>
Subject: 64bit x86: NMI nesting still buggy?
Message-ID: <alpine.LNX.2.00.1404291150200.8903@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

so while debugging some hard-to-explain hangs in the past, we have been 
going around in circles around the NMI nesting disaster, and I tend to 
believe that Steven's fixup (for most part introduced in 3f3c8b8c ("x86: 
Add workaround to NMI iret woes")) makes the race *much* smaller, but it 
doesn't fix it completely (it basically reduces the race to a few 
instructions in first_nmi which are doing the stack preparatory work).

According to 38.4 of [1], when SMM mode is entered while the CPU is 
handling NMI, the end result might be that upon exit from SMM, NMIs will 
be re-enabled and latched NMI delivered as nested [2].

This is handled well by playing the frame-saving and flag-setting games in 
`first_nmi' / `nested_nmi' / `repeat_nmi' (and that also works flawlessly 
in cases exception or breakpoint triggers some time later during NMI 
handling when all the 'nested' setup has been done).

There is unfortunately small race window, which, I believe, is not covered 
by this.

	- 1st NMI triggers
	- SMM is entered very shortly afterwards, even before `first_nmi' 
	  was able to do its job
	- 2nd NMI is latched
	- SMM exits with NMIs re-enabled (see [2]) and 2nd NMI triggers
	- 2nd NMI gets handled properly, exits with iret
	- iret returns to the place where 1st NMI was interrupted, but 
	  the return address on the stack where iret from 1st NMI should 
	  eventually return to is gone, and the 'saved/copy' locations of 
	  the stack don't contain the correct frame either

The race is very small and it's hard to trigger SMM in a deterministic 
way, so it's probably very difficult to trigger. But I wouldn't be 
surprised if it'd trigger ocassionally in the wild, and the resulting 
problems were never root-caused (as the problem is very rare, not 
reproducible, probably doesn't happen on the same system more than once in 
a lifetime).

We were not able to come up with any other fix than avoiding using IST 
completely on x86_64, and instead going back to stack switching in 
software -- the same way 32bit x86 does.

So basically, I have two questions:

(1) is the above analysis correct? (if not, why?)
(2) if it is correct, is there any other option for fix than avoiding 
    using IST for exception stack switching, and having kernel do the 
    legacy task switching (the same way x86_32 is doing)?

[1] http://www.intel.com/content/dam/www/public/us/en/documents/manuals/64-ia-32-architectures-software-developer-manual-325462.pdf

[2] 	"A special case can occur if an SMI handler nests inside an NMI 
	 handler and then another NMI occurs. During NMI interrupt 
	 handling, NMI interrupts are disabled, so normally NMI interrupts 
 	 are serviced and completed with an IRET instruction one at a 
	 time. When the processor enters SMM while executing an NMI 
	 handler, the processor saves the SMRAM state save map but does 
	 not save the attribute to keep NMI interrupts disabled. 
	 Potentially, an NMI could be latched (while in SMM or upon exit) 
	 and serviced upon exit of SMM even though the previous NMI  
	 handler has still not completed."

-- 
Jiri Kosina
SUSE Labs
