Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751040Ab3FIUAq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 16:00:46 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:34622 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822Ab3FIUAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 16:00:44 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Joshua Covington <joshuacov@googlemail.com>,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        <stable@vger.kernel.org>
Subject: [PATCH 1/2] x86,mtrr: Fix original mtrr range get for mtrr_cleanup
Date: Sun,  9 Jun 2013 13:00:04 -0700
Message-Id: <1370808005-23565-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.1.4
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joshua reported: Commit cd7b304dfaf1 (x86, range: fix missing merge
during add range) broke mtrr cleanup on his setup in 3.9.5.
corresponding commit in upstream is fbe06b7bae7c.

  *BAD*gran_size: 64K chunk_size: 16M num_reg: 6 lose cover RAM: -0G

https://bugzilla.kernel.org/show_bug.cgi?id=59491

So it rejects new var mtrr layout.

It turns out we have some problem with initial mtrr range retrievel.
current sequence is:
	x86_get_mtrr_mem_range
		==> bunchs of add_range_with_merge
		==> bunchs of subract_range
		==> clean_sort_range
	add_range_with_merge for [0,1M)
	sort_range()

add_range_with_merge could have blank slots, so we can not just
sort only, that will have final result have extra blank slot in head.

So move that calling add_range_with_merge for [0,1M), with that we
could avoid extra clean_sort_range calling.

Reported-by: Joshua Covington <joshuacov@googlemail.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: <stable@vger.kernel.org> v3.9

---
 arch/x86/kernel/cpu/mtrr/cleanup.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/x86/kernel/cpu/mtrr/cleanup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/mtrr/cleanup.c
+++ linux-2.6/arch/x86/kernel/cpu/mtrr/cleanup.c
@@ -714,15 +714,15 @@ int __init mtrr_cleanup(unsigned address
 	if (mtrr_tom2)
 		x_remove_size = (mtrr_tom2 >> PAGE_SHIFT) - x_remove_base;
 
-	nr_range = x86_get_mtrr_mem_range(range, 0, x_remove_base, x_remove_size);
 	/*
 	 * [0, 1M) should always be covered by var mtrr with WB
 	 * and fixed mtrrs should take effect before var mtrr for it:
 	 */
 	nr_range = add_range_with_merge(range, RANGE_NUM, nr_range, 0,
 					1ULL<<(20 - PAGE_SHIFT));
-	/* Sort the ranges: */
-	sort_range(range, nr_range);
+	/* add from var mtrr at last */
+	nr_range = x86_get_mtrr_mem_range(range, nr_range,
+					  x_remove_base, x_remove_size);
 
 	range_sums = sum_ranges(range, nr_range);
 	printk(KERN_INFO "total RAM covered: %ldM\n",
