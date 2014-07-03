Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932219AbaGCHeN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 03:34:13 -0400
Received: from goliath.siemens.de ([192.35.17.28]:42922 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755819AbaGCHeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 03:34:09 -0400
Message-ID: <53B50760.3040708@siemens.com>
Date: Thu, 03 Jul 2014 09:33:52 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Bandan Das <bsd@redhat.com>, Wanpeng Li <wanpeng.li@linux.intel.com>
CC: Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Hu Robert <robert.hu@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: Fix IRQs inject to L2 which belong to L1 since
 race
References: <1404284054-51863-1-git-send-email-wanpeng.li@linux.intel.com>	<jpg7g3v7mk0.fsf@redhat.com> <20140703051142.GA2687@kernel> <jpg61jf9fis.fsf@redhat.com>
In-Reply-To: <jpg61jf9fis.fsf@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-07-03 07:29, Bandan Das wrote:
> Wanpeng Li <wanpeng.li@linux.intel.com> writes:
> 
>> Hi Bandan,
>> On Wed, Jul 02, 2014 at 12:27:59PM -0400, Bandan Das wrote:
>>> Wanpeng Li <wanpeng.li@linux.intel.com> writes:
>>>
>>>> This patch fix bug https://bugzilla.kernel.org/show_bug.cgi?id=72381 
>>> I can also reproduce this easily with Linux as L1 by "slowing it down"
>>> eg. running with ept = 0
>>>
>>> I suggest changing the subject to -
>>> KVM: nVMX: Fix race that incorrectly injects L1's irq to L2
>>>
>>
>> Ok, I will fold this to next version. ;-)
>>
>>>> If we didn't inject a still-pending event to L1 since nested_run_pending,
>>>> KVM_REQ_EVENT should be requested after the vmexit in order to inject the 
>>>> event to L1. However, current log blindly request a KVM_REQ_EVENT even if 
>>>
>>> What's current "log" ? Do you mean current "code" ?
>>>
>>
>> Yeah, it's a typo. I mean "logic".
>>
>> [...]
>>> Also, I am wondering isn't it enough to just do this to avoid this race ?
>>>
>>> static int vmx_interrupt_allowed(struct kvm_vcpu *vcpu)
>>> {
>>> -       return (!to_vmx(vcpu)->nested.nested_run_pending &&
>>> +       return (!is_guest_mode(vcpu) &&
>>> +               !to_vmx(vcpu)->nested.nested_run_pending &&
>>>                vmcs_readl(GUEST_RFLAGS) & X86_EFLAGS_IF) &&
>>>                !(vmcs_read32(GUEST_INTERRUPTIBILITY_INFO) &
>>>
>>
>> I don't think you fix the root cause of the race, and there are two cases which 
>> I concern about your proposal:
>>
>> - If there is a special L1 which don't ask to exit on external intrs, you will 
>>   lose the intrs which L0 inject to L2.  
> 
> Oh didn't think about that case :), thanks for the pointing this out.
> It's easy to check this with Xen as L1, I suppose.

Xen most probably intercepts external interrupts, but Jailhouse
definitely does not. We also have a unit test for that, but I will
likely not expose the issue of lost events.

Jan

-- 
Siemens AG, Corporate Technology, CT RTC ITP SES-DE
Corporate Competence Center Embedded Linux
