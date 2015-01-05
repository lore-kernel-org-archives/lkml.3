Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997AbbAEMLr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 07:11:47 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:55262 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368AbbAEMLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 07:11:46 -0500
Date: Mon, 5 Jan 2015 12:11:36 +0000
From: Will Deacon <will.deacon@arm.com>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Pavel Machek <pavel@ucw.cz>, Marc Zyngier <Marc.Zyngier@arm.com>,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] Revert 9fc2105aeaaf56b0cf75296a84702d0f9e64437b to fix
 pyaudio (and probably more)
Message-ID: <20150105121126.GA10116@arm.com>
References: <20150104190123.GA20153@amd>
 <alpine.LFD.2.11.1501041438130.18844@knanqh.ubzr>
 <20150104201026.GA23427@amd>
 <alpine.LFD.2.11.1501041512440.18844@knanqh.ubzr>
 <20150104203724.GA16372@amd>
 <alpine.LFD.2.11.1501041547050.18844@knanqh.ubzr>
 <CA+55aFy5yB2d-1iXEUtU+puua4TAmV0kZF_7TBhXO1Y4Khqb9Q@mail.gmail.com>
 <alpine.LFD.2.11.1501041609290.18844@knanqh.ubzr>
 <20150104212659.GC12302@n2100.arm.linux.org.uk>
 <alpine.LFD.2.11.1501042343240.18844@knanqh.ubzr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.11.1501042343240.18844@knanqh.ubzr>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Sorry for the late reply, it seems that neither myself or the
arm-linux-kernel list were on CC for this thread.

On Mon, Jan 05, 2015 at 04:51:31AM +0000, Nicolas Pitre wrote:
> On Sun, 4 Jan 2015, Russell King - ARM Linux wrote:
> > I encourage you *not* to back down like this.  Linus is right in so far
> > as the regressions issue, but he is *totally* wrong to do the revert,
> > which IMHO has been done out of nothing more than spite.
> > 
> > Either *with or without* the revert, the issue still remains, and needs
> > to be addressed properly.
> > 
> > With the revert in place, we now have insanely small bogomips values
> > reported via /proc/cpuinfo when hardware timers are used.  That needs
> > fixing.
> 
> Here's my take on it.  Taking a step back, it was stupid to mix bogomips 
> with timer based delays.

Well, bogomips is directly related to loops_per_jiffy so I don't think the
mechanism is "stupid"; the issue is that userspace makes assumptions
(bogus or otherwise) about the relation of bogomips to cpu frequency which
have historically been good enough. More below...

> ----- >8
> From: Nicolas Pitre <nicolas.pitre@linaro.org>
> Date: Sun, 4 Jan 2015 22:28:58 -0500
> Subject: [PATCH] ARM: disentangle timer based delays and bogomips calibration
> 
> The bogomips value is a pseudo CPU speed value originally used to calibrate
> loop-based small delays.  It is also exported to user space through the
> /proc filesystem and some user space apps started relying on it.
> 
> Modern hardware can vary their CPU clock at run time making the bogomips
> value less reliable for delay purposes. With the advent of high resolution
> timers, small delays migrated to timer polling loops instead.  Strangely
> enough, the bogomips value calibration became timer based too, making it
> way more bogus than it already was as a CPU speed representation and people
> using it via /proc/cpuinfo started complaining.

As you pointed out previously, these complaints were what prompted us to
revisit the bogomips reporting. The class of application using the value
was very much things like "How fast is my AwesomePhone-9000?":

  https://play.google.com/store/apps/details?id=com.securiteinfo.android.bogomips&hl=en_GB
  https://bugs.launchpad.net/ubuntu/+source/byobu/+bug/675442

so actually, having *these* applications either exit early with an
"unable to calculate CPU frequency" message or print something like "CPU
freq: unknown" is arguably the right thing to do. What Pavel is now
reporting is different; some useful piece of software has lost core
functionality.

Now, even with the loop-based bogomips values we have the following
(user-visible) problems:

  (1) It's not portable between microarchitectures (for example, some
      CPUs can give you double the value if they predict the backwards
      branch in the calibration loop)

  (2) It's not reliable in the face of frequency scaling

  (3) It's not reliable in the face of heterogeneous systems (big.LITTLE)

  (4) The lpj calculation is susceptible to overflow, limiting the maximum
      delay value depending on the CPU performance

Essentially, the value is only really useful on relatively low-clocked,
in-order, uniprocessor systems (like the one where Pavel reported the bug).

> Since it was wrong for user space to rely on a "bogus" mips value to start
> with, the initial responce from kernel people was to remove it.  This broke
> user space even more as some applications then refused to run altogether.
> The bogomips export was therefore reinstated in commit 4bf9636c39 ("Revert
> 'ARM: 7830/1: delay: don't bother reporting bogomips in /proc/cpuinfo'").

Actually, our initial response was to report a dummy value iirc. I remember
even making it selectable in kconfig, but it bordered on the absurd. It's
worth noting that, with the current revert in place, the value reported
is now basically selectable via the "clock-frequency" property on the
arch_timer node for systems using the timer implementation.

> Because the reported bogomips is orders of magnitude away from the
> traditionally expected value for a given CPU when timer based delays are
> in use, and because lumping bogomips and timer based delay loops is rather
> senseless anyway, let's calibrate bogomips using a CPU loop all the time
> even when timer based delays are available.  Timer based delays don't
> need any calibration and /proc/cpuinfo will provide somewhat sensible
> values again.
> 
> In practice, calls to __delay() will now always use the CPU based loop.
> Things remain unchanged for udelay() and its derivatives.

Given that we have a hard limit of 3355 bogomips in our calibration code,
could we not just report that instead? We already have all of the issues I
highlighted above and the systems that are going to be hit by this are the
more recent (more performant) cores that will be approaching this maximum
value anyway.

We also need something we can port to the arm64 compat layer, so a constant
would be easier there too, doesn't require the calibration delay at boot
and doesn't break __delay.

One thing we're missing from all of this is what happens if Pavel's testcase
is executed on a system using a timer-backed delay? If the program chokes
on the next line anyway, then we could consider only advertising the
bogomips line when the loop-based delay is in use.

Pavel: do you have something we can run to observe the problem?

Finally, the revert doesn't have a Cc stable tag which is probably needed
if it's going to land in 3.19 final, irrespective of whether we agree that
it's the right way forward.

Will
