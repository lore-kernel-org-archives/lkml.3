Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700AbbAMUZb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 15:25:31 -0500
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:42526 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572AbbAMUZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 15:25:12 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Cc: Peter Zijlstra <peterz@infradead.org>, Davidlohr Bueso <dave@stgolabs.net>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-arch@vger.kernel.org,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [GIT PULL 1/1] kernel: Change ASSIGN_ONCE(val, x) to WRITE_ONCE(x, val)
Date: Tue, 13 Jan 2015 21:25:05 +0100
Message-Id: <1421180705-44875-2-git-send-email-borntraeger@de.ibm.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1421180705-44875-1-git-send-email-borntraeger@de.ibm.com>
References: <1421180705-44875-1-git-send-email-borntraeger@de.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15011320-0041-0000-0000-000002DFD20E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Feedback has shown that WRITE_ONCE(x, val) is easier to use than
ASSIGN_ONCE(val,x).
There are no in-tree users yet, so lets change it for 3.19.

Signed-off-by: Christian Borntraeger <borntraeger@de.ibm.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
Acked-by: Davidlohr Bueso <dave@stgolabs.net>
Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/compiler.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index a1c81f8..33063f8 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -215,7 +215,7 @@ static __always_inline void __read_once_size(volatile void *p, void *res, int si
 	}
 }
 
-static __always_inline void __assign_once_size(volatile void *p, void *res, int size)
+static __always_inline void __write_once_size(volatile void *p, void *res, int size)
 {
 	switch (size) {
 	case 1: *(volatile __u8 *)p = *(__u8 *)res; break;
@@ -235,15 +235,15 @@ static __always_inline void __assign_once_size(volatile void *p, void *res, int
 /*
  * Prevent the compiler from merging or refetching reads or writes. The
  * compiler is also forbidden from reordering successive instances of
- * READ_ONCE, ASSIGN_ONCE and ACCESS_ONCE (see below), but only when the
+ * READ_ONCE, WRITE_ONCE and ACCESS_ONCE (see below), but only when the
  * compiler is aware of some particular ordering.  One way to make the
  * compiler aware of ordering is to put the two invocations of READ_ONCE,
- * ASSIGN_ONCE or ACCESS_ONCE() in different C statements.
+ * WRITE_ONCE or ACCESS_ONCE() in different C statements.
  *
  * In contrast to ACCESS_ONCE these two macros will also work on aggregate
  * data types like structs or unions. If the size of the accessed data
  * type exceeds the word size of the machine (e.g., 32 bits or 64 bits)
- * READ_ONCE() and ASSIGN_ONCE()  will fall back to memcpy and print a
+ * READ_ONCE() and WRITE_ONCE()  will fall back to memcpy and print a
  * compile-time warning.
  *
  * Their two major use cases are: (1) Mediating communication between
@@ -257,8 +257,8 @@ static __always_inline void __assign_once_size(volatile void *p, void *res, int
 #define READ_ONCE(x) \
 	({ typeof(x) __val; __read_once_size(&x, &__val, sizeof(__val)); __val; })
 
-#define ASSIGN_ONCE(val, x) \
-	({ typeof(x) __val; __val = val; __assign_once_size(&x, &__val, sizeof(__val)); __val; })
+#define WRITE_ONCE(x, val) \
+	({ typeof(x) __val; __val = val; __write_once_size(&x, &__val, sizeof(__val)); __val; })
 
 #endif /* __KERNEL__ */
 
-- 
1.9.3

