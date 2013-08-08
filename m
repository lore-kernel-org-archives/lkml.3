Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258Ab3HHFvo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 01:51:44 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:55246 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753925Ab3HHFvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 01:51:43 -0400
Message-ID: <1375941095.18565.19.camel@marge.simpson.net>
Subject: Re: [PATCH V3]hrtimer: Fix a performance regression by disable
 reprogramming in remove_hrtimer
From: Mike Galbraith <bitbucket@online.de>
To: "ethan.zhao" <ethan.kernel@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, johlstei@codeaurora.org,
        Yinghai Lu <yinghai@kernel.org>, Jin Feng <joe.jin@oracle.com>,
        Youquan Song <youquan.song@intel.com>, LenBrown <len.brown@intel.com>
Date: Thu, 08 Aug 2013 07:51:35 +0200
In-Reply-To: <1375939750.18565.11.camel@marge.simpson.net>
References: <1374955447-5051-1-git-send-email-ethan.kernel@gmail.com>
	 <alpine.DEB.2.02.1307291146060.4089@ionos.tec.linutronix.de>
	 <CABawtvP4oLuvHOS3prbbgPShXVziV_wTo7i6KCqJ9KkoVdz0ag@mail.gmail.com>
	 <20130730093519.GP3008@twins.programming.kicks-ass.net>
	 <1375774140.5412.9.camel@marge.simpson.net>
	 <1375775172.5412.14.camel@marge.simpson.net>
	 <BD6ACAD8-25D7-406B-A843-22696F9D8DCC@gmail.com>
	 <1375939750.18565.11.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:xBNLJyZhpdFUZK1kk5ALMAPzC6mifzYK+TSW5Y/ii8U
 nYttqNNQpXXJ+SnSdQzkHYegvJt8h1xVRbtL4Zl1fsaFt1+qmR
 Z57jwhcMupByiVBfjg4z3gk/sWdt4RXPA6WpNbFJhiir1Qe451
 PGVV4Z3WJ/p0+6noki2PLXh0Ke1CPdYhIytrOCtQO92WS7wMUL
 5ml8QTQRtdwzkwt4jRLEFORoif3VIPNNS0QjCis9a9lN7icy1L
 fwpuvrdR2lNTH3AxxmXXSbld5X6TawSriVv3/JQhfBQ3XkALiv
 nRrJ5JAiGoS/otI251bwlKOOSBsq6wb5knB1c/rljpPRnlq5Ci
 d2Q99i7UDehyokM+wHa6KFqcdBnC5gRDbEKu62tBFQFbLMT6it
 oulhSitmrtJ0A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-08-08 at 07:29 +0200, Mike Galbraith wrote:

> On Thu, 2013-08-08 at 12:31 +0800, ethan.zhao wrote:
> 
> > diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
> > index 4137890..c27f04f 100644
> > --- a/arch/x86/include/asm/smp.h
> > +++ b/arch/x86/include/asm/smp.h
> > @@ -137,7 +137,7 @@ static inline void play_dead(void)
> > 
> > static inline void smp_send_reschedule(int cpu)
> > {
> > -       smp_ops.smp_send_reschedule(cpu);
> > +       /* smp_ops.smp_send_reschedule(cpu); */
> > }
> 
> Hm.  You're much braver than I am.

BTW, according to my testing, Peter's patch should make your box a lot
happier.  It won't make reschedule_interrupt crawl back under its rock,
but should improve your pipe-test numbers quite a bit.

Also note that pipe-test is really kinda silly cross core, it's really
good for measuring fastpath weight gain when pinned.  When scheduled
cross core (we do that to cut latency for stuff that does real work), it
will always suck rocks, as it's 100% synchronous, there's nada to gain
by occupying two cores.  (fortunately, real programs tend to do more
than play ping-pong with a microscopic ball;)

-Mike

