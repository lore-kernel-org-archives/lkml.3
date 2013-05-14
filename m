Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609Ab3ENHyR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 03:54:17 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:58584 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594Ab3ENHyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 03:54:16 -0400
Message-ID: <5191ECF7.7040502@linux.vnet.ibm.com>
Date: Tue, 14 May 2013 13:21:19 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: =?UTF-8?B?QmrDuHJuIE1vcms=?= <bjorn@mork.no>
CC: paulmck@linux.vnet.ibm.com, Dipankar Sarma <dipankar@in.ibm.com>,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [v3.10-rc1] WARNING: at kernel/rcutree.c:502
References: <87ip2opntp.fsf@nemi.mork.no> <20130512113905.GH3648@linux.vnet.ibm.com>	<87li7kp50r.fsf@nemi.mork.no> <20130512172135.GJ3648@linux.vnet.ibm.com>	<87a9o0ukll.fsf@nemi.mork.no> <87sj1rydol.fsf@nemi.mork.no>	<87wqr3j656.fsf@nemi.mork.no> <519169BF.4080208@linux.vnet.ibm.com> <87ppwuroxb.fsf@nemi.mork.no> <5191EBEF.4060409@linux.vnet.ibm.com>
In-Reply-To: <5191EBEF.4060409@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13051407-9574-0000-0000-000007DBE8E6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2013 01:16 PM, Srivatsa S. Bhat wrote:
> On 05/14/2013 01:08 PM, Bjørn Mork wrote:
>> "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com> writes:
>>> On 05/13/2013 08:09 PM, Bjørn Mork wrote:
>>>
>>>> Hey, hey, hey.  Turns out this wasn't that wrong after all.  That merge
>>>> includes a oneline diff in kernel/cpu/idle.c and it *is* actually this
>>>> diff which trigger the problem for me.  Reverting it, using the attached
>>>> patch, makes the warning go away.  Which means that it had nothing to do
>>>> with your RCU changes.
>>>>
>>>> But I haven't the faintest idea how this is supposed to work, or even
>>>> how to explain the patch properly, so I think I need some help from
>>>> Thomas here.  Unless this makes you understand the real issue?
>>>>
>>>> Thomas, why does powertop trigger the
>>>>
>>>>   WARNING: at kernel/rcutree.c:502 rcu_eqs_exit_common.isra.48+0x3d/0x125()
>>>>
>>>> without the attached patch?  And what is the proper resolution?
>>>>
>>>  
>>> The problem appears to be in the cpu idle poll implementation. You can trigger
>>> this problem by passing idle=poll in the kernel cmd-line as well, right?
>>
>> That sounded so obvious that it made me think "Doh, why didn't I just
>> test that before?"  But unfortunately there must be some other factor
>> involved. No warnings observed during normal use when running with
>> idle=poll:
>>
> 
> I didn't expect warnings with normal use.
> 
>>  bjorn@nemi:~$ dmesg|grep polling
>>  [    0.000000] process: using polling idle threads
>>
>>
>> I expected a flood of warnings here, but there is none until I start
>> powertop (to confirm that the original issue is still there).  So it's
>> more than just entering cpu_idle_poll().
>>
> 
> Yeah, of course it is :-) The warning triggers only when you enable the tracepoint
> in the idle code. And in your case, powertop does that. That's why it only
> triggers when you run powertop. Alternatively, if you enable the tracepoint
> yourself manually, I bet you'll see the warnings, even without using powertop.
>  

IOW, what I wanted to confirm with you was my theory that this problem has got
nothing to do with the tick_check_broadcast_expired() check. That check only increases
the probability of entering the buggy polling code during normal use (since nobody
uses idle=poll in the kernel cmdline usually). That's why I requested you to try
running powertop by using idle=poll, to rule out the tick_check_broadcast_expired()
check from the equation.

But now that you confirmed it, everything fits perfectly! Thanks a lot!

Regards,
Srivatsa S. Bhat

