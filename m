Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275AbaGKDjQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 23:39:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28006 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752144AbaGKDjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 23:39:14 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>, Paul Moore <pmoore@redhat.com>,
        Eric Paris <eparis@redhat.com>, Al Viro <aviro@redhat.com>,
        Will Drewry <wad@chromium.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 3/3] [RFC] Revert "x86: remove the x32 syscall bitmask from syscall_get_nr()"
Date: Thu, 10 Jul 2014 23:38:14 -0400
Message-Id: <4f70164ca972f0c7c81db693eeefb28b7460bd84.1405023592.git.rgb@redhat.com>
In-Reply-To: <cover.1405023592.git.rgb@redhat.com>
References: <cover.1405023592.git.rgb@redhat.com>
In-Reply-To: <cover.1405023592.git.rgb@redhat.com>
References: <cover.1405023592.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 8b4b9f27e57584f3d90e0bb84cf800ad81cfe3a1.
which broke audit and potentially other users of syscall_get_nr() which depend
on that call as named without being overloaded by architecture bits.

This patch along with
	seccomp: give BPF x32 bit when restoring x32 filter
will satisfy other regular users of syscall_get_nr() and syscall_get_arch()
without changing the seccomp interface to BPF.

Cc: Paul Moore <pmoore@redhat.com>
Cc: Eric Paris <eparis@redhat.com>
Cc: Al Viro <aviro@redhat.com>
Cc: Will Drewry <wad@chromium.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
Link: http://lkml.kernel.org/r/cover.1405023592.git.rgb@redhat.com
---
 arch/x86/include/asm/syscall.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/syscall.h b/arch/x86/include/asm/syscall.h
index d58b6be..8c1bb2b 100644
--- a/arch/x86/include/asm/syscall.h
+++ b/arch/x86/include/asm/syscall.h
@@ -30,13 +30,13 @@ extern const sys_call_ptr_t sys_call_table[];
  */
 static inline int syscall_get_nr(struct task_struct *task, struct pt_regs *regs)
 {
-	return regs->orig_ax;
+	return regs->orig_ax & __SYSCALL_MASK;
 }
 
 static inline void syscall_rollback(struct task_struct *task,
 				    struct pt_regs *regs)
 {
-	regs->ax = regs->orig_ax;
+	regs->ax = regs->orig_ax & __SYSCALL_MASK;
 }
 
 static inline long syscall_get_error(struct task_struct *task,
-- 
1.7.1

