Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030AbaK0Ipw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 03:45:52 -0500
Received: from mail.kernel.org ([198.145.19.201]:40956 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837AbaK0Ipu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 03:45:50 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 01/91] KVM: s390: Fix user triggerable bug in dead code
Date: Thu, 27 Nov 2014 16:41:44 +0800
Message-Id: <1417077794-9299-1-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417077368-9217-1-git-send-email-lizf@kernel.org>
References: <1417077368-9217-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christian Borntraeger <borntraeger@de.ibm.com>

3.4.105-rc1 review patch.  If anyone has any objections, please let me know.

------------------


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
[lizf: Backported to 3.4:
 - adjust context
 - no KVM_EXIT_S390_TSCH and KVM_EXIT_DEBUG in 3.4]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 arch/s390/kvm/kvm-s390.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 53c973e..0f250d1 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -566,17 +566,6 @@ rerun_vcpu:
 
 	BUG_ON(vcpu->kvm->arch.float_int.local_int[vcpu->vcpu_id] == NULL);
 
-	switch (kvm_run->exit_reason) {
-	case KVM_EXIT_S390_SIEIC:
-	case KVM_EXIT_UNKNOWN:
-	case KVM_EXIT_INTR:
-	case KVM_EXIT_S390_RESET:
-	case KVM_EXIT_S390_UCONTROL:
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

