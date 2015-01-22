Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209AbbAVUNz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 15:13:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:32914 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbbAVUNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 15:13:54 -0500
Date: Thu, 22 Jan 2015 12:13:42 -0800
From: tip-bot for Andy Lutomirski <tipbot@zytor.com>
Message-ID: <tip-e30ab185c490e9a9381385529e0fd32f0a399495@git.kernel.org>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, tglx@linutronix.de,
        luto@amacapital.net, hpa@zytor.com
Reply-To: hpa@zytor.com, luto@amacapital.net, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, mingo@kernel.org
In-Reply-To: <72a059de55e86ad5e2935c80aa91880ddf19d07c.1421954363.git.luto@amacapital.net>
References: <72a059de55e86ad5e2935c80aa91880ddf19d07c.1421954363.git.luto@amacapital.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, tls, ldt: Stop checking lm in LDT_empty
Git-Commit-ID: e30ab185c490e9a9381385529e0fd32f0a399495
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e30ab185c490e9a9381385529e0fd32f0a399495
Gitweb:     http://git.kernel.org/tip/e30ab185c490e9a9381385529e0fd32f0a399495
Author:     Andy Lutomirski <luto@amacapital.net>
AuthorDate: Thu, 22 Jan 2015 11:27:58 -0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 22 Jan 2015 21:11:06 +0100

x86, tls, ldt: Stop checking lm in LDT_empty

32-bit programs don't have an lm bit in their ABI, so they can't
reliably cause LDT_empty to return true without resorting to memset.
They shouldn't need to do this.

This should fix a longstanding, if minor, issue in all 64-bit kernels
as well as a potential regression in the TLS hardening code.

Fixes: 41bdc78544b8 x86/tls: Validate TLS entries to protect espfix
Cc: stable@vger.kernel.org
Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Cc: torvalds@linux-foundation.org
Link: http://lkml.kernel.org/r/72a059de55e86ad5e2935c80aa91880ddf19d07c.1421954363.git.luto@amacapital.net
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/desc.h | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/desc.h b/arch/x86/include/asm/desc.h
index 50d033a..fc237fd 100644
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
