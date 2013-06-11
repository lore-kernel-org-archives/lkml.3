Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754235Ab3FKJ0n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 05:26:43 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:46075 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685Ab3FKJ0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 05:26:41 -0400
X-AuditID: 85900ec0-d24c6b900000151e-8e-51b6ed4e6570
Message-ID: <51B6ED3E.8050906@hitachi.com>
Date: Tue, 11 Jun 2013 18:26:22 +0900
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120604 Thunderbird/13.0
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        David Sharp <dhsharp@google.com>, Steven Rostedt <rostedt@goodmis.org>,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>, yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Re: Re: Re: [PATCH V2 1/1] kvm/vmx: Add a tracepoint write_tsc_offset
References: <20130604083619.22713.25360.stgit@yunodevel> <20130606002322.GA24351@amt.cnet> <20130606113305.GB4725@redhat.com> <51B16E0E.5020208@hitachi.com> <20130609111442.GP4725@redhat.com> <51B59CC2.3060707@hitachi.com> <20130610100505.GB4725@redhat.com> <20130610140424.GA25632@amt.cnet> <20130610163834.GG29022@redhat.com> <20130610202823.GC31409@amt.cnet> <20130611065037.GC4725@redhat.com>
In-Reply-To: <20130611065037.GC4725@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/06/11 15:50), Gleb Natapov wrote:
> On Mon, Jun 10, 2013 at 05:28:23PM -0300, Marcelo Tosatti wrote:
>> On Mon, Jun 10, 2013 at 07:38:34PM +0300, Gleb Natapov wrote:
>>>> Guest traces contain vcpu number and not pid (because guest is unaware
>>>> of host PID).
>>>>
>>> No, guest trace is just a regular ftrace done inside a guest. It contains
>>> guest's PIDs which is useless for host.
>>
>> # tracer: nop
>> #
>> # entries-in-buffer/entries-written: 5333/5333   #P:4
>> #
>> #                              _-----=> irqs-off
>> #                             / _----=> need-resched
>> #                            | / _---=> hardirq/softirq
>> #                            || / _--=> preempt-depth
>> #                            ||| /     delay
>> #           TASK-PID   CPU#  ||||    TIMESTAMP  FUNCTION
>> #              | |       |   ||||       |         |
>>
>> Traces contain CPU ID.
>>
> Doh, yes it does, but this is not vcpu_id. vcpu_id is seen as apic id in
> a guest, so additional step is needed to map between numbers that you see
> in the trace and vcpu_id. This is easy to do by looking at /proc/cpuinfo
> of a guest.
>
>>> I do not know how exactly guest traces are transfered to a host, if
>>> each vcpu buffer is transfered separately host can figure out what
>>> trace entry belong to which vcpu based on what buffer the trace is in.
>>> But the information about what buffer belongs to which vcpu id should
>>> be transfered to a host somehow too.
>>>
>>>>>>                                                  However, when we
>>>>>> focus on output data of the write_tsc_offset event, it is difficult to
>>>>>> directly understand contents of the data if vcpu number information is
>>>>>> not included. So, including the information is useful, I think.
>>>>>>
>>>>> How your tool does it now?
>>>>
>>>> It merges guest trace with host trace (by converting the TSC timestamp
>>>> in the guest trace to host TSC using tsc_offset information).
>>>>
>>> I mean how it does it now without vcpu id. The answer is that it works
>>> for only one vcpu now.
>>
>> Yes.
>>
>>>> By not recording vcpu ID in the tsc_offset trace, it is necessary to
>>>> supply the tool with PID<->VCPU_id tuples for translation (so its an
>>>> additional step required, and it makes trace merge impossible
>>>> if the information is not available).
>>> The tool needs PID<->VCPU_id tuples to do the merging of any trace
>>> entry. Without that it does not know how to interpret entry timestamps
>>> (which offset to use). Apparently it will get this information from
>>> vmentry trace point. What is so special about tsc_offset tracing that
>>> it needs to contain vcpuid by itself.
>>
>> If the tsc_offset tracepoint contains vcpu ID, its possible to lookup
>> guest trace entry (which contains CPU ID), and match on that.
>>
>> Without that, PID<->VCPU_id tuples are necessary. Yes?
> Ah, I think I see it now. For some reason I assumed that merge is done
> for each vcpu separately, so you need to separate host events per vcpu
> too, but this is not the case, host and guest event are merged based on
> tsc timestamp only. In this case I see the merits of having vcpu id in
> tsc_offset change trace point. It will make things easier a bit.

OK, I'll resend a patch including vcpu_id information.

Thanks,
Yoshihiro YUNOMAE

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com


