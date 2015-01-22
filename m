Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754283AbbAVT2O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 14:28:14 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:55596 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387AbbAVT2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 14:28:09 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: x86@kernel.org, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: Andy Lutomirski <luto@amacapital.net>, stable@vger.kernel.org
Subject: [PATCH 1/2] x86, tls, ldt: Stop checking lm in LDT_empty
Date: Thu, 22 Jan 2015 11:27:58 -0800
Message-Id: <72a059de55e86ad5e2935c80aa91880ddf19d07c.1421954363.git.luto@amacapital.net>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <cover.1421954363.git.luto@amacapital.net>
References: <cover.1421954363.git.luto@amacapital.net>
In-Reply-To: <cover.1421954363.git.luto@amacapital.net>
References: <cover.1421954363.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

32-bit programs don't have an lm bit in their ABI, so they can't
reliably cause LDT_empty to return true without resorting to memset.
They shouldn't need to do this.

This should fix a longstanding, if minor, issue in all 64-bit kernels
as well as a potential regression in the TLS hardening code.

Fixes: 41bdc78544b8 x86/tls: Validate TLS entries to protect espfix
Cc: stable@vger.kernel.org
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/include/asm/desc.h | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/desc.h b/arch/x86/include/asm/desc.h
index 50d033a8947d..fc237fd0259a 100644
--- a/arch/x86/include/asm/desc.h
+++ b/arch/x86/include/asm/desc.h
@@ -251,7 +251,8 @@ static inline void native_load_tls(struct thread_struct *t, unsigned int cpu)
 		gdt[GDT_ENTRY_TLS_MIN + i] = t->tls_array[i];
 }
 
-#define _LDT_empty(info)				\
+/* This intentionally ignores lm, since 32-bit apps don't have that field. */
+#define LDT_empty(info)					\
 	((info)->base_addr		== 0	&&	\
 	 (info)->limit			== 0	&&	\
 	 (info)->contents		== 0	&&	\
@@ -261,12 +262,6 @@ static inline void native_load_tls(struct thread_struct *t, unsigned int cpu)
 	 (info)->seg_not_present	== 1	&&	\
 	 (info)->useable		== 0)
 
-#ifdef CONFIG_X86_64
-#define LDT_empty(info) (_LDT_empty(info) && ((info)->lm == 0))
-#else
-#define LDT_empty(info) (_LDT_empty(info))
-#endif
-
 static inline void clear_LDT(void)
 {
 	set_ldt(NULL, 0);
-- 
2.1.0

