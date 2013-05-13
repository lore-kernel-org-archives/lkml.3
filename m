Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754905Ab3EMPVR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 11:21:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6662 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754855Ab3EMPVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 11:21:13 -0400
Date: Mon, 13 May 2013 17:17:29 +0200
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
Subject: [PATCH 09/13] ptrace/x86: ptrace_write_dr7() should create bp if
	!disabled
Message-ID: <20130513151729.GA6283@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130513151631.GA6215@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

24f1e32c "hw-breakpoints: Rewrite the hw-breakpoints layer on top
of perf events" introduced the minor regression. Before this commit

	PTRACE_POKEUSER DR7, enableDR0
	PTRACE_POKEUSER DR0, address

was perfectly valid, now PTRACE_POKEUSER(DR7) fails if DR0 was not
previously initialized by PTRACE_POKEUSER(DR0).

Change ptrace_write_dr7() to do ptrace_register_breakpoint(addr => 0)
if !bp && !disabled. This fixes watchpoint-zeroaddr from ptrace-tests,
see https://bugzilla.redhat.com/show_bug.cgi?id=660204.

Reported-by: Jan Kratochvil <jan.kratochvil@redhat.com>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/kernel/ptrace.c |   17 ++++++++++-------
 1 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 0526368..5c387b3 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -670,13 +670,16 @@ restore:
 		if (!bp) {
 			if (disabled)
 				continue;
-			/*
-			 * We should have at least an inactive breakpoint at
-			 * this slot. It means the user is writing dr7 without
-			 * having written the address register first.
-			 */
-			rc = -EINVAL;
-			break;
+
+			bp = ptrace_register_breakpoint(tsk,
+					len, type, 0, disabled);
+			if (IS_ERR(bp)) {
+				rc = PTR_ERR(bp);
+				break;
+			}
+
+			thread->ptrace_bps[i] = bp;
+			continue;
 		}
 
 		rc = ptrace_modify_breakpoint(bp, len, type, disabled);
-- 
1.5.5.1

