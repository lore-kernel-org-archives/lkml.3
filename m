Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809Ab3EMPVI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 11:21:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37521 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752684Ab3EMPVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 11:21:05 -0400
Date: Mon, 13 May 2013 17:17:06 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        Michael Neuling <mikey@neuling.org>, Paul Mackerras <paulus@samba.org>,
        Paul Mundt <lethal@linux-sh.org>, Prasad <prasad@linux.vnet.ibm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 03/13] ptrace/arm: Revert "hw_breakpoints: Fix racy access
	to ptrace breakpoints"
Message-ID: <20130513151706.GA6249@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130513151631.GA6215@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit bf0b8f4b55e591ba417c2dbaff42769e1fc773b0.

The patch was fine but we can no longer race with SIGKILL after
9899d11f "ptrace: ensure arch_ptrace/ptrace_request can never race
with SIGKILL", the __TASK_TRACED tracee can't be woken up and
->ptrace_bps[] can't go away.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Will Deacon <will.deacon@arm.com>
---
 arch/arm/kernel/ptrace.c |    8 --------
 1 files changed, 0 insertions(+), 8 deletions(-)

diff --git a/arch/arm/kernel/ptrace.c b/arch/arm/kernel/ptrace.c
index 03deeff..41668e5 100644
--- a/arch/arm/kernel/ptrace.c
+++ b/arch/arm/kernel/ptrace.c
@@ -886,20 +886,12 @@ long arch_ptrace(struct task_struct *child, long request,
 
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
 		case PTRACE_GETHBPREGS:
-			if (ptrace_get_breakpoints(child) < 0)
-				return -ESRCH;
-
 			ret = ptrace_gethbpregs(child, addr,
 						(unsigned long __user *)data);
-			ptrace_put_breakpoints(child);
 			break;
 		case PTRACE_SETHBPREGS:
-			if (ptrace_get_breakpoints(child) < 0)
-				return -ESRCH;
-
 			ret = ptrace_sethbpregs(child, addr,
 						(unsigned long __user *)data);
-			ptrace_put_breakpoints(child);
 			break;
 #endif
 
-- 
1.5.5.1

