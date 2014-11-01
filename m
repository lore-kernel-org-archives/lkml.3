Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453AbaKAXDy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 19:03:54 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60027 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751391AbaKAWj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 18:39:26 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David Hildenbrand" <dahi@linux.vnet.ibm.com>,
        "Cornelia Huck" <cornelia.huck@de.ibm.com>,
        "Christian Borntraeger" <borntraeger@de.ibm.com>
Date: Sat, 01 Nov 2014 22:28:03 +0000
Message-ID: <lsq.1414880883.728071678@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 006/102] KVM: s390: Fix user triggerable bug in dead code
In-Reply-To: <lsq.1414880882.522510247@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.64-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/s390/kvm/kvm-s390.c | 13 -------------
 1 file changed, 13 deletions(-)

--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -516,16 +516,6 @@ rerun_vcpu:
 
 	BUG_ON(vcpu->kvm->arch.float_int.local_int[vcpu->vcpu_id] == NULL);
 
-	switch (kvm_run->exit_reason) {
-	case KVM_EXIT_S390_SIEIC:
-	case KVM_EXIT_UNKNOWN:
-	case KVM_EXIT_INTR:
-	case KVM_EXIT_S390_RESET:
-		break;
-	default:
-		BUG();
-	}
-
 	vcpu->arch.sie_block->gpsw.mask = kvm_run->psw_mask;
 	vcpu->arch.sie_block->gpsw.addr = kvm_run->psw_addr;
 

