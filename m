Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872AbaIZKAL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:00:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33005 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755087AbaIZJql (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:41 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 056/142] powerpc/thp: Invalidate with vpn in loop
Date: Fri, 26 Sep 2014 11:44:27 +0200
Message-Id: <5611f07c012a8174a1cd5c9b3ced93810d479989.1411724724.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/powerpc/mm/hash_native_64.c | 23 +++++++----------------
 1 file changed, 7 insertions(+), 16 deletions(-)

diff --git a/arch/powerpc/mm/hash_native_64.c b/arch/powerpc/mm/hash_native_64.c
index 9197691fd5d5..9ca9c160dee4 100644
--- a/arch/powerpc/mm/hash_native_64.c
+++ b/arch/powerpc/mm/hash_native_64.c
@@ -418,7 +418,7 @@ static void native_hugepage_invalidate(unsigned long vsid,
 				       unsigned char *hpte_slot_array,
 				       int psize, int ssize)
 {
-	int i, lock_tlbie;
+	int i;
 	struct hash_pte *hptep;
 	int actual_psize = MMU_PAGE_16M;
 	unsigned int max_hpte_count, valid;
@@ -457,22 +457,13 @@ static void native_hugepage_invalidate(unsigned long vsid,
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
2.1.0

