Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752427AbaGKDjk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 23:39:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33371 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751663AbaGKDjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 23:39:13 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>, Paul Moore <pmoore@redhat.com>,
        Eric Paris <eparis@redhat.com>, Al Viro <aviro@redhat.com>,
        Will Drewry <wad@chromium.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 2/3] [RFC] seccomp: give BPF x32 bit when restoring x32 filter
Date: Thu, 10 Jul 2014 23:38:13 -0400
Message-Id: <6a69eb94b4cfac5f94b229c2eb2ebc402aac722a.1405023592.git.rgb@redhat.com>
In-Reply-To: <cover.1405023592.git.rgb@redhat.com>
References: <cover.1405023592.git.rgb@redhat.com>
In-Reply-To: <cover.1405023592.git.rgb@redhat.com>
References: <cover.1405023592.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit
	fca460f hpa@zytor.com 2012-02-19 07:56:26 -0800
	x32: Handle the x32 system call flag

provided a method to multiplex architecture with the syscall number for X32
calls.

Commit
	8b4b9f2 pmoore@redhat.com 2013-02-15 12:21:43 -0500
	x86: remove the x32 syscall bitmask from syscall_get_nr()

broke audit and potentially other users of syscall_get_nr() which depend on
that call as named.

Commit
	audit: add AUDIT_ARCH_X86_X32 arch definition

is required to provide the new ARCH definition AUDIT_ARCH_X86_X32 for
syscall_get_arch().

This patch along with reverting 8b4b9f2 should satisfy other regular users of
syscall_get_nr() without changing the seccomp interface to BPF.

Cc: Paul Moore <pmoore@redhat.com>
Cc: Eric Paris <eparis@redhat.com>
Cc: Al Viro <aviro@redhat.com>
Cc: Will Drewry <wad@chromium.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
Link: http://lkml.kernel.org/r/cover.1405023592.git.rgb@redhat.com
---
 arch/x86/include/asm/syscall.h |    4 ++++
 kernel/seccomp.c               |    6 ++++++
 2 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/syscall.h b/arch/x86/include/asm/syscall.h
index d6a756a..d58b6be 100644
--- a/arch/x86/include/asm/syscall.h
+++ b/arch/x86/include/asm/syscall.h
@@ -236,6 +236,10 @@ static inline int syscall_get_arch(void)
 		return AUDIT_ARCH_I386;
 #endif
 	/* Both x32 and x86_64 are considered "64-bit". */
+#ifdef CONFIG_X86_X32_ABI
+	if (task_pt_regs(current)->orig_ax & __X32_SYSCALL_BIT)
+		return AUDIT_ARCH_X86_X32;
+#endif
 	return AUDIT_ARCH_X86_64;
 }
 #endif	/* CONFIG_X86_32 */
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index b35c215..bc18214 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -73,6 +73,12 @@ static void populate_seccomp_data(struct seccomp_data *sd)
 
 	sd->nr = syscall_get_nr(task, regs);
 	sd->arch = syscall_get_arch();
+#ifdef CONFIG_X86_X32_ABI
+	if (sd->arch == AUDIT_ARCH_X86_X32) {
+		sd->arch = AUDIT_ARCH_X86_64;
+		sd->nr |= __X32_SYSCALL_BIT;
+	}
+#endif
 	syscall_get_arguments(task, regs, 0, 6, args);
 	sd->args[0] = args[0];
 	sd->args[1] = args[1];
-- 
1.7.1

