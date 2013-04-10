Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937476Ab3DJWuG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 18:50:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56556 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937459Ab3DJWuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:50:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Paul Moore <pmoore@redhat.com>, Will Drewry <wad@chromium.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [ 18/29] x86: remove the x32 syscall bitmask from syscall_get_nr()
Date: Wed, 10 Apr 2013 15:49:36 -0700
Message-Id: <20130410224805.965513423@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130410224804.061806042@linuxfoundation.org>
References: <20130410224804.061806042@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/include/asm/syscall.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/include/asm/syscall.h
+++ b/arch/x86/include/asm/syscall.h
@@ -27,13 +27,13 @@ extern const unsigned long sys_call_tabl
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


