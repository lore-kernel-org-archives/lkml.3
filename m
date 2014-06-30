Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446AbaF3McO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:32:14 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:53045 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755337AbaF3McF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 08:32:05 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 120/181] arm64: ptrace: change fs when passing kernel pointer to regset code
Date: Mon, 30 Jun 2014 13:52:21 +0200
Message-Id: <bd44b0890d0e2ff4b0f59a1ac310dd9f401a4141.1404128998.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
References: <61844d8e25eb8899b0836afa9796fa239db80f1f.1404128997.git.jslaby@suse.cz>
In-Reply-To: <cover.1404128997.git.jslaby@suse.cz>
References: <cover.1404128997.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Will Deacon <will.deacon@arm.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
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
2.0.0

