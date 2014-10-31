Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758629AbaJaKgu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 06:36:50 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:51791 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758540AbaJaKgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 06:36:48 -0400
Message-ID: <5453663B.90500@redhat.com>
Date: Fri, 31 Oct 2014 11:36:43 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: "Chen, Tiejun" <tiejun.chen@intel.com>,
        Wanpeng Li <wanpeng.li@linux.intel.com>
CC: Gleb Natapov <gleb@kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Takashi Iwai <tiwai@suse.de>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: fix access memslots w/o hold srcu read lock
References: <1414730012-7278-1-git-send-email-wanpeng.li@linux.intel.com> <54531E7B.1040006@intel.com>
In-Reply-To: <54531E7B.1040006@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 31/10/2014 06:30, Chen, Tiejun wrote:
> 
> @@ -4442,6 +4442,7 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu)
>  {
>         struct vcpu_vmx *vmx = to_vmx(vcpu);
>         struct msr_data apic_base_msr;
> +       int idx;
> 
>         vmx->rmode.vm86_active = 0;
> 
> @@ -4509,7 +4510,9 @@ static void vmx_vcpu_reset(struct kvm_vcpu *vcpu)
>                 vmcs_write32(TPR_THRESHOLD, 0);
>         }
> 
> +       idx = srcu_read_lock(&vcpu->kvm->srcu);
>         kvm_vcpu_reload_apic_access_page(vcpu);
> +       srcu_read_unlock(&vcpu->kvm->srcu, idx);
> 
>         if (vmx_vm_has_apicv(vcpu->kvm))
>                 memset(&vmx->pi_desc, 0, sizeof(struct pi_desc));

Not enough; you can call vcpu_enter_guest -> kvm_apic_accept_events ->
kvm_vcpu_reset -> vmx_vcpu_reset while under the SRCU lock.  The right
place to add the lock is kvm_arch_vcpu_setup.

Thanks,

Paolo
