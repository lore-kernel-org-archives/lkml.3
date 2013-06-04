Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536Ab3FDKVg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 06:21:36 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34871 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab3FDKVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 06:21:32 -0400
Date: Tue, 4 Jun 2013 11:21:14 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-arm-msm@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        linux-kernel@vger.kernel.org, arm@kernel.org,
        John Stultz <john.stultz@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv2 4/6] sched_clock: Add support for >32 bit sched_clock
Message-ID: <20130604102114.GU18614@n2100.arm.linux.org.uk>
References: <1370155183-31421-1-git-send-email-sboyd@codeaurora.org> <1370155183-31421-5-git-send-email-sboyd@codeaurora.org> <20130603093938.GG18614@n2100.arm.linux.org.uk> <51AD069F.1060308@codeaurora.org> <20130603221210.GO18614@n2100.arm.linux.org.uk> <51AD483F.2010206@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51AD483F.2010206@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 03, 2013 at 06:51:59PM -0700, Stephen Boyd wrote:
> On 06/03/13 15:12, Russell King - ARM Linux wrote:
> > If you have a 56-bit clock which ticks at a period of 1ns, then
> > cd.rate = 1, and your sched_clock() values will be truncated to 56-bits.
> > The scheduler always _requires_ 64-bits from sched_clock.  That's why we
> > have the complicated code to extend the 32-bits-or-less to a _full_
> > 64-bit value.
> >
> > Let me make this clearer: sched_clock() return values _must_ without
> > exception monotonically increment from zero to 2^64-1 and then wrap
> > back to zero.  No other behaviour is acceptable for sched_clock().
> 
> Ok so you're saying if we have less than 64 bits of useable information
> we _must_ do something to find where the wraparound will occur and
> adjust for it so that epoch_ns is always incrementing until 2^64-1. Fair
> enough. I was trying to avoid more work because on arm architected timer
> platforms it takes many years for that to happen.
> 
> I'll see what I can do.

Well, 56 bits at 1ns intervals is 833 days (2^56 / (1000000000*60*60*24)).
We used to say that 497 days was enough several years ago, and that got
fixed.  We used to say 640K was enough memory for anything, and that
got fixed.

Whenever there's a limit, that limit will always be exceeded.  833 days
uptime has already been exceeded by ARM machines - I have one at the
moment:

 11:17:58 up 1082 days, 11:53, 14 users,  load average: 1.20, 1.28, 1.32

and I would not be surprised if there were others around.
