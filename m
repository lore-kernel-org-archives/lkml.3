Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393Ab3A3Bol (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 20:44:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43921 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab3A3Bok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 20:44:40 -0500
Date: Tue, 29 Jan 2013 17:44:28 -0800
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Message-ID: <tip-0e691cf824f76adefb4498fe39c300aba2c2575a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, alexander.h.duyck@intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, alexander.h.duyck@intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <1359058816-7615-25-git-send-email-yinghai@kernel.org>
References: <1359058816-7615-25-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm2] x86, kexec, 64bit: Only set ident mapping for ram.
Git-Commit-ID: 0e691cf824f76adefb4498fe39c300aba2c2575a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 29 Jan 2013 17:44:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0e691cf824f76adefb4498fe39c300aba2c2575a
Gitweb:     http://git.kernel.org/tip/0e691cf824f76adefb4498fe39c300aba2c2575a
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Thu, 24 Jan 2013 12:20:05 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 29 Jan 2013 15:26:35 -0800

x86, kexec, 64bit: Only set ident mapping for ram.

We should set mappings only for usable memory ranges under max_pfn
Otherwise causes same problem that is fixed by

	x86, mm: Only direct map addresses that are marked as E820_RAM

This patch exposes pfn_mapped array, and only sets ident mapping for ranges
in that array.

This patch relies on new kernel_ident_mapping_init that could handle existing
pgd/pud between different calls.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1359058816-7615-25-git-send-email-yinghai@kernel.org
Cc: Alexander Duyck <alexander.h.duyck@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/page.h        |  4 ++++
 arch/x86/kernel/machine_kexec_64.c | 13 +++++++++----
 arch/x86/mm/init.c                 |  4 ++--
 3 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/page.h b/arch/x86/include/asm/page.h
index 8ca8283..100a20c 100644
--- a/arch/x86/include/asm/page.h
+++ b/arch/x86/include/asm/page.h
@@ -17,6 +17,10 @@
 
 struct page;
 
+#include <linux/range.h>
+extern struct range pfn_mapped[];
+extern int nr_pfn_mapped;
+
 static inline void clear_user_page(void *page, unsigned long vaddr,
 				   struct page *pg)
 {
diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
index d2d7e02..4eabc16 100644
--- a/arch/x86/kernel/machine_kexec_64.c
+++ b/arch/x86/kernel/machine_kexec_64.c
@@ -100,10 +100,15 @@ static int init_pgtable(struct kimage *image, unsigned long start_pgtable)
 
 	level4p = (pgd_t *)__va(start_pgtable);
 	clear_page(level4p);
-	result = kernel_ident_mapping_init(&info, level4p,
-						0, max_pfn << PAGE_SHIFT);
-	if (result)
-		return result;
+	for (i = 0; i < nr_pfn_mapped; i++) {
+		mstart = pfn_mapped[i].start << PAGE_SHIFT;
+		mend   = pfn_mapped[i].end << PAGE_SHIFT;
+
+		result = kernel_ident_mapping_init(&info,
+						 level4p, mstart, mend);
+		if (result)
+			return result;
+	}
 
 	/*
 	 * segments's mem ranges could be outside 0 ~ max_pfn,
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 3364a76..d418152 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -302,8 +302,8 @@ static int __meminit split_mem_range(struct map_range *mr, int nr_range,
 	return nr_range;
 }
 
-static struct range pfn_mapped[E820_X_MAX];
-static int nr_pfn_mapped;
+struct range pfn_mapped[E820_X_MAX];
+int nr_pfn_mapped;
 
 static void add_pfn_range_mapped(unsigned long start_pfn, unsigned long end_pfn)
 {
