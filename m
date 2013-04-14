Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752674Ab3DNQIh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 12:08:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36019 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752247Ab3DNQIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 12:08:34 -0400
Date: Sun, 14 Apr 2013 18:05:38 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Paul Mundt <lethal@linux-sh.org>, Prasad <prasad@linux.vnet.ibm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] ptrace/sh: Revert "hw_breakpoints: Fix racy access to
	ptrace breakpoints"
Message-ID: <20130414160538.GA7653@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130414160501.GA7612@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit e0ac8457d020c0289ea566917267da9e5e6d9865.

The patch was fine but we can no longer race with SIGKILL after
9899d11f "ptrace: ensure arch_ptrace/ptrace_request can never race
with SIGKILL", the __TASK_TRACED tracee can't be woken up and
->ptrace_bps[] can't go away.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Paul Mundt <lethal@linux-sh.org>
---
 arch/sh/kernel/ptrace_32.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/arch/sh/kernel/ptrace_32.c b/arch/sh/kernel/ptrace_32.c
index 81f999a..668c816 100644
--- a/arch/sh/kernel/ptrace_32.c
+++ b/arch/sh/kernel/ptrace_32.c
@@ -117,11 +117,7 @@ void user_enable_single_step(struct task_struct *child)
 
 	set_tsk_thread_flag(child, TIF_SINGLESTEP);
 
-	if (ptrace_get_breakpoints(child) < 0)
-		return;
-
 	set_single_step(child, pc);
-	ptrace_put_breakpoints(child);
 }
 
 void user_disable_single_step(struct task_struct *child)
-- 
1.5.5.1

