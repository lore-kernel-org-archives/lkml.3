Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932869AbaFLJWl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 05:22:41 -0400
Received: from s3.sipsolutions.net ([5.9.151.49]:34248 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932634AbaFLJWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 05:22:39 -0400
Message-ID: <1402564914.8095.9.camel@jlt4.sipsolutions.net>
Subject: Re: net_timedelta() affected by settimeofday() (was: [patch 12/13]
 net: mac80211: Remove silly timespec dance)
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org,
        Stephen Hemminger <shemminger@linux-foundation.org>,
        netdev <netdev@vger.kernel.org>
Date: Thu, 12 Jun 2014 11:21:54 +0200
In-Reply-To: <alpine.DEB.2.10.1406121047280.5170@nanos>
References: <20140611234024.103571777@linutronix.de>
	  <20140611234607.683770899@linutronix.de>
	  <1402555774.4224.1.camel@jlt4.sipsolutions.net>
	  <alpine.DEB.2.10.1406121017500.5170@nanos>
	  <1402562114.8095.3.camel@jlt4.sipsolutions.net>
	  (sfid-20140612_103558_525847_209A5C98) <1402562399.8095.5.camel@jlt4.sipsolutions.net>
	 <alpine.DEB.2.10.1406121047280.5170@nanos>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-06-12 at 10:57 +0200, Thomas Gleixner wrote:

> > > Right, but isn't that odd? Suddenly your delay measurement here might be
> > > minutes, hours, or years if you settimeofday() between timestamping and
> > > calculating the delta. That seems very strange to me, why would that be
> > > the right behaviour in any way?
> 
> Indeed. clock monotonic is the appropriate one for measurements.

And that's what we had here with ktime_get_ts()? I thought so, just
making sure.
 
> > > Now, it seems that there are only two current users of net_timedelta()
> > > (in DCCP) so perhaps it's not too late to change some of this?
> > > 
> > > Maybe in general the skb timestamp should be based on a different clock
> > > and only adjusted to real time when used in userspace?
> 
> You have the same problem then, just at a different place:
> 
>     ts = ktime_get();
> 
> 			settimeofday()
> 			   offset_mono_to_real = new value;
> 
>     userts = mono_to_real(ts);

Right. I'm not really sure if that's an issue though.

> But maybe that's not a real issue, as ktime_get_real() can race with
> settimeofday() or NTP as well.
> 
>    ts = ktime_get_real();
> 				settimeofday();
>    userts = ts;
> 
> So the user might see a weird timestamp for a packet, which cannot be
> correlated with the user space gettimeofday().

Right, once settimeofday() is called the timestamps from before/during
it can't really be correlated any more.

This is part of the userspace API already, but might it have been better
to expose the monotonic clock, since userspace can also get at it? Not
sure.

Either way it's an issue I guess; however I'm thinking your patch is
making it worse for the measurement in this particular code (where the
userspace issue doesn't come in, it should never be accessible there)

johannes


