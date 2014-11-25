Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917AbaKYMll (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 07:41:41 -0500
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:43380 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754264AbaKYMis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 07:38:48 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: "linux-arch@vger.kernel.org, linux-mips@linux-mips.org, linux-x86_64@vger.kernel.org, linux-s390"@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>, paulmck@linux.vnet.ibm.com,
        mingo@kernel.org, torvalds@linux-foundation.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Russell King <linux@arm.linux.org.uk>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCHv2 02/10] kernel: Provide READ_ONCE and ASSIGN_ONCE
Date: Tue, 25 Nov 2014 13:38:29 +0100
Message-Id: <1416919117-50652-3-git-send-email-borntraeger@de.ibm.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1416919117-50652-1-git-send-email-borntraeger@de.ibm.com>
References: <1416919117-50652-1-git-send-email-borntraeger@de.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14112512-0017-0000-0000-000001F84C81
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ACCESS_ONCE does not work reliably on non-scalar types. For
example gcc 4.6 and 4.7 might remove the volatile tag for such
accesses during the SRA (scalar replacement of aggregates) step
https://gcc.gnu.org/bugzilla/show_bug.cgi?id=58145)

Let's provide READ_ONCE/ASSIGN_ONCE that will do all accesses via
scalar types.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
---
 include/linux/compiler.h | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index d5ad7b1..0ff01f2 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -186,6 +186,40 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
 # define __UNIQUE_ID(prefix) __PASTE(__PASTE(__UNIQUE_ID_, prefix), __LINE__)
 #endif
 
+#include <linux/types.h>
+
+static __always_inline void __assign_once_size(volatile void *p, void *res, int size)
+{
+	switch (size) {
+	case 1: *(volatile u8 *)p = *(u8 *)res; break;
+	case 2: *(volatile u16 *)p = *(u16 *)res; break;
+	case 4: *(volatile u32 *)p = *(u32 *)res; break;
+#ifdef CONFIG_64BIT
+	case 8: *(volatile u64 *)p = *(u64 *)res; break;
+#endif
+       }
+}
+
+#define ASSIGN_ONCE(val, p) \
+      ({ typeof(p) __val; __val = val; __assign_once_size(&p, &__val, sizeof(__val)); __val; })
+
+
+static __always_inline void __read_once_size(volatile void *p, void *res, int size)
+{
+	switch (size) {
+	case 1: *(u8 *)res = *(volatile u8 *)p; break;
+	case 2: *(u16 *)res = *(volatile u16 *)p; break;
+	case 4: *(u32 *)res = *(volatile u32 *)p; break;
+#ifdef CONFIG_64BIT
+	case 8: *(u64 *)res = *(volatile u64 *)p; break;
+#endif
+       }
+}
+
+#define READ_ONCE(p) \
+      ({ typeof(p) __val; __read_once_size(&p, &__val, sizeof(__val)); __val; })
+
+
 #endif /* __KERNEL__ */
 
 #endif /* __ASSEMBLY__ */
-- 
1.9.3

