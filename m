Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933429Ab3FRQxM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 12:53:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59892 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933207Ab3FRQxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 12:53:09 -0400
Date: Tue, 18 Jun 2013 09:52:02 -0700
From: tip-bot for Yinghai Lu <tipbot@zytor.com>
Message-ID: <tip-d8d386c10630d8f7837700f4c466443d49e12cc0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, joshuacov@googlemail.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, joshuacov@googlemail.com,
        hpa@linux.intel.com
In-Reply-To: <1371154622-8929-2-git-send-email-yinghai@kernel.org>
References: <1371154622-8929-2-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, mtrr:
  Fix original mtrr range get for mtrr_cleanup
Git-Commit-ID: d8d386c10630d8f7837700f4c466443d49e12cc0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 18 Jun 2013 09:52:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d8d386c10630d8f7837700f4c466443d49e12cc0
Gitweb:     http://git.kernel.org/tip/d8d386c10630d8f7837700f4c466443d49e12cc0
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Thu, 13 Jun 2013 13:17:01 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 18 Jun 2013 11:32:02 -0500

x86, mtrr: Fix original mtrr range get for mtrr_cleanup

Joshua reported: Commit cd7b304dfaf1 (x86, range: fix missing merge
during add range) broke mtrr cleanup on his setup in 3.9.5.
corresponding commit in upstream is fbe06b7bae7c.

  *BAD*gran_size: 64K chunk_size: 16M num_reg: 6 lose cover RAM: -0G

https://bugzilla.kernel.org/show_bug.cgi?id=59491

So it rejects new var mtrr layout.

It turns out we have some problem with initial mtrr range retrieval.
The current sequence is:
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
Tested-by: Joshua Covington <joshuacov@googlemail.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1371154622-8929-2-git-send-email-yinghai@kernel.org
Cc: <stable@vger.kernel.org> v3.9
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/cpu/mtrr/cleanup.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/cleanup.c b/arch/x86/kernel/cpu/mtrr/cleanup.c
index 35ffda5..5f90b85 100644
--- a/arch/x86/kernel/cpu/mtrr/cleanup.c
+++ b/arch/x86/kernel/cpu/mtrr/cleanup.c
@@ -714,15 +714,15 @@ int __init mtrr_cleanup(unsigned address_bits)
 	if (mtrr_tom2)
 		x_remove_size = (mtrr_tom2 >> PAGE_SHIFT) - x_remove_base;
 
-	nr_range = x86_get_mtrr_mem_range(range, 0, x_remove_base, x_remove_size);
 	/*
 	 * [0, 1M) should always be covered by var mtrr with WB
 	 * and fixed mtrrs should take effect before var mtrr for it:
 	 */
-	nr_range = add_range_with_merge(range, RANGE_NUM, nr_range, 0,
+	nr_range = add_range_with_merge(range, RANGE_NUM, 0, 0,
 					1ULL<<(20 - PAGE_SHIFT));
-	/* Sort the ranges: */
-	sort_range(range, nr_range);
+	/* add from var mtrr at last */
+	nr_range = x86_get_mtrr_mem_range(range, nr_range,
+					  x_remove_base, x_remove_size);
 
 	range_sums = sum_ranges(range, nr_range);
 	printk(KERN_INFO "total RAM covered: %ldM\n",
