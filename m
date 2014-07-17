Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756490AbaGQKA0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 06:00:26 -0400
Received: from mga01.intel.com ([192.55.52.88]:17399 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755423AbaGQKAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 06:00:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208,223";a="362432644"
Date: Thu, 17 Jul 2014 18:01:30 +0800
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: "Zhang, Yang Z" <yang.z.zhang@intel.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Gleb Natapov <gleb@kernel.org>, Bandan Das <bsd@redhat.com>,
        "Hu, Robert" <robert.hu@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] KVM: nVMX: Fix fail to get nested ack intr's vector
 during nested vmexit
Message-ID: <20140717100130.GA9118@kernel>
Reply-To: Wanpeng Li <wanpeng.li@linux.intel.com>
References: <1405573011-41330-1-git-send-email-wanpeng.li@linux.intel.com>
 <1405573011-41330-2-git-send-email-wanpeng.li@linux.intel.com>
 <53C78E37.5090807@redhat.com>
 <A9667DDFB95DB7438FA9D7D576C3D87E0AB31D9E@SHSMSX104.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="AqsLC8rIMeq19msA"
Content-Disposition: inline
In-Reply-To: <A9667DDFB95DB7438FA9D7D576C3D87E0AB31D9E@SHSMSX104.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AqsLC8rIMeq19msA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 17, 2014 at 09:13:56AM +0000, Zhang, Yang Z wrote:
>Paolo Bonzini wrote on 2014-07-17:
>> Il 17/07/2014 06:56, Wanpeng Li ha scritto:
>>>  	    && nested_exit_intr_ack_set(vcpu)) {
>>>  		int irq = kvm_cpu_get_interrupt(vcpu);
>>> +
>>> +		if (irq < 0 && kvm_apic_vid_enabled(vcpu->kvm))
>>> +			irq = kvm_get_apic_interrupt(vcpu);
>> 
>> There's something weird in this patch.  If you "inline"
>> kvm_cpu_get_interrupt, what you get is this:
>> 
>>          int irq;
>> 	/* Beginning of kvm_cpu_get_interrupt... */
>>          if (!irqchip_in_kernel(v->kvm))
>>                  irq = v->arch.interrupt.nr;
>> 	else {
>> 	        irq = kvm_cpu_get_extint(v); /* PIC */
>> 	        if (!kvm_apic_vid_enabled(v->kvm) && irq == -1)
>> 			irq = kvm_get_apic_interrupt(v); /* APIC */
>> 	}
>> 
>> 	/* kvm_cpu_get_interrupt done. */
>> 	if (irq < 0 && kvm_apic_vid_enabled(vcpu->kvm))
>> 		irq = kvm_get_apic_interrupt(vcpu);
>> 
>> There are just two callers of kvm_cpu_get_interrupt, and the other is
>> protected by kvm_cpu_has_injectable_intr so it won't be executed if
>> virtual interrupt delivery is enabled.  So you patch is effectively the same as this:
>> 
>> diff --git a/arch/x86/kvm/irq.c b/arch/x86/kvm/irq.c index
>> bd0da43..a1ec6a5 100644 --- a/arch/x86/kvm/irq.c +++
>> b/arch/x86/kvm/irq.c @@ -108,7 +108,7 @@ int
>> kvm_cpu_get_interrupt(struct kvm_vcpu *v)
>> 
>>   	vector = kvm_cpu_get_extint(v);
>> -	if (kvm_apic_vid_enabled(v->kvm) || vector != -1)
>> +	if (vector != -1)
>>   		return vector;			/* PIC */
>>   
>>   	return kvm_get_apic_interrupt(v);	/* APIC */
>> But in kvm_get_apic_interrupt I have just added this comment:
>> 
>>          /* Note that we never get here with APIC virtualization
>> 	 * enabled.  */
>> 
>> because kvm_get_apic_interrupt calls apic_set_isr, and apic_set_isr
>> must never be called with APIC virtualization enabled either.  With
>> APIC virtualization enabled, isr_count is always 1, and
>> highest_isr_cache is always -1, and apic_set_isr breaks both of these invariants.
>> 
>
>You are right. kvm_lapic_find_highest_irr should be the right one.

That is my original proposal solution of this bug. However, what I concern 
after more think is since kvm_lapic_find_highest_irr will not clear
irr, if the intr will be injected by kvm_86_ops->hwapic_irr_update(vcpu, 
kvm_lapic_find_highest_irr(vcpu)) which called by vcpu_enter_guest() again? 

Any idea, Paolo?

Regards,
Wanpeng Li 

>
>> Paolo
>
>
>Best regards,
>Yang
>

--AqsLC8rIMeq19msA
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-fix-warning.patch"

>From b14c444e073a21560961b37be643b78c6c9cba17 Mon Sep 17 00:00:00 2001
From: Wanpeng Li <wanpeng.li@linux.intel.com>
Date: Thu, 17 Jul 2014 17:41:28 +0800
Subject: [PATCH v2] KVM: nVMX: Fix fail to get nested ack intr's vector during nested vmexit

WARNING: CPU: 9 PID: 7251 at arch/x86/kvm/vmx.c:8719 nested_vmx_vmexit+0xa4/0x233 [kvm_intel]()
Modules linked in: tun nfsv3 nfs_acl auth_rpcgss oid_registry nfsv4 dns_resolver nfs fscache lockd
sunrpc pci_stub netconsole kvm_intel kvm bridge stp llc autofs4 8021q ipv6 uinput joydev microcode
pcspkr igb i2c_algo_bit ehci_pci ehci_hcd e1000e ixgbe ptp pps_core hwmon mdio i2c_i801 i2c_core
tpm_tis tpm ipmi_si ipmi_msghandler isci libsas scsi_transport_sas button dm_mirror dm_region_hash
dm_log dm_mod
CPU: 9 PID: 7251 Comm: qemu-system-x86 Tainted: G        W     3.16.0-rc1 #2
Hardware name: Intel Corporation S2600CP/S2600CP, BIOS RMLSDP.86I.00.29.D696.1311111329 11/11/2013
 000000000000220f ffff880ffd107bf8 ffffffff81493563 000000000000220f
 0000000000000000 ffff880ffd107c38 ffffffff8103f0eb ffff880ffd107c48
 ffffffffa059709a ffff881ffc9e0040 ffff8800b74b8000 00000000ffffffff
Call Trace:
 [<ffffffff81493563>] dump_stack+0x49/0x5e
 [<ffffffff8103f0eb>] warn_slowpath_common+0x7c/0x96
 [<ffffffffa059709a>] ? nested_vmx_vmexit+0xa4/0x233 [kvm_intel]
 [<ffffffff8103f11a>] warn_slowpath_null+0x15/0x17
 [<ffffffffa059709a>] nested_vmx_vmexit+0xa4/0x233 [kvm_intel]
 [<ffffffffa0594295>] ? nested_vmx_exit_handled+0x6a/0x39e [kvm_intel]
 [<ffffffffa0537931>] ? kvm_apic_has_interrupt+0x80/0xd5 [kvm]
 [<ffffffffa05972ec>] vmx_check_nested_events+0xc3/0xd3 [kvm_intel]
 [<ffffffffa051ebe9>] inject_pending_event+0xd0/0x16e [kvm]
 [<ffffffffa051efa0>] vcpu_enter_guest+0x319/0x704 [kvm]

After commit 77b0f5d (KVM: nVMX: Ack and write vector info to intr_info if L1
asks us to), "Acknowledge interrupt on exit" behavior can be emulated. Current
logic will ask for intr vector if it is nested vmexit and VM_EXIT_ACK_INTR_ON_EXIT
is set by L1. However, intr vector for posted intr can't be got by generic read
pending interrupt vector and intack routine, there is a requirement to sync from
pir to irr. This patch fix it by ask the intr vector after sync pir to irr.

Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
---
v1 -> v2:
 * replace kvm_get_apic_interrupt() by kvm_lapic_find_highest_irr()

 arch/x86/kvm/lapic.c | 1 +
 arch/x86/kvm/vmx.c   | 3 +++
 2 files changed, 4 insertions(+)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 0069118..b7d45dc 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1637,6 +1637,7 @@ int kvm_get_apic_interrupt(struct kvm_vcpu *vcpu)
 	apic_clear_irr(vector, apic);
 	return vector;
 }
+EXPORT_SYMBOL_GPL(kvm_get_apic_interrupt);
 
 void kvm_apic_post_state_restore(struct kvm_vcpu *vcpu,
 		struct kvm_lapic_state *s)
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 4ae5ad8..a704f71 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -8697,6 +8697,9 @@ static void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 exit_reason,
 	if ((exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT)
 	    && nested_exit_intr_ack_set(vcpu)) {
 		int irq = kvm_cpu_get_interrupt(vcpu);
+
+		if (irq < 0 && kvm_apic_vid_enabled(vcpu->kvm))
+			irq = kvm_lapic_find_highest_irr(vcpu);
 		WARN_ON(irq < 0);
 		vmcs12->vm_exit_intr_info = irq |
 			INTR_INFO_VALID_MASK | INTR_TYPE_EXT_INTR;
-- 
1.9.1


--AqsLC8rIMeq19msA--
