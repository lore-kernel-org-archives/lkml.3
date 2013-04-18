Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616Ab3DRJRe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 05:17:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40031 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756350Ab3DRJR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 05:17:29 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Paul Moore <pmoore@redhat.com>, Will Drewry <wad@chromium.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 09/72] x86: remove the x32 syscall bitmask from syscall_get_nr()
Date: Thu, 18 Apr 2013 10:15:54 +0100
Message-Id: <1366276617-3553-10-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1366276617-3553-1-git-send-email-luis.henriques@canonical.com>
References: <1366276617-3553-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Moore <pmoore@redhat.com>

commit 8b4b9f27e57584f3d90e0bb84cf800ad81cfe3a1 upstream.

Commit fca460f95e928bae373daa8295877b6905bc62b8 simplified the x32
implementation by creating a syscall bitmask, equal to 0x40000000, that
could be applied to x32 syscalls such that the masked syscall number
would be the same as a x86_64 syscall.  While that patch was a nice
way to simplify the code, it went a bit too far by adding the mask to
syscall_get_nr(); returning the masked syscall numbers can cause
confusion with callers that expect syscall numbers matching the x32
ABI, e.g. unmasked syscall numbers.

This patch fixes this by simply removing the mask from syscall_get_nr()
while preserving the other changes from the original commit.  While
there are several syscall_get_nr() callers in the kernel, most simply
check that the syscall number is greater than zero, in this case this
patch will have no effect.  Of those remaining callers, they appear
to be few, seccomp and ftrace, and from my testing of seccomp without
this patch the original commit definitely breaks things; the seccomp
filter does not correctly filter the syscalls due to the difference in
syscall numbers in the BPF filter and the value from syscall_get_nr().
Applying this patch restores the seccomp BPF filter functionality on
x32.

I've tested this patch with the seccomp BPF filters as well as ftrace
and everything looks reasonable to me; needless to say general usage
seemed fine as well.

Signed-off-by: Paul Moore <pmoore@redhat.com>
Link: http://lkml.kernel.org/r/20130215172143.12549.10292.stgit@localhost
Cc: Will Drewry <wad@chromium.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/x86/include/asm/syscall.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/syscall.h b/arch/x86/include/asm/syscall.h
index 1ace47b..2e188d6 100644
--- a/arch/x86/include/asm/syscall.h
+++ b/arch/x86/include/asm/syscall.h
@@ -29,13 +29,13 @@ extern const unsigned long sys_call_table[];
  */
 static inline int syscall_get_nr(struct task_struct *task, struct pt_regs *regs)
 {
-	return regs->orig_ax & __SYSCALL_MASK;
+	return regs->orig_ax;
 }
 
 static inline void syscall_rollback(struct task_struct *task,
 				    struct pt_regs *regs)
 {
-	regs->ax = regs->orig_ax & __SYSCALL_MASK;
+	regs->ax = regs->orig_ax;
 }
 
 static inline long syscall_get_error(struct task_struct *task,
-- 
1.8.1.2

