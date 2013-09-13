Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757491Ab3IMCro (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 22:47:44 -0400
Received: from mail1.windriver.com ([147.11.146.13]:52282 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244Ab3IMCrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 22:47:24 -0400
Message-ID: <52327C92.5010009@windriver.com>
Date: Fri, 13 Sep 2013 10:46:42 +0800
From: Fan Du <fan.du@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>, <tglx@linutronix.de>
CC: <herbert@gondor.hengli.com.au>, <steffen.klassert@secunet.com>,
        <dborkman@redhat.com>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCHv3 linux-next] hrtimer: Add notifier when clock_was_set
 was called
References: <alpine.DEB.2.02.1309121441420.4089@ionos.tec.linutronix.de>	<20130912134409.GB21212@gondor.apana.org.au>	<alpine.DEB.2.02.1309121636010.4089@ionos.tec.linutronix.de> <20130912.133252.425268707009916773.davem@davemloft.net>
In-Reply-To: <20130912.133252.425268707009916773.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [128.224.162.195]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave/Thomas

On 2013年09月13日 01:32, David Miller wrote:
> From: Thomas Gleixner<tglx@linutronix.de>
> Date: Thu, 12 Sep 2013 16:43:37 +0200 (CEST)
>
>> So what about going back to timer_list timers and simply utilize
>> register_pm_notifier(), which will tell you that the system resumed?
>
> The thing to understand is that there are two timeouts for an IPSEC
> rule, a soft and a hard timeout.
>
> There is a gap between these two exactly so that we can negotiate a
> new encapsulation with the IPSEC gateway before communication ceases
> to be possible over the IPSEC protected path.
>
> So the idea is that the soft timeout triggers the re-negotiation,
> and after a hard timeout the IPSEC path is no longer usable and
> all communication will fail.
>
> Simply triggering a re-negoation after every suspend/resume makes
> no sense at all.  Spurious re-negotiations are undesirable.
     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ (*a*)

What's the differences between this with re-negotiation after every
system wall clock changing by using clock_was_set notifier?


 > On 2013年08月02日 06:35, David Miller wrote:
 >
 > I suspect the thing to do is to have system time changes generate a
 > notifier when clock_was_set() is called.
 >
 > The XFRM code would walk the rules and pretend that we hit the soft
 > timeout for every rule that we haven't hit the soft timeout yet
 > already.
 >
 > If a rule hit the soft timeout, force a hard timeout.
 >
 > When forcing a soft timeout, adjust the hard timeout to be
 > (hard_timeout - soft_timeout) into the future.



> What we want are real timers.  We want that rather than a "we
> suspended so just assume all timers expired" event which is not very
> useful for this kind of application.
>

Here we are facing two problems:)

(1) what kind timer should xfrm_state should employ, Two requirements here:
     First one, KEY lifetime should include suspend/resume time. Second one,
     system wall clock time changing(backward/forward) should *not* impact
     *timer* timeout event(not the soft/hard IPsec events fired to user space!)

     net-next commit 99565a6c471cbb66caa68347c195133017559943 ("xfrm: Make
     xfrm_state timer monotonic") by utilizing *CLOCK_BOOTTIME* has solved this problem.

(2) What I have been bugging you around here for this long time is really the second
     problem, I'm sorry I didn't make it clearly to you and others, which is below:

     Why using wall clock time to calculate soft/hard IPsec events when xfrm_state timer
     out happens in its timeout handler? Because even if xfrm_state using CLOCK_BOOTTIME,
     system wall clock time changing will surely disturb soft/hard IPsec events, which
     you raised your concern about in (*a*).

     The initial approach( http://marc.info/?l=linux-netdev&m=137534280429187&w=2) has
     tried to solve this second problem by eliminating depending system wall clock in
     xfrm_state timer timeout handler.

I think this time, I have made this situation crystal clear.

-- 
浮沉随浪只记今朝笑

--fan
