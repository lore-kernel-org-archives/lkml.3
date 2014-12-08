Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005AbaLHF3s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 00:29:48 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:48628 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751007AbaLHF3q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 00:29:46 -0500
Message-ID: <5485373B.302@linux.vnet.ibm.com>
Date: Mon, 08 Dec 2014 10:59:31 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jingchang.lu@freescale.com" <jingchang.lu@freescale.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH] tick-broadcast: Register for hrtimer based broadcast
 as the default broadcast mode
References: <20141205124756.25803.4988.stgit@preeti.in.ibm.com> <20141205133908.GA21313@leverpostej>
In-Reply-To: <20141205133908.GA21313@leverpostej>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120805-0033-0000-0000-000001412B31
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2014 07:09 PM, Mark Rutland wrote:
> Hi Preeti,
> 
> Moving this out of the architecture code looks good to me!
> 
> I have a couple of minor comments below.
<snip>

>>  
>> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
>> index ec1791f..6044a51 100644
>> --- a/kernel/time/timekeeping.c
>> +++ b/kernel/time/timekeeping.c
>> @@ -1016,6 +1016,10 @@ void __init timekeeping_init(void)
>>  		boot.tv_sec = 0;
>>  		boot.tv_nsec = 0;
>>  	}
>> +	/* Register for hrtimer based broadcast as the default timekeeping
>> +	 * mode in deep idle states.
>> +	 */
> 
> Nit: for code style this should have a newline after the '/*' (and we
> should probably have a newline before that anyway.
> 
>> +	tick_setup_hrtimer_broadcast();
> 
> We register the generic dummy timer via an early_initcall, which keeps
> all the logic in the dummy timer driver. Are we able to do the same of
> the broadcast hrtimer? Or is there some ordering constraint we need to
> meet?

Yes this is doable. There are no ordering constraints. Placing it in an
early_initcall() will enable it to run before initializing SMP and
cpuidle, which is perfect (we do not have any per-cpu initializations
and we do not want cpus to begin entering idle states before this
hrtimer is initialized).

It also runs after the hrtimer/clockevents infrastructure has been
initialized, which is good since we need them. The broadcast hrtimer
will thus only get registered as a broadcast device if no other clock
device has managed to register itself as one.

Let me send out a V2.

Thanks

Regards
Preeti U Murthy

