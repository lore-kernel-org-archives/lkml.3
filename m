Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203AbaGaPlB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 11:41:01 -0400
Received: from mga14.intel.com ([192.55.52.115]:25716 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753022AbaGaPk7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 11:40:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="366274785"
Subject: [PATCH 4/7] x86: mm: unify remote invlpg code
To: hpa@zytor.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Dave Hansen <dave@sr71.net>, dave.hansen@linux.intel.com,
        riel@redhat.com, mgorman@suse.de
From: Dave Hansen <dave@sr71.net>
Date: Thu, 31 Jul 2014 08:40:58 -0700
References: <20140731154052.C7E7FBC1@viggo.jf.intel.com>
In-Reply-To: <20140731154052.C7E7FBC1@viggo.jf.intel.com>
Message-Id: <20140731154058.E0F90408@viggo.jf.intel.com>
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
--- a/arch/x86/mm/tlb.c~x86-tlb-simplify-remote-flush-code	2014-06-30 16:18:28.009559635 -0700
+++ b/arch/x86/mm/tlb.c	2014-06-30 16:18:28.013559817 -0700
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
