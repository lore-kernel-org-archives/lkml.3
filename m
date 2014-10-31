Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932358AbaJaLLE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 07:11:04 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:38576 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758160AbaJaLLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 07:11:02 -0400
Message-ID: <54536E31.3090207@gmail.com>
Date: Fri, 31 Oct 2014 19:10:41 +0800
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

Ah, ok, I will send a newer version tomorrow. ;-)

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

