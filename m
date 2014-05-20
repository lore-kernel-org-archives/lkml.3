Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626AbaETKjg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 06:39:36 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:49850 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbaETKjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 06:39:35 -0400
Message-ID: <537B309C.7000100@linux.vnet.ibm.com>
Date: Tue, 20 May 2014 16:08:20 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>,
        akpm@linux-foundation.org, fweisbec@gmail.com,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de, mingo@kernel.org,
        rusty@rustcorp.com.au, hch@infradead.org, mgorman@suse.de,
        riel@redhat.com, bp@suse.de, rostedt@goodmis.org, mgalbraith@suse.de,
        ego@linux.vnet.ibm.com, rjw@rjwysocki.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 UPDATEDv3 3/3] CPU hotplug, smp: Flush any pending
 IPI callbacks before CPU offline
References: <20140515191938.GB21306@htj.dyndns.org> <537514D3.4060308@linux.vnet.ibm.com> <20140515193656.GM4570@linux.vnet.ibm.com> <537518D6.6030006@linux.vnet.ibm.com> <5379F6BD.1090809@linux.vnet.ibm.com> <20140519161836.GA30387@redhat.com> <537A6060.7070406@linux.vnet.ibm.com> <537A6811.50808@linux.vnet.ibm.com> <20140520094203.GU2485@laptop.programming.kicks-ass.net> <537B29F7.6060104@linux.vnet.ibm.com> <20140520102542.GW2485@laptop.programming.kicks-ass.net> <537B2F09.5020306@linux.vnet.ibm.com>
In-Reply-To: <537B2F09.5020306@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14052010-1618-0000-0000-00000045121D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2014 04:01 PM, Srivatsa S. Bhat wrote:
> On 05/20/2014 03:55 PM, Peter Zijlstra wrote:
>> On Tue, May 20, 2014 at 03:39:59PM +0530, Srivatsa S. Bhat wrote:
>>>> The multi_cpu_stop() path isn't exclusive to hotplug, so your changelog
>>>> is wrong or the patch is.
>>>>
>>>
>>> Yes, I know that multi_cpu_stop() isn't exclusive to hotplug. That's why
>>> I have explicitly referred to CPU hotplug in the comment as well as the
>>> changelog.
>>>
>>> But I totally agree that code-wise this is not the best way to do it since
>>> this affects (although harmlessly) usecases other than hotplug as well.
>>>
>>> Do you have any other suggestions?
>>
>> How about making a kernel/smp.c hotplug notifier and stuffing it in the
>> CPU_DYING list? That's typically after we've already torn down the
>> interrupts for that cpu, so no chance of any new ones coming in.
>>
>> Or is that too late?
>>
> 
> No, that should work just fine. Thank you for the suggestion! I'll give
> it a shot.
> 

The only problem will be that CPU_DYING notifiers are run after marking
the CPU offline, and hence the warning will trigger. We can avoid that by
defining a __generic_smp_call_function_single_interrupt() that doesn't
check for cpu_online(smp_processor_id) and call this function from the
hotplug notifier.


Regards,
Srivatsa S. Bhat

