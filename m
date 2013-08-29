Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932067Ab3H2Ub3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 16:31:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42060 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755974Ab3H2Ub1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 16:31:27 -0400
Date: Thu, 29 Aug 2013 13:31:05 -0700
From: "=?UTF-8?B?dGlwLWJvdCBmb3IgSmFuLVNpbW9uIE3DtmxsZXI=?=" 
	<tipbot@zytor.com>
Message-ID: <tip-bdfc017eead9bc17cd23317ff42eb7297cb9468a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        dl9pf@gmx.de, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dl9pf@gmx.de, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1377803585-5913-3-git-send-email-dl9pf@gmx.de>
References: <1377803585-5913-3-git-send-email-dl9pf@gmx.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86, asm: Fix a compilation issue with clang
Git-Commit-ID: bdfc017eead9bc17cd23317ff42eb7297cb9468a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 29 Aug 2013 13:31:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bdfc017eead9bc17cd23317ff42eb7297cb9468a
Gitweb:     http://git.kernel.org/tip/bdfc017eead9bc17cd23317ff42eb7297cb9468a
Author:     Jan-Simon Möller <dl9pf@gmx.de>
AuthorDate: Thu, 29 Aug 2013 21:13:05 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 29 Aug 2013 13:26:33 -0700

x86, asm: Fix a compilation issue with clang

Clang does not support the "shortcut" we're taking here for gcc (see below).
The patch uses the macro _ASM_DX to do the job.

>From arch/x86/include/asm/uaccess.h:
/*
 * Careful: we have to cast the result to the type of the pointer
 * for sign reasons.
 *
 * The use of %edx as the register specifier is a bit of a
 * simplification, as gcc only cares about it as the starting point
 * and not size: for a 64-bit value it will use %ecx:%edx on 32 bits
 * (%ecx being the next register in gcc's x86 register sequence), and
 * %rdx on 64 bits.
 */

[ hpa: I consider this a compatibility bug in clang as this reflects a
  bit of a misunderstanding about how register strings are used by
  gcc, but the workaround is straightforward and there is no
  particular reason to not do it. ]

Signed-off-by: Jan-Simon Möller <dl9pf@gmx.de>
Link: http://lkml.kernel.org/r/1377803585-5913-3-git-send-email-dl9pf@gmx.de
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/uaccess.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 5ee2687..f715fee 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -162,7 +162,7 @@ __typeof__(__builtin_choose_expr(sizeof(x) > sizeof(0UL), 0ULL, 0UL))
 #define get_user(x, ptr)						\
 ({									\
 	int __ret_gu;							\
-	register __inttype(*(ptr)) __val_gu asm("%edx");		\
+	register __inttype(*(ptr)) __val_gu asm("%"_ASM_DX);		\
 	__chk_user_ptr(ptr);						\
 	might_fault();							\
 	asm volatile("call __get_user_%P3"				\
