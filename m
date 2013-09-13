Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791Ab3IMRGI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 13:06:08 -0400
Received: from mail.openrapids.net ([64.15.138.104]:46062 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751624Ab3IMRGH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 13:06:07 -0400
Message-ID: <523345EC.8070206@efficios.com>
Date: Fri, 13 Sep 2013 10:05:48 -0700
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        John Stultz <john.stultz@linaro.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, lttng-dev@lists.lttng.org
Subject: Re: [RFC PATCH] Introduce timekeeper latch synchronization
References: <20130913025253.GA17218@Krystal> <alpine.DEB.2.02.1309131803360.4089@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1309131803360.4089@ionos.tec.linutronix.de>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/09/13 09:13 AM, Thomas Gleixner wrote:
> On Thu, 12 Sep 2013, Mathieu Desnoyers wrote:
>> * Peter Zijlstra (peterz@infradead.org) wrote:
>> [...]
>>> Yep, that's good. I suppose if there's multiple use sites we can jump
>>> through another few hoops to get rid of the specific struct foo
>>> assumptions by storing sizeof() whatever we do use and playing pointer
>>> math games.
>>>
>>> But for now with the time stuff as only user this looks ok.
>> OK! Here is the full implementation of the idea against Linux
>> timekeeper, ntp, and PPS. It appears that ntp and PPS were relying on
>> the timekeeper seqlock too. And guess what, after booting my laptop with
>> this kernel there still no smoke coming out of it after a good 5 minutes
>> of testing. ;-)
>>
>> Comments are welcome.
> First of all this needs to be split into several patches.
How about:
- three patches refactoring data structures into objects (no
synchronization changes whatsoever). timekeeper, ntp and pps each done
in separate patches,
- one patch to introduce the new synchronization scheme along with the
usage site changes. This patch would include the removal of the
shadow_timekeeper variable, which is made pointless by the introduction
of this mixed-rcu-seqcount synchronization scheme.

is that enough, or you see a more fine-grained breakdown ?


>
>>  static void update_wall_time(void)
>  ...
>> -	write_seqcount_begin(&timekeeper_seq);
>>  	/* Update clock->cycle_last with the new value */
>>  	clock->cycle_last = tk->cycle_last;
>> -	/*
>> -	 * Update the real timekeeper.
>> -	 *
>> -	 * We could avoid this memcpy by switching pointers, but that
>> -	 * requires changes to all other timekeeper usage sites as
>> -	 * well, i.e. move the timekeeper pointer getter into the
>> -	 * spinlocked/seqcount protected sections. And we trade this
>> -	 * memcpy under the timekeeper_seq against one before we start
>> -	 * updating.
>> -	 */
>> -	memcpy(real_tk, tk, sizeof(*tk));
>> -	timekeeping_update(real_tk, action);
> So you're dropping the timekeeping_update() call here. I wonder how
> this works.

It doesn't :-)

There appears to be a couple of side-effects related to removal of the
call to timekeeping_update(). On the positive side, I now have much more
free time on my hands. However, people seem to complain that I arrive
late to meetings for some reasons ;-)

>
>> +	timekeeper_write_begin(&latch_timekeeper, &prev, &tk);
>> +	*tk = *prev;
> Do we really need to do the copy on all call sites, instead of doing
> it in timekeeper_write_begin() ?

Since we're indeed doing the copy on all call sites, I think it would be
good to move it into timekeeper_write_begin() as you suggest.

Initially, I kept the copy in the caller in case we could do without the
copy in some cases (in case the caller would overwrite the entire
structure without caring about prior content). But since we need to copy
timekeeper, ntp and pps structures, I doubt this is realistic. So let's
move this copy into timekeeper_write_begin().

Thanks !

Mathieu


>
> Thanks,
>
> 	tglx

