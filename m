Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933182AbbA1CRr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 21:17:47 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41026 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758675AbbA1B2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:28:12 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>, torvalds@linux-foundation.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 3.10 19/32] x86, tls, ldt: Stop checking lm in LDT_empty
Date: Tue, 27 Jan 2015 17:26:49 -0800
Message-Id: <20150128012629.890226663@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150128012627.081285723@linuxfoundation.org>
References: <20150128012627.081285723@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Lutomirski <luto@amacapital.net>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/desc.h |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/arch/x86/include/asm/desc.h
+++ b/arch/x86/include/asm/desc.h
@@ -251,7 +251,8 @@ static inline void native_load_tls(struc
 		gdt[GDT_ENTRY_TLS_MIN + i] = t->tls_array[i];
 }
 
-#define _LDT_empty(info)				\
+/* This intentionally ignores lm, since 32-bit apps don't have that field. */
+#define LDT_empty(info)					\
 	((info)->base_addr		== 0	&&	\
 	 (info)->limit			== 0	&&	\
 	 (info)->contents		== 0	&&	\
@@ -261,12 +262,6 @@ static inline void native_load_tls(struc
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


