Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759862AbaLLG3k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:29:40 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51954 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759331AbaLLGQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:16:58 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Frederic Weisbecker" <fweisbec@gmail.com>,
        "Wade Farnsworth" <wade_farnsworth@mentor.com>,
        "Will Deacon" <will.deacon@arm.com>,
        "Steven Rostedt" <rostedt@goodmis.org>,
        "Jason Baron" <jbaron@redhat.com>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.19326747@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 102/164] tracing/syscalls: Fix perf syscall tracing
 when syscall_nr == -1
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/trace/trace_syscalls.c | 4 ++++
 1 file changed, 4 insertions(+)

--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -519,6 +519,8 @@ static void perf_syscall_enter(void *ign
 	int size;
 
 	syscall_nr = syscall_get_nr(current, regs);
+	if (syscall_nr < 0)
+		return;
 	if (!test_bit(syscall_nr, enabled_perf_enter_syscalls))
 		return;
 
@@ -593,6 +595,8 @@ static void perf_syscall_exit(void *igno
 	int size;
 
 	syscall_nr = syscall_get_nr(current, regs);
+	if (syscall_nr < 0)
+		return;
 	if (!test_bit(syscall_nr, enabled_perf_exit_syscalls))
 		return;
 

