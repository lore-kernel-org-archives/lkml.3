Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932502AbaGCJcF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 05:32:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52576 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030551AbaGCJZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 05:25:03 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 177/198] arm64: ptrace: change fs when passing kernel pointer to regset code
Date: Thu,  3 Jul 2014 10:20:20 +0100
Message-Id: <1404379241-8590-178-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
References: <1404379241-8590-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.13 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/arm64/kernel/ptrace.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
index c484d5625ffb..9fa78cd0f092 100644
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -823,6 +823,7 @@ static int compat_ptrace_write_user(struct task_struct *tsk, compat_ulong_t off,
 				    compat_ulong_t val)
 {
 	int ret;
+	mm_segment_t old_fs = get_fs();
 
 	if (off & 3 || off >= COMPAT_USER_SZ)
 		return -EIO;
@@ -830,10 +831,13 @@ static int compat_ptrace_write_user(struct task_struct *tsk, compat_ulong_t off,
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

