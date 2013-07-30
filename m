Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751863Ab3G3MKn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 08:10:43 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:58952 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094Ab3G3MKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 08:10:40 -0400
X-AuditID: cbfec7f5-b7f376d000001ec6-93-51f7ad3e014f
Message-id: <51F7AD3C.8030407@samsung.com>
Date: Tue, 30 Jul 2013 16:10:36 +0400
From: Igor Zhbanov <i.zhbanov@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:18.0) Gecko/20100101 Firefox/18.0
 SeaMonkey/2.15
MIME-version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
Cc: Konstantin Krivyakin <k.krivyakin@samsung.com>,
        linux-kernel@vger.kernel.org, rjw@sisk.pl, viresh.kumar@linaro.org,
        mingo@redhat.com, kgene.kim@samsung.com, linux-pm@vger.kernel.org,
        e.voevodin@samsung.com, kyungmin.park@samsung.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH RFC 0/3] Per-process power consumption measurement facility
References: <1375172259-9641-1-git-send-email-k.krivyakin@samsung.com>
 <20130730085256.GK3008@twins.programming.kicks-ass.net>
In-reply-to: <20130730085256.GK3008@twins.programming.kicks-ass.net>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFLMWRmVeSWpSXmKPExsVy+t/xK7p2a78HGtxYw2YxZz2QWHuuncli
	6sLD7Ba9C66yWZxtesNucXnXHDaLz71HGC0uHVjAZHG89wCTRf/CXiaLjV89HLg9Nq/Q8rhz
	bQ+bx4kZv1k83u+7yubRt2UVo8ejxS2MHp83yQWwR3HZpKTmZJalFunbJXBl3Fv8jqngtVLF
	hxkN7A2Mk2S6GDk5JARMJJq3vGeFsMUkLtxbz9bFyMUhJLCUUeLY2efMEE4Xk8TH83+ZQKp4
	BbQkdjx6CNTBwcEioCpxdUcqSJgNKLz3+QpmEFtUIF5i8vTT7BDlghI/Jt9jAbFFBDQlVrbd
	B1vALNDLJLH90WKwhLCAv8SWefPA5gsJNDBKnN2ZA2JzCrhInJ+3mA3EZhawllg5aRsjhC0v
	sXnNW+YJjAKzkOyYhaRsFpKyBYzMqxhFU0uTC4qT0nON9IoTc4tL89L1kvNzNzFC4uPrDsal
	x6wOMQpwMCrx8HIUfwsUYk0sK67MPcQowcGsJMJ7fuL3QCHelMTKqtSi/Pii0pzU4kOMTByc
	Ug2MFlYJc0wXat3SWbr47dYCz++hF6WZ10l5XZux/9j5B+zz7Pdd+PyQPUk0/KC4R3nVrolT
	Dt7sm79PzP3X8dJLq87c4dOR29Z+9p7J047YW8cVGp1jci8kHuXQXd2eEfimJSDDSebUvoeb
	GBxU25Xvno2X3Bi7kLfqifKdy9LzpylFsRVFXLJ/p8RSnJFoqMVcVJwIAPzHybhtAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Peter,

Peter Zijlstra wrote:

> On Tue, Jul 30, 2013 at 12:17:36PM +0400, Konstantin Krivyakin wrote:
>> This patchset adds per-process power consumption measurement facility.
>> Power consumption is very important on mobile platforms. This code
>> allows to measure consumed power in Watts*Hours. The consumed power
>> for process is updated on scheduler switch and depends on current
>> CPU voltage and frequency.
>>
>> The formula for computation is: P = C * V^2 * f, where C is a constant
>> that reflects capacity of the system, V is the current voltage and
>> f is the current frequency.
>> (Taken from: http://en.wikipedia.org/wiki/CPU_power_dissipation).
>>
>> In this patchset was added implementation for Exynos platform
>> to demonstrate how it works.
>>
>> To minimize scheduler impact for each CPU P-state the value of (V^2 *f)
>> was precomputed at the time of platform initialization.
> It seems to me the 3 multiplies that takes could be done when cpufreq
> actually changes the P-state.
>> And to reduce performance impact furthermore, the C constant is multiplied
>> in userspace.
> That seems particularly silly; how is userspace to know C and why
> isn't it a much better idea to do this in the code generating the number
> for userspace to consume.
>
> Also, I intensely dislike this thing because:
>
>   - it adds more user interface
>   - it adds more accounting muck
>   - it completely lacks any useful changelogs
>   - it completely fails to even begin addressing the issues we already
>     have with cpufreq
>
> There's been a lot of talk about power aware scheduling in the recent
> past, there's also been a lot of problems listed we must overcome/solve.
> This patch set completely fails to tie into any of that.
>
> You also completely fail to explain the user case and thus related why
> you can't use any of the other facilities like perf or ftrace to measure
> this.

Our goal is to create new developer facility for power consumption measurement
of different components of mobile system such as CPU, GPU, modem, storage, etc.

This instrument should allow to correlate consumed power with applications' activity.
It should show what application or system componet consumes lots of power and why.
Then developers could optimize their applications to reduce power consumption.

The power consumption optimization is very critical for mobile platforms. And this
instrument should help developers to reduce consumed power of their applications.

This patch is a first piece of a power consumption framework. It is not related to
power aware scheduling. We want to get consumed power by CPU, GPU and other
devices accounted for user processes that performed corresponding activity.
As I know, any existing tools can't provide needed information or doing it
in not efficient way.

For example, it is possible to track scheduler switches and CPU frequency change
via trace events. But it clould be big number of events to handle (consider
CONFIG_HZ=1000 and 4 cores) just to track that at this timeslice a particaular
application consumed that amount of power. The PowerTOP utility does like that.
But we want to make it in a more efficient way. That's why we considered to modify
process accounting code.

It seems reasonable to us to calculate consumed power right where the power state
is changed -- in the kernel. For each power domain the kernel knows exact time when
the state was changed, the duration of the time and all characteristics of the state,
i.e. frequency and voltage.

In our "final" solution we think about power consumption counters for each power
domain (or device) that are orginized in a tree-like structure and state updates will
propage from leaves to roots. So for each operation (network IO, block IO, CPU and
GPU consuming) the corresponding user task will be accounted for real energy that
was spent by the system.

If you can suggest us some useful technique or existent approach, it would be very
helpful to implement our task in correct way and enhance current kernel functionality.

Thank you.

P.S. Since I'm not subscribed to LKML, please CC in reply.

-- 
Best regards,
Igor Zhbanov,
Sub-Project Leader,
phone: +7 (495) 797 25 00 ext 3981
e-mail: i.zhbanov@samsung.com

Mobile group, Moscow R&D center, Samsung Electronics
12 Dvintsev street, building 1
127018, Moscow, Russian Federation

