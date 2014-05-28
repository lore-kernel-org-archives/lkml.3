Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753774AbaE1BGi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 21:06:38 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:22678 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543AbaE1BGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 21:06:37 -0400
Message-ID: <5385368E.2060507@huawei.com>
Date: Wed, 28 May 2014 09:06:22 +0800
From: Libo Chen <libo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Mike Galbraith <umgwanakikbuti@gmail.com>, <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, "Li Zefan" <lizefan@huawei.com>,
        <peterz@infradead.org>, Huang Qiang <h.huangqiang@huawei.com>
Subject: Re: balance storm
References: <5382AF2E.1040407@huawei.com>  <1401081082.5339.41.camel@marge.simpson.net> <538330B7.5070503@huawei.com>  <1401113960.23186.41.camel@marge.simpson.net> <53844510.1040502@huawei.com> <1401184553.5134.115.camel@marge.simpson.net> <53848A2C.5010209@huawei.com> <alpine.DEB.2.02.1405272245050.21720@ionos.tec.linutronix.de>
In-Reply-To: <alpine.DEB.2.02.1405272245050.21720@ionos.tec.linutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.22.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/5/28 4:53, Thomas Gleixner wrote:
> On Tue, 27 May 2014, Libo Chen wrote:
>> On 2014/5/27 17:55, Mike Galbraith wrote:
>>> On Tue, 2014-05-27 at 15:56 +0800, Libo Chen wrote: 
>>>>> On 2014/5/26 22:19, Mike Galbraith wrote:
>>>>>>> On Mon, 2014-05-26 at 20:16 +0800, Libo Chen wrote: 
>>>>>>>>> On 2014/5/26 13:11, Mike Galbraith wrote:
>>>>>>>
>>>>>>>>>>> Your synthetic test is the absolute worst case scenario.  There has to
>>>>>>>>>>> be work between wakeups for select_idle_sibling() to have any chance
>>>>>>>>>>> whatsoever of turning in a win.  At 0 work, it becomes 100% overhead.
>>>>>>>>>
>>>>>>>>> not synthetic, it is a real problem in our product. under no load, waste
>>>>>>>>> much cpu time.
>>>>>>>
>>>>>>> What happens in your product if you apply the commit I pointed out?
>>>>>
>>>>> under no load, cpu usage is up to 60%, but the same apps cost 10% on
>>>>> susp sp1.  The apps use a lot of timer.
>>> Something is rotten.  3.14-rt contains that commit, I ran your test with
>>> 256 threads on 64 core box, saw ~4%.
>>>
>>> Putting master/nopreempt config on box and doing the same test, box is
>>> chewing up truckloads of CPU, but not from migrations. 
>>>
>>> perf top -g --sort=symbol
>> in my box:
>>
>> perf top -g --sort=symbol
>>
>> Events: 3K cycles
>>  73.27%  [k] read_hpet
> 
> Why is that machine using read_hpet() ?
> 
> Please provide the output of 
> 
> # dmesg | grep -i tsc
> 

Euler:/home # dmesg  | grep -i tsc
[    0.000000] Fast TSC calibration using PIT
[    0.226921] TSC synchronization [CPU#0 -> CPU#1]:
[    0.227142] Measured 1053728 cycles TSC warp between CPUs, turning off TSC clock.
[    0.008000] Marking TSC unstable due to check_tsc_sync_source failed

> and
> 
> # cat /sys/devices/system/clocksource/clocksource0/available_clocksource

hpet acpi_pm

> 
> and
> 
> # cat /sys/devices/system/clocksource/clocksource0/current_clocksource

hpet

> 
> Thanks,
> 
> 	tglx
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> .
> 


