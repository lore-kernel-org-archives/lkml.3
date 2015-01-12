Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757137AbbALT0M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 14:26:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59354 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755536AbbALT0J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 14:26:09 -0500
Message-ID: <54B41FB1.2010406@redhat.com>
Date: Mon, 12 Jan 2015 14:25:37 -0500
From: William Cohen <wcohen@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>, Pratyush Anand <panand@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steve Capper <steve.capper@linaro.org>,
        David Long <dave.long@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: Query: ARM64: Behavior of el1_dbg exception while executing el0_dbg
References: <54AE830E.1090000@redhat.com> <20150108162312.GO11583@arm.com> <54AEBE45.9080203@redhat.com> <20150109154635.GG11258@arm.com> <54B00C39.1070809@redhat.com> <20150112173005.GK13360@arm.com>
In-Reply-To: <20150112173005.GK13360@arm.com>
Content-Type: multipart/mixed;
 boundary="------------010308000109090802000905"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010308000109090802000905
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

On 01/12/2015 12:30 PM, Will Deacon wrote:
> On Fri, Jan 09, 2015 at 05:13:29PM +0000, Pratyush Anand wrote:
>>
>>
>> On Friday 09 January 2015 09:16 PM, Will Deacon wrote:
>>> On Thu, Jan 08, 2015 at 05:28:37PM +0000, Pratyush Anand wrote:
>>>> On Thursday 08 January 2015 09:53 PM, Will Deacon wrote:
>>>>> On Thu, Jan 08, 2015 at 01:15:58PM +0000, Pratyush Anand wrote:
>>>>>> I am trying to test following scenario, which seems valid to me. But I
>>>>>> am very new to ARM64 as well as to debugging tools, so seeking expert's
>>>>>> comment here.
>>>>>>
>>>>>> -- I have inserted a kprobe to the function uprobe_breakpoint_handler
>>>>>> which is called from elo_dbg
>>>>>> (el0_dbg->do_debug_exception->brk_handler->call_break_hook->uprobe_breakpoint_handler)
>>>>>>
>>>>>> -- kprobe is enabled.
>>>>>>
>>>>>> -- an uprobe is inserted into a test application and enabled.
>>>>>>
>>>>>> So, when uprobe is enabled and test code execution reaches to probe
>>>>>> instruction, it executes uprobe breakpoint instruction and el0_dbg
>>>>>> exception is raised.
>>>>>>
>>>>>> When control reaches to start of uprobe_breakpoint_handler and it
>>>>>> executes first instruction (which has been replaced with a kprobe
>>>>>> breakpoint instruction), el1_dbg exception is raised.
>>>>>
>>>>> Hmm, debug exceptions should be masked at this point so I don't see why
>>>>> you're taking the second debug exception.
>>>>>
>>>>
>>>> So, you mean to say that when an exception which has been taken from
>>>> lower exception level (EL0) is being executed, then we keep masked also
>>>> the exception from current exception level (EL1)...
>>>
>>> Yeah, if you look at entry.S then you'll see that neither el0_dbg or el1_dbg
>>> re-enable debug exceptions (masked automatically by the CPU after taking the
>>> exception) until *after* the handling has completed. This is to prevent
>>> recursive debug exceptions, which I don't see how we can reasonable handle.
>>
>> May be I am missing something, but my observation on silicon is 
>> different. Please have a look at git log of HEAD of following branch, 
>> which says that el1_dbg exception has been raised while el0_dbg was 
>> executing. Do not know what I am missing..
>>
>> https://github.com/pratyushanand/linux/tree/ml_arm64_uprobe_devel_debug_kprobe_insertion_at_uprobe_breakpoint_handler
> 
> That page just says "Failed to load latest commit information." for me.

I got that message too, but I was able to see the history and the information in the first entry of:

https://github.com/pratyushanand/linux/commits/ml_arm64_uprobe_devel_debug_kprobe_insertion_at_uprobe_breakpoint_handler

> 
> Regardless, I think you need to debug further and found out if PSTATE.D is
> getting cleared and, if so, who is responsible for that. Somebody could be
> enabling IRQs, for example, which will then unmask debug exceptions in
> el1_irq.
> 
> Will
> 

If the problem is due to the irq being enabled and then an irq handler re-enabling the flag, it would be possible to use a systemtap script to monitor the irq_handler_entry and irq_handler_exit tracepoints to see if PSTATE.D is gettting cleared.  Maybe something like the attached script. This script isn't using the kprobe support, so should avoid the problematic interactions between kprobes and uprobes.

-Will Cohen

--------------010308000109090802000905
Content-Type: text/plain; charset=UTF-8;
 name="irq_pstated.stp"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="irq_pstated.stp"

global pstated

function masked_dflag:long(f) { return ((f & 1 << 9) != 0) }

probe irq_handler.entry {
  // Record if pstate.d is masked
  pstated[cpu(), irq] = masked_dflag(flags)
}

probe irq_handler.exit {
  if ((!masked_dflag(flags)) && pstated[cpu(), irq]) {
    printf("d flag unmasked in irq %d(%s)\n", irq, kernel_string(dev_name));
  }
  delete pstated[cpu(), irq]
}
--------------010308000109090802000905--
