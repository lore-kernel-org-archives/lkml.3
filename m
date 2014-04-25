Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436AbaDYWh5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 18:37:57 -0400
Received: from mga11.intel.com ([192.55.52.93]:37561 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752285AbaDYWhs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 18:37:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,929,1389772800"; 
   d="scan'208";a="519975051"
Subject: [PATCH 4/8] x86: mm: unify remote invlpg code
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, x86@kernel.org, Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Fri, 25 Apr 2014 15:37:47 -0700
References: <20140425223742.0A27E42E@viggo.jf.intel.com>
In-Reply-To: <20140425223742.0A27E42E@viggo.jf.intel.com>
Message-Id: <20140425223747.5D6B4D6E@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

There are currently three paths through the remote flush code:

1. full invalidation
2. single page invalidation using invlpg
3. ranged invalidation using invlpg

This takes 2 and 3 and combines them in to a single path by
making the single-page one just be the start and end be start
plus a single page.  This makes placement of our tracepoint easier.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
---

 b/arch/x86/mm/tlb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/x86/mm/tlb.c~x86-tlb-simplify-remote-flush-code arch/x86/mm/tlb.c
--- a/arch/x86/mm/tlb.c~x86-tlb-simplify-remote-flush-code	2014-04-25 15:33:13.091058396 -0700
+++ b/arch/x86/mm/tlb.c	2014-04-25 15:33:13.094058531 -0700
@@ -102,13 +102,13 @@ static void flush_tlb_func(void *info)
 
 	if (f->flush_mm != this_cpu_read(cpu_tlbstate.active_mm))
 		return;
+	if (!f->flush_end)
+		f->flush_end = f->flush_start + PAGE_SIZE;
 
 	count_vm_tlb_event(NR_TLB_REMOTE_FLUSH_RECEIVED);
 	if (this_cpu_read(cpu_tlbstate.state) == TLBSTATE_OK) {
 		if (f->flush_end == TLB_FLUSH_ALL)
 			local_flush_tlb();
-		else if (!f->flush_end)
-			__flush_tlb_single(f->flush_start);
 		else {
 			unsigned long addr;
 			addr = f->flush_start;
_
