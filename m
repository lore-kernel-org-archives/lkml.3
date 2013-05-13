Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755078Ab3EMP1D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 11:27:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35897 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751697Ab3EMP1B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 11:27:01 -0400
Date: Mon, 13 May 2013 17:17:40 +0200
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
Subject: [PATCH 12/13] ptrace/x86: flush_ptrace_hw_breakpoint() shoule
	clear the virtual debug registers
Message-ID: <20130513151740.GA6300@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130513151631.GA6215@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

flush_ptrace_hw_breakpoint() destroys the counters set by ptrace, but
"leaks" ->debugreg6 and ->ptrace_dr7.

The problem is minor, but still it doesn't look right and flush_thread()
did this until 66cb5917. Now that PTRACE_DETACH does flush_ too this makes
even more sense.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---
 arch/x86/kernel/hw_breakpoint.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
index 02f0763..f66ff16 100644
--- a/arch/x86/kernel/hw_breakpoint.c
+++ b/arch/x86/kernel/hw_breakpoint.c
@@ -393,6 +393,9 @@ void flush_ptrace_hw_breakpoint(struct task_struct *tsk)
 		unregister_hw_breakpoint(t->ptrace_bps[i]);
 		t->ptrace_bps[i] = NULL;
 	}
+
+	t->debugreg6 = 0;
+	t->ptrace_dr7 = 0;
 }
 
 void hw_breakpoint_restore(void)
-- 
1.5.5.1

