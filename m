Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750929Ab3KCXcL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 18:32:11 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33327 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729Ab3KCXcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 18:32:09 -0500
Date: Mon, 4 Nov 2013 00:32:07 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Stephan Mueller <smueller@chronox.de>
Cc: "Theodore Ts'o" <tytso@mit.edu>, sandy harris <sandyinchina@gmail.com>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] CPU Jitter RNG: inclusion into kernel crypto API and
 /dev/random
Message-ID: <20131103233207.GA5105@amd.pavel.ucw.cz>
References: <2579337.FPgJGgHYdz@tauon>
 <7861469.OAmn4h8An0@tauon>
 <20131102110112.GA16231@amd.pavel.ucw.cz>
 <3537770.iLHXPOXMiU@tauon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3537770.iLHXPOXMiU@tauon>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Another friend of mine mentioned that he assumes the rise and fall times 
> of transistors varies very slightly and could be the main reason for the 
> jitter. I do not think that this is really the case, because our gates 
> that form the CPU instructions comprise of many transistors. The 
> combined raise/fall jitter should cancel each other out.

Plus, there's clock that should make sure that this jitter does not
matter.

> >There should be way to extract entropy more directly from various
> >oscillator effects, no?
> 
> I am working a different way of measuring such oscillator effects by 
> using the high-resolution timer of the CPU and measure it with a 
> Jiffies-based snapshotting window. So, here I would combine two timers 
> that are differently generated. If their frequencies would be relative 
> prime to each other, we would measure a direct oscillator effect.

I guess main problem is machines that do not have high-resolution
timer on the CPU (rdtsc). They do not get enough entropy during boot,
and the hell breaks loose.

But they usually _do_ have RTC or other clock, not driven by CPU
oscilator. Good.

What about just

while (!enough_entropy) {
      cur_time = read_rtc();
      simulated_tsc = 0;
      while (cur_time == read_rtc())
      	    simulated_tsc++;
      gain_entropy_from(simulated_tsc)
}

(Where enough_entropy should be something like 128 bits).

This should work, we know why it works (drift between rtc and cpu
clock) and it does _not_ need rdtsc-style fast source.

Disadvantage is that it burns cpu, but, well, you only need 128
bits. Asuming the rtc used has 100Hz resolution, enough entropy should
be collected in under 2 seconds. That's acceptable adition to time it
takes generating ssh keys on slow cpu.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
