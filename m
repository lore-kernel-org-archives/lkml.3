Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359Ab3IWCnx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 22:43:53 -0400
Received: from imap.thunk.org ([74.207.234.97]:36205 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753064Ab3IWCnv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 22:43:51 -0400
Date: Sun, 22 Sep 2013 22:43:38 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: =?iso-8859-1?Q?J=F6rg-Volker?= Peetz <jvpeetz@web.de>,
        John Stultz <john.stultz@linaro.org>,
        Stephan Mueller <smueller@chronox.de>,
        LKML <linux-kernel@vger.kernel.org>, dave.taht@bufferbloat.net,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH,RFC] random: make fast_mix() honor its name
Message-ID: <20130923024338.GF7321@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	=?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>,
	=?iso-8859-1?Q?J=F6rg-Volker?= Peetz <jvpeetz@web.de>,
	John Stultz <john.stultz@linaro.org>,
	Stephan Mueller <smueller@chronox.de>,
	LKML <linux-kernel@vger.kernel.org>, dave.taht@bufferbloat.net,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Thomas Gleixner <tglx@linutronix.de>
References: <20130912233155.GB5279@thunk.org>
 <20130916154026.GA23345@logfs.org>
 <20130921212510.GD8606@thunk.org>
 <20130921214118.GE8606@thunk.org>
 <20130922030553.GA21422@thunk.org>
 <523F5AB6.8070107@web.de>
 <20130922212752.GB7321@thunk.org>
 <20130922205334.GC4584@logfs.org>
 <20130922233641.GE7321@thunk.org>
 <20130923001623.GD4584@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130923001623.GD4584@logfs.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 22, 2013 at 08:16:23PM -0400, Jörn Engel wrote:
> How about we switch between the two mixing functions depending on the
> interrupt load?  If this CPU has seen fewer than 1000 interrupts in
> the last second, use the better one, otherwise us the cheaper one?

I guess the question here is whether it's worth it.  On a 2.8 GHz
laptop Ivy Bridge chip the numbers are:

Original fast_mix: 84 ns
tytso's fast_mix:  14 ns
joern's fast_mix:   8 ns

In terms of absolute overhead if you are running at an insane 100k
interrupts per second, it's still only 0.84%, 0.14%, and 0.08%,
respectively.  Granted, an embedded CPU will be (much) slower, but so
will the overall overhead of the rest of the interrupt handling code
path plus whatever the overhead of the device driver will be.  The
real bug is the 100k interrupts per second workload.

How about this as a compromise?  We can add an #ifdef in the random.c
code which has the alternate fast_mix algorithm in the very rare case
that some embedded software engineer under time-pressure and suffering
under the need to use a pathetically broken hardware design, and who
starts looking in the random.c code, will find the an alternate
version.  That way, we avoid the complexity of an dynamic switching
system, plus the overhead of measuring the number of interrupts per
second.

I am very strongly of the opinion that the number of systems where you
have an embedded system with that kind of inane interrupt rate is the
0.00000000001% case.  So IMHO it's not even worth having a dynamic
switching system, especially when it's only going to improve things
slightly.

						- Ted

P.S.  The real reason for the original fast_mix() function is because
it has a separate pool for each CPU, so there's no spinlock contention
and no cache line bouncing.  And that's why the fast_mix pool is so
small --- so that the entire struct fast_pool can fit in a single CPU
cache line.  So on normal, common systems --- even mobile handsets
have multiple cores these days --- fast_mix() *is* actually much
faster than the standard entropy pool, even before any optimizations.
