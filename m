Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163AbaBZSPY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 13:15:24 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5413 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751698AbaBZSPW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 13:15:22 -0500
From: Andrew Jones <drjones@redhat.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: mtosatti@redhat.com, pbonzini@redhat.com
Subject: [PATCH 2/2] x86: kvm: introduce periodic global clock updates
Date: Wed, 26 Feb 2014 19:15:12 +0100
Message-Id: <1393438512-21273-3-git-send-email-drjones@redhat.com>
In-Reply-To: <1393438512-21273-1-git-send-email-drjones@redhat.com>
References: <1393438512-21273-1-git-send-email-drjones@redhat.com>
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
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/x86.c              | 65 +++++++++++++++++++++++++++++++++++++++--
 2 files changed, 63 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 9aa09d330a4b5..77c69aa4756f9 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -599,6 +599,7 @@ struct kvm_arch {
 	u64 master_kernel_ns;
 	cycle_t master_cycle_now;
 	struct delayed_work kvmclock_update_work;
+	bool clocks_synced;
 
 	struct kvm_xen_hvm_config xen_hvm_config;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a2d30de597b7d..5cba20b446aac 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1620,6 +1620,60 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 	return 0;
 }
 
+static void kvm_schedule_kvmclock_update(struct kvm *kvm, bool now);
+static void clock_sync_fn(struct work_struct *work);
+static DECLARE_DELAYED_WORK(clock_sync_work, clock_sync_fn);
+
+#define CLOCK_SYNC_PERIOD_SECS	300
+#define CLOCK_SYNC_BUMP_SECS	30
+#define CLOCK_SYNC_STEP_MSECS	100
+
+#define __steps(s) (((s) * MSEC_PER_SEC) / CLOCK_SYNC_STEP_MSECS)
+
+static void clock_sync_fn(struct work_struct *work)
+{
+	static unsigned reset_step = __steps(CLOCK_SYNC_PERIOD_SECS);
+	static unsigned step = 0;
+	struct kvm *kvm;
+	bool sync = false;
+
+	spin_lock(&kvm_lock);
+
+	if (step == 0)
+		list_for_each_entry(kvm, &vm_list, vm_list)
+			kvm->arch.clocks_synced = false;
+
+	list_for_each_entry(kvm, &vm_list, vm_list) {
+		if (!kvm->arch.clocks_synced) {
+			kvm_get_kvm(kvm);
+			sync = true;
+			break;
+		}
+	}
+
+	spin_unlock(&kvm_lock);
+
+	if (sync) {
+		kvm_schedule_kvmclock_update(kvm, true);
+		kvm_put_kvm(kvm);
+
+		if (++step == reset_step) {
+			reset_step += __steps(CLOCK_SYNC_BUMP_SECS);
+			pr_warn("kvmclock: reducing VM clock sync frequency "
+				"to every %ld seconds.\n", (reset_step
+					* CLOCK_SYNC_STEP_MSECS)/MSEC_PER_SEC);
+		}
+
+		schedule_delayed_work(&clock_sync_work,
+				msecs_to_jiffies(CLOCK_SYNC_STEP_MSECS));
+	} else {
+		unsigned s = reset_step - step;
+		step = 0;
+		schedule_delayed_work(&clock_sync_work,
+				msecs_to_jiffies(s * CLOCK_SYNC_STEP_MSECS));
+	}
+}
+
 /*
  * kvmclock updates which are isolated to a given vcpu, such as
  * vcpu->cpu migration, should not allow system_timestamp from
@@ -1652,11 +1706,12 @@ static void kvmclock_update_fn(struct work_struct *work)
 	kvm_put_kvm(kvm);
 }
 
-static void kvm_schedule_kvmclock_update(struct kvm *kvm)
+static void kvm_schedule_kvmclock_update(struct kvm *kvm, bool now)
 {
 	kvm_get_kvm(kvm);
+	kvm->arch.clocks_synced = true;
 	schedule_delayed_work(&kvm->arch.kvmclock_update_work,
-					KVMCLOCK_UPDATE_DELAY);
+				now ? 0 : KVMCLOCK_UPDATE_DELAY);
 }
 
 static void kvm_gen_kvmclock_update(struct kvm_vcpu *v)
@@ -1664,7 +1719,7 @@ static void kvm_gen_kvmclock_update(struct kvm_vcpu *v)
 	struct kvm *kvm = v->kvm;
 
 	set_bit(KVM_REQ_CLOCK_UPDATE, &v->requests);
-	kvm_schedule_kvmclock_update(kvm);
+	kvm_schedule_kvmclock_update(kvm, false);
 }
 
 static bool msr_mtrr_valid(unsigned msr)
@@ -5584,6 +5639,8 @@ int kvm_arch_init(void *opaque)
 	pvclock_gtod_register_notifier(&pvclock_gtod_notifier);
 #endif
 
+	schedule_delayed_work(&clock_sync_work, CLOCK_SYNC_PERIOD_SECS * HZ);
+
 	return 0;
 
 out_free_percpu:
@@ -5594,6 +5651,8 @@ out:
 
 void kvm_arch_exit(void)
 {
+	cancel_delayed_work_sync(&clock_sync_work);
+
 	perf_unregister_guest_info_callbacks(&kvm_guest_cbs);
 
 	if (!boot_cpu_has(X86_FEATURE_CONSTANT_TSC))
-- 
1.8.1.4

