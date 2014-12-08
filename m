Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756362AbaLHTEg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 14:04:36 -0500
Received: from mga02.intel.com ([134.134.136.20]:61731 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756203AbaLHTEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 14:04:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,540,1413270000"; 
   d="scan'208";a="620566268"
Subject: [PATCH 1/2] x86 tlb: fix overflow of flush_end in remote tlb flush
To: linux-kernel@vger.kernel.org
Cc: Dave Hansen <dave@sr71.net>, dave.hansen@linux.intel.com,
        stable@vger.kernel.org
From: Dave Hansen <dave@sr71.net>
Date: Mon, 08 Dec 2014 11:03:48 -0800
Message-Id: <20141208190348.BEDDE684@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Dave Hansen <dave.hansen@linux.intel.com>

If flush_end ends up being at or above 1 page before the end of
memory, the following calculation can overflow:

	f->flush_end = f->flush_start + PAGE_SIZE;

x86_64 has a 2MB hole at the end of memory, so we don't expect
this to be possible there.  On i386, I believe this page is in
the fixmap, and we never use this code there.  We only do _local_
tlb flushes.

Either way, just fall back to a full tlb flush and spit out a
warning if we ever run in to this.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc: stable@vger.kernel.org
---

 b/arch/x86/mm/tlb.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff -puN arch/x86/mm/tlb.c~x86-tlb-fix-overflow arch/x86/mm/tlb.c
--- a/arch/x86/mm/tlb.c~x86-tlb-fix-overflow	2014-12-08 10:58:21.875765823 -0800
+++ b/arch/x86/mm/tlb.c	2014-12-08 10:58:21.878765959 -0800
@@ -109,8 +109,17 @@ static void flush_tlb_func(void *info)
 
 	if (f->flush_mm != this_cpu_read(cpu_tlbstate.active_mm))
 		return;
-	if (!f->flush_end)
+	if (!f->flush_end) {
 		f->flush_end = f->flush_start + PAGE_SIZE;
+		/*
+		 * Check for an overflow and just flush the whole
+		 * TLB in that case.
+		 */
+		if (f->flush_end < f->flush_start + PAGE_SIZE) {
+			f->flush_end = TLB_FLUSH_ALL;
+			VM_WARN_ON_ONCE(1);
+		}
+	}
 
 	count_vm_tlb_event(NR_TLB_REMOTE_FLUSH_RECEIVED);
 	if (this_cpu_read(cpu_tlbstate.state) == TLBSTATE_OK) {
_
