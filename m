Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756324AbaGQJDt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 05:03:49 -0400
Received: from mga03.intel.com ([143.182.124.21]:59708 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755610AbaGQJDp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 05:03:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,676,1400050800"; 
   d="scan'208";a="458053011"
From: "Zhang, Yang Z" <yang.z.zhang@intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
        Wanpeng Li <wanpeng.li@linux.intel.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Bandan Das <bsd@redhat.com>, "Hu, Robert" <robert.hu@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/3] KVM: nVMX: Fix virtual interrupt delivery injection
Thread-Topic: [PATCH 1/3] KVM: nVMX: Fix virtual interrupt delivery injection
Thread-Index: AQHPoZzbaM1BHfv4PUeQrhkbNLpMIpuj93Dw
Date: Thu, 17 Jul 2014 09:03:01 +0000
Message-ID: <A9667DDFB95DB7438FA9D7D576C3D87E0AB31D4A@SHSMSX104.ccr.corp.intel.com>
References: <1405573011-41330-1-git-send-email-wanpeng.li@linux.intel.com>
 <53C78F67.1060802@redhat.com>
In-Reply-To: <53C78F67.1060802@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paolo Bonzini wrote on 2014-07-17:
> Il 17/07/2014 06:56, Wanpeng Li ha scritto:
>> This patch fix bug reported in
>> https://bugzilla.kernel.org/show_bug.cgi?id=73331, after the patch
>> http://www.spinics.net/lists/kvm/msg105230.html applied, there is some
>> progress and the L2 can boot up, however, slowly. The original idea of
>> this fix vid injection patch is from "Zhang, Yang Z"
>> <yang.z.zhang@intel.com>.
>> 
>> Interrupt which delivered by vid should be injected to L1 by L0 if
>> current is in L1, or should be injected to L2 by L0 through the old
>> injection way if L1 doesn't have set VM_EXIT_ACK_INTR_ON_EXIT. The
>> current logic doen't consider these cases. This patch fix it by vid
>> intr to L1 if current is L1 or L2 through old injection way if L1
>> doen't have VM_EXIT_ACK_INTR_ON_EXIT set.
>> 
>> Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
>> Signed-off-by: "Zhang, Yang Z" <yang.z.zhang@intel.com>
>> ---
>>  arch/x86/kvm/vmx.c | 18 ++++++++++++++++--
>>  1 file changed, 16 insertions(+), 2 deletions(-)
>> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c index
>> 021d84a..ad36646 100644
>> --- a/arch/x86/kvm/vmx.c
>> +++ b/arch/x86/kvm/vmx.c
>> @@ -7112,8 +7112,22 @@ static void vmx_hwapic_irr_update(struct
>> kvm_vcpu *vcpu, int max_irr)  {
>>  	if (max_irr == -1)
>>  		return;
>> -
>> -	vmx_set_rvi(max_irr);
>> +	if (!is_guest_mode(vcpu)) {
>> +		vmx_set_rvi(max_irr);
>> +	} else if (is_guest_mode(vcpu) && !nested_exit_on_intr(vcpu)) {
>> +		/*
>> +		 * Fall back to old way to inject the interrupt since there
>> +		 * is no vAPIC-v for L2.
>> +		 */
>> +		if (vcpu->arch.exception.pending ||
>> +				vcpu->arch.nmi_injected ||
>> +				vcpu->arch.interrupt.pending)
>> +			return;
>> +		else if (vmx_interrupt_allowed(vcpu)) {
>> +			kvm_queue_interrupt(vcpu, max_irr, false);
>> +			vmx_inject_irq(vcpu);
>> +		}
>> +	}
>>  }
>>  
>>  static void vmx_load_eoi_exitmap(struct kvm_vcpu *vcpu, u64
>> *eoi_exit_bitmap)
>> 
> 
> What hypervisor did you test with? nested_exit_on_intr(vcpu) will

Jailhouse will clear External-interrupt exiting bit. Am I right? Jan.

> return true for both Xen and KVM (nested_exit_on_intr is not the same
> thing as ACK_INTR_ON_EXIT).

I guess he want to say External-interrupt exiting bit not ACK_INTR_ON_EXIT. 

> 
> Paolo


Best regards,
Yang


