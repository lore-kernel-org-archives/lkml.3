Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751480Ab3IJLd3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 07:33:29 -0400
Received: from merlin.infradead.org ([205.233.59.134]:44091 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302Ab3IJLd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 07:33:28 -0400
Date: Tue, 10 Sep 2013 13:33:22 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: ralf@linux-mips.org
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
Subject: [RFC][PATCH] MIPS: Use pagefault_{dis,en}able for k{,un}map_coherent
Message-ID: <20130910113322.GE31370@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ralf,

I was poking about the preempt_count muck and stumbled upon this..

Should you be using the pagefault_*() methods here?

--- a/arch/mips/mm/init.c
+++ b/arch/mips/mm/init.c
@@ -124,7 +124,7 @@ void *kmap_coherent(struct page *page, u
 
 	BUG_ON(Page_dcache_dirty(page));
 
-	inc_preempt_count();
+	pagefault_disable();
 	idx = (addr >> PAGE_SHIFT) & (FIX_N_COLOURS - 1);
 #ifdef CONFIG_MIPS_MT_SMTC
 	idx += FIX_N_COLOURS * smp_processor_id() +
@@ -193,8 +193,7 @@ void kunmap_coherent(void)
 	write_c0_entryhi(old_ctx);
 	EXIT_CRITICAL(flags);
 #endif
-	dec_preempt_count();
-	preempt_check_resched();
+	pagefault_enable();
 }
 
 void copy_user_highpage(struct page *to, struct page *from,
