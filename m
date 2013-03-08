Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933796Ab3CHH0f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 02:26:35 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:5466 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522Ab3CHH0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 02:26:34 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 07 Mar 2013 23:26:30 -0800
Message-ID: <51399243.6050007@nvidia.com>
Date: Fri, 8 Mar 2013 12:54:51 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "toddpoynor@google.com" <toddpoynor@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] alarmtimer: add error prints when suspend failed
References: <1362684457-32570-1-git-send-email-ldewangan@nvidia.com> <20130307231640.GE4280@kroah.com>
In-Reply-To: <20130307231640.GE4280@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 08 March 2013 04:46 AM, Greg KH wrote:
> On Fri, Mar 08, 2013 at 12:57:37AM +0530, Laxman Dewangan wrote:
>> The alramtimer suspend failed when nearest alarm wakeup time is
>> less than 2 sec or rtc timer can not start.
>>
>> In suspend/resume stress testing, we found that sometimes alramtimer
>> failed to suspend and hence it cancel the suspend ops. Add error prints
>> in suspend failure to provide more info when failure occurs to help
>> debugging.
>>
>> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
>> ---
>>   kernel/time/alarmtimer.c |    6 +++++-
>>   1 files changed, 5 insertions(+), 1 deletions(-)
>>
>> diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
>> index f11d83b..eed5646 100644
>> --- a/kernel/time/alarmtimer.c
>> +++ b/kernel/time/alarmtimer.c
>> @@ -249,6 +249,8 @@ static int alarmtimer_suspend(struct device *dev)
>>   
>>   	if (ktime_to_ns(min) < 2 * NSEC_PER_SEC) {
>>   		__pm_wakeup_event(ws, 2 * MSEC_PER_SEC);
>> +		dev_err(dev,
>> +			"Nearest alarm wakeup time < 2sec, avoiding suspend\n");
> What can userspace now do with this information?  How often is this now
> going to spam the syslog and cause confusion?


When we executed the stress on suspend/resume for system stability, 
occasionally we get such error (3/4 times in 1000 cycle):
[ 235.508010] dpm_run_callback(): platform_pm_suspend+0x0/0x64 returns -16
[ 235.514999] PM: Device alarmtimer failed to suspend: error -16
[ 235.520958] PM: Some devices failed to suspend


After tracing back the failure case, we found that possible reason could 
be above one.
In this case, if any function returns error then always better to print 
the error so that it is easy to findout the cause of the error and analyse.

It should not generate spam as this does happen on some cases.


