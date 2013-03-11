Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753491Ab3CKReL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 13:34:11 -0400
Received: from goliath.siemens.de ([192.35.17.28]:31158 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319Ab3CKReJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 13:34:09 -0400
Message-ID: <513E158B.80506@siemens.com>
Date: Mon, 11 Mar 2013 18:34:03 +0100
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
References: <513DAE8F.3050102@redhat.com> <20130311102852.GE31619@redhat.com> <513DBF45.9030803@redhat.com> <20130311115144.GG31619@redhat.com> <513DDCC2.9070807@redhat.com> <20130311135441.GN31619@redhat.com> <513DE3C4.5000503@siemens.com> <20130311140503.GO31619@redhat.com> <513DE8C5.3090209@redhat.com> <513DFA01.1040500@siemens.com> <20130311172342.GS31619@redhat.com>
In-Reply-To: <20130311172342.GS31619@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-03-11 18:23, Gleb Natapov wrote:
> On Mon, Mar 11, 2013 at 04:36:33PM +0100, Jan Kiszka wrote:
>> On 2013-03-11 15:23, Paolo Bonzini wrote:
>>> Il 11/03/2013 15:05, Gleb Natapov ha scritto:
>>>> On Mon, Mar 11, 2013 at 03:01:40PM +0100, Jan Kiszka wrote:
>>>>>> We are not moving away from mp_state, we are moving away from using
>>>>>> mp_state for signaling because with nested virt INIT does not always
>>>>>> change mp_state, not only that it can change mp_state long after signal
>>>>>> is received after vmx off is done.
>>>>>
>>>>> Right.
>>>>>
>>>>> BTW, for that to happen, we will also need to influence the INIT level.
>>>>> Unless I misread the spec, INIT is blocked while in root mode, and if
>>>>> you deassert INIT before leaving root (vmxoff, vmenter), nothing
>>>>> actually happens. So what matters is the INIT signal level at the exit
>>>>> of root mode.
>>>>>
>>>> You are talking about INIT# signal received via CPU pin, right? I think
>>>> INIT send by IPI cannot go away.
>>>
>>> Neither can go away.  For INIT sent by IPI, 10.4.7 says:
>>>
>>> Only the Pentium and P6 family processors support the INIT-deassert IPI.
>>> An INIT-disassert IPI has no affect on the state of the APIC, other than
>>> to reload the arbitration ID register with the value in the APIC ID
>>> register.
>>>
>>> 18.27.1 also says that "In the local APIC, NMI and INIT (except for INIT
>>> deassert) are always treated as edge triggered interrupts".
>>>
>>>
>>> For INIT#, the ICH9 chipset says that "INIT# is driven low for 16 PCI
>>> clocks" when a soft reset is requested.  So we can guess that INIT# is
>>> also edge-triggered.
>>
>> Ah, ok. So, virtually, INIT stays asserted until it can be delivered in
>> form of a reset or a vmexit.
>>
> vmexit clears it?

It has to. Otherwise, it would hit the host on vmxoff.

The spec says: "The INIT signal is blocked whenever a logical processor
is in VMX root operation. It is not blocked in VMX non-root operation.
Instead, INITs cause VM exits [...]."

Jan

-- 
Siemens AG, Corporate Technology, CT RTC ITP SDP-DE
Corporate Competence Center Embedded Linux
