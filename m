Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270Ab3F1S4D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 14:56:03 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41771 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652Ab3F1Sz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 14:55:59 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 105/105] KVM: x86: fix deadlock in clock-in-progress request handling
Date: Fri, 28 Jun 2013 11:52:07 -0700
Message-Id: <1372445527-24414-106-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372445527-24414-1-git-send-email-kamal@canonical.com>
References: <1372445527-24414-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcelo Tosatti <mtosatti@redhat.com>

commit c09664bb44184b3846e8c5254db4eae4b932682a upstream.

There is a deadlock in pvclock handling:

cpu0:                                               cpu1:
kvm_gen_update_masterclock()
                                              kvm_guest_time_update()
 spin_lock(pvclock_gtod_sync_lock)
                                               local_irq_save(flags)

spin_lock(pvclock_gtod_sync_lock)

 kvm_make_mclock_inprogress_request(kvm)
  make_all_cpus_request()
   smp_call_function_many()

Now if smp_call_function_many() called by cpu0 tries to call function on
cpu1 there will be a deadlock.

Fix by moving pvclock_gtod_sync_lock protected section outside irq
disabled section.

Analyzed by Gleb Natapov <gleb@redhat.com>
Acked-by: Gleb Natapov <gleb@redhat.com>
Reported-and-Tested-by: Yongjie Ren <yongjie.ren@intel.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/x86/kvm/x86.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ff74a2c..6e2af7b 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1416,15 +1416,6 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 	kernel_ns = 0;
 	host_tsc = 0;
 
-	/* Keep irq disabled to prevent changes to the clock */
-	local_irq_save(flags);
-	this_tsc_khz = __get_cpu_var(cpu_tsc_khz);
-	if (unlikely(this_tsc_khz == 0)) {
-		local_irq_restore(flags);
-		kvm_make_request(KVM_REQ_CLOCK_UPDATE, v);
-		return 1;
-	}
-
 	/*
 	 * If the host uses TSC clock, then passthrough TSC as stable
 	 * to the guest.
@@ -1436,6 +1427,15 @@ static int kvm_guest_time_update(struct kvm_vcpu *v)
 		kernel_ns = ka->master_kernel_ns;
 	}
 	spin_unlock(&ka->pvclock_gtod_sync_lock);
+
+	/* Keep irq disabled to prevent changes to the clock */
+	local_irq_save(flags);
+	this_tsc_khz = __get_cpu_var(cpu_tsc_khz);
+	if (unlikely(this_tsc_khz == 0)) {
+		local_irq_restore(flags);
+		kvm_make_request(KVM_REQ_CLOCK_UPDATE, v);
+		return 1;
+	}
 	if (!use_master_clock) {
 		host_tsc = native_read_tsc();
 		kernel_ns = get_kernel_ns();
-- 
1.8.1.2

