Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382Ab3AaI6B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 03:58:01 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:36767 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248Ab3AaI56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 03:57:58 -0500
Message-ID: <510A320D.8010301@linux.vnet.ibm.com>
Date: Thu, 31 Jan 2013 16:57:49 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Namhyung Kim <namhyung@kernel.org>
CC: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        tglx@linutronix.de
Subject: Re: [RFC 2/2] sched/fair: prefer a CPU in the "lowest" idle state
References: <1359580757-4121-1-git-send-email-bigeasy@linutronix.de> <1359580757-4121-3-git-send-email-bigeasy@linutronix.de> <5109D313.1020409@linux.vnet.ibm.com>	<8738xiue31.fsf@sejong.aot.lge.com> <510A1198.2070803@linux.vnet.ibm.com>	<87txpxu9cx.fsf@sejong.aot.lge.com> <510A1D7A.3050408@linux.vnet.ibm.com> <87pq0lu7ew.fsf@sejong.aot.lge.com> <510A2A50.1090207@linux.vnet.ibm.com> <510A2F42.5050007@linux.vnet.ibm.com>
In-Reply-To: <510A2F42.5050007@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13013108-1396-0000-0000-0000027CA8EC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2013 04:45 PM, Michael Wang wrote:
> On 01/31/2013 04:24 PM, Michael Wang wrote:
>> On 01/31/2013 03:40 PM, Namhyung Kim wrote:
>>> On Thu, 31 Jan 2013 15:30:02 +0800, Michael Wang wrote:
>>>> On 01/31/2013 02:58 PM, Namhyung Kim wrote:
>>>>> But AFAIK the number of states in cpuidle is usually less than 10 so maybe
>>>>> we can change the weight then, but there's no promise...
>>>>
>>>> And I just got another case we should take care:
>>>>
>>>> 	group 0		cpu 0			cpu 1
>>>> 			power index 8		power index 8
>>>>
>>>>
>>>> 	group 1		cpu 2			cpu 3
>>>> 			power index 0		load 15
>>>>
>>>> so load of group 0 is 16 and group 1 is 15, but group 0 is better...
>>>
>>> Maybe it's not.  The cpus in group 0 are in a lower power state so that
>>> there will be a benefit to select cpu 2 from the power' PoV IMHO.  Also
>>> such a low power state has a longer exit latency so that we should
>>> choose cpu2 to get a better performance and it's the basic idea of this
>>> patchset I believe.
>>
>> Well, this case is just to notify that, we may face the comparison
>> between load and index, not between index and index, I just doubt there
>> won't be a rule which could take care both, besides, comparison between
>> load and index is strange...
> 
> Oh, I miss the point that you call it 'idle load', hmm...may be it could
> works, if we could scale the current load number, then we will have more
> 'space' for 'idle load'.

And some tips here:

/*      
 * Increase resolution of nice-level calculations for 64-bit architectures.
 * The extra resolution improves shares distribution and load balancing of
 * low-weight task groups (eg. nice +19 on an autogroup), deeper taskgroup
 * hierarchies, especially on larger systems. This is not a user-visible change
 * and does not change the user-interface for setting shares/weights.
 *      
 * We increase resolution only if we have enough bits to allow this increased
 * resolution (i.e. BITS_PER_LONG > 32). The costs for increasing resolution
 * when BITS_PER_LONG <= 32 are pretty high and the returns do not justify the
 * increased costs.
 */
#if 0 /* BITS_PER_LONG > 32 -- currently broken: it increases power usage under light load  */
# define SCHED_LOAD_RESOLUTION  10
# define scale_load(w)          ((w) << SCHED_LOAD_RESOLUTION)
# define scale_load_down(w)     ((w) >> SCHED_LOAD_RESOLUTION)

It mentioned some regressions, that's the history but
sounds like a lot of testing is needed.

Regards,
Michael Wang

> 
> Regards,
> Michael Wang
> 
>>
>> Regards,
>> Michael Wang
>>
>>>
>>> Thanks,
>>> Namhyung
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>>>
>>
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

