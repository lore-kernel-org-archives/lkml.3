Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751780Ab3K2HmV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 02:42:21 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:62164 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929Ab3K2HmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 02:42:20 -0500
Message-ID: <1385710934.11444.2.camel@phoenix>
Subject: [PATCH] include/linux/kernel.h: Make might_fault to be a nop for
 !MMU
From: Axel Lin <axel.lin@ingics.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Date: Fri, 29 Nov 2013 15:42:14 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No fault if !MUU, thus make might_fault to be a nop for !MMU.

This fixes below build error if
!CONFIG_MMU && (CONFIG_PROVE_LOCKING=y || CONFIG_DEBUG_ATOMIC_SLEEP=y):

arch/arm/kernel/built-in.o: In function `arch_ptrace':
arch/arm/kernel/ptrace.c:852: undefined reference to `might_fault'
arch/arm/kernel/built-in.o: In function `restore_sigframe':
arch/arm/kernel/signal.c:173: undefined reference to `might_fault'
arch/arm/kernel/signal.c:174: undefined reference to `might_fault'
arch/arm/kernel/signal.c:175: undefined reference to `might_fault'
arch/arm/kernel/signal.c:176: undefined reference to `might_fault'
arch/arm/kernel/built-in.o:arch/arm/kernel/signal.c:177: more undefined references to `might_fault' follow
make: *** [vmlinux] Error 1

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 include/linux/kernel.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 2ac0277..8b0ad48 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -193,7 +193,8 @@ extern int _cond_resched(void);
 		(__x < 0) ? -__x : __x;		\
 	})
 
-#if defined(CONFIG_PROVE_LOCKING) || defined(CONFIG_DEBUG_ATOMIC_SLEEP)
+#if defined(CONFIG_MMU) && \
+	(defined(CONFIG_PROVE_LOCKING) || defined(CONFIG_DEBUG_ATOMIC_SLEEP))
 void might_fault(void);
 #else
 static inline void might_fault(void) { }
-- 
1.8.1.2



