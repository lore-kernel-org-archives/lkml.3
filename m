Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977Ab3BORWC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 12:22:02 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8847 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753082Ab3BORV6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 12:21:58 -0500
Subject: [PATCH] x86: remove the x32 syscall bitmask from syscall_get_nr()
To: x86@kernel.org, linux-kernel@vger.kernel.org
From: Paul Moore <pmoore@redhat.com>
Cc: coreyb@linux.vnet.ibm.com, wad@chromium.org, hpa@zytor.com
Date: Fri, 15 Feb 2013 12:21:43 -0500
Message-ID: <20130215172143.12549.10292.stgit@localhost>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Cc: stable@vger.kernel.org
Cc: Will Drewry <wad@chromium.org>
Cc: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/include/asm/syscall.h |    4 ++--
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

