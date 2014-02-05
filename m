Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929AbaBEWCt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 17:02:49 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:44250 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787AbaBEWCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 17:02:47 -0500
Message-ID: <52F2B504.5010403@linaro.org>
Date: Wed, 05 Feb 2014 14:02:44 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>,
        Alexey Perevalov <a.perevalov@samsung.com>
CC: linux-kernel@vger.kernel.org, anton@enomsg.org, kyungmin.park@samsung.com,
        akpm@linux-foundation.org, cw00.choi@samsung.com
Subject: Re: [PATCH v2 0/3] Deferrable timers support for timerfd API
References: <1389609835-24377-1-git-send-email-a.perevalov@samsung.com> <52DEC6A3.9020600@linaro.org> <52E606D8.6000401@samsung.com> <alpine.DEB.2.02.1402041419420.24986@ionos.tec.linutronix.de> <52F1DDA8.90605@samsung.com> <alpine.DEB.2.02.1402051229260.24986@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1402051229260.24986@ionos.tec.linutronix.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2014 01:41 PM, Thomas Gleixner wrote:
> On Wed, 5 Feb 2014, Alexey Perevalov wrote:
>> On 02/04/2014 08:10 PM, Thomas Gleixner wrote:
>>> On Mon, 27 Jan 2014, Alexey Perevalov wrote:
>>>> On 01/21/2014 11:12 PM, John Stultz wrote:
>>>>> Thomas: Any thought here? Should we be trying to unify the timerfd flags
>>>>> and the posix timer flags (specifically things like TIMER_CANCEL_ON_SET,
>>>>> which is currently timerfd-only)?  Should a deferrable flag be added to
>>>>> the hrtimer core or left to the timer wheel?
>>> The timer cancel on set was added only to timerfd because timerfd is a
>>> non posix interface and we are halfways free to add stuff to
>>> it. Adding extra flags to the real posix timer interfaces is a
>>> different story.
>> And what about "deferrable" possibility for hrtimers, do you consider it
>> reasonable?
> In principle, I have no objections, but we need a proper technical
> solution. Just adding a flag and keeping the timers in the same rbtree
> like we do for the timer wheel timers is not going to happen.
>
> The only feasible solution is to have separate clock ids,
> e.g. CLOCK_*_DEFERRABLE, which would enable the deferrable
> functionality for all user space interfaces. No need for magic flags
> and complex search for non deferrable timers.

So of course, I was actually arguing against having a new clockid (which
was Alexey's first approach).

My reasoning was that the deferrablity isn't a clock domain, and is more
of a modifier. Thus to keep the interfaces somewhat sane (and avoiding
having to add N new clockids for each new modifier), we should utilize
the flag arguments to timers. So instead of just having TIMER_ABSTIME,
we could add TIMER_DEFER, etc, which we could utilize instead.

Internally we can still keep separate bases, much as your patch does, to
keep the next-event searching overhead more limited.

I mainly wanted to get your thoughts on extending the flags, and doing
so in a consistent manner between the timerfd and other timer interfaces.

Of course, all this is after I added the _ALARM clockids... so you can
decide if its hypocrisy or experience.
(The "old wisdom comes from experience and experience comes from bad
decisions" bit ;).

thanks
-john










