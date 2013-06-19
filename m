Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672Ab3FSIbr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 04:31:47 -0400
Received: from na3sys009aog135.obsmtp.com ([74.125.149.84]:58035 "EHLO
	na3sys009aog135.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755576Ab3FSIbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 04:31:44 -0400
Message-ID: <51C16B97.3040304@marvell.com>
Date: Wed, 19 Jun 2013 16:28:07 +0800
From: Xiaoguang Chen <chenxg@marvell.com>
Organization: Marvell
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>
CC: "rjw@sisk.pl" <rjw@sisk.pl>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ning Jiang <njiang1@marvell.com>, Zhoujie Wu <zjwu@marvell.com>,
        Yilu Mao <ylmao@marvell.com>,
        "chenxg.marvell@gmail.com" <chenxg.marvell@gmail.com>
Subject: Re: [PATCH v9] Cpufreq: Fix governor start/stop race condition
References: <1371625207-26702-1-git-send-email-chenxg@marvell.com> <CAKohponDRcfHyRA-JCW01SC8R-dDiOx1dzBcOU6ag2DUa5_DyA@mail.gmail.com>
In-Reply-To: <CAKohponDRcfHyRA-JCW01SC8R-dDiOx1dzBcOU6ag2DUa5_DyA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2013 03:55 PM, Viresh Kumar wrote:
> On 19 June 2013 12:30, Xiaoguang Chen <chenxg@marvell.com> wrote:
>> Cpufreq governor's stop and start operation should be kept in sequence.
>> If not, there will be unexpected behavior, for example:
>>
>> There are 4 CPUs and policy->cpu=CPU0, CPU1/2/3 are linked to CPU0.
>> The normal sequence is as below:
>>
>> 1) Current governor is userspace, One application tries to set
>> governor to ondemand. It will call __cpufreq_set_policy in which it
>> will stop userspace governor and then start ondemand governor.
>>
>> 2) Current governor is userspace, Now CPU0 hotplugs in CPU3 (put CPU3 online),
>> It will call cpufreq_add_policy_cpu in which it first stops userspace
>> governor, and then starts userspace governor.
>>
>> Now if the sequence of above two cases interleaves, It becomes like below:
>>
>> 1) Application stops userspace governor
>> 2)                                      Hotplug stops userspace governor
>> 3) Application starts ondemand governor
>> 4)                                      Hotplug starts a governor
>>
>> In step 4, Hotplug is supposed to start userspace governor, But now
>> the governor has been changed by application to ondemand, So hotplug
>> starts ondemand governor again !!!!
>>
>> The solution is: Do not allow stop policy's governor multi-times.
>> Governor should only be stopped once for one policy, After it is stopped,
>> No other governor stop operation should be executed. also add one mutex to
>> protect __cpufreq_governor so governor operation can be kept in sequence.
>>
>> Signed-off-by: Xiaoguang Chen <chenxg@marvell.com>
>> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
>> ---
>>   drivers/cpufreq/cpufreq.c | 24 ++++++++++++++++++++++++
>>   include/linux/cpufreq.h   |  1 +
>>   2 files changed, 25 insertions(+)
> All good now. Sorry for the noise :)
Thank you for the professional instructions. It makes the code more 
beautiful. :)

-- 
Thanks
Xiaoguang

