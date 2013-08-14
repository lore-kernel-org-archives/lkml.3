Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759417Ab3HNHgZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 03:36:25 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:35230 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757957Ab3HNHgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 03:36:23 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpo=QKPvqUcQVsbbSQdWOOi5L-P2CBFzcfMsobs8uGpLkVw@mail.gmail.com>
References: <1376377766-2594-1-git-send-email-chenxg@marvell.com>
	<CAKohpo=QKPvqUcQVsbbSQdWOOi5L-P2CBFzcfMsobs8uGpLkVw@mail.gmail.com>
Date: Wed, 14 Aug 2013 15:36:20 +0800
Message-ID: <CAFgnuDes_F7Q5CHbXKC=ndrn9Gr3PJfGj0QvDXA-FuGcq41CHQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] cpufreq: Add governor operation ongoing flag
From: Xiaoguang Chen <chenxg.marvell@gmail.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Xiaoguang Chen <chenxg@marvell.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/8/14 Viresh Kumar <viresh.kumar@linaro.org>:
> On 13 August 2013 12:39, Xiaoguang Chen <chenxg@marvell.com> wrote:
>> __cpufreq_governor operation needs to be executed one by one.
>> If one operation is ongoing, the other operation can't be executed.
>> If the order is not guaranteed, there may be unexpected behavior.
>
> What order??
I mean one stop operation is ongoing, one other process tries to call
a start operation.

>
>>  For example, governor is in enable state, and one process
>> tries to stop the goveror, but it is scheduled out before policy->
>> governor->governor() is executed, but the governor enable flag is
>> set to false already. Then one other process tries to start governor,
>> It finds enable flag is false, and it can process down to do governor
>> start operation, So the governor is started twice.
>
> That's not possible. A process will not and should not call START
> before calling STOP. And so the order of calling these routines must
> be forced.
>
> Hence, we may not need your patch.

Please see below code in __cpufreq_governor function

mutex_lock(&cpufreq_governor_lock);
if ((!policy->governor_enabled && (event == CPUFREQ_GOV_STOP)) ||
                            //////////// <1> Here one process A tries
to stop governor, it finds governor is enabled, so it will pass down.
   (policy->governor_enabled && (event == CPUFREQ_GOV_START))) {
                          /////////////<3> Process B tries to start
governor, it finds enable flag is false, so it can also pass down.
mutex_unlock(&cpufreq_governor_lock);
return -EBUSY;
}

if (event == CPUFREQ_GOV_STOP)
policy->governor_enabled = false;
                                                  //////////// < 2>
Here process A set flag to false and then process A is scheduled out
for some reasons(like interrupt or time slice end)
else if (event == CPUFREQ_GOV_START)
policy->governor_enabled = true;

mutex_unlock(&cpufreq_governor_lock);

ret = policy->governor->governor(policy, event);
                                           ///////////////<4>  Process
B executes the governor start operation, process A is not scheduled
back yet. as policy->governor->governor is not protected by


                the cpufreq_governor_lock, So this sequence can happen
really.









Thanks
Xiaoguang
