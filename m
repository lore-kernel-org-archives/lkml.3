Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967724Ab3DSAeG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 20:34:06 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:32546 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967617Ab3DSAeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 20:34:04 -0400
Message-ID: <51708FE5.6000301@oracle.com>
Date: Thu, 18 Apr 2013 20:29:25 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130408 Thunderbird/17.0.5
MIME-Version: 1.0
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        "Wu, Fengguang" <fengguang.wu@intel.com>,
        "eag0628@gmail.com" <eag0628@gmail.com>, Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        John Stultz <johnstul@us.ibm.com>
Subject: Re: WARNING: at kernel/smp.c:385 smp_call_function_many
References: <5170602E.3050206@oracle.com> <27240C0AC20F114CBF8149A2696CBE4AC1B56C@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <27240C0AC20F114CBF8149A2696CBE4AC1B56C@SHSMSX101.ccr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Liu,

On 04/18/2013 08:10 PM, Liu, Chuansheng wrote:
>> It seems that with commit "smp: Give WARN()ing when calling
>> > smp_call_function_many()/single() in serving irq" I'm getting a bunch of these:
> This patch gives the warning even when the smp_call_function_many() is called in softirq context,
> because it will bring the possible deadlock cases, the example is below:
> CPUA                            CPUB
>                                 spin_lock(&spinlock)
>                                 Any irq coming, call the irq handler
>                                 irq_exit()
> spin_lock_irq(&spinlock)
> <== Blocking here due to
> CPUB hold it
>                                   __do_softirq()
>                                     run_timer_softirq()
>                                       timer_cb()
>                                         call smp_call_function_many()
>                                           send IPI interrupt to CPUA
>                                             wait_csd()
> 
> Then both CPUA and CPUB will be deadlocked here.

Right.

So commit f55a6faa3 ("hrtimer: Provide clock_was_set_delayed()") followed by one
of the commits that used clock_was_set_delayed() may trigger the deadlock you've
described. (cc John Stultz...)


Thanks,
Sasha
