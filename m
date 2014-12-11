Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964960AbaLKOGV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 09:06:21 -0500
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:39814 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964794AbaLKOF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 09:05:29 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, paulmck@linux.vnet.ibm.com,
        torvalds@linux-foundation.org, George Spelvin <linux@horizon.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH 3.20] kernel: tighten rules for ACCESS ONCE
Date: Thu, 11 Dec 2014 15:05:12 +0100
Message-Id: <1418306712-17245-10-git-send-email-borntraeger@de.ibm.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1418306712-17245-1-git-send-email-borntraeger@de.ibm.com>
References: <1418306712-17245-1-git-send-email-borntraeger@de.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121114-0017-0000-0000-00000230BC3F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that all non-scalar users of ACCESS_ONCE have been converted
to READ_ONCE or ASSIGN once, lets tighten ACCESS_ONCE to only
work on scalar types.
This variant was proposed by Alexei Starovoitov.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/compiler.h | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 1437f02..6253521 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -443,12 +443,23 @@ static __always_inline void __assign_once_size(volatile void *p, void *res, int
  * to make the compiler aware of ordering is to put the two invocations of
  * ACCESS_ONCE() in different C statements.
  *
- * This macro does absolutely -nothing- to prevent the CPU from reordering,
- * merging, or refetching absolutely anything at any time.  Its main intended
- * use is to mediate communication between process-level code and irq/NMI
- * handlers, all running on the same CPU.
+ * ACCESS_ONCE will only work on scalar types. For union types, ACCESS_ONCE
+ * on a union member will work as long as the size of the member matches the
+ * size of the union and the size is smaller than word size.
+ *
+ * The major use cases of ACCESS_ONCE used to be (1) Mediating communication
+ * between process-level code and irq/NMI handlers, all running on the same CPU,
+ * and (2) Ensuring that the compiler does not  fold, spindle, or otherwise
+ * mutilate accesses that either do not require ordering or that interact
+ * with an explicit memory barrier or atomic instruction that provides the
+ * required ordering.
+ *
+ * If possible use READ_ONCE/ASSIGN_ONCE instead.
  */
-#define ACCESS_ONCE(x) (*(volatile typeof(x) *)&(x))
+#define __ACCESS_ONCE(x) ({ \
+	 __maybe_unused typeof(x) __var = 0; \
+	(volatile typeof(x) *)&(x); })
+#define ACCESS_ONCE(x) (*__ACCESS_ONCE(x))
 
 /* Ignore/forbid kprobes attach on very low level functions marked by this attribute: */
 #ifdef CONFIG_KPROBES
-- 
1.9.3

