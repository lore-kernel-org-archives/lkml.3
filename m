Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933148AbbA2KlG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 05:41:06 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44737 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754896AbbA2JAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:00:04 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>,
        torvalds@linux-foundation.org, Thomas Gleixner <tglx@linutronix.de>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 159/176] x86, tls, ldt: Stop checking lm in LDT_empty
Date: Wed, 28 Jan 2015 15:29:49 +0100
Message-Id: <64eaeaddfb50adca98234b97782d9aa1e4bff60c.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Lutomirski <luto@amacapital.net>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit e30ab185c490e9a9381385529e0fd32f0a399495 upstream.

32-bit programs don't have an lm bit in their ABI, so they can't
reliably cause LDT_empty to return true without resorting to memset.
They shouldn't need to do this.

This should fix a longstanding, if minor, issue in all 64-bit kernels
as well as a potential regression in the TLS hardening code.

Fixes: 41bdc78544b8 x86/tls: Validate TLS entries to protect espfix
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Cc: torvalds@linux-foundation.org
Link: http://lkml.kernel.org/r/72a059de55e86ad5e2935c80aa91880ddf19d07c.1421954363.git.luto@amacapital.net
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/x86/include/asm/desc.h | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/desc.h b/arch/x86/include/asm/desc.h
index b90e5dfeee46..9210eebd079e 100644
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
2.2.2

