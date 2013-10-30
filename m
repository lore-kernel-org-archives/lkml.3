Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337Ab3J3TGk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 15:06:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55780 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754273Ab3J3TGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 15:06:39 -0400
Date: Wed, 30 Oct 2013 21:09:29 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: paulmck@linux.vnet.ibm.com, linux-kernel <linux-kernel@vger.kernel.org>
Cc: kvm@vger.kernel.org, gleb@redhat.com, pbonzini@redhat.com
Subject: [PATCH RFC] kvm: optimize out smp_mb using srcu_read_unlock
Message-ID: <20131030190929.GA7153@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed that srcu_read_lock/unlock both have a memory barrier,
so just by moving srcu_read_unlock earlier we can get rid of
one call to smp_mb().

Unsurprisingly, the gain is small but measureable using the unit test
microbenchmark:
before
	vmcall 1407
after
	vmcall 1357

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

--

I didn't stress test this yet, sending out for early review/flames.

Paul, could you review this patch please?
Documentation/memory-barriers.txt says that unlock has a weaker
uni-directional barrier, but in practice srcu_read_unlock calls
smp_mb().

Is it OK to rely on this? If not, can I add
smp_mb__after_srcu_read_unlock (making it an empty macro for now)
so we can avoid an actual extra smp_mb()?

Thanks.

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 8617c9d..a48fb36 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5949,8 +5949,10 @@ restore:
 
 	/* We should set ->mode before check ->requests,
 	 * see the comment in make_all_cpus_request.
+	 *
+	 * srcu_read_unlock below acts as a memory barrier.
 	 */
-	smp_mb();
+	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->srcu_idx);
 
 	local_irq_disable();
 
@@ -5960,12 +5962,11 @@ restore:
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
