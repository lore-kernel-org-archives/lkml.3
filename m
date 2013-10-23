Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149Ab3JWNfO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 09:35:14 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:56077 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841Ab3JWN3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 09:29:55 -0400
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
To: gleb@redhat.com
Cc: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Subject: [PATCH v3 03/15] KVM: MMU: flush tlb if the spte can be locklessly modified
Date: Wed, 23 Oct 2013 21:29:21 +0800
Message-Id: <1382534973-13197-4-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1382534973-13197-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
References: <1382534973-13197-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102313-3864-0000-0000-00000AB58517
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Relax the tlb flush condition since we will write-protect the spte out of mmu
lock. Note lockless write-protection only marks the writable spte to readonly
and the spte can be writable only if both SPTE_HOST_WRITEABLE and
SPTE_MMU_WRITEABLE are set (that are tested by spte_is_locklessly_modifiable)

This patch is used to avoid this kind of race:

      VCPU 0                         VCPU 1
lockless wirte protection:
      set spte.w = 0
                                 lock mmu-lock

                                 write protection the spte to sync shadow page,
                                 see spte.w = 0, then without flush tlb

				 unlock mmu-lock

                                 !!! At this point, the shadow page can still be
                                     writable due to the corrupt tlb entry
     Flush all TLB

Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
---
 arch/x86/kvm/mmu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 8739208..62f18ec 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -595,7 +595,8 @@ static bool mmu_spte_update(u64 *sptep, u64 new_spte)
 	 * we always atomicly update it, see the comments in
 	 * spte_has_volatile_bits().
 	 */
-	if (is_writable_pte(old_spte) && !is_writable_pte(new_spte))
+	if (spte_is_locklessly_modifiable(old_spte) &&
+	      !is_writable_pte(new_spte))
 		ret = true;
 
 	if (!shadow_accessed_mask)
-- 
1.8.1.4

