Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384Ab3IKAu4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 20:50:56 -0400
Received: from imap.thunk.org ([74.207.234.97]:57949 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752168Ab3IKAuz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 20:50:55 -0400
Date: Tue, 10 Sep 2013 20:50:47 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: John Stultz <john.stultz@linaro.org>
Cc: Stephan Mueller <smueller@chronox.de>, LKML <linux-kernel@vger.kernel.org>,
        dave.taht@bufferbloat.net, Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] /dev/random: Insufficient of entropy on many
 architectures
Message-ID: <20130911005047.GA13315@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	John Stultz <john.stultz@linaro.org>,
	Stephan Mueller <smueller@chronox.de>,
	LKML <linux-kernel@vger.kernel.org>, dave.taht@bufferbloat.net,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>
References: <10005394.BRCyBMYWy3@tauon>
 <CANcMJZAHuXNQ4eUx+qpVnfJTg625HkJU_9pgBP24ykkmBww3yw@mail.gmail.com>
 <20130910203853.GG29237@thunk.org>
 <522F851D.1040101@linaro.org>
 <20130910211009.GI29237@thunk.org>
 <522F984C.2070909@linaro.org>
 <20130910223326.GD11063@thunk.org>
 <522FB9F1.3070905@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <522FB9F1.3070905@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 05:31:45PM -0700, John Stultz wrote:
> Yea, that point about "every single interrupt" vs "every timer
> interrupt". I suspect that if its every timer interrupt, this can be
> done easily w/ clocksources as we already do that read, but every single
> interrupt would have potential problems with various other devices with
> high irq frequency.

Yep.  The worse case would probably a serial port running at 230400
bps.  Even with a 16550A UART with the 16-byte FIFO, we're talking
about close to 2,000 interrupts per second.  A 16450 running at 115200
bps would give us 11,520 interrupts per second....

> Right so get_cycles() really sounds like the right thing here.

For those platforms which have them, yes.

> Although I wonder if you run into issues with counters that wrap
> quickly? Or does that not matter?

No, it doesn't matter.  It's really the low bits of the counter which
are really important to us anyway.  For example on MIPS there is a
register which is bumped on every CPU cycle, but its kept mod the
number of entries in the TLB (it's used for random TLB eviction).
That's what we'll probably ending using for MIPS, since its cycle
counter is not guaranteed to be there, and had a bug which could cause
timer interrupts to get lost if you tried reading from it at the wrong
time.

> Right. In many cases jiffies is all that we have. Thus the check for
> timekeeping_valid_for_hres() can be used to at least flag that case. Not
> that I know what you want to do if it comes up false.

Right now, if get_cycles() returns 0, we fall back to only mixing in
the IP register from the interrupt plus the jiffies counter.  The
platforms where get_cycles returns 0 is:

- MIPS (solution pending)
- User mode Linux
- Sparc 32 bit
- M68K
- M32R
- Hexagon
- H8/300
- FR-V
- CRIS
- AVR32
- ARC
- METAG
- Microblaze
- SCORE
- SH
- Unicore32

Would I be correct in assuming that most of these probably don't have a
high-res clocksource, and so would fall back to jiffies anyway?

Thanks,

	 	      	     	   	     - Ted
