Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992Ab3ILWmB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 18:42:01 -0400
Received: from longford.logfs.org ([213.229.74.203]:60204 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413Ab3ILWmA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 18:42:00 -0400
Date: Thu, 12 Sep 2013 17:07:17 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: John Stultz <john.stultz@linaro.org>,
        Stephan Mueller <smueller@chronox.de>,
        LKML <linux-kernel@vger.kernel.org>, dave.taht@bufferbloat.net,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] /dev/random: Insufficient of entropy on many
 architectures
Message-ID: <20130912210717.GC3809@logfs.org>
References: <10005394.BRCyBMYWy3@tauon>
 <CANcMJZAHuXNQ4eUx+qpVnfJTg625HkJU_9pgBP24ykkmBww3yw@mail.gmail.com>
 <20130910203853.GG29237@thunk.org>
 <522F851D.1040101@linaro.org>
 <20130910211009.GI29237@thunk.org>
 <522F984C.2070909@linaro.org>
 <20130910223326.GD11063@thunk.org>
 <522FB9F1.3070905@linaro.org>
 <20130911005047.GA13315@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130911005047.GA13315@thunk.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 September 2013 20:50:47 -0400, Theodore Ts'o wrote:
> 
> Yep.  The worse case would probably a serial port running at 230400
> bps.  Even with a 16550A UART with the 16-byte FIFO, we're talking
> about close to 2,000 interrupts per second.  A 16450 running at 115200
> bps would give us 11,520 interrupts per second....

I happen to have a real-world system with >100k interrupts per second
and - surprise - add_interrupt_randomness() showed up prominently in
the profiles.  I was also told twice to just remove that call.  I
resisted both times and have done far more work to reduce overhead
while still collecting entropy.  Some others would have caved in.

My bottom line: we have to make add_interrupt_randomness() cheaper or
else it will get removed in custom kernels.  Quite likely it already
has been removed in a number of places.

One option is to add the "input_pool.entropy_count > trickle_thresh"
condition that all other entropy sources currently have.  But instead
I would rather rename fast_mix() to not_too_fast_mix() and implement a
real fast_mix().  Essentially just xor the collected numbers into a
pool and schedule something to shuffle the bits at a later point.

The point is to make collection of randomness as cheap as possible.
The cheaper it is to collect, the more of it we will collect.  And
collecting lots of bad randomness really cheaply may be a better
tradeoff than collecting a bit of good randomness with medium cost.
Hashing will ensure that any real randomness will overcome all
predictable data we may have collected alongside.

Jörn

--
Optimizations always bust things, because all optimizations are, in
the long haul, a form of cheating, and cheaters eventually get caught.
-- Larry Wall
