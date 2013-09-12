Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683Ab3ILNVk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 09:21:40 -0400
Received: from www.linutronix.de ([62.245.132.108]:58630 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752509Ab3ILNVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 09:21:38 -0400
Date: Thu, 12 Sep 2013 15:21:24 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Fan Du <fan.du@windriver.com>
cc: Steffen Klassert <steffen.klassert@secunet.com>,
        David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Daniel Borkmann <dborkman@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCHv3 linux-next] hrtimer: Add notifier when clock_was_set
 was called
In-Reply-To: <5212CCCA.4090907@windriver.com>
Message-ID: <alpine.DEB.2.02.1309121441420.4089@ionos.tec.linutronix.de>
References: <1375866296-15079-1-git-send-email-fan.du@windriver.com> <1375866296-15079-2-git-send-email-fan.du@windriver.com> <52021177.6020306@redhat.com> <520213F2.5090401@windriver.com> <520214C6.6000307@redhat.com> <520B4552.2000607@windriver.com>
 <alpine.DEB.2.02.1308181102230.4089@ionos.tec.linutronix.de> <5212CCCA.4090907@windriver.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Aug 2013, Fan Du wrote:
> Thanks for your patience. Please let me take a few seconds try to
> explain this.

Sorry for the late reply.
 
> Current xfrm layers has *one* hrtimer to guard Ipsec keys timeout,
> The timeout could be measured in either of below two ways:
> 
>  (1) The timer is started once the keys is created, but this
>      key is not necessary actually used right now. In detail,
>      record the get_seconds() when this key is created.
> 
>  (2) Starting the timer when this key is actually used, e.g when
>      an IP packet need to be encrypted. In details, recored the
>      get_seconds() when this key is first used.
> 
> So in the hrtimer handler, the code get current get_seconds, and
> check against with what saved in (1)or(2), and notify the timeout
> up to user land.
> 
> So the pitfall is using one hrtimer for two timeout events,
> most importantly using get_seconds to check timeout, once system
> clock is changed by user intentionally, the key timeout could
> misbehave wildly.
> 
> A refractor has been proposed to get rid of depending on system wall
> clock by cleaning up the hrtimer handler. Unfortunately David frowned
> on it in (3), and suggest once system clock is changed, adjust the
> timeout of the key.
> 
> 
> (3): http://www.spinics.net/lists/netdev/msg245169.html

Thanks for the explanation so far.

What's still unclear to me is why these timeouts are bound to wall
time in the first place.

Is there any real reason why the key life time can't simply be
expressed in monotonic time, e.g. N seconds after creation or M
seconds after usage? Looking at the relevant RFCs I can't find any
requirement for binding the life time to wall time. 

A life time of 10 minutes does not change when the wall clock is
adjusted for whatever reasons. It's still 10 minutes and not some
random result of the wall clock adjustments. But I might be wrong as
usual :)

Thanks,

	tglx
