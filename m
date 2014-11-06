Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721AbaKFWmA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:42:00 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58802 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbaKFWl4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:41:56 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 039/162] sparc64: Do not define thread fpregs save area as zero-length array.
Date: Thu,  6 Nov 2014 14:35:03 -0800
Message-Id: <1415313426-9622-40-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit e2653143d7d79a49f1a961aeae1d82612838b12c ]

This breaks the stack end corruption detection facility.

What that facility does it write a magic value to "end_of_stack()"
and checking to see if it gets overwritten.

"end_of_stack()" is "task_thread_info(p) + 1", which for sparc64 is
the beginning of the FPU register save area.

So once the user uses the FPU, the magic value is overwritten and the
debug checks trigger.

Fix this by making the size explicit.

Due to the size we use for the fpsaved[], gsr[], and xfsr[] arrays we
are limited to 7 levels of FPU state saves.  So each FPU register set
is 256 bytes, allocate 256 * 7 for the fpregs area.

Reported-by: Meelis Roos <mroos@linux.ee>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/sparc/include/asm/thread_info_64.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/sparc/include/asm/thread_info_64.h b/arch/sparc/include/asm/thread_info_64.h
index f85dc85..cc6275c 100644
--- a/arch/sparc/include/asm/thread_info_64.h
+++ b/arch/sparc/include/asm/thread_info_64.h
@@ -63,7 +63,8 @@ struct thread_info {
 	struct pt_regs		*kern_una_regs;
 	unsigned int		kern_una_insn;
 
-	unsigned long		fpregs[0] __attribute__ ((aligned(64)));
+	unsigned long		fpregs[(7 * 256) / sizeof(unsigned long)]
+		__attribute__ ((aligned(64)));
 };
 
 #endif /* !(__ASSEMBLY__) */
-- 
1.9.1

