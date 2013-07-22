Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574Ab3GVGMc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 02:12:32 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:35419 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756427Ab3GVGM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 02:12:29 -0400
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: <gleb@redhat.com>, <mingo@redhat.com>, <jeremy@goop.org>, <x86@kernel.org>,
        <konrad.wilk@oracle.com>, <hpa@zytor.com>, <pbonzini@redhat.com>
Cc: linux-doc@vger.kernel.org, <habanero@linux.vnet.ibm.com>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        <xen-devel@lists.xensource.com>, <peterz@infradead.org>,
        <mtosatti@redhat.com>, <stefano.stabellini@eu.citrix.com>,
        <andi@firstfloor.org>, <attilio.rao@citrix.com>, <ouyang@cs.pitt.edu>,
        <gregkh@suse.de>, <agraf@suse.de>, <chegu_vinod@hp.com>,
        <torvalds@linux-foundation.org>, <avi.kivity@gmail.com>,
        <tglx@linutronix.de>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <riel@redhat.com>,
        <drjones@redhat.com>, <virtualization@lists.linux-foundation.org>,
        <srivatsa.vaddagiri@gmail.com>
Date: Mon, 22 Jul 2013 11:49:49 +0530
Message-Id: <20130722061949.24737.81055.sendpatchset@codeblue>
In-Reply-To: <20130722061631.24737.75508.sendpatchset@codeblue>
References: <20130722061631.24737.75508.sendpatchset@codeblue>
Subject: [PATCH RFC V11 13/18] kvm : Fold pv_unhalt flag into GET_MP_STATE ioctl to aid migration
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072205-9264-0000-0000-0000042B9E73
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kvm : Fold pv_unhalt flag into GET_MP_STATE ioctl to aid migration

From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>

During migration, any vcpu that got kicked but did not become runnable
(still in halted state) should be runnable after migration.

Signed-off-by: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
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
 

