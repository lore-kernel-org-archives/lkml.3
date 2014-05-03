Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292AbaECTXF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 15:23:05 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:62408 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216AbaECTXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 15:23:03 -0400
From: Richard Weinberger <richard@nod.at>
To: user-mode-linux-devel@lists.sourceforge.net
Cc: toralf.foerster@gmx.de, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 1/2] Revert "um: Fix wait_stub_done() error handling"
Date: Sat,  3 May 2014 21:12:43 +0200
Message-Id: <1399144364-30696-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 0974a9cadc7886f7baaa458bb0c89f5c5f9d458e.
It was a bad idea and was only papering over the real issue.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/um/os-Linux/skas/process.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/arch/um/os-Linux/skas/process.c b/arch/um/os-Linux/skas/process.c
index d531879..908579f 100644
--- a/arch/um/os-Linux/skas/process.c
+++ b/arch/um/os-Linux/skas/process.c
@@ -54,7 +54,7 @@ static int ptrace_dump_regs(int pid)
 
 void wait_stub_done(int pid)
 {
-	int n, status, err, bad_stop = 0;
+	int n, status, err;
 
 	while (1) {
 		CATCH_EINTR(n = waitpid(pid, &status, WUNTRACED | __WALL));
@@ -74,8 +74,6 @@ void wait_stub_done(int pid)
 
 	if (((1 << WSTOPSIG(status)) & STUB_DONE_MASK) != 0)
 		return;
-	else
-		bad_stop = 1;
 
 bad_wait:
 	err = ptrace_dump_regs(pid);
@@ -85,10 +83,7 @@ bad_wait:
 	printk(UM_KERN_ERR "wait_stub_done : failed to wait for SIGTRAP, "
 	       "pid = %d, n = %d, errno = %d, status = 0x%x\n", pid, n, errno,
 	       status);
-	if (bad_stop)
-		kill(pid, SIGKILL);
-	else
-		fatal_sigsegv();
+	fatal_sigsegv();
 }
 
 extern unsigned long current_stub_stack(void);
-- 
1.8.1.4

