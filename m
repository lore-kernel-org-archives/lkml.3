Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554AbaDFRga (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 13:36:30 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:44363 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313AbaDFRg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 13:36:27 -0400
From: Ming Lei <tom.leiming@gmail.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Ming Lei <tom.leiming@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH] arm, kvm: fix double lock on cpu_add_remove_lock
Date: Mon,  7 Apr 2014 01:36:08 +0800
Message-Id: <1396805768-18669-1-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch of "arm, kvm: Fix CPU hotplug callback registration"
in -next tree holds the lock before calling the two functions:

	kvm_vgic_hyp_init()
	kvm_timer_hyp_init()

and both the two functions are calling register_cpu_notifier()
to register cpu notifier, so cause double lock on cpu_add_remove_lock.

Considered that both two functions are only called inside
kvm_arch_init() with holding cpu_add_remove_lock, so simply use
__register_cpu_notifier() to fix the problem.

Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 virt/kvm/arm/arch_timer.c |    2 +-
 virt/kvm/arm/vgic.c       |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
index 5081e80..22fa819 100644
--- a/virt/kvm/arm/arch_timer.c
+++ b/virt/kvm/arm/arch_timer.c
@@ -277,7 +277,7 @@ int kvm_timer_hyp_init(void)
 
 	host_vtimer_irq = ppi;
 
-	err = register_cpu_notifier(&kvm_timer_cpu_nb);
+	err = __register_cpu_notifier(&kvm_timer_cpu_nb);
 	if (err) {
 		kvm_err("Cannot register timer CPU notifier\n");
 		goto out_free;
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 8ca405c..47b2983 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -1496,7 +1496,7 @@ int kvm_vgic_hyp_init(void)
 		goto out;
 	}
 
-	ret = register_cpu_notifier(&vgic_cpu_nb);
+	ret = __register_cpu_notifier(&vgic_cpu_nb);
 	if (ret) {
 		kvm_err("Cannot register vgic CPU notifier\n");
 		goto out_free_irq;
-- 
1.7.9.5

