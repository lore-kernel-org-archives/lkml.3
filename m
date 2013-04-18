Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919Ab3DRSsC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 14:48:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21300 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750934Ab3DRSsA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 14:48:00 -0400
Date: Thu, 18 Apr 2013 20:44:19 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        Prasad <prasad@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] ptrace/x86: ptrace_write_dr7() should create bp if
	!disabled
Message-ID: <20130418184419.GA4444@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130418184350.GA4407@redhat.com>
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

