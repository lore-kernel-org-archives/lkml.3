Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007Ab3FKSOl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 14:14:41 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:33555 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753238Ab3FKSOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 14:14:39 -0400
Message-ID: <51B7690C.8090805@linaro.org>
Date: Tue, 11 Jun 2013 11:14:36 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Tomas Janousek <tjanouse@redhat.com>,
        Tomas Smetana <tsmetana@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] de_thread() should update ->real_start_time
References: <20130610183300.GA14379@redhat.com> <CANcMJZCr+Jr+J495MHX+1wnet_UtM6hSR+mgAGMma_YvLaxn4A@mail.gmail.com> <20130611171300.GA7920@redhat.com>
In-Reply-To: <20130611171300.GA7920@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2013 10:13 AM, Oleg Nesterov wrote:
> On 06/10, John Stultz wrote:
>
>>> simply change copy_process
>>>
>>>          -       do_posix_clock_monotonic_gettime(&p->start_time);
>>>          +       get_monotonic_boottime(&p->start_time);
>>>
>>> ?
>>>
>>> Afaics, this will only affect do_acct_process() and bacct_add_tsk(),
>>> but do we really want to exclude the suspended time in this case?
>> So bacct_add_tsk seems easy to change, since its just:
>>      do_posix_clock_monotonic_gettime(&uptime);
>>      ts = timespec_sub(uptime, tsk->start_time);
>>
>> So grabbing the monotonic boot time for uptime would provide the same
>> relative delta.
> Not really, or I misunderstood monotonic/boottime interaction.
>
> IIUC, monotonic doesn't grow during suspend, so the delta can grow if
> we use get_monotonic_boottime() in copy_process() and bacct_add_tsk()
> and the system was suspended in between. Right?

Oh right. Good point. The suspend time may not be constant between the 
calculations.


> But perhaps this is fine and even more correct?

Hrmm.. Looking closer at what the calculations are used for, I worry 
changing to counting suspend time in elapsed run time would be a 
userland visible behaivor change that might be problematic.

That said, elapsed run time as it exists now is not really a useful 
measurement, since you get different results depending on the situation: 
ie, a VM that doesn't get much cpu time vs a system that suspends 
frequently. In one case, you seem to have been running for a long time, 
but not getting much cpu runtime, where as the other you might appear to 
get quite a bit of the possible execution time.

This all goes back to issues around what suspend-state really is. Where 
in previously it was viewed to be user-controlled and considered closer 
to the system temporarily being off - thus the intent was to make 
suspend invisible/hidden to the system itself, but more recently, with 
systems suspending quite frequently suspend state is more 
invisible/hidden to the end user, and is closer to a deep idle state.

Back in the day folks were up in arms that someone could "cheat" their 
way to large uptime values by leaving their system suspended. But, if I 
could do it again, I'd probably push for CLOCK_MONOTONIC (as exported to 
userland) and all of these user-visible metrics to include suspend time.

So I think it probably *makes more sense* to include suspend_time in the 
elapsed runtime value being exported via bacct_add_tsk() and 
do_acct_process(), but I unfortunately worry now any such change would 
risk breaking userland expectations.

The *actual* risk may be quite minor, so this could be one of those: 
"Let the tree fall and if no one is there to hear it, fine" interface 
breaks, but I'm not sure I'm eager enough to be the one proposing it. :)

thanks
-john
