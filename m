Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751327AbaK0Wac (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 17:30:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58217 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163AbaK0Waa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 17:30:30 -0500
Date: Thu, 27 Nov 2014 23:30:19 +0100
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Gleb Natapov <gleb@kernel.org>, Nadav Amit <namit@cs.technion.ac.il>
Subject: [PATCH 5/4] KVM: x86: check bounds of APIC maps
Message-ID: <20141127223019.GA26994@potion.brq.redhat.com>
References: <1417114994-25235-1-git-send-email-rkrcmar@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1417114994-25235-1-git-send-email-rkrcmar@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They can't be violated now, but we think against the infinite thing.

Signed-off-by: Radim Krčmář <rkrcmar@redhat.com>
---
 I realized it could make a separate patch as well,
 which might be more convenient.

 arch/x86/kvm/lapic.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 6c2b8a5..ae019f6 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -190,15 +190,16 @@ static void recalculate_apic_map(struct kvm *kvm)
 	kvm_for_each_vcpu(i, vcpu, kvm) {
 		struct kvm_lapic *apic = vcpu->arch.apic;
 		u16 cid, lid;
-		u32 ldr;
-
-		new->phys_map[kvm_apic_id(apic)] = apic;
+		u32 ldr, aid;
 
+		aid = kvm_apic_id(apic);
 		ldr = kvm_apic_get_reg(apic, APIC_LDR);
 		cid = apic_cluster_id(new, ldr);
 		lid = apic_logical_id(new, ldr);
 
-		if (lid)
+		if (aid < ARRAY_SIZE(new->phys_map))
+			new->phys_map[aid] = apic;
+		if (lid && cid < ARRAY_SIZE(new->logical_map))
 			new->logical_map[cid][ffs(lid) - 1] = apic;
 	}
 out:
-- 
2.1.0

