Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032Ab3HFPtQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 11:49:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60502 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755113Ab3HFPtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 11:49:14 -0400
Date: Tue, 6 Aug 2013 17:43:37 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Grazvydas Ignotas <notasas@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Denys Vlasenko <dvlasenk@redhat.com>
Subject: [PATCH 1/1] Revert "ptrace: PTRACE_DETACH should do
	flush_ptrace_hw_breakpoint(child)"
Message-ID: <20130806154337.GB398@redhat.com>
References: <CA+55aFwTX47vLvZckozZub0rUEo-aCBe7weqe=4mfQGfrW7NUA@mail.gmail.com> <CAMP44s2bOniz4qx5y9h4ppHRUjiPVGL+igSwO5NUJd4zpObxFw@mail.gmail.com> <20130806154314.GA398@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130806154314.GA398@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit fab840fc2d542fabcab903db8e03589a6702ba5f.

This commit even has the test-case to prove that the tracee
can be killed by SIGTRAP if the debugger does not remove the
breakpoints before PTRACE_DETACH.

However, this is exactly what wineserver deliberately does,
set_thread_context() calls PTRACE_ATTACH + PTRACE_DETACH just
for PTRACE_POKEUSER(DR*) in between.

So we should revert this fix and document that PTRACE_DETACH
should keep the breakpoints.

Reported-by: Felipe Contreras <felipe.contreras@gmail.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/ptrace.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 4041f57..a146ee3 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -469,7 +469,6 @@ static int ptrace_detach(struct task_struct *child, unsigned int data)
 	/* Architecture-specific hardware disable .. */
 	ptrace_disable(child);
 	clear_tsk_thread_flag(child, TIF_SYSCALL_TRACE);
-	flush_ptrace_hw_breakpoint(child);
 
 	write_lock_irq(&tasklist_lock);
 	/*
-- 
1.5.5.1


