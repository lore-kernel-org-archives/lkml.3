Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752997Ab3IFVao (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 17:30:44 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:44778 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807Ab3IFVam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 17:30:42 -0400
From: behanw@converseincode.com
To: linux@arm.linux.org.uk, Tejun Heo <tj@kernel.org>,
        Christoph Lameter <cl@linux-foundation.org>
Cc: behanw@converseincode.com, Mark Charlebois <charlebm@gmail.com>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM PORT),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 2/5] arm: LLVMLinux: use current_stack_pointer for percpu
Date: Fri,  6 Sep 2013 17:28:08 -0400
Message-Id: <1378502899-1241-3-git-send-email-behanw@converseincode.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378502899-1241-1-git-send-email-behanw@converseincode.com>
References: <1378502899-1241-1-git-send-email-behanw@converseincode.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Behan Webster <behanw@converseincode.com>

The existing code uses named registers to get the value of the stack pointer.
The new current_stack_pointer macro is more readable and allows for a central
portable implementation of how to get the stack pointer with ASM.  This change
supports being able to compile the kernel with both gcc and Clang.

Signed-off-by: Mark Charlebois <charlebm@gmail.com>
Signed-off-by: Behan Webster <behanw@converseincode.com>
Reviewed-by: Jan-Simon Möller <dl9pf@gmx.de>
---
 arch/arm/include/asm/percpu.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/percpu.h b/arch/arm/include/asm/percpu.h
index 209e650..629a975 100644
--- a/arch/arm/include/asm/percpu.h
+++ b/arch/arm/include/asm/percpu.h
@@ -30,14 +30,14 @@ static inline void set_my_cpu_offset(unsigned long off)
 static inline unsigned long __my_cpu_offset(void)
 {
 	unsigned long off;
-	register unsigned long *sp asm ("sp");
+	unsigned long sp = current_stack_pointer;
 
 	/*
 	 * Read TPIDRPRW.
 	 * We want to allow caching the value, so avoid using volatile and
 	 * instead use a fake stack read to hazard against barrier().
 	 */
-	asm("mrc p15, 0, %0, c13, c0, 4" : "=r" (off) : "Q" (*sp));
+	asm("mrc p15, 0, %0, c13, c0, 4" : "=r" (off) : "Q" (sp));
 
 	return off;
 }
-- 
1.8.1.2

