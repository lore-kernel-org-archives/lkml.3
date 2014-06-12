Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218AbaFLQXg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 12:23:36 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:42281 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756131AbaFLQXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 12:23:34 -0400
From: Tejun Heo <tj@kernel.org>
To: cl@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 01/12] percpu: disallow archs from overriding SHIFT_PERCPU_PTR()
Date: Thu, 12 Jun 2014 12:23:18 -0400
Message-Id: <1402590209-31610-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1402590209-31610-1-git-send-email-tj@kernel.org>
References: <1402590209-31610-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It has been about half a decade since all archs started using the
dynamic percpu allocator and thus the same SHIFT_PERCPU_PTR()
implementation.  There's no benefit in overriding SHIFT_PERCPU_PTR()
anymore.

Remove #ifndef around it to clarify that this is identical regardless
of the arch.

This patch doesn't cause any functional difference.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/asm-generic/percpu.h | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/include/asm-generic/percpu.h b/include/asm-generic/percpu.h
index 0703aa7..63d2b68 100644
--- a/include/asm-generic/percpu.h
+++ b/include/asm-generic/percpu.h
@@ -36,17 +36,14 @@ extern unsigned long __per_cpu_offset[NR_CPUS];
 #endif
 
 /*
- * Add a offset to a pointer but keep the pointer as is.
- *
- * Only S390 provides its own means of moving the pointer.
+ * Add an offset to a pointer but keep the pointer as-is.  Use RELOC_HIDE()
+ * to prevent the compiler from making incorrect assumptions about the
+ * pointer value.  The weird cast keeps both GCC and sparse happy.
  */
-#ifndef SHIFT_PERCPU_PTR
-/* Weird cast keeps both GCC and sparse happy. */
 #define SHIFT_PERCPU_PTR(__p, __offset)	({				\
 	__verify_pcpu_ptr((__p));					\
 	RELOC_HIDE((typeof(*(__p)) __kernel __force *)(__p), (__offset)); \
 })
-#endif
 
 /*
  * A percpu variable may point to a discarded regions. The following are
-- 
1.9.3

