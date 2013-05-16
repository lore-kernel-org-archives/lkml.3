Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028Ab3EPSZA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 14:25:00 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:39980 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482Ab3EPSY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 14:24:59 -0400
Message-ID: <5195242A.4040007@oracle.com>
Date: Thu, 16 May 2013 14:23:38 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130429 Thunderbird/17.0.5
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
CC: "Liu, Chuansheng" <chuansheng.liu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Wu, Fengguang" <fengguang.wu@intel.com>,
        "eag0628@gmail.com" <eag0628@gmail.com>, Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        John Stultz <johnstul@us.ibm.com>
Subject: Re: WARNING: at kernel/smp.c:385 smp_call_function_many
References: <5170602E.3050206@oracle.com> <27240C0AC20F114CBF8149A2696CBE4AC1B56C@SHSMSX101.ccr.corp.intel.com> <51708FE5.6000301@oracle.com>
In-Reply-To: <51708FE5.6000301@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2013 08:29 PM, Sasha Levin wrote:
> Hi Liu,
> 
> On 04/18/2013 08:10 PM, Liu, Chuansheng wrote:
>>> It seems that with commit "smp: Give WARN()ing when calling
>>>> smp_call_function_many()/single() in serving irq" I'm getting a bunch of these:
>> This patch gives the warning even when the smp_call_function_many() is called in softirq context,
>> because it will bring the possible deadlock cases, the example is below:
>> CPUA                            CPUB
>>                                 spin_lock(&spinlock)
>>                                 Any irq coming, call the irq handler
>>                                 irq_exit()
>> spin_lock_irq(&spinlock)
>> <== Blocking here due to
>> CPUB hold it
>>                                   __do_softirq()
>>                                     run_timer_softirq()
>>                                       timer_cb()
>>                                         call smp_call_function_many()
>>                                           send IPI interrupt to CPUA
>>                                             wait_csd()
>>
>> Then both CPUA and CPUB will be deadlocked here.
> 
> Right.
> 
> So commit f55a6faa3 ("hrtimer: Provide clock_was_set_delayed()") followed by one
> of the commits that used clock_was_set_delayed() may trigger the deadlock you've
> described. (cc John Stultz...)

Ping?


Thanks,
Sasha

