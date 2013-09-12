Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932Ab3ILOns (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 10:43:48 -0400
Received: from www.linutronix.de ([62.245.132.108]:59048 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab3ILOnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 10:43:47 -0400
Date: Thu, 12 Sep 2013 16:43:37 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Herbert Xu <herbert@gondor.hengli.com.au>
cc: Fan Du <fan.du@windriver.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        David Miller <davem@davemloft.net>,
        Daniel Borkmann <dborkman@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCHv3 linux-next] hrtimer: Add notifier when clock_was_set
 was called
In-Reply-To: <20130912134409.GB21212@gondor.apana.org.au>
Message-ID: <alpine.DEB.2.02.1309121636010.4089@ionos.tec.linutronix.de>
References: <1375866296-15079-1-git-send-email-fan.du@windriver.com> <1375866296-15079-2-git-send-email-fan.du@windriver.com> <52021177.6020306@redhat.com> <520213F2.5090401@windriver.com> <520214C6.6000307@redhat.com> <520B4552.2000607@windriver.com>
 <alpine.DEB.2.02.1308181102230.4089@ionos.tec.linutronix.de> <5212CCCA.4090907@windriver.com> <alpine.DEB.2.02.1309121441420.4089@ionos.tec.linutronix.de> <20130912134409.GB21212@gondor.apana.org.au>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Sep 2013, Herbert Xu wrote:
> On Thu, Sep 12, 2013 at 03:21:24PM +0200, Thomas Gleixner wrote:
> >
> > > (3): http://www.spinics.net/lists/netdev/msg245169.html
> > 
> > Thanks for the explanation so far.
> > 
> > What's still unclear to me is why these timeouts are bound to wall
> > time in the first place.
> > 
> > Is there any real reason why the key life time can't simply be
> > expressed in monotonic time, e.g. N seconds after creation or M
> > seconds after usage? Looking at the relevant RFCs I can't find any
> > requirement for binding the life time to wall time. 
> > 
> > A life time of 10 minutes does not change when the wall clock is
> > adjusted for whatever reasons. It's still 10 minutes and not some
> > random result of the wall clock adjustments. But I might be wrong as
> > usual :)
> 
> Well we started out with straight timers.  It was changed because
> people wanted IPsec SAs to expire after a suspect/resume which

Right suspend is the usual suspect :)

> AFAIK does not touch normal timers.
> 
> Of course, this brought with it a new set of problems when the
> system time is stepped which now cause SAs to expire even though
> they probably shouldn't.

Right. That's what I guessed. So your problem is that the timer_list
timers which are the proper mechanism for this (the life time has a 1
second granularity, so hrtimers are complete overkill) are not
expiring after a suspend/resume cycle.

So what about going back to timer_list timers and simply utilize
register_pm_notifier(), which will tell you that the system resumed?

Thanks,

	tglx

