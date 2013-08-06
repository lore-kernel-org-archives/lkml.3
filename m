Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756704Ab3HFSQ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 14:16:57 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:57050 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756578Ab3HFSQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 14:16:55 -0400
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: <gleb@redhat.com>, <mingo@redhat.com>, <jeremy@goop.org>, <x86@kernel.org>,
        <konrad.wilk@oracle.com>, <hpa@zytor.com>, <pbonzini@redhat.com>
Cc: <agraf@suse.de>, linux-doc@vger.kernel.org, <habanero@linux.vnet.ibm.com>,
        <riel@redhat.com>, Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        <drjones@redhat.com>, <avi.kivity@gmail.com>, <peterz@infradead.org>,
        <andi@firstfloor.org>, <virtualization@lists.linux-foundation.org>,
        <torvalds@linux-foundation.org>, <tglx@linutronix.de>,
        <mtosatti@redhat.com>, <kvm@vger.kernel.org>,
        <srivatsa.vaddagiri@gmail.com>, <ouyang@cs.pitt.edu>,
        <chegu_vinod@hp.com>, <linux-kernel@vger.kernel.org>
Date: Tue, 06 Aug 2013 23:53:09 +0530
Message-Id: <20130806182309.2386.35697.sendpatchset@codeblue.in.ibm.com>
In-Reply-To: <20130806182150.2386.95104.sendpatchset@codeblue.in.ibm.com>
References: <20130806182150.2386.95104.sendpatchset@codeblue.in.ibm.com>
Subject: [PATCH V12 3/5] kvm : Fold pv_unhalt flag into GET_MP_STATE ioctl to aid migration
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13080618-3620-0000-0000-000003D57C34
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kvm : Fold pv_unhalt flag into GET_MP_STATE ioctl to aid migration

From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>

During migration, any vcpu that got kicked but did not become runnable
(still in halted state) should be runnable after migration.

Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Acked-by: Gleb Natapov <gleb@redhat.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kvm/x86.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index dae4575..1e73dab 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -6284,7 +6284,12 @@ int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
 				    struct kvm_mp_state *mp_state)
 {
 	kvm_apic_accept_events(vcpu);
-	mp_state->mp_state = vcpu->arch.mp_state;
+	if (vcpu->arch.mp_state == KVM_MP_STATE_HALTED &&
+					vcpu->arch.pv.pv_unhalted)
+		mp_state->mp_state = KVM_MP_STATE_RUNNABLE;
+	else
+		mp_state->mp_state = vcpu->arch.mp_state;
+
 	return 0;
 }
 

