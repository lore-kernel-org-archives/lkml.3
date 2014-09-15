Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760014AbaIOXIh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 19:08:37 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50677 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755001AbaIOWMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:12:45 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Smith <alex.smith@imgtec.com>, linux-mips@linux-mips.org,
        Ralf Baechle <ralf@linux-mips.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 132/187] MIPS: O32/32-bit: Fix bug which can cause incorrect system call restarts
Date: Mon, 15 Sep 2014 15:09:02 -0700
Message-Id: <1410818997-9432-133-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Smith <alex.smith@imgtec.com>

commit e90e6fddc57055c4c6b57f92787fea1c065d440b upstream.

On 32-bit/O32, pt_regs has a padding area at the beginning into which the
syscall arguments passed via the user stack are copied. 4 arguments
totalling 16 bytes are copied to offset 16 bytes into this area, however
the area is only 24 bytes long. This means the last 2 arguments overwrite
pt_regs->regs[{0,1}].

If a syscall function returns an error, handle_sys stores the original
syscall number in pt_regs->regs[0] for syscall restart. signal.c checks
whether regs[0] is non-zero, if it is it will check whether the syscall
return value is one of the ERESTART* codes to see if it must be
restarted.

Should a syscall be made that results in a non-zero value being copied
off the user stack into regs[0], and then returns a positive (non-error)
value that matches one of the ERESTART* error codes, this can be mistaken
for requiring a syscall restart.

While the possibility for this to occur has always existed, it is made
much more likely to occur by commit 46e12c07b3b9 ("MIPS: O32 / 32-bit:
Always copy 4 stack arguments."), since now every syscall will copy 4
arguments and overwrite regs[0], rather than just those with 7 or 8
arguments.

Since that commit, booting Debian under a 32-bit MIPS kernel almost
always results in a hang early in boot, due to a wait4 syscall returning
a PID that matches one of the ERESTART* codes, which then causes an
incorrect restart of the syscall.

The problem is fixed by increasing the size of the padding area so that
arguments copied off the stack will not overwrite pt_regs->regs[{0,1}].

Signed-off-by: Alex Smith <alex.smith@imgtec.com>
Reviewed-by: Aurelien Jarno <aurelien@aurel32.net>
Tested-by: Aurelien Jarno <aurelien@aurel32.net>
Cc: linux-mips@linux-mips.org
Patchwork: https://patchwork.linux-mips.org/patch/7454/
Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/mips/include/asm/ptrace.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/include/asm/ptrace.h b/arch/mips/include/asm/ptrace.h
index 7bba9da..6d019ca 100644
--- a/arch/mips/include/asm/ptrace.h
+++ b/arch/mips/include/asm/ptrace.h
@@ -23,7 +23,7 @@
 struct pt_regs {
 #ifdef CONFIG_32BIT
 	/* Pad bytes for argument save space on the stack. */
-	unsigned long pad0[6];
+	unsigned long pad0[8];
 #endif
 
 	/* Saved main processor registers. */
-- 
1.9.1

