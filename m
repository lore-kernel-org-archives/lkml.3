Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223AbaB1LxR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 06:53:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59634 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661AbaB1LxM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 06:53:12 -0500
From: Andrew Jones <drjones@redhat.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: mtosatti@redhat.com, pbonzini@redhat.com
Subject: [PATCH 2/2 v2] x86: kvm: introduce periodic global clock updates
Date: Fri, 28 Feb 2014 12:52:55 +0100
Message-Id: <1393588375-13664-3-git-send-email-drjones@redhat.com>
In-Reply-To: <1393588375-13664-1-git-send-email-drjones@redhat.com>
References: <1393588375-13664-1-git-send-email-drjones@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 0061d53daf26f introduced a mechanism to execute a global clock
update for a vm. We can apply this periodically in order to propagate
host NTP corrections. Also, if all vcpus of a vm are pinned, then
without an additional trigger, no guest NTP corrections can propagate
either, as the current trigger is only vcpu cpu migration.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
v2: greatly simplify things by creating per vm sync work, and not
    worrying about vms making simultaneous update requests.

 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/x86.c              | 20 ++++++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9aa09d330a4b5..85be627ef5de2 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -599,6 +599,7 @@ struct kvm_arch {
 	u64 master_kernel_ns;
 	cycle_t master_cycle_now;
 	struct delayed_work kvmclock_update_work;
+	struct delayed_work kvmclock_sync_work;
 
 	struct kvm_xen_hvm_config xen_hvm_config;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e656719750fdf..17c57c1ed1835 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1660,6 +1660,20 @@ static void kvm_gen_kvmclock_update(struct kvm_vcpu *v)
 					KVMCLOCK_UPDATE_DELAY);
 }
 
+#define KVMCLOCK_SYNC_PERIOD (300 * HZ)
+
+static void kvmclock_sync_fn(struct work_struct *work)
+{
+	struct delayed_work *dwork = to_delayed_work(work);
+	struct kvm_arch *ka = container_of(dwork, struct kvm_arch,
+					   kvmclock_sync_work);
+	struct kvm *kvm = container_of(ka, struct kvm, arch);
+
+	schedule_delayed_work(&kvm->arch.kvmclock_update_work, 0);
+	schedule_delayed_work(&kvm->arch.kvmclock_sync_work,
+					KVMCLOCK_SYNC_PERIOD);
+}
+
 static bool msr_mtrr_valid(unsigned msr)
 {
 	switch (msr) {
@@ -6733,6 +6747,7 @@ int kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
 {
 	int r;
 	struct msr_data msr;
+	struct kvm *kvm = vcpu->kvm;
 
 	r = vcpu_load(vcpu);
 	if (r)
@@ -6743,6 +6758,9 @@ int kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
 	kvm_write_tsc(vcpu, &msr);
 	vcpu_put(vcpu);
 
+	schedule_delayed_work(&kvm->arch.kvmclock_sync_work,
+					KVMCLOCK_SYNC_PERIOD);
+
 	return r;
 }
 
@@ -7036,6 +7054,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 	pvclock_update_vm_gtod_copy(kvm);
 
 	INIT_DELAYED_WORK(&kvm->arch.kvmclock_update_work, kvmclock_update_fn);
+	INIT_DELAYED_WORK(&kvm->arch.kvmclock_sync_work, kvmclock_sync_fn);
 
 	return 0;
 }
@@ -7074,6 +7093,7 @@ static void kvm_free_vcpus(struct kvm *kvm)
 
 void kvm_arch_sync_events(struct kvm *kvm)
 {
+	cancel_delayed_work_sync(&kvm->arch.kvmclock_sync_work);
 	cancel_delayed_work_sync(&kvm->arch.kvmclock_update_work);
 	kvm_free_all_assigned_devices(kvm);
 	kvm_free_pit(kvm);
-- 
1.8.1.4

