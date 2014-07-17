Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423AbaGQJE2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 05:04:28 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:49441 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755737AbaGQJEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 05:04:23 -0400
Message-ID: <53C79182.1040408@redhat.com>
Date: Thu, 17 Jul 2014 11:04:02 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Wanpeng Li <wanpeng.li@linux.intel.com>,
        Jan Kiszka <jan.kiszka@siemens.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@kernel.org>,
        Bandan Das <bsd@redhat.com>, Zhang Yang <yang.z.zhang@intel.com>,
        Hu Robert <robert.hu@intel.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] KVM: nVMX: Fix vmptrld fail and vmwrite error when
 L1 goes down
References: <1405573011-41330-1-git-send-email-wanpeng.li@linux.intel.com> <1405573011-41330-3-git-send-email-wanpeng.li@linux.intel.com> <53C78FA9.5000303@redhat.com>
In-Reply-To: <53C78FA9.5000303@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 17/07/2014 10:56, Paolo Bonzini ha scritto:
> Il 17/07/2014 06:56, Wanpeng Li ha scritto:
>> This bug can be trigger by L1 goes down directly w/ enable_shadow_vmcs.
>>
>> [ 6413.158950] kvm: vmptrld           (null)/780000000000 failed
>> [ 6413.158954] vmwrite error: reg 401e value 4 (err 1)
>> [ 6413.158957] CPU: 0 PID: 4840 Comm: qemu-system-x86 Tainted:
>> G           OE 3.16.0kvm+ #2
>> [ 6413.158958] Hardware name: Dell Inc. OptiPlex 9020/0DNKMN, BIOS A05
>> 12/05/2013
>> [ 6413.158959]  0000000000000003 ffff880210c9fb58 ffffffff81741de9
>> ffff8800d7433f80
>> [ 6413.158960]  ffff880210c9fb68 ffffffffa059fa08 ffff880210c9fb78
>> ffffffffa05938bf
>> [ 6413.158962]  ffff880210c9fba8 ffffffffa059a97f ffff8800d7433f80
>> 0000000000000003
>> [ 6413.158963] Call Trace:
>> [ 6413.158968]  [<ffffffff81741de9>] dump_stack+0x45/0x56
>> [ 6413.158972]  [<ffffffffa059fa08>] vmwrite_error+0x2c/0x2e [kvm_intel]
>> [ 6413.158974]  [<ffffffffa05938bf>] vmcs_writel+0x1f/0x30 [kvm_intel]
>> [ 6413.158976]  [<ffffffffa059a97f>] free_nested.part.73+0x5f/0x170
>> [kvm_intel]
>> [ 6413.158978]  [<ffffffffa059ab13>] vmx_free_vcpu+0x33/0x70 [kvm_intel]
>> [ 6413.158991]  [<ffffffffa0360324>] kvm_arch_vcpu_free+0x44/0x50 [kvm]
>> [ 6413.158998]  [<ffffffffa0360f92>] kvm_arch_destroy_vm+0xf2/0x1f0 [kvm]
>>
>> Commit 26a865 (KVM: VMX: fix use after free of vmx->loaded_vmcs) fix
>> the use
>> after free bug by move free_loaded_vmcs() before free_nested(),
>> however, this
>> lead to free loaded_vmcs->vmcs premature and vmptrld load a NULL
>> pointer during
>> sync shadow vmcs to vmcs12. In addition, vmwrite which used to disable
>> shadow
>> vmcs and reset VMCS_LINK_POINTER failed since there is no valid
>> current-VMCS.
>> This patch fix it by skipping sync shadow vmcs and reset vmcs field
>> for L1
>> destroy since they will be reinitialized after L1 recreate.
>>
>> Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
>> ---
>>  arch/x86/kvm/vmx.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
>> index fbce89e..2b28da7 100644
>> --- a/arch/x86/kvm/vmx.c
>> +++ b/arch/x86/kvm/vmx.c
>> @@ -6113,9 +6113,9 @@ static void free_nested(struct vcpu_vmx *vmx)
>>          return;
>>      vmx->nested.vmxon = false;
>>      if (vmx->nested.current_vmptr != -1ull) {
>> -        nested_release_vmcs12(vmx);
>>          vmx->nested.current_vmptr = -1ull;
>>          vmx->nested.current_vmcs12 = NULL;
>> +        nested_release_vmcs12(vmx);
>>      }
>>      if (enable_shadow_vmcs)
>>          free_vmcs(vmx->nested.current_shadow_vmcs);
>>
>
> This looks good, I'll apply it to kvm/master.

Hmm, on second thought the lifetimes of the VMCSes are a total mess. 
Let me look more at this.

Paolo

