Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759929AbaGOVuq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 17:50:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54944 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934003AbaGOVis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 17:38:48 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 154/198] arm64: ptrace: change fs when passing kernel pointer to regset code
Date: Tue, 15 Jul 2014 14:30:24 -0700
Message-Id: <1405459868-15089-155-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405459868-15089-1-git-send-email-kamal@canonical.com>
References: <1405459868-15089-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit c168870704bcde6bb63d05f7882b620dd3985a46 upstream.

Our compat PTRACE_POKEUSR implementation simply passes the user data to
regset_copy_from_user after some simple range checking. Unfortunately,
the data in question has already been copied to the kernel stack by this
point, so the subsequent access_ok check fails and the ptrace request
returns -EFAULT. This causes problems tracing fork() with older versions
of strace.

This patch briefly changes the fs to KERNEL_DS, so that the access_ok
check passes even with a kernel address.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm64/kernel/ptrace.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index 6a8928b..bf288e4 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -821,6 +821,7 @@ static int compat_ptrace_write_user(struct task_struct *tsk, compat_ulong_t off,
 				    compat_ulong_t val)
 {
 	int ret;
+	mm_segment_t old_fs = get_fs();
 
 	if (off & 3 || off >= COMPAT_USER_SZ)
 		return -EIO;
@@ -828,10 +829,13 @@ static int compat_ptrace_write_user(struct task_struct *tsk, compat_ulong_t off,
 	if (off >= sizeof(compat_elf_gregset_t))
 		return 0;
 
+	set_fs(KERNEL_DS);
 	ret = copy_regset_from_user(tsk, &user_aarch32_view,
 				    REGSET_COMPAT_GPR, off,
 				    sizeof(compat_ulong_t),
 				    &val);
+	set_fs(old_fs);
+
 	return ret;
 }
 
-- 
1.9.1

