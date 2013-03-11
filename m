Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247Ab3CKSrO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 14:47:14 -0400
Received: from david.siemens.de ([192.35.17.14]:23490 "EHLO david.siemens.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752686Ab3CKSrN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 14:47:13 -0400
Message-ID: <513E26A7.4020405@siemens.com>
Date: Mon, 11 Mar 2013 19:47:03 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Paolo Bonzini <pbonzini@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>
Subject: Re: [PATCH] x86: kvm: reset the bootstrap processor when it gets
 an INIT
References: <513DE3C4.5000503@siemens.com> <20130311140503.GO31619@redhat.com> <513DE8C5.3090209@redhat.com> <513DFA01.1040500@siemens.com> <20130311172342.GS31619@redhat.com> <513E158B.80506@siemens.com> <20130311174155.GU31619@redhat.com> <513E1CFC.6010201@siemens.com> <20130311181306.GW31619@redhat.com> <513E2220.2090501@siemens.com> <20130311183915.GA14689@redhat.com>
In-Reply-To: <20130311183915.GA14689@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-03-11 19:39, Gleb Natapov wrote:
> On Mon, Mar 11, 2013 at 07:27:44PM +0100, Jan Kiszka wrote:
>> On 2013-03-11 19:13, Gleb Natapov wrote:
>>> On Mon, Mar 11, 2013 at 07:05:48PM +0100, Jan Kiszka wrote:
>>>> On 2013-03-11 18:41, Gleb Natapov wrote:
>>>>> On Mon, Mar 11, 2013 at 06:34:03PM +0100, Jan Kiszka wrote:
>>>>>> On 2013-03-11 18:23, Gleb Natapov wrote:
>>>>>>> On Mon, Mar 11, 2013 at 04:36:33PM +0100, Jan Kiszka wrote:
>>>>>>>> On 2013-03-11 15:23, Paolo Bonzini wrote:
>>>>>>>>> Il 11/03/2013 15:05, Gleb Natapov ha scritto:
>>>>>>>>>> On Mon, Mar 11, 2013 at 03:01:40PM +0100, Jan Kiszka wrote:
>>>>>>>>>>>> We are not moving away from mp_state, we are moving away from using
>>>>>>>>>>>> mp_state for signaling because with nested virt INIT does not always
>>>>>>>>>>>> change mp_state, not only that it can change mp_state long after signal
>>>>>>>>>>>> is received after vmx off is done.
>>>>>>>>>>>
>>>>>>>>>>> Right.
>>>>>>>>>>>
>>>>>>>>>>> BTW, for that to happen, we will also need to influence the INIT level.
>>>>>>>>>>> Unless I misread the spec, INIT is blocked while in root mode, and if
>>>>>>>>>>> you deassert INIT before leaving root (vmxoff, vmenter), nothing
>>>>>>>>>>> actually happens. So what matters is the INIT signal level at the exit
>>>>>>>>>>> of root mode.
>>>>>>>>>>>
>>>>>>>>>> You are talking about INIT# signal received via CPU pin, right? I think
>>>>>>>>>> INIT send by IPI cannot go away.
>>>>>>>>>
>>>>>>>>> Neither can go away.  For INIT sent by IPI, 10.4.7 says:
>>>>>>>>>
>>>>>>>>> Only the Pentium and P6 family processors support the INIT-deassert IPI.
>>>>>>>>> An INIT-disassert IPI has no affect on the state of the APIC, other than
>>>>>>>>> to reload the arbitration ID register with the value in the APIC ID
>>>>>>>>> register.
>>>>>>>>>
>>>>>>>>> 18.27.1 also says that "In the local APIC, NMI and INIT (except for INIT
>>>>>>>>> deassert) are always treated as edge triggered interrupts".
>>>>>>>>>
>>>>>>>>>
>>>>>>>>> For INIT#, the ICH9 chipset says that "INIT# is driven low for 16 PCI
>>>>>>>>> clocks" when a soft reset is requested.  So we can guess that INIT# is
>>>>>>>>> also edge-triggered.
>>>>>>>>
>>>>>>>> Ah, ok. So, virtually, INIT stays asserted until it can be delivered in
>>>>>>>> form of a reset or a vmexit.
>>>>>>>>
>>>>>>> vmexit clears it?
>>>>>>
>>>>>> It has to. Otherwise, it would hit the host on vmxoff.
>>>>>>
>>>>> Why do you thing this is not happening?
>>>>>
>>>>> Look at [1] page 10 "VMX and INIT blocking". Do you think they were
>>>>> lucky to hit CPU while it was in a root mode?
>>>>>
>>>>> [1] http://www.invisiblethingslab.com/resources/2011/Software%20Attacks%20on%20Intel%20VT-d.pdf
>>>>
>>>> Interesting. And confusing. If a VMM cannot "consume" INIT events by
>>>> reentering the guest nor postpone those events up to that point if they
>>>> arrived in root mode, the whole vmexit-on-INIT thing is practically
>>>> useless. I wonder what use case Intel had in mind while designing this.
>>>>
>>> I actually find it very useful. On INIT vmexit hypervisor may call
>>> vmxoff and do proper reset. I find it less useful on AMD where you need
>>> to send self INIT IPI, but then how you can send self SIPI?
>>
>> Where's the difference? On Intel, SIPI is also not deliverable until
>> after vmxoff. So that signal has to come from the INIT sender, just like
>> on AMD.
>>
> On Intel:
> CPU 1                          CPU 2 in a guest mode
> send INIT
> send SIPI
>                                 INIT vmexit
>                                 vmxoff
>                                 reset and start from SIPI vector

Is SIPI sticky as well, even if the CPU is not in the wait-for-SIPI
state (but runnable and in vmxon) while receiving it?

> 
> 
> On AMD;
> CPU 1                           CPU 2 in a guest mode
> send INIT
> send SIPI
>                                 INIT vmexit
>                                 self INIT IPI
>                                 ???
> 
> 
>> However, AMD allows you to NOT do a reset after leaving virtualization
>> mode. On Intel, INIT is obviously irreversible, thus of limited use.
>>
> Why would hypervisor send INIT to one of its CPUs if it does not want to
> reset it? :)

First of all, to trigger a vmexit. What will happen with this event
should be the hand of the hypervisor - ideally.

Jan

-- 
Siemens AG, Corporate Technology, CT RTC ITP SDP-DE
Corporate Competence Center Embedded Linux
