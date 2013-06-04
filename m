Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759799Ab3FDHAK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 03:00:10 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:41571 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759581Ab3FDHAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 03:00:07 -0400
Date: Tue, 4 Jun 2013 08:59:56 +0200
From: Tobias Waldekranz <tobias@waldekranz.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] timekeeping: handle epoch roll-over (2038) on 32-bit
 systems
Message-ID: <20130604065947.GA10895@gmail.com>
References: <CAFaRD2FP0rrQstV1GszP_URO+cZZuQdyRxOYUEmA+5BvopUAvQ@mail.gmail.com>
 <alpine.LFD.2.02.1306031622520.2905@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1306031622520.2905@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 03, 2013 at 04:34:25PM +0200, Thomas Gleixner wrote:
> B1;2601;0cOn Mon, 3 Jun 2013, Tobias Waldekranz wrote:
> > In ktime_get_update_offsets, calculate the current time in the same
> > way as in ktime_get.
> > 
> > On 32-bit systems, the current time is truncated via the call to
> > ktime_set, the following subtraction of offs_real will result in an
> > inaccurate time when the current number of seconds since epoch can no
> > longer fit in 31-bits (2038-01-19 03:14:07 UTC). This will send
> > hrtimer_interrupt into an infinite loop on some architectures (arm),
> > or emit an oops on others(x86).
> 
> If we really want to survive 2038, then we need to get rid of the
> timespec based representation of time in the kernel alltogether and
> switch all related code over to a scalar nsec 64bit storage.
> 
Agreed.

> Just "fixing" some random parts of the code in a "make it work
> somehow" way is a pointless exercise IMO.
> 
Now hold on, it is hardly random. On an ARM system, the kernel will
completely hang. I would think that many users would like to avoid
that. In addition this behavior is rather new, hrtimer_interrupt used
to source its time from ktime_get which avoids this issue. The change
was introduced in:

5baefd6d84163443215f4a99f6a20f054ef11236

I understand that you would like a solution to the broader issue. But
for some users (embedded especially) having a system that continues to
operate 25 years from now is an issue today.

As for "make it work somehow", modifying the current time calculation
to work in the same way as in ktime_get does seem to be a reasonable
way to go IMO.
 
> We already had long discussions about how the timekeeping code should
> be restructured to address that and other problems at least on the
> kernel side and switching everything to scalar storage is definitely
> the way to go.
> 
> Though even if we fix that we still need to twist our brains around
> the timespec/timeval based user space interfaces. That's going to be
> the way more interesting challenge.
> 
> Thanks,
> 
> 	tglx

Thanks,
	wkz
