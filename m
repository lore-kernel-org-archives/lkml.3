Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751Ab3CSMx6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 08:53:58 -0400
Received: from mail1.sysgo.com ([176.9.26.183]:38056 "EHLO mail1.sysgo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753862Ab3CSMx5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 08:53:57 -0400
Message-ID: <51485FE3.1020905@sysgo.com>
Date: Tue, 19 Mar 2013 13:53:55 +0100
From: David Engraf <david.engraf@sysgo.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ktime_add_ns() may overflow on 32bit architectures
References: <51485A43.4020600@sysgo.com> <1363696716.21184.45.camel@edumazet-glaptop>
In-Reply-To: <1363696716.21184.45.camel@edumazet-glaptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 19.03.2013 13:38, schrieb Eric Dumazet:
> On Tue, 2013-03-19 at 13:29 +0100, David Engraf wrote:
>> Hello,
>>
>> I've triggered an overflow when using ktime_add_ns() on a 32bit
>> architecture not supporting CONFIG_KTIME_SCALAR.
>>
>> When passing a very high value for u64 nsec, e.g. 7881299347898368000
>> the do_div() function converts this value to seconds (7881299347) which
>> is still to high to pass to the ktime_set() function as long. The result
>> in my case is a negative value.
>>
>> The problem on my system occurs in the tick-sched.c,
>> tick_nohz_stop_sched_tick() when time_delta is set to
>> timekeeping_max_deferment(). The check for time_delta < KTIME_MAX is
>> valid, thus ktime_add_ns() is called with a too large value resulting in
>> a negative expire value. This leads to an endless loop in the ticker code:
>>
>> time_delta: 7881299347898368000
>> expires = ktime_add_ns(last_update, time_delta)
>> expires: negative value
>>
>> This error doesn't occurs on 64bit or architectures supporting
>> CONFIG_KTIME_SCALAR (e.g. ARM, x86-32).
>>
>> Best regards
>> - David
>>
>> Signed-off-by: David Engraf <david.engraf@sysgo.com>
>>
>
> But check already exists for 64bit arches in ktime_set()
>

Yes, but not for 32bit arches. 64-bit arches doesn't run into this 
problem because ktime_add_ns() can directly calculate the result without 
calling do_div() and ktime_set().

