Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585AbaKBHLO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 02:11:14 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:50513 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264AbaKBHLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 02:11:12 -0500
Message-ID: <5455D903.3080801@gmail.com>
Date: Sun, 02 Nov 2014 15:10:59 +0800
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
References: <1414730012-7278-1-git-send-email-wanpeng.li@linux.intel.com> <54531E7B.1040006@intel.com> <5453663B.90500@redhat.com> <54544A45.1000505@gmail.com> <5455D435.5050405@redhat.com>
In-Reply-To: <5455D435.5050405@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paolo,
On 14/11/2 下午2:50, Paolo Bonzini wrote:
>
> On 01/11/2014 03:49, Wanpeng Li wrote:
>> This is also not enough. I see the warning in the below path during the
>> test:
>>
>> kvm_arch_vcpu_ioctl_run
>> -> kvm_apic_accept_events
>> -> kvm_vcpu_reset
> Hmm, better bypass the problem altogether:
>
> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> index a0f78dbaabee..3e556c68351b 100644
> --- a/arch/x86/kvm/vmx.c
> +++ b/arch/x86/kvm/vmx.c
> @@ -4579,7 +4579,7 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu)
>   		vmcs_write32(TPR_THRESHOLD, 0);
>   	}
>   
> -	kvm_vcpu_reload_apic_access_page(vcpu);
> +	kvm_make_request(KVM_REQ_APIC_PAGE_RELOAD, vcpu);
>   
>   	if (vmx_vm_has_apicv(vcpu->kvm))
>   		memset(&vmx->pi_desc, 0, sizeof(struct pi_desc));
>

Great idea and it works. Just send out version 4 of the patch. ;-)

Regards,
Wanpeng Li

> (untested)
>
> Paolo

