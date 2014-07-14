Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117AbaGNMlV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 08:41:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8358 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754469AbaGNMlQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 08:41:16 -0400
Message-ID: <53C3CFC1.9070800@redhat.com>
Date: Mon, 14 Jul 2014 14:40:33 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: kan.liang@intel.com, andi@firstfloor.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH V5 1/2] perf ignore LBR and extra_regs
References: <1404989984-3068-1-git-send-email-kan.liang@intel.com> <53C3C517.4000500@redhat.com> <20140714120922.GV9918@twins.programming.kicks-ass.net>
In-Reply-To: <20140714120922.GV9918@twins.programming.kicks-ass.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 14/07/2014 14:09, Peter Zijlstra ha scritto:
> On Mon, Jul 14, 2014 at 01:55:03PM +0200, Paolo Bonzini wrote:
>> Il 10/07/2014 12:59, kan.liang@intel.com ha scritto:
>>> From: Kan Liang <kan.liang@intel.com>
>>>
>>> x86, perf: Protect LBR and extra_regs against KVM lying
>>>
>>> With -cpu host, KVM reports LBR and extra_regs support, if the host has support.
>>> When the guest perf driver tries to access LBR or extra_regs MSR,
>>> it #GPs all MSR accesses,since KVM doesn't handle LBR and extra_regs support.
>>> So check the related MSRs access right once at initialization time to avoid the error access at runtime.
>>>
>>> For reproducing the issue, please build the kernel with CONFIG_KVM_INTEL = y (for host kernel).
>>> And CONFIG_PARAVIRT = n and CONFIG_KVM_GUEST = n (for guest kernel).
>>
>> I'm not sure this is a useful patch.
>>
>> This is #GP'ing just because of a limitation in the PMU; just compile the
>> kernel with CONFIG_PARAVIRT
>
> How's that going to help? If you run kvm -host the VM is lying through
> its teeth is the kernel is going to assume all those MSRs present,
> PARAVIRT isn't going to help with this.
>
>> , or split the "rdmsr is always rdmsr_safe"
>> behavior out of CONFIG_PARAVIRT and into a new Kconfig symbol.
>
> That's not useful either, because non of these code-paths are going to
> check the return value.

Hmmm, I thought rdmsr_safe was going to return zero, but it just returns 
whatever happened to be in edx:eax which maybe should also be fixed.

Kan Liang, what happens if CONFIG_PARAVIRT=y?  Do you get garbage or 
just no events reported?

>> In fact there's no reason why LBR cannot be virtualized (though it does need
>> support from the processor), and it may even be possible to support
>> OFFCORE_RSP_X in the KVM virtual PMU.
>
> But its not, so something needs to be done, right?

A first thing that could be done, is to have a way for the kernel to 
detect absence of LBR, for example an all-1s setting of the LBR format 
field of IA32_PERF_CAPABILITIES.  If Intel can tell us "all 1s will 
never be used", we can have KVM set the field that way.  The kernel then 
should disable LBR.

Paolo
