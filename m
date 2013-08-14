Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759503Ab3HNITg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 04:19:36 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:57020 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759459Ab3HNITd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 04:19:33 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohponD2LdDsJy=UJCf-1yANjyPjmAyokV5a4HOSJn_DMJVhA@mail.gmail.com>
References: <1376377766-2594-1-git-send-email-chenxg@marvell.com>
	<CAKohpo=QKPvqUcQVsbbSQdWOOi5L-P2CBFzcfMsobs8uGpLkVw@mail.gmail.com>
	<CAFgnuDes_F7Q5CHbXKC=ndrn9Gr3PJfGj0QvDXA-FuGcq41CHQ@mail.gmail.com>
	<CAKohponD2LdDsJy=UJCf-1yANjyPjmAyokV5a4HOSJn_DMJVhA@mail.gmail.com>
Date: Wed, 14 Aug 2013 16:19:31 +0800
Message-ID: <CAFgnuDetTVYayBABNPhME15b+b6qUtJX2hBaJ6y4+gOSgGFwdQ@mail.gmail.com>
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
> I am still not sure if I got what you are trying to say, sorry :(
>
> On 14 August 2013 13:06, Xiaoguang Chen <chenxg.marvell@gmail.com> wrote:
>> Please see below code in __cpufreq_governor function
>>
>> mutex_lock(&cpufreq_governor_lock);
>> if ((!policy->governor_enabled && (event == CPUFREQ_GOV_STOP)) ||
>>                             //////////// <1> Here one process A tries
>> to stop governor, it finds governor is enabled, so it will pass down.
>>    (policy->governor_enabled && (event == CPUFREQ_GOV_START))) {
>>                           /////////////<3> Process B tries to start
>> governor, it finds enable flag is false, so it can also pass down.
>
> Processes aren't allowed to call START/STOP in random manner. They
> must do a STOP first, if it succeeds do a START.
>
> So lets see it this way:
>
> Process A                            Process B
> STOP
>                                             STOP
>                                             START (If STOP passed)
> START (If STOP passed)
>
> So, Process B tries to STOP/START after governor is Stopped by A.
> Now call to STOP for process B will fail as we are already stopped..
>
> Can you explain with this example the problem you are trying to solve?

Yes, "START (If STOP passed)", this is important,  we don't have this
patch on our code base, So even Process B's STOP failed(as governor
enable flag is set to false by process A already ), it can still do
START operation, So my problem occurs.
My problem is that I see ondemand governor is started twice during
frequent governor switch and cpu hotplug stress test.

The After seeing your patch for the return value checking, I think my
problem should not occur.
This issue really botherred me for a long time. :(


Thanks
Xiaoguang
