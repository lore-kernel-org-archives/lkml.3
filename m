Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756513Ab3AYKoH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 05:44:07 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40873 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755085Ab3AYKoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 05:44:03 -0500
Date: Fri, 25 Jan 2013 02:43:45 -0800
From: tip-bot for Jan Beulich <JBeulich@suse.com>
Message-ID: <tip-05fbf4d6fc6a3c0c3e63b77979c9311596716d10@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        konrad.wilk@oracle.com, torvalds@linux-foundation.org,
        jbeulich@suse.com, JBeulich@suse.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, torvalds@linux-foundation.org,
        JBeulich@suse.com, jbeulich@suse.com, tglx@linutronix.de
In-Reply-To: <5093E4F302000078000A6162@nat28.tlf.novell.com>
References: <5093E4F302000078000A6162@nat28.tlf.novell.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asm] x86/xor: Make virtualization friendly
Git-Commit-ID: 05fbf4d6fc6a3c0c3e63b77979c9311596716d10
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 25 Jan 2013 02:43:51 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  05fbf4d6fc6a3c0c3e63b77979c9311596716d10
Gitweb:     http://git.kernel.org/tip/05fbf4d6fc6a3c0c3e63b77979c9311596716d10
Author:     Jan Beulich <JBeulich@suse.com>
AuthorDate: Fri, 2 Nov 2012 14:21:23 +0000
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 25 Jan 2013 09:23:51 +0100

x86/xor: Make virtualization friendly

In virtualized environments, the CR0.TS management needed here
can be a lot slower than anticipated by the original authors of
this code, which particularly means that in such cases forcing
the use of SSE- (or MMX-) based implementations is not desirable
- actual measurements should always be done in that case.

For consistency, pull into the shared (32- and 64-bit) header
not only the inclusion of the generic code, but also that of the
AVX variants.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Link: http://lkml.kernel.org/r/5093E4F302000078000A6162@nat28.tlf.novell.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/xor.h    |  8 +++++++-
 arch/x86/include/asm/xor_32.h | 22 ++++++++++------------
 arch/x86/include/asm/xor_64.h | 10 ++++++----
 3 files changed, 23 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/xor.h b/arch/x86/include/asm/xor.h
index d882975..55cd464 100644
--- a/arch/x86/include/asm/xor.h
+++ b/arch/x86/include/asm/xor.h
@@ -487,6 +487,12 @@ static struct xor_block_template xor_block_sse_pf64 = {
 
 #undef XOR_CONSTANT_CONSTRAINT
 
+/* Also try the AVX routines */
+#include <asm/xor_avx.h>
+
+/* Also try the generic routines. */
+#include <asm-generic/xor.h>
+
 #ifdef CONFIG_X86_32
 # include <asm/xor_32.h>
 #else
@@ -494,6 +500,6 @@ static struct xor_block_template xor_block_sse_pf64 = {
 #endif
 
 #define XOR_SELECT_TEMPLATE(FASTEST) \
-	AVX_SELECT(FASTEST)
+	(cpu_has_hypervisor ? (FASTEST) : AVX_SELECT(FASTEST))
 
 #endif /* _ASM_X86_XOR_H */
diff --git a/arch/x86/include/asm/xor_32.h b/arch/x86/include/asm/xor_32.h
index ce05722..fe7a277 100644
--- a/arch/x86/include/asm/xor_32.h
+++ b/arch/x86/include/asm/xor_32.h
@@ -537,12 +537,6 @@ static struct xor_block_template xor_block_pIII_sse = {
 	.do_5 = xor_sse_5,
 };
 
-/* Also try the AVX routines */
-#include <asm/xor_avx.h>
-
-/* Also try the generic routines.  */
-#include <asm-generic/xor.h>
-
 /* We force the use of the SSE xor block because it can write around L2.
    We may also be able to load into the L1 only depending on how the cpu
    deals with a load to a line that is being prefetched.  */
@@ -553,15 +547,19 @@ do {							\
 	if (cpu_has_xmm) {				\
 		xor_speed(&xor_block_pIII_sse);		\
 		xor_speed(&xor_block_sse_pf64);		\
-	} else if (cpu_has_mmx) {			\
+		if (!cpu_has_hypervisor)		\
+			break;				\
+	}						\
+	if (cpu_has_mmx) {				\
 		xor_speed(&xor_block_pII_mmx);		\
 		xor_speed(&xor_block_p5_mmx);		\
-	} else {					\
-		xor_speed(&xor_block_8regs);		\
-		xor_speed(&xor_block_8regs_p);		\
-		xor_speed(&xor_block_32regs);		\
-		xor_speed(&xor_block_32regs_p);		\
+		if (!cpu_has_hypervisor)		\
+			break;				\
 	}						\
+	xor_speed(&xor_block_8regs);			\
+	xor_speed(&xor_block_8regs_p);			\
+	xor_speed(&xor_block_32regs);			\
+	xor_speed(&xor_block_32regs_p);			\
 } while (0)
 
 #endif /* _ASM_X86_XOR_32_H */
diff --git a/arch/x86/include/asm/xor_64.h b/arch/x86/include/asm/xor_64.h
index 546f1e3..30f9c43 100644
--- a/arch/x86/include/asm/xor_64.h
+++ b/arch/x86/include/asm/xor_64.h
@@ -9,10 +9,6 @@ static struct xor_block_template xor_block_sse = {
 	.do_5 = xor_sse_5,
 };
 
-
-/* Also try the AVX routines */
-#include <asm/xor_avx.h>
-
 /* We force the use of the SSE xor block because it can write around L2.
    We may also be able to load into the L1 only depending on how the cpu
    deals with a load to a line that is being prefetched.  */
@@ -22,6 +18,12 @@ do {						\
 	AVX_XOR_SPEED;				\
 	xor_speed(&xor_block_sse_pf64);		\
 	xor_speed(&xor_block_sse);		\
+	if (cpu_has_hypervisor) {		\
+		xor_speed(&xor_block_8regs);	\
+		xor_speed(&xor_block_8regs_p);	\
+		xor_speed(&xor_block_32regs);	\
+		xor_speed(&xor_block_32regs_p);	\
+	}					\
 } while (0)
 
 #endif /* _ASM_X86_XOR_64_H */
