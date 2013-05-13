Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218Ab3EMM2W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 08:28:22 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:11623 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251Ab3EMM2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 08:28:21 -0400
Date: Mon, 13 May 2013 14:28:12 +0200
From: Jean Delvare <khali@linux-fr.org>
To: imre.deak@intel.com
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 01/11] time: add *_to_jiffies_min helpers to guarantee a
  minimum duration
Message-ID: <20130513142812.0a606a75@endymion.delvare>
In-Reply-To: <1368444448.16445.62.camel@intelbox>
References: <1368188011-23661-1-git-send-email-imre.deak@intel.com>
	<20130513092904.3ba12f9d@endymion.delvare>
	<1368444448.16445.62.camel@intelbox>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.14; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Imre,

On Mon, 13 May 2013 14:27:28 +0300, Imre Deak wrote:
> On Mon, 2013-05-13 at 09:29 +0200, Jean Delvare wrote:
> > Hi Imre,
> > 
> > On Fri, 10 May 2013 15:13:19 +0300, Imre Deak wrote:
> > > The *_to_jiffies(x) macros return a jiffy value, which if used as a
> > > delta to wait for a specific amount of time, may result in a wait-time
> > > that is less than x.
> > 
> > Are you sure? I have always considered that *_to_jiffies(x) macros
> > rounded up, and reading the code seems to confirm that:
> > 
> > 	/*
> > 	 * Generic case - multiply, round and divide. (...)
> > 	 */
> > 	(...)
> > 	return (MSEC_TO_HZ_MUL32 * m + MSEC_TO_HZ_ADJ32)
> > 		>> MSEC_TO_HZ_SHR32;
> > 
> > What makes you think the resulting wait time can be less that requested?
> 
> Yes the above does a round-up, but for another reason. It makes only
> sure you won't wait less than the requested time because you have a too
> coarse HZ value. So for example with HZ=1000 it won't do any adjustment,
> but with HZ=100 it'll round up durations not dividable by 10 msec.

For HZ=1000 the code above is never reached, the code which is executed
instead is:

	/*
	 * HZ is equal to or smaller than 1000, and 1000 is a nice
	 * round multiple of HZ, divide with the factor between them,
	 * but round upwards:
	 */
	return (m + (MSEC_PER_SEC / HZ) - 1) / (MSEC_PER_SEC / HZ);

which simplifies to just:

	return m;

So indeed no round up of any kind. Thanks for the clarification.

> What the proposed change wants to solve is how - or rather what point in
> time - the returned value is used. For example in the following loop to
> wait for some condition to become true:
> 
> timeout = msecs_to_jiffies(1);
> while (!condition && timeout) {
> 	prepare_to_wait(wq, ...);
> 	timeout = schedule_timeout(timeout);
> }
> 
> it would seem we'll wait at least 1 msec for the condition to become
> true. In fact with HZ=1000 and an initial timeout value of 1 we may wait
> less, since schedule_timeout() will return with 0 already at the next
> scheduling clock tick which is most probably less than 1 msec ahead in
> time.

OK, I see your point now.

But maybe your example code is not good in the first place. I don't
think you should use schedule_timeout() for such a small wait time.
Aren't you supposed to use HR timers instead?

> > If this really is the case then the proper way to address the issue is
> > to fix the original macros, not introducing new ones.
> 
> I'm not sure if we need the adjustment in all cases. For example in the
> following polling loop we'd like to wake up every msec (to check for
> something not signaled through the wq) and time out after 50 iterations:
> 
> for (i = 0; i < 50; i++) {
> 	prepare_to_wait(wq, ...);
> 	if (condition)
> 		break;
> 	schedule_timeout(msecs_to_jiffies(1));
> }
> 
> Having the +1 adjustment in msecs_to_jiffies() would result in waking up
> close to every 2 msec.

To be honest I thought it was already the case, but I was wrong. What
confused me is that I mostly work on hwmon drivers and the typical use
case of msecs_to_jiffies() in these drivers is in conjunction with
time_after(). It's time_after() which does "round up", in that it
always completes the current jiffy before it starts counting.

So there may be a need for what you're doing, just not in the drivers
I'm taking care of. So I'll keep quiet about it from now on ;)

-- 
Jean Delvare
