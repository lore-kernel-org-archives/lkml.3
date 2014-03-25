Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754786AbaCYRUu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 13:20:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55770 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753434AbaCYRUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 13:20:45 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Steve Capper <steve.capper@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 81/81] arm64: mm: Add double logical invert to pte accessors
Date: Tue, 25 Mar 2014 10:16:34 -0700
Message-Id: <1395767794-5012-82-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1395767794-5012-1-git-send-email-kamal@canonical.com>
References: <1395767794-5012-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.20 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steve Capper <steve.capper@linaro.org>

commit 84fe6826c28f69d8708bd575faed7f75e6b6f57f upstream.

Page table entries on ARM64 are 64 bits, and some pte functions such as
pte_dirty return a bitwise-and of a flag with the pte value. If the
flag to be tested resides in the upper 32 bits of the pte, then we run
into the danger of the result being dropped if downcast.

For example:
	gather_stats(page, md, pte_dirty(*pte), 1);
where pte_dirty(*pte) is downcast to an int.

This patch adds a double logical invert to all the pte_ accessors to
ensure predictable downcasting.

Signed-off-by: Steve Capper <steve.capper@linaro.org>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
[ kamal: backport to 3.8 (n/a to pte_write in 3.8) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm64/include/asm/pgtable.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index e333a24..72dd657 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -129,10 +129,10 @@ extern struct page *empty_zero_page;
 /*
  * The following only work if pte_present(). Undefined behaviour otherwise.
  */
-#define pte_present(pte)	(pte_val(pte) & (PTE_VALID | PTE_PROT_NONE))
-#define pte_dirty(pte)		(pte_val(pte) & PTE_DIRTY)
-#define pte_young(pte)		(pte_val(pte) & PTE_AF)
-#define pte_special(pte)	(pte_val(pte) & PTE_SPECIAL)
+#define pte_present(pte)	(!!(pte_val(pte) & (PTE_VALID | PTE_PROT_NONE)))
+#define pte_dirty(pte)		(!!(pte_val(pte) & PTE_DIRTY))
+#define pte_young(pte)		(!!(pte_val(pte) & PTE_AF))
+#define pte_special(pte)	(!!(pte_val(pte) & PTE_SPECIAL))
 #define pte_write(pte)		(!(pte_val(pte) & PTE_RDONLY))
 #define pte_exec(pte)		(!(pte_val(pte) & PTE_UXN))
 
-- 
1.8.3.2

