Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751818AbaILRH2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 13:07:28 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:53325 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750881AbaILRH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 13:07:27 -0400
Date: Fri, 12 Sep 2014 18:07:20 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3.17-rc4 v5 2/6] arm: fiq: Replace default FIQ handler
Message-ID: <20140912170720.GM12361@n2100.arm.linux.org.uk>
References: <1410272111-30516-1-git-send-email-daniel.thompson@linaro.org> <1410435078-28462-1-git-send-email-daniel.thompson@linaro.org> <1410435078-28462-3-git-send-email-daniel.thompson@linaro.org> <20140912170307.GL12361@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140912170307.GL12361@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 12, 2014 at 06:03:07PM +0100, Russell King - ARM Linux wrote:
> On Thu, Sep 11, 2014 at 12:31:14PM +0100, Daniel Thompson wrote:
> > -	.macro	svc_entry, stack_hole=0
> > +	.macro	svc_entry, stack_hole=0, call_trace=1
> >   UNWIND(.fnstart		)
> >   UNWIND(.save {r0 - pc}		)
> >  	sub	sp, sp, #(S_FRAME_SIZE + \stack_hole - 4)
> > @@ -183,7 +183,9 @@ ENDPROC(__und_invalid)
> >  	stmia	r7, {r2 - r6}
> >  
> >  #ifdef CONFIG_TRACE_IRQFLAGS
> > +	.if \call_trace
> >  	bl	trace_hardirqs_off
> > +	.endif
> >  #endif
> 
> Good, you picked this up from my patch.  But what about the call into
> lockdep from usr_entry?
> 
> Yes, it should be safe if we're entering from user mode, because by
> definition, the kernel can't be holding any locks at that point.
> However, I'd much prefer to keep to a set of simple rules here: avoid
> lockdep in FIQ code altogether.
> 
> That's much easier to understand than "we can call into lockdep provided
> we've been entered from user mode".
> 
> The other thing you miss is that /potentially/ call into the scheduler
> as well from a FIQ.  Do we /really/ want to do that kind of work here?
> 
> Not happy.

And you're also missing a .cantunwind for __fiq_usr, which means that the
Dwarf doesn't contain an explicit point to stop unwinding.

Lastly, don't thread your new patches to the old ones.  I utterly hate
that behaviour.  It makes subject lines totally pointless because all
I end up seeing is "[PAT" on the very right hand of the screen.  Far
from useful.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
