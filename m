Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751015AbaLOOrR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:47:17 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38725 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774AbaLOO2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:28:34 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Markos Chandras <markos.chandras@imgtec.com>, linux-mips@linux-mips.org,
        Ralf Baechle <ralf@linux-mips.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 106/168] MIPS: r4kcache: Add EVA case for protected_writeback_dcache_line
Date: Mon, 15 Dec 2014 14:26:00 +0000
Message-Id: <1418653622-21105-107-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markos Chandras <markos.chandras@imgtec.com>

commit 83fd43449baaf88fe5c03dd0081a062041837c51 upstream.

Commit de8974e3f76c0 ("MIPS: asm: r4kcache: Add EVA cache flushing
functions") added cache function for EVA using the cachee instruction.
However, it didn't add a case for the protected_writeback_dcache_line.
mips_dsemul() calls r4k_flush_cache_sigtramp() which in turn uses
the protected_writeback_dcache_line() to flush the trampoline code
back to memory. This used the wrong "cache" instruction leading to
random userland crashes on non-FPU cores.

Signed-off-by: Markos Chandras <markos.chandras@imgtec.com>
Cc: linux-mips@linux-mips.org
Patchwork: https://patchwork.linux-mips.org/patch/8331/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/mips/include/asm/r4kcache.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/mips/include/asm/r4kcache.h b/arch/mips/include/asm/r4kcache.h
index 0b8bd28a0df1..ed038d7c3410 100644
--- a/arch/mips/include/asm/r4kcache.h
+++ b/arch/mips/include/asm/r4kcache.h
@@ -254,7 +254,11 @@ static inline void protected_flush_icache_line(unsigned long addr)
  */
 static inline void protected_writeback_dcache_line(unsigned long addr)
 {
+#ifdef CONFIG_EVA
+	protected_cachee_op(Hit_Writeback_Inv_D, addr);
+#else
 	protected_cache_op(Hit_Writeback_Inv_D, addr);
+#endif
 }
 
 static inline void protected_writeback_scache_line(unsigned long addr)
-- 
2.1.3

