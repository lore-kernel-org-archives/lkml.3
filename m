Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759176AbaIOWh6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:37:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51143 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758193AbaIOWTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:19:08 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 183/187] powerpc/thp: Invalidate with vpn in loop
Date: Mon, 15 Sep 2014 15:09:53 -0700
Message-Id: <1410818997-9432-184-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

commit 969b7b208f7408712a3526856e4ae60ad13f6928 upstream.

As per ISA, for 4k base page size we compare 14..65 bits of VA specified
with the entry_VA in tlb. That implies we need to make sure we do a
tlbie with all the possible 4k va we used to access the 16MB hugepage.
With 64k base page size we compare 14..57 bits of VA. Hence we cannot
ignore the lower 24 bits of va while tlbie .We also cannot tlb
invalidate a 16MB entry with just one tlbie instruction because
we don't track which va was used to instantiate the tlb entry.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/powerpc/mm/hash_native_64.c | 23 +++++++----------------
 1 file changed, 7 insertions(+), 16 deletions(-)

diff --git a/arch/powerpc/mm/hash_native_64.c b/arch/powerpc/mm/hash_native_64.c
index 44886c2..838de8e 100644
--- a/arch/powerpc/mm/hash_native_64.c
+++ b/arch/powerpc/mm/hash_native_64.c
@@ -423,7 +423,7 @@ static void native_hugepage_invalidate(unsigned long vsid,
 				       unsigned char *hpte_slot_array,
 				       int psize, int ssize)
 {
-	int i, lock_tlbie;
+	int i;
 	struct hash_pte *hptep;
 	int actual_psize = MMU_PAGE_16M;
 	unsigned int max_hpte_count, valid;
@@ -462,22 +462,13 @@ static void native_hugepage_invalidate(unsigned long vsid,
 		else
 			/* Invalidate the hpte. NOTE: this also unlocks it */
 			hptep->v = 0;
+		/*
+		 * We need to do tlb invalidate for all the address, tlbie
+		 * instruction compares entry_VA in tlb with the VA specified
+		 * here
+		 */
+		tlbie(vpn, psize, actual_psize, ssize, 0);
 	}
-	/*
-	 * Since this is a hugepage, we just need a single tlbie.
-	 * use the last vpn.
-	 */
-	lock_tlbie = !mmu_has_feature(MMU_FTR_LOCKLESS_TLBIE);
-	if (lock_tlbie)
-		raw_spin_lock(&native_tlbie_lock);
-
-	asm volatile("ptesync":::"memory");
-	__tlbie(vpn, psize, actual_psize, ssize);
-	asm volatile("eieio; tlbsync; ptesync":::"memory");
-
-	if (lock_tlbie)
-		raw_spin_unlock(&native_tlbie_lock);
-
 	local_irq_restore(flags);
 }
 
-- 
1.9.1

