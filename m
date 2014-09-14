Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578AbaINIpf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 04:45:35 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:55238 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752458AbaINIpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 04:45:30 -0400
Date: Sun, 14 Sep 2014 09:45:11 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3.17-rc4 v5 2/6] arm: fiq: Replace default FIQ handler
Message-ID: <20140914084511.GU12361@n2100.arm.linux.org.uk>
References: <1410272111-30516-1-git-send-email-daniel.thompson@linaro.org> <1410435078-28462-1-git-send-email-daniel.thompson@linaro.org> <1410435078-28462-3-git-send-email-daniel.thompson@linaro.org> <20140912171404.GO12361@n2100.arm.linux.org.uk> <20140912171908.GP12361@n2100.arm.linux.org.uk> <20140912172337.GQ12361@n2100.arm.linux.org.uk> <5415376F.10302@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5415376F.10302@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 14, 2014 at 07:36:31AM +0100, Daniel Thompson wrote:
> > -	if (!relinquish)
> > +	if (!relinquish) {
> > +		/* Restore default handler and registers */
> > +		local_fiq_disable();
> > +		set_fiq_regs(&dfl_fiq_regs);
> 
> This variable was declared as def_fiq_regs .

Yep.

> >  		set_fiq_handler(&no_fiq_insn, sizeof(no_fiq_insn));
> > +		local_fiq_enable();
> > +
> > +		/* FIXME: notify irq controller to standard enable FIQs */
> 
> I don't understand what we need to tell the irq controller at this point.
> 
> If we do want to mask sources of FIQ from arch code then in the case of
> IPI_CPU_BACKTRACE we might be better off disabling it at point of
> generation than at the interrupt controller (to avoid the long timeout).

The point is, when a platform decides that it wants to insert its own
/fast/ interrupt handler into the vector, our default one is moved out
of the way.  Those fast interrupt handlers assume that they are the
only user of FIQ (since only one fast interrupt handler routine can be
in place at any one time.)  So, it's not going to expect to receive any
other FIQs other than the one(s) it's written for.

So, when the platform gives up the FIQ vector, and we restore the
default FIQ code, we need to make sure that the FIQ sources for that
code are re-enabled.

Yes, you may not like this, and you may want to turn FIQ into a sprawling
mess with interrupt source demux and such like, but that's not really on.
The clue is in the name.  *Fast*.  On certain platforms, it gets used for
time critical activities, and it being low latency is an absolute must.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
