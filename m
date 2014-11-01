Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760078AbaKACt7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 22:49:59 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:55049 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbaKACt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 22:49:57 -0400
Message-ID: <54544A45.1000505@gmail.com>
Date: Sat, 01 Nov 2014 10:49:41 +0800
From: Wanpeng Li <kernellwp@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>,
        "Chen, Tiejun" <tiejun.chen@intel.com>,
        Wanpeng Li <wanpeng.li@linux.intel.com>
CC: Gleb Natapov <gleb@kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Takashi Iwai <tiwai@suse.de>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: fix access memslots w/o hold srcu read lock
References: <1414730012-7278-1-git-send-email-wanpeng.li@linux.intel.com> <54531E7B.1040006@intel.com> <5453663B.90500@redhat.com>
In-Reply-To: <5453663B.90500@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paolo,
On 14/10/31 下午6:36, Paolo Bonzini wrote:
>
> On 31/10/2014 06:30, Chen, Tiejun wrote:
>> @@ -4442,6 +4442,7 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu)
>>   {
>>          struct vcpu_vmx *vmx = to_vmx(vcpu);
>>          struct msr_data apic_base_msr;
>> +       int idx;
>>
>>          vmx->rmode.vm86_active = 0;
>>
>> @@ -4509,7 +4510,9 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu)
>>                  vmcs_write32(TPR_THRESHOLD, 0);
>>          }
>>
>> +       idx = srcu_read_lock(&vcpu->kvm->srcu);
>>          kvm_vcpu_reload_apic_access_page(vcpu);
>> +       srcu_read_unlock(&vcpu->kvm->srcu, idx);
>>
>>          if (vmx_vm_has_apicv(vcpu->kvm))
>>                  memset(&vmx->pi_desc, 0, sizeof(struct pi_desc));
> Not enough; you can call vcpu_enter_guest -> kvm_apic_accept_events ->
> kvm_vcpu_reset -> vmx_vcpu_reset while under the SRCU lock.  The right
> place to add the lock is kvm_arch_vcpu_setup.

This is also not enough. I see the warning in the below path during the 
test:

kvm_arch_vcpu_ioctl_run
-> kvm_apic_accept_events
-> kvm_vcpu_reset

I just send out the version 3 and hope it can take care all the 
situations. ;-)

Regards,
Wanpeng Li

>
> Thanks,
>
> Paolo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

