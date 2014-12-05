Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357AbaLEXtx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 18:49:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53766 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbaLEWp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:45:56 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Markos Chandras <markos.chandras@imgtec.com>,
        linux-mips@linux-mips.org, Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH 3.17 009/122] MIPS: r4kcache: Add EVA case for protected_writeback_dcache_line
Date: Fri,  5 Dec 2014 14:43:03 -0800
Message-Id: <20141205223306.905029998@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205223305.514276242@linuxfoundation.org>
References: <20141205223305.514276242@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/include/asm/r4kcache.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/arch/mips/include/asm/r4kcache.h
+++ b/arch/mips/include/asm/r4kcache.h
@@ -257,7 +257,11 @@ static inline void protected_flush_icach
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


