Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756611AbaEAKCY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 06:02:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58789 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753941AbaEAKCU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 06:02:20 -0400
Date: Tue, 29 Apr 2014 17:41:58 +0200
From: Vojtech Pavlik <vojtech@suse.cz>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Salman Qazi <sqazi@google.com>, Ingo Molnar <mingo@elte.hu>,
        Michal Hocko <mhocko@suse.cz>, Borislav Petkov <bp@alien8.de>,
        Petr Tesarik <ptesarik@suse.cz>, Petr Mladek <pmladek@suse.cz>
Subject: Re: 64bit x86: NMI nesting still buggy?
Message-ID: <20140429154158.GB21754@suse.cz>
References: <alpine.LNX.2.00.1404291150200.8903@pobox.suse.cz>
 <20140429100345.3f76a5bd@gandalf.local.home>
 <alpine.LNX.2.00.1404291720440.16783@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1404291720440.16783@pobox.suse.cz>
X-Bounce-Cookie: It's a lemon tree, dear Watson!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2014 at 05:24:32PM +0200, Jiri Kosina wrote:
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

If we cannot disable IST for NMI on x86_64, because it'd break SYSCALL,
and thus cannot handle this situation well, then we should at least try
to detect it post-factum.

In the NMI handler, after ascertaining that the first NMI is executing
(in_nmi not yet set) we check the return address stored on the stack.

If it points anywhere inside the NMI handler (in reality only in the
space between the NMI handler start and the check), a SMI-triggered
nested NMI has happened.

Then we should be able to at least report it before dying.

If it doesn't ever happen: Great, this wasn't a real concern. If it
does, we can pester BIOS vendors.

-- 
Vojtech Pavlik
Director SuSE Labs
