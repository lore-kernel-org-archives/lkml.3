Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127AbaDXL2S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 07:28:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55505 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753794AbaDXL2O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 07:28:14 -0400
Date: Thu, 24 Apr 2014 13:28:11 +0200
From: Miroslav Lichvar <mlichvar@redhat.com>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>
Subject: Re: [PATCH] [RFC] timekeeping: Rework frequency adjustments to work
 better w/ nohz
Message-ID: <20140424112811.GF29729@localhost>
References: <1389067023-13541-1-git-send-email-john.stultz@linaro.org>
 <20140212154221.GG666@localhost>
 <53589195.3060605@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53589195.3060605@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 09:22:45PM -0700, John Stultz wrote:
> On 02/12/2014 07:42 AM, Miroslav Lichvar wrote:
> > You can see in this test it takes about 2500 updates to correct the
> > initial ntp error and settle down. That's with 1GHz clocksource. In
> > some tests I did with smaller clock frequencies or different frequency
> > offsets it took much longer than that.
> 
> So I started to look into this slow update issue. I was a little
> confused, as the logarithmic approximation done in the frequency
> correction shouldn't let *that* much initial error accumulate before get
> to the +1/0 adjustments.
> 
> It ends up this is more a reflection of a different part of your patch.
> Particularly the tk->ntp_tick storage. Bascially the ntp_tick variable
> is a cache of the ntp_tick_length() value, however it doesn't get set to
> ntp_tick_length() until *after* you do the first frequency correction.
> Basically this avoids accumulating any error until after the first
> correction is made.

Yes, that was one of the main points of the patch. Postponing the tick
length change should remove the biggest source of the ntp error.

> My main concern is that this seems like an accounting error. By
> basically avoiding accumulating the initial error it seems it would
> never be corrected, no?

Not if we don't consider it to be something that should be corrected.
When the ntp tick length is changed (by adjtimex call or on second
overflow), to which ticks should be this change applied? The current
code always accumulates ntp error with the current tick length, i.e.
the change is effectively applied to already passed ticks since last
accumulation. I'm not saying this is necessarily wrong, but it causes
large ntp errors. I'm proposing to look at the frequency change
in a different way and apply it at the current time in the current
tick when the clock is updated.

In my understanding, there are three sources of ntp error in the
current code:
- change in the tick length is not effectively applied at the current
  time in the clock update
- mult is controlled by an iterative method
- insufficient resolution of mult

I think the first source can be removed by postpoing the tick length
change as explained above. The second source can be removed by
calculating mult precisely with division instead of an iterative
method. There is probably nothing we can do about the third source
(except switching to 64-bit mult), but it's small, predictable and can
be handled easily and cheaply by the +1/0 mult adjustment.

I'm still not convinced the clock can be controlled quickly and
accurately without information about when will be the next clock
update if the first and possibly second source of ntp error remain
there. As you have probably seen when working on the patches, the
requirements are in conflict and it's difficult or maybe not even
possible to get something working well with all different update
intervals, clock multipliers and frequency changes.

>From my view, as someone involved in development of algorithms
controlling clocks, I'd like the clock to be as deterministic as
possible. When I set the frequency, the kernel shouldn't be correcting
some large unknown phase error behind my back. I still wouldn't know
when exactly was the frequency actually set, but if that information
was exported by adjtimex (I have some ideas how to do that), it would
be perfect for me.

Thanks for still working on this.

-- 
Miroslav Lichvar
