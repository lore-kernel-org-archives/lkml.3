Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758886Ab3DCARd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 20:17:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59650 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758737Ab3DCARb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 20:17:31 -0400
Date: Tue, 2 Apr 2013 17:17:13 -0700
From: tip-bot for Paul Moore <tipbot@zytor.com>
Message-ID: <tip-8b4b9f27e57584f3d90e0bb84cf800ad81cfe3a1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        wad@chromium.org, pmoore@redhat.com, stable@vger.kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        wad@chromium.org, pmoore@redhat.com, tglx@linutronix.de,
        stable@vger.kernel.org, hpa@linux.intel.com
In-Reply-To: <20130215172143.12549.10292.stgit@localhost>
References: <20130215172143.12549.10292.stgit@localhost>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86:
  remove the x32 syscall bitmask from syscall_get_nr()
Git-Commit-ID: 8b4b9f27e57584f3d90e0bb84cf800ad81cfe3a1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 02 Apr 2013 17:17:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8b4b9f27e57584f3d90e0bb84cf800ad81cfe3a1
Gitweb:     http://git.kernel.org/tip/8b4b9f27e57584f3d90e0bb84cf800ad81cfe3a1
Author:     Paul Moore <pmoore@redhat.com>
AuthorDate: Fri, 15 Feb 2013 12:21:43 -0500
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 2 Apr 2013 14:38:09 -0700

x86: remove the x32 syscall bitmask from syscall_get_nr()

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
Cc: <stable@vger.kernel.org>
Cc: Will Drewry <wad@chromium.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
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
