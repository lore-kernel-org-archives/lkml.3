Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034AbaGHJb3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 05:31:29 -0400
Received: from mga11.intel.com ([192.55.52.93]:63061 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752135AbaGHJb0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 05:31:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,624,1400050800"; 
   d="scan'208";a="566630231"
Date: Tue, 8 Jul 2014 17:27:31 +0800
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Jan Kiszka <jan.kiszka@siemens.com>
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Bandan Das <bsd@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: nVMX: Fix vmptrld fail and vmwrite error when L1
 goes down w/ enable_shadow_vmcs
Message-ID: <20140708092731.GB19860@kernel>
Reply-To: Wanpeng Li <wanpeng.li@linux.intel.com>
References: <1404456758-33691-1-git-send-email-wanpeng.li@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404456758-33691-1-git-send-email-wanpeng.li@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping,
On Fri, Jul 04, 2014 at 02:52:38PM +0800, Wanpeng Li wrote:
>This bug can be trigger by L1 goes down directly w/ enable_shadow_vmcs.
>
>[ 6413.158950] kvm: vmptrld           (null)/780000000000 failed
>[ 6413.158954] vmwrite error: reg 401e value 4 (err 1)
>[ 6413.158957] CPU: 0 PID: 4840 Comm: qemu-system-x86 Tainted: G           OE 3.16.0kvm+ #2
>[ 6413.158958] Hardware name: Dell Inc. OptiPlex 9020/0DNKMN, BIOS A05 12/05/2013
>[ 6413.158959]  0000000000000003 ffff880210c9fb58 ffffffff81741de9 ffff8800d7433f80
>[ 6413.158960]  ffff880210c9fb68 ffffffffa059fa08 ffff880210c9fb78 ffffffffa05938bf
>[ 6413.158962]  ffff880210c9fba8 ffffffffa059a97f ffff8800d7433f80 0000000000000003
>[ 6413.158963] Call Trace:
>[ 6413.158968]  [<ffffffff81741de9>] dump_stack+0x45/0x56
>[ 6413.158972]  [<ffffffffa059fa08>] vmwrite_error+0x2c/0x2e [kvm_intel]
>[ 6413.158974]  [<ffffffffa05938bf>] vmcs_writel+0x1f/0x30 [kvm_intel]
>[ 6413.158976]  [<ffffffffa059a97f>] free_nested.part.73+0x5f/0x170 [kvm_intel]
>[ 6413.158978]  [<ffffffffa059ab13>] vmx_free_vcpu+0x33/0x70 [kvm_intel]
>[ 6413.158991]  [<ffffffffa0360324>] kvm_arch_vcpu_free+0x44/0x50 [kvm]
>[ 6413.158998]  [<ffffffffa0360f92>] kvm_arch_destroy_vm+0xf2/0x1f0 [kvm]
>
>Commit 26a865 (KVM: VMX: fix use after free of vmx->loaded_vmcs) fix the use 
>after free bug by move free_loaded_vmcs() before free_nested(), however, this 
>lead to free loaded_vmcs->vmcs premature and vmptrld load a NULL pointer during 
>sync shadow vmcs to vmcs12. In addition, vmwrite which used to disable shadow 
>vmcs and reset VMCS_LINK_POINTER failed since there is no valid current-VMCS.
>This patch fix it by skipping kfree vmcs02_list item for current-vmcs in 
>nested_free_all_saved_vmcss() and kfree it after free_loaded_vmcs(). This can 
>also avoid use after free bug.
>
>Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
>---
> arch/x86/kvm/vmx.c | 15 +++++++++++----
> 1 file changed, 11 insertions(+), 4 deletions(-)
>
>diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
>index 021d84a..6e427ac 100644
>--- a/arch/x86/kvm/vmx.c
>+++ b/arch/x86/kvm/vmx.c
>@@ -5762,10 +5762,11 @@ static void nested_free_all_saved_vmcss(struct vcpu_vmx *vmx)
> {
> 	struct vmcs02_list *item, *n;
> 	list_for_each_entry_safe(item, n, &vmx->nested.vmcs02_pool, list) {
>-		if (vmx->loaded_vmcs != &item->vmcs02)
>+		if (vmx->loaded_vmcs != &item->vmcs02) {
> 			free_loaded_vmcs(&item->vmcs02);
>-		list_del(&item->list);
>-		kfree(item);
>+			list_del(&item->list);
>+			kfree(item);
>+		}
> 	}
> 	vmx->nested.vmcs02_num = 0;
> 
>@@ -7526,10 +7527,16 @@ static void __noclone vmx_vcpu_run(struct kvm_vcpu *vcpu)
> static void vmx_free_vcpu(struct kvm_vcpu *vcpu)
> {
> 	struct vcpu_vmx *vmx = to_vmx(vcpu);
>+	struct vmcs02_list *item;
> 
> 	free_vpid(vmx);
>-	free_loaded_vmcs(vmx->loaded_vmcs);
> 	free_nested(vmx);
>+	free_loaded_vmcs(vmx->loaded_vmcs);
>+	if (vmx->nested.vmxon)
>+		list_for_each_entry(item, &vmx->nested.vmcs02_pool, list) {
>+			list_del(&item->list);
>+			kfree(item);
>+		}
> 	kfree(vmx->guest_msrs);
> 	kvm_vcpu_uninit(vcpu);
> 	kmem_cache_free(kvm_vcpu_cache, vmx);
>-- 
>1.9.1
