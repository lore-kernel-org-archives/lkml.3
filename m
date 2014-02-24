Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326AbaBXPmj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 10:42:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9250 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753294AbaBXPmh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 10:42:37 -0500
From: Andrew Jones <drjones@redhat.com>
To: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: mtosatti@redhat.com, pbonzini@redhat.com
Subject: [PATCH] x86: kvm: fix unstable_tsc boot
Date: Mon, 24 Feb 2014 16:42:29 +0100
Message-Id: <1393256549-7743-1-git-send-email-drjones@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the tsc is marked unstable on the host it causes global clock
updates to be requested each time a vcpu is loaded, nearly halting
all progress on guests with a large number of vcpus.

Fix this by only requesting a local clock update unless the vcpu
is migrating to another cpu.

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arch/x86/kvm/x86.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 6530019116b0d..ea716a162b4a3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2781,15 +2781,18 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 						vcpu->arch.last_guest_tsc);
 			kvm_x86_ops->write_tsc_offset(vcpu, offset);
 			vcpu->arch.tsc_catchup = 1;
+			set_bit(KVM_REQ_CLOCK_UPDATE, &vcpu->requests);
 		}
+	}
+
+	if (unlikely(vcpu->cpu != cpu)) {
 		/*
 		 * On a host with synchronized TSC, there is no need to update
 		 * kvmclock on vcpu->cpu migration
 		 */
 		if (!vcpu->kvm->arch.use_master_clock || vcpu->cpu == -1)
 			kvm_make_request(KVM_REQ_GLOBAL_CLOCK_UPDATE, vcpu);
-		if (vcpu->cpu != cpu)
-			kvm_migrate_timers(vcpu);
+		kvm_migrate_timers(vcpu);
 		vcpu->cpu = cpu;
 	}
 
-- 
1.8.1.4

