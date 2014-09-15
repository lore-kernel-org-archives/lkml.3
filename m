Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757709AbaIOU0s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 16:26:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55158 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755715AbaIOThI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:37:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 3.14 029/114] powerpc/thp: Invalidate with vpn in loop
Date: Mon, 15 Sep 2014 12:25:29 -0700
Message-Id: <20140915192642.347461114@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192641.428509513@linuxfoundation.org>
References: <20140915192641.428509513@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/mm/hash_native_64.c |   23 +++++++----------------
 1 file changed, 7 insertions(+), 16 deletions(-)

--- a/arch/powerpc/mm/hash_native_64.c
+++ b/arch/powerpc/mm/hash_native_64.c
@@ -423,7 +423,7 @@ static void native_hugepage_invalidate(u
 				       unsigned char *hpte_slot_array,
 				       int psize, int ssize)
 {
-	int i, lock_tlbie;
+	int i;
 	struct hash_pte *hptep;
 	int actual_psize = MMU_PAGE_16M;
 	unsigned int max_hpte_count, valid;
@@ -462,22 +462,13 @@ static void native_hugepage_invalidate(u
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
 


