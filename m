Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751469AbaILFoS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 01:44:18 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:62688 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbaILFoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 01:44:17 -0400
From: guohliu <liuguohui@gmail.com>
To: pbonzini@redhat.com
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        guohliu <liuguohui@gmail.com>
Subject: [PATCH] KVM: Refactor making request to makes it meaningful
Date: Fri, 12 Sep 2014 13:43:19 +0800
Message-Id: <1410500599-12114-1-git-send-email-liuguohui@gmail.com>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch replace the set_bit method by kvm_make_request
to makes it more readable and consistency.

Signed-off-by: Guo Hui Liu <liuguohui@gmail.com>
---
 arch/x86/kvm/x86.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 916e895..5fed2de 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1518,7 +1518,7 @@ static void kvm_gen_update_masterclock(struct kvm *kvm)
 	pvclock_update_vm_gtod_copy(kvm);
 
 	kvm_for_each_vcpu(i, vcpu, kvm)
-		set_bit(KVM_REQ_CLOCK_UPDATE, &vcpu->requests);
+		kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
 
 	/* guest entries allowed */
 	kvm_for_each_vcpu(i, vcpu, kvm)
@@ -1661,7 +1661,7 @@ static void kvmclock_update_fn(struct work_struct *work)
 	struct kvm_vcpu *vcpu;
 
 	kvm_for_each_vcpu(i, vcpu, kvm) {
-		set_bit(KVM_REQ_CLOCK_UPDATE, &vcpu->requests);
+		kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
 		kvm_vcpu_kick(vcpu);
 	}
 }
@@ -1670,7 +1670,7 @@ static void kvm_gen_kvmclock_update(struct kvm_vcpu *v)
 {
 	struct kvm *kvm = v->kvm;
 
-	set_bit(KVM_REQ_CLOCK_UPDATE, &v->requests);
+	kvm_make_request(KVM_REQ_CLOCK_UPDATE, v);
 	schedule_delayed_work(&kvm->arch.kvmclock_update_work,
 					KVMCLOCK_UPDATE_DELAY);
 }
@@ -2846,7 +2846,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	if (unlikely(vcpu->arch.tsc_offset_adjustment)) {
 		adjust_tsc_offset_host(vcpu, vcpu->arch.tsc_offset_adjustment);
 		vcpu->arch.tsc_offset_adjustment = 0;
-		set_bit(KVM_REQ_CLOCK_UPDATE, &vcpu->requests);
+		kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
 	}
 
 	if (unlikely(vcpu->cpu != cpu) || check_tsc_unstable()) {
@@ -5600,7 +5600,7 @@ static void pvclock_gtod_update_fn(struct work_struct *work)
 	spin_lock(&kvm_lock);
 	list_for_each_entry(kvm, &vm_list, vm_list)
 		kvm_for_each_vcpu(i, vcpu, kvm)
-			set_bit(KVM_REQ_MASTERCLOCK_UPDATE, &vcpu->requests);
+			kvm_make_request(KVM_REQ_MASTERCLOCK_UPDATE, vcpu);
 	atomic_set(&kvm_guest_has_master_clock, 0);
 	spin_unlock(&kvm_lock);
 }
@@ -6978,7 +6978,7 @@ int kvm_arch_hardware_enable(void)
 	list_for_each_entry(kvm, &vm_list, vm_list) {
 		kvm_for_each_vcpu(i, vcpu, kvm) {
 			if (!stable && vcpu->cpu == smp_processor_id())
-				set_bit(KVM_REQ_CLOCK_UPDATE, &vcpu->requests);
+				kvm_make_request(KVM_REQ_CLOCK_UPDATE, vcpu);
 			if (stable && vcpu->arch.last_host_tsc > local_tsc) {
 				backwards_tsc = true;
 				if (vcpu->arch.last_host_tsc > max_tsc)
@@ -7032,8 +7032,7 @@ int kvm_arch_hardware_enable(void)
 			kvm_for_each_vcpu(i, vcpu, kvm) {
 				vcpu->arch.tsc_offset_adjustment += delta_cyc;
 				vcpu->arch.last_host_tsc = local_tsc;
-				set_bit(KVM_REQ_MASTERCLOCK_UPDATE,
-					&vcpu->requests);
+				kvm_make_request(KVM_REQ_MASTERCLOCK_UPDATE, vcpu);
 			}
 
 			/*
-- 
1.9.3

