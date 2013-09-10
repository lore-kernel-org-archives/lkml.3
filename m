Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834Ab3IJWdc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 18:33:32 -0400
Received: from imap.thunk.org ([74.207.234.97]:57916 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752091Ab3IJWdb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 18:33:31 -0400
Date: Tue, 10 Sep 2013 18:33:26 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: John Stultz <john.stultz@linaro.org>
Cc: Stephan Mueller <smueller@chronox.de>, LKML <linux-kernel@vger.kernel.org>,
        dave.taht@bufferbloat.net, Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] /dev/random: Insufficient of entropy on many
 architectures
Message-ID: <20130910223326.GD11063@thunk.org>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <522F984C.2070909@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 03:08:12PM -0700, John Stultz wrote:
> One other area you might look at is using the delta between when the
> next hrtimer was scheduled for and when we actually expired it? That's
> something we could cheaply calculate on every hrtimer expiration. Though
> I probably should be hesitant with my suggestions, as I'm not well
> versed in RNG theory.

What we need is a time source which whose granularity is substantially
finer-grained that the rate at which interrupts are delievered to the
system (preferably by a factor at least 8 or 16).  It also needs to be
fast enough (since we will be calling it on every single interrupt)
that the overhead doesn't cause architecture maintainers to break out
their torches and pitchforks and come looking for me.  :-)

Reading from a cycle counter is therefore ideal; it doesn't need to be
synchronized across CPU's, and I don't care if it gets stops ticking
when the system is suspended, and I don't care if the rate at which it
increment is dependent on CPU clock speed getting jacked up and down
for by power management systems.  (And in fact, if it's going to cost
extra overhead to correct for the CPU being suspended or running at a
1.6 MHz instead of 2.8 MHz, that's a bug, not a feature.)  We just
need something fine-grained.

The problem is what do we do on platforms that don't have a cycle
counter.  Stephan Mueller has proposed using the "best" clocksource as
a default fallback.  Which might be OK, but I still remember that
really, REALLY angry customer who discovered that gettimeofday() was
breathtakingly slow on an IBM X440 (at least, when they were calling
it at super high rates).

I just have no idea what various clock sources might do on different
architectures, and if many of the more older ones (i.e., sparc 32,
m32, h8, etc.) are just going to fall back to jiffies, I'm not sure
it's worth it.

       	     			     	       - Ted
