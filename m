Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759057AbaDJS6K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 14:58:10 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55158 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965720AbaDJS6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 14:58:05 -0400
Date: Thu, 10 Apr 2014 16:40:03 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Olsa <jolsa@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org
Subject: x86: Allow vmalloc faults from NMI context
Message-ID: <20140410144003.GF13658@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri reported he hit vmalloc_faults()'s:

  WARN_ON_ONCE(in_nmi());

The patch that added this ebc8827f75954 ("x86: Barf when vmalloc and
kmemcheck faults happen in NMI") explains that this was done in order to
avoid faults from NMI to cause nested NMIs.

We have, however, completely fixed this issue and can now safely take
faults from NMI context.

Therefore remove this warning. We must still leave the kmemcheck warn in
place since kmemcheck itself can't deal with NMI context yet.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 arch/x86/mm/fault.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 8e5722992677..d0234cdf70f1 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -271,8 +271,6 @@ static noinline __kprobes int vmalloc_fault(unsigned long address)
 	if (!(address >= VMALLOC_START && address < VMALLOC_END))
 		return -1;
 
-	WARN_ON_ONCE(in_nmi());
-
 	/*
 	 * Synchronize this task's top level page-table
 	 * with the 'reference' page table.
@@ -369,8 +367,6 @@ static noinline __kprobes int vmalloc_fault(unsigned long address)
 	if (!(address >= VMALLOC_START && address < VMALLOC_END))
 		return -1;
 
-	WARN_ON_ONCE(in_nmi());
-
 	/*
 	 * Copy kernel mappings over when needed. This can also
 	 * happen within a race in page table update. In the later

