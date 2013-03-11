Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668Ab3CKXve (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 19:51:34 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:43922 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754377Ab3CKXvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 19:51:33 -0400
Message-ID: <513E6E02.8030602@linaro.org>
Date: Mon, 11 Mar 2013 16:51:30 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: Greg KH <gregkh@linuxfoundation.org>,
        "toddpoynor@google.com" <toddpoynor@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] alarmtimer: add error prints when suspend failed
References: <1362684457-32570-1-git-send-email-ldewangan@nvidia.com> <20130307231640.GE4280@kroah.com> <51399243.6050007@nvidia.com>
In-Reply-To: <51399243.6050007@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/07/2013 11:24 PM, Laxman Dewangan wrote:
> On Friday 08 March 2013 04:46 AM, Greg KH wrote:
>> On Fri, Mar 08, 2013 at 12:57:37AM +0530, Laxman Dewangan wrote:
>>> The alramtimer suspend failed when nearest alarm wakeup time is
>>> less than 2 sec or rtc timer can not start.
>>>
>>> In suspend/resume stress testing, we found that sometimes alramtimer
>>> failed to suspend and hence it cancel the suspend ops. Add error prints
>>> in suspend failure to provide more info when failure occurs to help
>>> debugging.
>>>
>>> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
>>> ---
>>>   kernel/time/alarmtimer.c |    6 +++++-
>>>   1 files changed, 5 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
>>> index f11d83b..eed5646 100644
>>> --- a/kernel/time/alarmtimer.c
>>> +++ b/kernel/time/alarmtimer.c
>>> @@ -249,6 +249,8 @@ static int alarmtimer_suspend(struct device *dev)
>>>         if (ktime_to_ns(min) < 2 * NSEC_PER_SEC) {
>>>           __pm_wakeup_event(ws, 2 * MSEC_PER_SEC);
>>> +        dev_err(dev,
>>> +            "Nearest alarm wakeup time < 2sec, avoiding suspend\n");
>> What can userspace now do with this information?  How often is this now
>> going to spam the syslog and cause confusion?
>
>
> When we executed the stress on suspend/resume for system stability, 
> occasionally we get such error (3/4 times in 1000 cycle):
> [ 235.508010] dpm_run_callback(): platform_pm_suspend+0x0/0x64 returns 
> -16
> [ 235.514999] PM: Device alarmtimer failed to suspend: error -16
> [ 235.520958] PM: Some devices failed to suspend
>
>
> After tracing back the failure case, we found that possible reason 
> could be above one.
> In this case, if any function returns error then always better to 
> print the error so that it is easy to findout the cause of the error 
> and analyse.
>
> It should not generate spam as this does happen on some cases.

But if there is a recurring alarm timer that triggers every second, it 
will print out every time.

Greg's concern is that the error message is unhelpful, since it just 
will cause lots of log messages when the system is actually behaving as 
designed. That said, the PM suspend messages are fairly noisy as well, 
even when there are no errors.

Rafael: What are your thoughts here? If the alarmtimer subsystem blocks 
a suspend attempt (returning EBUSY, as a pending alarm will fire soon), 
how verbose should we be, since this isn't really an error case?

thanks
-john



