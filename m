Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756295AbaLHTEA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 14:04:00 -0500
Received: from mga11.intel.com ([192.55.52.93]:53922 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755931AbaLHTD6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 14:03:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="426586448"
Subject: [PATCH 2/2] x86 tlb: fix tracepoint nr_pages calculation
To: linux-kernel@vger.kernel.org
Cc: Dave Hansen <dave@sr71.net>, dave.hansen@linux.intel.com,
        stable@vger.kernel.org
From: Dave Hansen <dave@sr71.net>
Date: Mon, 08 Dec 2014 11:03:49 -0800
References: <20141208190348.BEDDE684@viggo.jf.intel.com>
In-Reply-To: <20141208190348.BEDDE684@viggo.jf.intel.com>
Message-Id: <20141208190349.8846A23A@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

We calculate nr_pages with f->flush_end and f->flush_start, both
of which are virtual addresses.  However, we only divide
f->flush_start by PAGE_SIZE, and missed f->flush_end.  This patch
adds some parenthesis to catch f->flush_end as well.

nr_pages is only used for a trace point.  This should not have
any functional impact other than keeping the trace point from
spitting out garbage for the flush length.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: stable@vger.kernel.org
---

 b/arch/x86/mm/tlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/mm/tlb.c~x86-tlb-fix-tracepoint-data arch/x86/mm/tlb.c
--- a/arch/x86/mm/tlb.c~x86-tlb-fix-tracepoint-data	2014-12-08 10:58:22.245782512 -0800
+++ b/arch/x86/mm/tlb.c	2014-12-08 10:58:22.248782647 -0800
@@ -129,7 +129,7 @@ static void flush_tlb_func(void *info)
 		} else {
 			unsigned long addr;
 			unsigned long nr_pages =
-				f->flush_end - f->flush_start / PAGE_SIZE;
+				(f->flush_end - f->flush_start) / PAGE_SIZE;
 			addr = f->flush_start;
 			while (addr < f->flush_end) {
 				__flush_tlb_single(addr);
_
