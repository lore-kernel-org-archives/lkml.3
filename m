Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267Ab3KDUdd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 15:33:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30236 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750749Ab3KDUdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 15:33:32 -0500
Date: Mon, 4 Nov 2013 22:36:25 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Gleb Natapov <gleb@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        kvm@vger.kernel.org
Subject: [PATCH 2/2] kvm: optimize out smp_mb after srcu_read_unlock
Message-ID: <1383592884-2535-2-git-send-email-mst@redhat.com>
References: <1383592884-2535-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383592884-2535-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed that srcu_read_lock/unlock both have a memory barrier,
so just by moving srcu_read_unlock earlier we can get rid of
one call to smp_mb() using smp_mb__after_srcu_read_unlock instead.

Unsurprisingly, the gain is small but measureable using the unit test
microbenchmark:
before
        vmcall in the ballpark of 1410 cycles
after
        vmcall in the ballpark of 1360 cycles

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 arch/x86/kvm/x86.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e5ca72a..d609dce 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5945,10 +5945,12 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
 	vcpu->mode = IN_GUEST_MODE;
 
+	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
+
 	/* We should set ->mode before check ->requests,
 	 * see the comment in make_all_cpus_request.
 	 */
-	smp_mb();
+	smp_mb__after_srcu_read_unlock();
 
 	local_irq_disable();
 
@@ -5958,12 +5960,11 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		smp_wmb();
 		local_irq_enable();
 		preempt_enable();
+		vcpu->srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
 		r = 1;
 		goto cancel_injection;
 	}
 
-	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
-
 	if (req_immediate_exit)
 		smp_send_reschedule(vcpu->cpu);
 
-- 
MST

