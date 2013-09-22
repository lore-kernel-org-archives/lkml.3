Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716Ab3IVWMF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 18:12:05 -0400
Received: from longford.logfs.org ([213.229.74.203]:57943 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752457Ab3IVWME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 18:12:04 -0400
Date: Sun, 22 Sep 2013 16:53:34 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: =?utf-8?Q?J=C3=B6rg-Volker?= Peetz <jvpeetz@web.de>,
        John Stultz <john.stultz@linaro.org>,
        Stephan Mueller <smueller@chronox.de>,
        LKML <linux-kernel@vger.kernel.org>, dave.taht@bufferbloat.net,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH,RFC] random: make fast_mix() honor its name
Message-ID: <20130922205334.GC4584@logfs.org>
References: <522FB9F1.3070905@linaro.org>
 <20130911005047.GA13315@thunk.org>
 <20130912210717.GC3809@logfs.org>
 <20130912233155.GB5279@thunk.org>
 <20130916154026.GA23345@logfs.org>
 <20130921212510.GD8606@thunk.org>
 <20130921214118.GE8606@thunk.org>
 <20130922030553.GA21422@thunk.org>
 <523F5AB6.8070107@web.de>
 <20130922212752.GB7321@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130922212752.GB7321@thunk.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 September 2013 17:27:52 -0400, Theodore Ts'o wrote:
> 
> The structure of the mixing functions in /dev/random has been well
> studied, and validatetd in a number of different academic papers.  So
> I prefer to stick with the basic architecture, even as it is scaled
> down for speed reasons and beause the pool is smaller.

And I want to keep that function.  Essentially the point of fast_mix()
is to ratelimit _mix_pool_bytes().  Naïve ratelimiting would simply
discard the input once the ratelimit has been reached.  My proposal is
to still use the input bits, but use a really cheap mixing function.

Your version of fast_mix() failed in the "really cheap" department.
As a result, it showed up in profiles and at least one idiot (me)
reverted to naïve ratelimiting.  It could have been worse, I was
explicitly asked twice to just remove the call to
add_interrupt_randomness().

So don't think of my patch as weakening the mixing, but as
strengthening the ratelimited mixing.  If we have few interrupts,
_mix_pool_bytes() will be run once a second, if we have many it will
be run once every 64 interrupts.  And in the latter case, the input
for _mix_pool_bytes() is much better than with naïve ratelimiting.

And you should do the same for add_timer_randomness(), where again you
have ratelimiting.  Once trickle_thresh is reached your code simply
discards most randomness.  Only once in 4096 call do you use all the
bits you get - most of which will be predictable.  Why not use a cheap
mixing function for the other 4095 calls and ensure we have many good
bits on call 4096?

Jörn

--
You can't tell where a program is going to spend its time. Bottlenecks
occur in surprising places, so don't try to second guess and put in a
speed hack until you've proven that's where the bottleneck is.
-- Rob Pike
