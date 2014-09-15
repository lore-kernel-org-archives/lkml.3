Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596AbaIOWN5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:13:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50791 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755427AbaIOWNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:13:52 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 184/187] powerpc/thp: Use ACCESS_ONCE when loading pmdp
Date: Mon, 15 Sep 2014 15:09:54 -0700
Message-Id: <1410818997-9432-185-git-send-email-kamal@canonical.com>
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

commit 7e467245bf5226db34c4b12d3cbacfa2f7a15a8b upstream.

We would get wrong results in compiler recomputed old_pmd. Avoid
that by using ACCESS_ONCE

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/powerpc/mm/hugepage-hash64.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/mm/hugepage-hash64.c b/arch/powerpc/mm/hugepage-hash64.c
index e0da847..7d86c86 100644
--- a/arch/powerpc/mm/hugepage-hash64.c
+++ b/arch/powerpc/mm/hugepage-hash64.c
@@ -84,7 +84,9 @@ int __hash_page_thp(unsigned long ea, unsigned long access, unsigned long vsid,
 	 * atomically mark the linux large page PMD busy and dirty
 	 */
 	do {
-		old_pmd = pmd_val(*pmdp);
+		pmd_t pmd = ACCESS_ONCE(*pmdp);
+
+		old_pmd = pmd_val(pmd);
 		/* If PMD busy, retry the access */
 		if (unlikely(old_pmd & _PAGE_BUSY))
 			return 0;
-- 
1.9.1

