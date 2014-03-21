Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965663AbaCUAFH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 20:05:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36938 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760530AbaCUAE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:04:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Steve Capper <steve.capper@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 3.13 148/149] arm64: mm: Add double logical invert to pte accessors
Date: Thu, 20 Mar 2014 17:05:11 -0700
Message-Id: <20140321000442.091645252@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000436.377902063@linuxfoundation.org>
References: <20140321000436.377902063@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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
[steve.capper@linaro.org: rebased patch to leave pte_write alone to
allow for merge with 3.13 stable]
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/include/asm/pgtable.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -136,10 +136,10 @@ extern struct page *empty_zero_page;
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
 


