Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752570Ab3EJMIx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 08:08:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37322 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785Ab3EJMIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 08:08:51 -0400
Date: Fri, 10 May 2013 05:08:23 -0700
From: tip-bot for Zhang Yanfei <tipbot@zytor.com>
Message-ID: <tip-cf8b166d5c1c89aad6c436a954fa40fd18a75bfb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        konrad.wilk@oracle.com, zhangyanfei@cn.fujitsu.com,
        akpm@linux-foundation.org, isimatu.yasuaki@jp.fujitsu.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, zhangyanfei@cn.fujitsu.com,
        akpm@linux-foundation.org, isimatu.yasuaki@jp.fujitsu.com,
        tglx@linutronix.de
In-Reply-To: <518BC776.7010506@gmail.com>
References: <518BC776.7010506@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/mm:
  Add missing comments for initial kernel direct mapping
Git-Commit-ID: cf8b166d5c1c89aad6c436a954fa40fd18a75bfb
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

Commit-ID:  cf8b166d5c1c89aad6c436a954fa40fd18a75bfb
Gitweb:     http://git.kernel.org/tip/cf8b166d5c1c89aad6c436a954fa40fd18a75bfb
Author:     Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
AuthorDate: Thu, 9 May 2013 23:57:42 +0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 10 May 2013 12:00:35 +0200

x86/mm: Add missing comments for initial kernel direct mapping

Two sets of comments were lost during patch-series shuffling:

  - comments for init_range_memory_mapping()

  - comments in init_mem_mapping that is helpful for reminding people
    that the pagetable is setup top-down

The comments were written by Yinghai in his patch in:

   https://lkml.org/lkml/2012/11/28/620

This patch reintroduces them.

Originally-From: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/518BC776.7010506@gmail.com
[ Tidied it all up a bit. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/mm/init.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index fdc5dca..eaac174 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -359,7 +359,17 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 }
 
 /*
- * would have hole in the middle or ends, and only ram parts will be mapped.
+ * We need to iterate through the E820 memory map and create direct mappings
+ * for only E820_RAM and E820_KERN_RESERVED regions. We cannot simply
+ * create direct mappings for all pfns from [0 to max_low_pfn) and
+ * [4GB to max_pfn) because of possible memory holes in high addresses
+ * that cannot be marked as UC by fixed/variable range MTRRs.
+ * Depending on the alignment of E820 ranges, this may possibly result
+ * in using smaller size (i.e. 4K instead of 2M or 1G) page tables.
+ *
+ * init_mem_mapping() calls init_range_memory_mapping() with big range.
+ * That range would have hole in the middle or ends, and only ram parts
+ * will be mapped in init_range_memory_mapping().
  */
 static unsigned long __init init_range_memory_mapping(
 					   unsigned long r_start,
@@ -419,6 +429,13 @@ void __init init_mem_mapping(void)
 	max_pfn_mapped = 0; /* will get exact value next */
 	min_pfn_mapped = real_end >> PAGE_SHIFT;
 	last_start = start = real_end;
+
+	/*
+	 * We start from the top (end of memory) and go to the bottom.
+	 * The memblock_find_in_range() gets us a block of RAM from the
+	 * end of RAM in [min_pfn_mapped, max_pfn_mapped) used as new pages
+	 * for page table.
+	 */
 	while (last_start > ISA_END_ADDRESS) {
 		if (last_start > step_size) {
 			start = round_down(last_start - 1, step_size);
