Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605AbaKXNDs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 08:03:48 -0500
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:58607 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753483AbaKXNDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 08:03:41 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: "linux-arch@vger.kernel.org, linux-mips@linux-mips.org, linux-x86_64@vger.kernel.org, linux-s390"@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>, paulmck@linux.vnet.ibm.com,
        mingo@kernel.org, torvalds@linux-foundation.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH/RFC 7/7] kernel: Force ACCESS_ONCE to work only on scalar types
Date: Mon, 24 Nov 2014 14:03:30 +0100
Message-Id: <1416834210-61738-8-git-send-email-borntraeger@de.ibm.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1416834210-61738-1-git-send-email-borntraeger@de.ibm.com>
References: <1416834210-61738-1-git-send-email-borntraeger@de.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14112413-0029-0000-0000-000001CF0D6E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACCESS_ONCE does not work reliably on non-scalar types. For
example gcc 4.6 and 4.7 might remove the volatile tag for such
accesses during the SRA (scalar replacement of aggregates) steps.
see  https://gcc.gnu.org/bugzilla/show_bug.cgi?id=58145

This patch is based on an initial proof-of-concept from Linus
Torvalds that causes compile errors for such accesses.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 include/linux/compiler.h | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index d5ad7b1..8a92c93 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -377,8 +377,18 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
  * merging, or refetching absolutely anything at any time.  Its main intended
  * use is to mediate communication between process-level code and irq/NMI
  * handlers, all running on the same CPU.
+ *
+ * ACCESS_ONCE will only work on scalar types. For union types, ACCESS_ONCE
+ * on a union member will work as long as the size of the member matches the
+ * size of the union and the size is smaller than word size. See the x86
+ * spinlock implementation as an example. For other cases like page table
+ * structures, a barrier might be a good alternative.
  */
-#define ACCESS_ONCE(x) (*(volatile typeof(x) *)&(x))
+#define get_scalar_volatile_pointer(x) ({ \
+	typeof(x) *__p = &(x); \
+	volatile typeof(x) *__vp = __p; \
+	(void)(long)*__p; __vp; })
+#define ACCESS_ONCE(x) (*get_scalar_volatile_pointer(x))
 
 /* Ignore/forbid kprobes attach on very low level functions marked by this attribute: */
 #ifdef CONFIG_KPROBES
-- 
1.9.3

