Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759905AbaIOXCY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 19:02:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50804 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757584AbaIOWN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:13:57 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 179/187] powerpc/thp: Add write barrier after updating the valid bit
Date: Mon, 15 Sep 2014 15:09:49 -0700
Message-Id: <1410818997-9432-180-git-send-email-kamal@canonical.com>
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

commit b0aa44a3dfae3d8f45bd1264349aa87f87b7774f upstream.

With hugepages, we store the hpte valid information in the pte page
whose address is stored in the second half of the PMD. Use a
write barrier to make sure clearing pmd busy bit and updating
hpte valid info are ordered properly.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/powerpc/mm/hugepage-hash64.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/mm/hugepage-hash64.c b/arch/powerpc/mm/hugepage-hash64.c
index 34de9e0..f50c4df 100644
--- a/arch/powerpc/mm/hugepage-hash64.c
+++ b/arch/powerpc/mm/hugepage-hash64.c
@@ -168,8 +168,11 @@ repeat:
 		mark_hpte_slot_valid(hpte_slot_array, index, slot);
 	}
 	/*
-	 * No need to use ldarx/stdcx here
+	 * The hpte valid is stored in the pgtable whose address is in the
+	 * second half of the PMD. Order this against clearing of the busy bit in
+	 * huge pmd.
 	 */
+	smp_wmb();
 	*pmdp = __pmd(new_pmd & ~_PAGE_BUSY);
 	return 0;
 }
-- 
1.9.1

