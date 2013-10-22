Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616Ab3JVQJu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 12:09:50 -0400
Received: from mga09.intel.com ([134.134.136.24]:3152 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753875Ab3JVQIH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 12:08:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="422985816"
From: Andi Kleen <andi@firstfloor.org>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 5/7] x86: Use inline assembler instead of global register variable to get sp v2
Date: Tue, 22 Oct 2013 09:07:57 -0700
Message-Id: <1382458079-24450-6-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1382458079-24450-1-git-send-email-andi@firstfloor.org>
References: <1382458079-24450-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

LTO in gcc 4.6/47. has trouble with global register variables. They were used
to read the stack pointer. Use a simple inline assembler statement with
a mov instead.

This also helps LLVM/clang, who do not support global register
variables.

v2: More general asm constraint. Fix description (Jan Beulich)
Cc: x86@kernel.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/thread_info.h | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index 2781119..ffda484 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -166,9 +166,11 @@ struct thread_info {
  */
 #ifndef __ASSEMBLY__
 
-
-/* how to get the current stack pointer from C */
-register unsigned long current_stack_pointer asm("esp") __used;
+#define current_stack_pointer ({		\
+	unsigned long sp;			\
+	asm("mov %%esp,%0" : "=g" (sp));	\
+	sp;					\
+})
 
 /* how to get the thread information struct from C */
 static inline struct thread_info *current_thread_info(void)
-- 
1.8.3.1

