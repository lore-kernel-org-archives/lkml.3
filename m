Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933404Ab3D3S5Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 14:57:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40351 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933391Ab3D3S5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 14:57:12 -0400
Date: Tue, 30 Apr 2013 20:53:41 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alan Stern <stern@rowland.harvard.edu>, Ingo Molnar <mingo@elte.hu>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        Prasad <prasad@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] ptrace/x86: flush_ptrace_hw_breakpoint() shoule clear
	the virtual debug registers
Message-ID: <20130430185341.GB12389@redhat.com>
References: <20130418184350.GA4407@redhat.com> <20130418184425.GA4454@redhat.com> <20130429160931.GD31230@somewhere> <20130429164038.GA27132@redhat.com> <20130429233647.GD1760@somewhere> <20130430175138.GA30014@redhat.com> <20130430185322.GA12389@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130430185322.GA12389@redhat.com>
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


