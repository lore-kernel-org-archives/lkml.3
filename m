Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158AbaHTMA4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 08:00:56 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58948 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752552AbaHTLoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:44:10 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 049/104] sparc64: Give more detailed information in {pgd,pmd}_ERROR() and kill pte_ERROR().
Date: Wed, 20 Aug 2014 13:43:12 +0200
Message-Id: <a483fe775115b14ad2f68b4405aa0493663a8b12.1408535000.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
References: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
In-Reply-To: <cover.1408535000.git.jslaby@suse.cz>
References: <cover.1408535000.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "David S. Miller" <davem@davemloft.net>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit fe866433f843b080246ce729b5e6b27b5f5d9a58 ]

pte_ERROR() is not used anywhere, delete it.

For pgd_ERROR() and pmd_ERROR(), output something similar to x86, giving the address
of the pgd/pmd as well as it's value.

Also provide the caller, since these macros are invoked from pgd_clear_bad() and
pmd_clear_bad() which provides little context as to what high level operation was
occuring when the BAD state was detected.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/sparc/include/asm/pgtable_64.h | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/sparc/include/asm/pgtable_64.h b/arch/sparc/include/asm/pgtable_64.h
index d80b4204a774..cadf36793595 100644
--- a/arch/sparc/include/asm/pgtable_64.h
+++ b/arch/sparc/include/asm/pgtable_64.h
@@ -119,9 +119,12 @@ static inline bool kern_addr_valid(unsigned long addr)
 /* Kernel has a separate 44bit address space. */
 #define FIRST_USER_ADDRESS	0
 
-#define pte_ERROR(e)	__builtin_trap()
-#define pmd_ERROR(e)	__builtin_trap()
-#define pgd_ERROR(e)	__builtin_trap()
+#define pmd_ERROR(e)							\
+	pr_err("%s:%d: bad pmd %p(%016lx) seen at (%pS)\n",		\
+	       __FILE__, __LINE__, &(e), pmd_val(e), __builtin_return_address(0))
+#define pgd_ERROR(e)							\
+	pr_err("%s:%d: bad pgd %p(%016lx) seen at (%pS)\n",		\
+	       __FILE__, __LINE__, &(e), pgd_val(e), __builtin_return_address(0))
 
 #endif /* !(__ASSEMBLY__) */
 
-- 
2.0.4

