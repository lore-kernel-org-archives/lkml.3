Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921AbaDDQVY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 12:21:24 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:54826 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229AbaDDQVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 12:21:22 -0400
Date: Fri, 4 Apr 2014 17:21:08 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Li, Aubrey" <aubrey.li@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [BUG] x86: reboot doesn't reboot
Message-ID: <20140404162108.GA17393@srcf.ucam.org>
References: <20140403121314.246b03a7@gandalf.local.home>
 <533DED74.6050202@linux.intel.com>
 <20140403194018.7c67aec7@gandalf.local.home>
 <533DF455.4040908@linux.intel.com>
 <533DF8D2.9060508@zytor.com>
 <533E0A94.5040007@linux.intel.com>
 <20140404151203.GA12370@srcf.ucam.org>
 <CA+55aFx+6ODkyueA2iHLhO8-eo95QYCBybhR63owxUMbhXh8wQ@mail.gmail.com>
 <20140404154520.GA14980@srcf.ucam.org>
 <CA+55aFwiO2kcNF4=ph9UWhPB7Vd6sRZ5B6g7qFV2yAwKBLP+2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwiO2kcNF4=ph9UWhPB7Vd6sRZ5B6g7qFV2yAwKBLP+2Q@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2014 at 09:09:32AM -0700, Linus Torvalds wrote:
> On Fri, Apr 4, 2014 at 8:45 AM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> >
> > Which is almost certainly because the other reboot methods are trapping
> > into SMI and hitting some hardware that we've left in a different state
> > to Windows.
> 
> Why are you making up these completely invalid arguments? Because you
> are making them up.
> 
> Our default reboot type is REBOOT_ACPI. That's the one we try *first*.
> There are no "other reboot methods" playing games.

We try ACPI. That will sometimes work, but infrequently. We then try the 
keyboard controller. That will generally work. We then try ACPI again, 
which will typically work because it's often now the second write to 
CF9. We then try the keyboard controller again, because that's what 
Windows does. The machine should now have rebooted.

But *any* of those accesses could have generated an SMI. For all we know 
the firmware is running huge quantities of code in response to any of 
those register accesses. We don't know what other hardware that code 
touches. We don't know what expectations it has. We don't know whether 
it was written by humans or written by some sort of simulated annealing 
mechanism that finally collapsed into a state where Windows rebooted and 
then shipped (or even humans behaving indistinguishably from a simulated 
annealing mechanism).

> And given this *fact*, your denial that "PCI reboot should never be
> used" is counterfactual. It may be true in some theoretical "this is
> how the world should work" universe, but in the real world it is just
> BS.
> 
> Why are you so deep in denial about this?

Because Windows doesn't use CF9 but machines reboot anyway. That 
shouldn't be a controversial point of view. We know that CF9 fixes some 
machines. We know that it breaks some machines. We don't know how many 
machines it fixes or how many machines it breaks. We don't know how many 
machines are flipped from a working state to a broken state whenever we 
fiddle with the order or introduce new heuristics. We don't know how 
many go from broken to working. The only way we can be reasonably 
certain that hardware will work is to duplicate precisely what Windows 
does, because that's all that most vendors will ever have tested.

The problem is that while we may know exactly what Windows does in terms 
of actually triggering the reboot, we don't know everything else it does 
on the shutdown path and it's difficult to instrument things like 
embedded controller accesses when qemu doesn't emulate one. I'll contact 
the people I know in Dell and see if I can find anyone from the firmware 
division who'll actually talk to us.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
