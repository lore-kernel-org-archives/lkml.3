Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753209AbaEVQtN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 12:49:13 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48927 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753113AbaEVQtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 12:49:10 -0400
From: Will Deacon <will.deacon@arm.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, monstr@monstr.eu, dhowells@redhat.com, broonie@linaro.org,
        benh@kernel.crashing.org, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, Will Deacon <will.deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH v2 16/18] x86: io: implement dummy relaxed accessor macros for writes
Date: Thu, 22 May 2014 17:47:28 +0100
Message-Id: <1400777250-17335-17-git-send-email-will.deacon@arm.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1400777250-17335-1-git-send-email-will.deacon@arm.com>
References: <1400777250-17335-1-git-send-email-will.deacon@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

write{b,w,l,q}_relaxed are implemented by some architectures in order to
permit memory-mapped I/O accesses with weaker barrier semantics than the
non-relaxed variants.

This patch adds dummy macros for the read and write accessors to x86,
which simply expand to the non-relaxed variants. Note that this
strengthens the relaxed read accessors, since they are now ordered with
respect to each other by way of a compiler barrier.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
---
 arch/x86/include/asm/io.h | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
index b8237d8a1e0c..56d6d43aca9b 100644
--- a/arch/x86/include/asm/io.h
+++ b/arch/x86/include/asm/io.h
@@ -67,13 +67,16 @@ build_mmio_write(__writeb, "b", unsigned char, "q", )
 build_mmio_write(__writew, "w", unsigned short, "r", )
 build_mmio_write(__writel, "l", unsigned int, "r", )
 
-#define readb_relaxed(a) __readb(a)
-#define readw_relaxed(a) __readw(a)
-#define readl_relaxed(a) __readl(a)
+#define readb_relaxed(a) readb(a)
+#define readw_relaxed(a) readw(a)
+#define readl_relaxed(a) readl(a)
 #define __raw_readb __readb
 #define __raw_readw __readw
 #define __raw_readl __readl
 
+#define writeb_relaxed(v, a) writeb(v, a)
+#define writew_relaxed(v, a) writew(v, a)
+#define writel_relaxed(v, a) writel(v, a)
 #define __raw_writeb __writeb
 #define __raw_writew __writew
 #define __raw_writel __writel
@@ -86,6 +89,7 @@ build_mmio_read(readq, "q", unsigned long, "=r", :"memory")
 build_mmio_write(writeq, "q", unsigned long, "r", :"memory")
 
 #define readq_relaxed(a)	readq(a)
+#define writeq_relaxed(v, a)	writeq(v, a)
 
 #define __raw_readq(a)		readq(a)
 #define __raw_writeq(val, addr)	writeq(val, addr)
-- 
1.9.2

