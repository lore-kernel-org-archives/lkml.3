Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751638Ab3GRExC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 00:53:02 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:54554 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378Ab3GRExA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 00:53:00 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: gleb@redhat.com
Cc: markus@trippelsdorf.de, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH] KVM: MMU: avoid fast page fault fixing mmio page fault
Date: Thu, 18 Jul 2013 12:52:37 +0800
Message-Id: <1374123157-11142-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071804-9574-0000-0000-000008C3B24C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, fast page fault tries to fix mmio page fault when the
generation number is invalid (spte.gen != kvm.gen) and returns to
guest to retry the fault since it sees the last spte is nonpresent
which causes infinity loop

It can be triggered only on AMD host since the mmio page fault is
recognized as ept-misconfig

Fix it by filtering the mmio page fault out in page_fault_can_be_fast

Reported-by: Markus Trippelsdorf <markus@trippelsdorf.de>
Tested-by: Markus Trippelsdorf <markus@trippelsdorf.de>
Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index bf7af1e..3a9493a 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -2811,6 +2811,13 @@ exit:
 static bool page_fault_can_be_fast(struct kvm_vcpu *vcpu, u32 error_code)
 {
 	/*
+	 * Do not fix the mmio spte with invalid generation number which
+	 * need to be updated by slow page fault path.
+	 */
+	if (unlikely(error_code & PFERR_RSVD_MASK))
+		return false;
+
+	/*
 	 * #PF can be fast only if the shadow page table is present and it
 	 * is caused by write-protect, that means we just need change the
 	 * W bit of the spte which can be done out of mmu-lock.
-- 
1.8.1.4

