Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760243AbaJ3OIx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 10:08:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40863 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760163AbaJ3OIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 10:08:51 -0400
From: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Gleb Natapov <gleb@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH 1/3] KVM: x86: detect SPIV changes under APICv
Date: Thu, 30 Oct 2014 15:06:45 +0100
Message-Id: <1414678007-9377-2-git-send-email-rkrcmar@redhat.com>
In-Reply-To: <1414678007-9377-1-git-send-email-rkrcmar@redhat.com>
References: <1414678007-9377-1-git-send-email-rkrcmar@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

APICv traps register writes, so we can't retrieve previous value.
(A bit of blame on Intel.)

This caused a migration bug:  LAPIC is enabled, so our restore code
correctly lowers apic_sw_enabled, but doesn't increase it after APICv is
disabled, so we get below zero when freeing it; resulting in this trace:

  WARNING: at kernel/jump_label.c:81 __static_key_slow_dec+0xa6/0xb0()
  jump label: negative count!

  [<ffffffff816bf898>] dump_stack+0x19/0x1b
  [<ffffffff8107c6f1>] warn_slowpath_common+0x61/0x80
  [<ffffffff8107c76c>] warn_slowpath_fmt+0x5c/0x80
  [<ffffffff811931e6>] __static_key_slow_dec+0xa6/0xb0
  [<ffffffff81193226>] static_key_slow_dec_deferred+0x16/0x20
  [<ffffffffa0637698>] kvm_free_lapic+0x88/0xa0 [kvm]
  [<ffffffffa061c63e>] kvm_arch_vcpu_uninit+0x2e/0xe0 [kvm]
  [<ffffffffa05ff301>] kvm_vcpu_uninit+0x21/0x40 [kvm]
  [<ffffffffa067cec7>] vmx_free_vcpu+0x47/0x70 [kvm_intel]
  [<ffffffffa061bc50>] kvm_arch_vcpu_free+0x50/0x60 [kvm]
  [<ffffffffa061ca22>] kvm_arch_destroy_vm+0x102/0x260 [kvm]
  [<ffffffff810b68fd>] ? synchronize_srcu+0x1d/0x20
  [<ffffffffa06030d1>] kvm_put_kvm+0xe1/0x1c0 [kvm]
  [<ffffffffa06036f8>] kvm_vcpu_release+0x18/0x20 [kvm]
  [<ffffffff81215c62>] __fput+0x102/0x310
  [<ffffffff81215f4e>] ____fput+0xe/0x10
  [<ffffffff810ab664>] task_work_run+0xb4/0xe0
  [<ffffffff81083944>] do_exit+0x304/0xc60
  [<ffffffff816c8dfc>] ? _raw_spin_unlock_irq+0x2c/0x50
  [<ffffffff810fd22d>] ?  trace_hardirqs_on_caller+0xfd/0x1c0
  [<ffffffff8108432c>] do_group_exit+0x4c/0xc0
  [<ffffffff810843b4>] SyS_exit_group+0x14/0x20
  [<ffffffff816d33a9>] system_call_fastpath+0x16/0x1b

Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
---
 arch/x86/kvm/lapic.c | 10 ++++++----
 arch/x86/kvm/lapic.h |  1 +
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index b8345dd..f538b14 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -201,11 +201,13 @@ out:
 
 static inline void apic_set_spiv(struct kvm_lapic *apic, u32 val)
 {
-	u32 prev = kvm_apic_get_reg(apic, APIC_SPIV);
+	bool enabled = val & APIC_SPIV_APIC_ENABLED;
 
 	apic_set_reg(apic, APIC_SPIV, val);
-	if ((prev ^ val) & APIC_SPIV_APIC_ENABLED) {
-		if (val & APIC_SPIV_APIC_ENABLED) {
+
+	if (enabled != apic->sw_enabled) {
+		apic->sw_enabled = enabled;
+		if (enabled) {
 			static_key_slow_dec_deferred(&apic_sw_disabled);
 			recalculate_apic_map(apic->vcpu->kvm);
 		} else
@@ -1320,7 +1322,7 @@ void kvm_free_lapic(struct kvm_vcpu *vcpu)
 	if (!(vcpu->arch.apic_base & MSR_IA32_APICBASE_ENABLE))
 		static_key_slow_dec_deferred(&apic_hw_disabled);
 
-	if (!(kvm_apic_get_reg(apic, APIC_SPIV) & APIC_SPIV_APIC_ENABLED))
+	if (!apic->sw_enabled)
 		static_key_slow_dec_deferred(&apic_sw_disabled);
 
 	if (apic->regs)
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 6a11845..5fcc3d3 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -33,6 +33,7 @@ struct kvm_lapic {
 	 * Note: Only one register, the TPR, is used by the microcode.
 	 */
 	void *regs;
+	bool sw_enabled;
 	gpa_t vapic_addr;
 	struct gfn_to_hva_cache vapic_cache;
 	unsigned long pending_events;
-- 
2.1.0

