Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965027AbbA1EX4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:23:56 -0500
Received: from mail.kernel.org ([198.145.29.136]:40491 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964977AbbA1EXw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:23:52 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Jason Baron <jbaron@redhat.com>,
        Wade Farnsworth <wade_farnsworth@mentor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 119/177] tracing/syscalls: Fix perf syscall tracing when syscall_nr == -1
Date: Wed, 28 Jan 2015 12:09:37 +0800
Message-Id: <1422418236-12852-210-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Will Deacon <will.deacon@arm.com>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit 60916a9382e88fbf5e54fd36a3e658efd7ab7bed upstream.

syscall_get_nr can return -1 in the case that the task is not executing
a system call.

This patch fixes perf_syscall_{enter,exit} to check that the syscall
number is valid before using it as an index into a bitmap.

Link: http://lkml.kernel.org/r/1345137254-7377-1-git-send-email-will.deacon@arm.com

Cc: Jason Baron <jbaron@redhat.com>
Cc: Wade Farnsworth <wade_farnsworth@mentor.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 kernel/trace/trace_syscalls.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index c9ce09a..aed38fd 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -519,6 +519,8 @@ static void perf_syscall_enter(void *ignore, struct pt_regs *regs, long id)
 	int size;
 
 	syscall_nr = syscall_get_nr(current, regs);
+	if (syscall_nr < 0)
+		return;
 	if (!test_bit(syscall_nr, enabled_perf_enter_syscalls))
 		return;
 
@@ -593,6 +595,8 @@ static void perf_syscall_exit(void *ignore, struct pt_regs *regs, long ret)
 	int size;
 
 	syscall_nr = syscall_get_nr(current, regs);
+	if (syscall_nr < 0)
+		return;
 	if (!test_bit(syscall_nr, enabled_perf_exit_syscalls))
 		return;
 
-- 
1.9.1

