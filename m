Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239AbaLJNV4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 08:21:56 -0500
Received: from mail-ig0-f174.google.com ([209.85.213.174]:54564 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927AbaLJNVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 08:21:53 -0500
MIME-Version: 1.0
Reply-To: cw00.choi@samsung.com
In-Reply-To: <1418206046.16644.26.camel@AMDC1943>
References: <1418134386-14681-1-git-send-email-cw00.choi@samsung.com>
	<1418206046.16644.26.camel@AMDC1943>
Date: Wed, 10 Dec 2014 22:21:52 +0900
Message-ID: <CAGTfZH3DoSCTTgW-6o3na_mO2-scrV1JftpdTM5u3w=EunLfaA@mail.gmail.com>
Subject: Re: [RFC PATCHv2 0/7] devfreq: Add devfreq-event class to provide raw
 data for devfreq device
From: Chanwoo Choi <cwchoi00@gmail.com>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, rafael.j.wysocki@intel.com,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        devicetree <devicetree@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Krzysztof,

On Wed, Dec 10, 2014 at 7:07 PM, Krzysztof Kozlowski
<k.kozlowski@samsung.com> wrote:
> On wto, 2014-12-09 at 23:12 +0900, Chanwoo Choi wrote:
>> This patchset add new devfreq_event class to provide raw data to determine
>> current utilization of device  which is used for devfreq governor.
>>
>> [Description of devfreq-event class]
>> This patchset add new devfreq_event class for devfreq_event device which provide
>> raw data (e.g., memory bus utilization/GPU utilization). This raw data from
>> devfreq_event data would be used for the governor of devfreq subsystem.
>> - devfreq_event device : Provide raw data for governor of existing devfreq device
>> - devfreq device       : Monitor device state and change frequency/voltage of device
>>                          using the raw data from devfreq_event device
>>
>> The devfreq subsystem support generic DVFS(Dynamic Voltage/Frequency Scaling)
>> for Non-CPU Devices. The devfreq device would dertermine current device state
>> using various governor (e.g., ondemand, performance, powersave). After completed
>> determination of system state, devfreq device would change the frequency/voltage
>> of devfreq device according to the result of governor.
>>
>> But, devfreq governor must need basic data which indicates current device state.
>> Existing devfreq subsystem only consider devfreq device which check current system
>> state and determine proper system state using basic data. There is no subsystem
>> for device providing basic data to devfreq device.
>>
>> The devfreq subsystem must need devfreq_event device(data-provider device) for
>> existing devfreq device. So, this patch add new devfreq_event class for
>> devfreq_event device which read various basic data(e.g, memory bus utilization,
>> GPU utilization) and provide measured data to existing devfreq device through
>> standard APIs of devfreq_event class.
>>
>> The following description explains the feature of two kind of devfreq class:
>> - devfreq class (existing)
>>  : devfreq consumer device use raw data from devfreq_event device for
>>    determining proper current system state and change voltage/frequency
>>    dynamically using various governors.
>> - devfreq_event class (new)
>>  : Provide measured raw data to devfreq device for governor
>>
>> Also, the devfreq-event device would support various type event as following:
>>  : DEVFREQ_EVENT_TYPE_RAW_DATA
>>  : DEVFREQ_EVENT_TYPE_UTILIZATION
>>  : DEVFREQ_EVENT_TYPE_BANDWIDTH
>>  : DEVFREQ_EVENT_TYPE_LATENCY
>>
>> [For example]
>> If board dts includes PPMU_DMC0/DMC1/CPU event node,
>> would show following sysfs entry. Also devfreq driver(e.g., exynos4_bus.c)
>> can get the instance of devfreq-event device by using provided API and then
>> get raw data which reflect the current state of device.
>>
>
> Hi,
>
> Overall I like the idea. I understand that now devfreq devices (like
> exynos devfreq) should bind themselves to buses, not to PPMU. It makes
> sense to me because bus clock and bus voltage are properties of bus, not
> monitoring unit.
>
> I see that this is still a RFC so it would be hard to base current
> devfreq work on top of it.

The goal of this patch set is not for devfreq device. This patch set
just is used for
devfreq-event device according to patch description.

The devfreq must need devfreq-event device (e.g., exynos-ppmu.c)
but current devfreq subsystem have not been supported any reason for
exyons-ppmu.c as devfreq-event device.

I discussed this same issue on following patch[1] which was posted to support
exynos4 busfreq by me.
[1] https://lkml.org/lkml/2014/3/14/132
- [PATCHv2 8/8] devfreq: exynos4: Add busfreq driver for exynos4210/exynos4x12
After discussion, I thought that devfreq-event class must be needed
before supporting
the dt of devfreq device.

So, I think that devfreq have to support the devfreq-event subsystem
for exynos-ppmu. And then I'll work to support the device-tree of devfreq device
as next job.

>
> One more general comment: you're adding a some API which is not used by
> current devfreq_event user (exynos). For example the exclusive flag or
> event types. I think it will be simpler to stick to the basic approach
> (reduced API). If some other user emerges then new API will be added.

I think that devfreq-event must support both event_flag(e.g., exclusive flag)
and event_type(e.g., raw_data, utilization, bandwidth, latency) because
devfreq-event device (e.g., exynos-ppmu) would provide various event data.
For example, exynos-ppmu driver could support the utilization/bandwidth/latency
of each IP of Exynos SoC. I checked PPMU IP on Exynos TRM.

Also, If specific devfreq-event device should be used on only one device driver,
devfrewq-event class have to support 'exclusive' flag. If
devfreq-event class don't
support the exclusive flag, devfreq-event could not guarantee the
integrity of event
from devfreq-event device.

Thanks for your comment.

Best Regards,
Chanwoo Choi
