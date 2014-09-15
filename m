Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434AbaIOIwK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 04:52:10 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:50426 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753400AbaIOIwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 04:52:08 -0400
Message-ID: <5416A8B0.8040603@linux.vnet.ibm.com>
Date: Mon, 15 Sep 2014 14:22:00 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Michael Ellerman <mpe@ellerman.id.au>
CC: mikey@neuling.org, linux-pm@vger.kernel.org, rjw@rjwysocki.net,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] cpuidle/powernv: Enter fastsleep on checking if deep
 idle states are allowed
References: <20140912110131.7311.86417.stgit@preeti.in.ibm.com> <1410764352.32643.2.camel@concordia>
In-Reply-To: <1410764352.32643.2.camel@concordia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14091508-0928-0000-0000-000004D51533
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/15/2014 12:29 PM, Michael Ellerman wrote:
> On Fri, 2014-09-12 at 16:31 +0530, Preeti U Murthy wrote:
>> Today the procfs interface /proc/sys/kernel/powersave-nap is used to control
>> entry into deep idle states beyond snooze. Check for the value of this
>> parameter before entering fastsleep. We already do this check for nap in
>> power7_idle().
>>
>> Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
>> ---
>>
>>  drivers/cpuidle/cpuidle-powernv.c |    6 ++++++
>>  1 file changed, 6 insertions(+)
>>
>> diff --git a/drivers/cpuidle/cpuidle-powernv.c b/drivers/cpuidle/cpuidle-powernv.c
>> index a64be57..b8ba52e 100644
>> --- a/drivers/cpuidle/cpuidle-powernv.c
>> +++ b/drivers/cpuidle/cpuidle-powernv.c
>> @@ -69,6 +69,12 @@ static int fastsleep_loop(struct cpuidle_device *dev,
>>  	unsigned long old_lpcr = mfspr(SPRN_LPCR);
>>  	unsigned long new_lpcr;
>>  
>> +	/*
>> +	 * Verify if snooze is the only valid cpuidle state
>> +	 */
>> +	if (!(powersave_nap > 0))
>> +		return index;
>> +
>>  	if (unlikely(system_state < SYSTEM_RUNNING))
>>  		return index;
> 
> Doesn't the above mean we are just going to keep trying to go into fastsleep
> again and again? Or does the idle code work out that it didn't work based on
> the fact that we didn't sleep for the right period?

Thats right. The idle code figures that its judgment to enter fastsleep
was not correct and applies a correction factor to its future decisions
. This correction factor is intended to influence the cpuidle governor's
decision on choosing an idle state for the cpu based on the history of
wakeups. Hence a shallower idle state will be chosen here on in the
above circumstance.

> 
> We were talking about getting rid of powersave_nap altogether, but I think we
> decided we couldn't, I forget.

Isn't this a helpful knob to disable cpuidle at runtime? Currently we
check the value of powersave_nap before entering both nap and fastsleep.

Regards
Preeti U Murthy
> 
> cheers
> 
> 
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev
> 

