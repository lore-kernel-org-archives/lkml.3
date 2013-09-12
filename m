Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123Ab3ILTIi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 15:08:38 -0400
Received: from relay3.sgi.com ([192.48.152.1]:54305 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751662Ab3ILTIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 15:08:37 -0400
Message-ID: <52321131.7090908@sgi.com>
Date: Thu, 12 Sep 2013 12:08:33 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jason Wessel <jason.wessel@windriver.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dimitri Sivanich <sivanich@sgi.com>, Hedi Berriche <hedi@sgi.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 9/9] x86/UV: Add ability to disable UV NMI handler
References: <20130905225032.879120272@asylum.americas.sgi.com> <20130905225034.343366161@asylum.americas.sgi.com> <20130909124349.GY31370@twins.programming.kicks-ass.net> <522E0037.3090107@sgi.com> <20130910090349.GN26785@twins.programming.kicks-ass.net> <20130912172731.GR3966@linux.vnet.ibm.com> <20130912183541.GA11712@linux.vnet.ibm.com>
In-Reply-To: <20130912183541.GA11712@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 9/12/2013 11:35 AM, Paul E. McKenney wrote:
> On Thu, Sep 12, 2013 at 10:27:31AM -0700, Paul E. McKenney wrote:
>> On Tue, Sep 10, 2013 at 11:03:49AM +0200, Peter Zijlstra wrote:
>>> On Mon, Sep 09, 2013 at 10:07:03AM -0700, Mike Travis wrote:
>>>> On 9/9/2013 5:43 AM, Peter Zijlstra wrote:
>>>>> On Thu, Sep 05, 2013 at 05:50:41PM -0500, Mike Travis wrote:
>>>>>> For performance reasons, the NMI handler may be disabled to lessen the
>>>>>> performance impact caused by the multiple perf tools running concurently.
>>>>>> If the system nmi command is issued when the UV NMI handler is disabled,
>>>>>> the "Dazed and Confused" messages occur for all cpus.  The NMI handler is
>>>>>> disabled by setting the nmi disabled variable to '1'.  Setting it back to
>>>>>> '0' will re-enable the NMI handler.
>>>>>
>>>>> I'm not entirely sure why this is still needed now that you've moved all
>>>>> really expensive bits into the UNKNOWN handler.
>>>>>
>>>>
>>>> Yes, it could be considered optional.  My primary use was to isolate
>>>> new bugs I found to see if my NMI changes were causing them.  But it
>>>> appears that they are not since the problems occur with or without
>>>> using the NMI entry into KDB.  So it can be safely removed.
>>>
>>> OK, as a debug option it might make sense, but removing it is (of course)
>>> fine with me ;-)
>>>
>>>> (The basic problem is that if you hang out in KDB too long the machine
>>>> locks up.  
>>>
>>> Yeah, known issue. Not much you can do about it either I suspect. The
>>> system generally isn't build for things like that.
>>>
>>>> Other problems like the rcu stall detector does not have a
>>>> means to be "touched" like the nmi_watchdog_timer so it fires off a
>>>> few to many, many messages.  
>>>
>>> That however might be easily cured if you ask Paul nicely ;-)
>>
>> RCU's grace-period mechanism is supposed to be what touches it.  ;-)
>>
>> But what is it that you are looking for?  If you want to silence it
>> completely, the rcu_cpu_stall_suppress boot/sysfs parameter is what
>> you want to use.
>>
>>>> Another, any network connections will time
>>>> out if you are in KDB more than say 20 or 30 seconds.)
>>
>> Ah, you are looking for RCU to refrain from complaining about grace
>> periods that have been delayed by breakpoints in the kernel?  Is there
>> some way that RCU can learn that a breakpoint has happened?  If so,
>> this should not be hard.
> 
> But wait...  RCU relies on the jiffies counter for RCU CPU stall warnings.
> Doesn't the jiffies counter stop during breakpoints?
> 
> 							Thanx, Paul

All cpus entering the UV NMI event use local_irq_save (as does the
entry into KGDB/KDB).  So the question becomes more what happens
after all the cpus do the local_irq_restore?  The hardware clocks
are of course still running.

> 
>> If not, I must fall back on the rcu_cpu_stall_suppress that I mentioned
>> earlier.
>>
>>>> One other problem is with the perf tool.  It seems running more than
>>>> about 2 or 3 perf top instances on a medium (1k cpu threads) sized
>>>> system, they start behaving badly with a bunch of NMI stackdumps
>>>> appearing on the console.  Eventually the system become unusable.
>>>
>>> Yuck.. I haven't seen anything like that on the 'tiny' systems I have :/
>>
>> Indeed, with that definition of "medium", large must be truly impressive!
>>
>> 							Thanx, Paul
>>
>>>> On a large system (4k), the perf tools get an error message (sorry
>>>> don't have it handy at the moment) the basically implies that the
>>>> perf config option is not set.  Again, I wanted to remove the new
>>>> NMI handler to insure that it wasn't doing something weird, and
>>>> it wasn't.
>>>
>>> Cute.. 
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>>>
> 
