Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299AbaB1Lxi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 06:53:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10535 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752139AbaB1LxK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 06:53:10 -0500
From: Andrew Jones <drjones@redhat.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: mtosatti@redhat.com, pbonzini@redhat.com
Subject: [PATCH 1/2 v2] x86: kvm: rate-limit global clock updates
Date: Fri, 28 Feb 2014 12:52:54 +0100
Message-Id: <1393588375-13664-2-git-send-email-drjones@redhat.com>
In-Reply-To: <1393588375-13664-1-git-send-email-drjones@redhat.com>
References: <1393588375-13664-1-git-send-email-drjones@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we update a vcpu's local clock it may pick up an NTP correction.
We can't wait an indeterminate amount of time for other vcpus to pick
up that correction, so commit 0061d53daf26f introduced a global clock
update. However, we can't request a global clock update on every vcpu
load either (which is what happens if the tsc is marked as unstable).
The solution is to rate-limit the global clock updates. Marcelo
calculated that we should delay the global clock updates no more
than 0.1s as follows:

Assume an NTP correction c is applied to one vcpu, but not the other,
then in n seconds the delta of the vcpu system_timestamps will be
c * n. If we assume a correction of 500ppm (worst-case), then the two
vcpus will diverge 50us in 0.1s, which is a considerable amount.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
v2: switch from kvm_{get,put}_kvm() to cancel_delayed_work_sync()

 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/x86.c              | 27 +++++++++++++++++++++++----
 2 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index e714f8c08ccf2..9aa09d330a4b5 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -598,6 +598,7 @@ struct kvm_arch {
 	bool use_master_clock;
 	u64 master_kernel_ns;
 	cycle_t master_cycle_now;
+	struct delayed_work kvmclock_update_work;
 
 	struct kvm_xen_hvm_config xen_hvm_config;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4cca45853dfeb..e656719750fdf 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1628,14 +1628,21 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
  * the others.
  *
  * So in those cases, request a kvmclock update for all vcpus.
- * The worst case for a remote vcpu to update its kvmclock
- * is then bounded by maximum nohz sleep latency.
+ * We need to rate-limit these requests though, as they can
+ * considerably slow guests that have a large number of vcpus.
+ * The time for a remote vcpu to update its kvmclock is bound
+ * by the delay we use to rate-limit the updates.
  */
 
-static void kvm_gen_kvmclock_update(struct kvm_vcpu *v)
+#define KVMCLOCK_UPDATE_DELAY msecs_to_jiffies(100)
+
+static void kvmclock_update_fn(struct work_struct *work)
 {
 	int i;
-	struct kvm *kvm = v->kvm;
+	struct delayed_work *dwork = to_delayed_work(work);
+	struct kvm_arch *ka = container_of(dwork, struct kvm_arch,
+					   kvmclock_update_work);
+	struct kvm *kvm = container_of(ka, struct kvm, arch);
 	struct kvm_vcpu *vcpu;
 
 	kvm_for_each_vcpu(i, vcpu, kvm) {
@@ -1644,6 +1651,15 @@ static void kvm_gen_kvmclock_update(struct kvm_vcpu *v)
 	}
 }
 
+static void kvm_gen_kvmclock_update(struct kvm_vcpu *v)
+{
+	struct kvm *kvm = v->kvm;
+
+	set_bit(KVM_REQ_CLOCK_UPDATE, &v->requests);
+	schedule_delayed_work(&kvm->arch.kvmclock_update_work,
+					KVMCLOCK_UPDATE_DELAY);
+}
+
 static bool msr_mtrr_valid(unsigned msr)
 {
 	switch (msr) {
@@ -7019,6 +7035,8 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 
 	pvclock_update_vm_gtod_copy(kvm);
 
+	INIT_DELAYED_WORK(&kvm->arch.kvmclock_update_work, kvmclock_update_fn);
+
 	return 0;
 }
 
@@ -7056,6 +7074,7 @@ static void kvm_free_vcpus(struct kvm *kvm)
 
 void kvm_arch_sync_events(struct kvm *kvm)
 {
+	cancel_delayed_work_sync(&kvm->arch.kvmclock_update_work);
 	kvm_free_all_assigned_devices(kvm);
 	kvm_free_pit(kvm);
 }
-- 
1.8.1.4

