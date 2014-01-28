Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180AbaA1Ohh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 09:37:37 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:54116 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754574AbaA1Ohg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 09:37:36 -0500
Message-ID: <52E7BF6E.4000509@linux.vnet.ibm.com>
Date: Tue, 28 Jan 2014 20:02:14 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Tejun Heo <tj@kernel.org>,
        Michel Lespinasse <walken@google.com>, ego@linux.vnet.ibm.com,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        Thomas Gleixner <tglx@linutronix.de>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: Deadlock between cpu_hotplug_begin and cpu_add_remove_lock
References: <20140122055239.GA29418@iris.ozlabs.ibm.com> <52DF81B0.7020700@linux.vnet.ibm.com> <52DF8C59.1090702@linux.vnet.ibm.com> <20140122191820.GA32127@redhat.com> <52E022C8.4060902@linux.vnet.ibm.com> <20140123170242.GA8051@redhat.com>
In-Reply-To: <20140123170242.GA8051@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14012814-6102-0000-0000-000004D95531
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2014 10:32 PM, Oleg Nesterov wrote:
> On 01/23, Srivatsa S. Bhat wrote:
>>
>> On 01/23/2014 12:48 AM, Oleg Nesterov wrote:
>>> On 01/22, Srivatsa S. Bhat wrote:
>>>>
>>>> Wait a min, that _will_ actually work for all cases because I have provided
>>>> an option to invoke _any_ arbitrary function as the "setup" routine.
>>>
>>> And probably the generic solution makes sense. I am not sure I actually
>>> understand the semantics of register_allcpu_notifier(), but the problem
>>> it tries to solve looks clear/valid.
>>>
>>
>> Thank you. But I was wondering whether its usage is a bit unintuitive/
>> convoluted. So I was contemplating between going with that solution or the
>> below one, where the call-sites are expected to do:
>>
>> cpu_maps_update_begin();
>> for_each_online_cpu(cpu) {
>> 	...
>> }
>> __register_cpu_notifier(); //use the __reg() variant, which doesn't take locks
>> cpu_maps_update_done();
>>
>> Of course, that requires exporting the functions cpu_maps_update_begin/done(),
>> but this latter form of callback registration might look more natural.
> 
> Yes, I thought about this too ;)
> 
>> But for some of the other call-sites, we might have to use one
>> of the solutions mentioned above.
> 
> Yes, yes, sure, I agree.
> 
> I suggested this change only for discussion, for the case we need
> an "urgent" fix without changes outside of drivers/md/. The generic
> solution is better.
> 

Ok :) But your fix for drivers/md/ also makes the code look much neater.
So I'll include your patch in my series and convert the rest of the call-
sites using the generic solution.

Thank you!

Regards,
Srivatsa S. Bhat

