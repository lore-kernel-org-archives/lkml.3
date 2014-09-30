Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754269AbaI3Viu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:38:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:32867 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754229AbaI3Vir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:38:47 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 078/103] KVM: s390: Fix user triggerable bug in dead code
Date: Tue, 30 Sep 2014 14:31:23 -0700
Message-Id: <1412112708-27356-79-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412112708-27356-1-git-send-email-kamal@canonical.com>
References: <1412112708-27356-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Borntraeger <borntraeger@de.ibm.com>

commit 614a80e474b227cace52fd6e3c790554db8a396e upstream.

In the early days, we had some special handling for the
KVM_EXIT_S390_SIEIC exit, but this was gone in 2009 with commit
d7b0b5eb3000 (KVM: s390: Make psw available on all exits, not
just a subset).

Now this switch statement is just a sanity check for userspace
not messing with the kvm_run structure. Unfortunately, this
allows userspace to trigger a kernel BUG. Let's just remove
this switch statement.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: Cornelia Huck <cornelia.huck@de.ibm.com>
Reviewed-by: David Hildenbrand <dahi@linux.vnet.ibm.com>
[ kamal: backport to 3.13-stable: context ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/s390/kvm/kvm-s390.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index bfe7726..2480d92 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -802,18 +802,6 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *kvm_run)
 
 	BUG_ON(vcpu->kvm->arch.float_int.local_int[vcpu->vcpu_id] == NULL);
 
-	switch (kvm_run->exit_reason) {
-	case KVM_EXIT_S390_SIEIC:
-	case KVM_EXIT_UNKNOWN:
-	case KVM_EXIT_INTR:
-	case KVM_EXIT_S390_RESET:
-	case KVM_EXIT_S390_UCONTROL:
-	case KVM_EXIT_S390_TSCH:
-		break;
-	default:
-		BUG();
-	}
-
 	vcpu->arch.sie_block->gpsw.mask = kvm_run->psw_mask;
 	vcpu->arch.sie_block->gpsw.addr = kvm_run->psw_addr;
 	if (kvm_run->kvm_dirty_regs & KVM_SYNC_PREFIX) {
-- 
1.9.1

