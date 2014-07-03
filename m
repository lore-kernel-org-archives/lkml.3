Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134AbaGCF3a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 01:29:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58953 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751633AbaGCF33 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 01:29:29 -0400
From: Bandan Das <bsd@redhat.com>
To: Wanpeng Li <wanpeng.li@linux.intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jan Kiszka <jan.kiszka@siemens.com>,
        Gleb Natapov <gleb@kernel.org>, Hu Robert <robert.hu@intel.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: Fix IRQs inject to L2 which belong to L1 since race
References: <1404284054-51863-1-git-send-email-wanpeng.li@linux.intel.com>
	<jpg7g3v7mk0.fsf@redhat.com> <20140703051142.GA2687@kernel>
Date: Thu, 03 Jul 2014 01:29:15 -0400
In-Reply-To: <20140703051142.GA2687@kernel> (Wanpeng Li's message of "Thu, 3
	Jul 2014 13:11:42 +0800")
Message-ID: <jpg61jf9fis.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wanpeng Li <wanpeng.li@linux.intel.com> writes:

> Hi Bandan,
> On Wed, Jul 02, 2014 at 12:27:59PM -0400, Bandan Das wrote:
>>Wanpeng Li <wanpeng.li@linux.intel.com> writes:
>>
>>> This patch fix bug https://bugzilla.kernel.org/show_bug.cgi?id=72381 
>>I can also reproduce this easily with Linux as L1 by "slowing it down"
>>eg. running with ept = 0
>>
>>I suggest changing the subject to -
>>KVM: nVMX: Fix race that incorrectly injects L1's irq to L2
>>
>
> Ok, I will fold this to next version. ;-)
>
>>> If we didn't inject a still-pending event to L1 since nested_run_pending,
>>> KVM_REQ_EVENT should be requested after the vmexit in order to inject the 
>>> event to L1. However, current log blindly request a KVM_REQ_EVENT even if 
>>
>>What's current "log" ? Do you mean current "code" ?
>>
>
> Yeah, it's a typo. I mean "logic".
>
> [...]
>>Also, I am wondering isn't it enough to just do this to avoid this race ?
>>
>> static int vmx_interrupt_allowed(struct kvm_vcpu *vcpu)
>> {
>>-       return (!to_vmx(vcpu)->nested.nested_run_pending &&
>>+       return (!is_guest_mode(vcpu) &&
>>+               !to_vmx(vcpu)->nested.nested_run_pending &&
>>                vmcs_readl(GUEST_RFLAGS) & X86_EFLAGS_IF) &&
>>                !(vmcs_read32(GUEST_INTERRUPTIBILITY_INFO) &
>>
>
> I don't think you fix the root cause of the race, and there are two cases which 
> I concern about your proposal:
>
> - If there is a special L1 which don't ask to exit on external intrs, you will 
>   lose the intrs which L0 inject to L2.  

Oh didn't think about that case :), thanks for the pointing this out.
It's easy to check this with Xen as L1, I suppose.

> - If inject_pending_event fail to inject an intr since the change that you made 
>   in vmx_interrupt_allowed, L0 will request an intr window for L2, however, the 
>   intr is belong to L1.
Oh, I thought inject_pending_event has kvm_queue_interrupt only if vmx_interrupt_allowed()
returns true so, interrupt will be injected correctly on the next vmexit.

Anyway, I am hitting another bug with your patch! Please see my other mail to the list.

Thanks!

> Regards,
> Wanpeng Li 
>
>>Thanks,
>>Bandan
