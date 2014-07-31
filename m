Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630AbaGaQKf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 12:10:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59709 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093AbaGaQKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 12:10:31 -0400
Date: Thu, 31 Jul 2014 09:10:17 -0700
From: tip-bot for Dave Hansen <tipbot@zytor.com>
Message-ID: <tip-a23421f111bb256cdbf23dcfe15f35567ab88e98@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        riel@redhat.com, mgorman@suse.de, tglx@linutronix.de,
        dave.hansen@linux.intel.com, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        riel@redhat.com, mgorman@suse.de, tglx@linutronix.de,
        dave.hansen@linux.intel.com, hpa@linux.intel.com
In-Reply-To: <20140731154058.E0F90408@viggo.jf.intel.com>
References: <20140731154058.E0F90408@viggo.jf.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86/mm: Unify remote INVLPG code
Git-Commit-ID: a23421f111bb256cdbf23dcfe15f35567ab88e98
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a23421f111bb256cdbf23dcfe15f35567ab88e98
Gitweb:     http://git.kernel.org/tip/a23421f111bb256cdbf23dcfe15f35567ab88e98
Author:     Dave Hansen <dave.hansen@linux.intel.com>
AuthorDate: Thu, 31 Jul 2014 08:40:58 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 31 Jul 2014 08:48:51 -0700

x86/mm: Unify remote INVLPG code

There are currently three paths through the remote flush code:

1. full invalidation
2. single page invalidation using invlpg
3. ranged invalidation using invlpg

This takes 2 and 3 and combines them in to a single path by
making the single-page one just be the start and end be start
plus a single page.  This makes placement of our tracepoint easier.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Link: http://lkml.kernel.org/r/20140731154058.E0F90408@viggo.jf.intel.com
Cc: Rik van Riel <riel@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/tlb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index ae584d0..add5a0f 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
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
