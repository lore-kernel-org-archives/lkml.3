Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258Ab3A3BWk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 20:22:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43614 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119Ab3A3BWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 20:22:37 -0500
Date: Tue, 29 Jan 2013 17:22:26 -0800
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Message-ID: <tip-c2bdee594ebcf4a531afe795baf18da509438392@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1359058816-7615-6-git-send-email-yinghai@kernel.org>
References: <1359058816-7615-6-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm2] x86, 64bit, mm:
  Make pgd next calculation consistent with pud/pmd
Git-Commit-ID: c2bdee594ebcf4a531afe795baf18da509438392
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 29 Jan 2013 17:22:32 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c2bdee594ebcf4a531afe795baf18da509438392
Gitweb:     http://git.kernel.org/tip/c2bdee594ebcf4a531afe795baf18da509438392
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Thu, 24 Jan 2013 12:19:46 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 29 Jan 2013 15:12:24 -0800

x86, 64bit, mm: Make pgd next calculation consistent with pud/pmd

Just like the way we calculate next for pud and pmd, aka round down and
add size.

Also, do not do boundary-checking with 'next', and just pass 'end' down
to phys_pud_init() instead. Because the loop in phys_pud_init() stops at
PTRS_PER_PUD and thus can handle a possibly bigger 'end' properly.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1359058816-7615-6-git-send-email-yinghai@kernel.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/init_64.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 191ab12..d7af907 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -530,9 +530,7 @@ kernel_physical_mapping_init(unsigned long start,
 		pgd_t *pgd = pgd_offset_k(start);
 		pud_t *pud;
 
-		next = (start + PGDIR_SIZE) & PGDIR_MASK;
-		if (next > end)
-			next = end;
+		next = (start & PGDIR_MASK) + PGDIR_SIZE;
 
 		if (pgd_val(*pgd)) {
 			pud = (pud_t *)pgd_page_vaddr(*pgd);
@@ -542,7 +540,7 @@ kernel_physical_mapping_init(unsigned long start,
 		}
 
 		pud = alloc_low_page();
-		last_map_addr = phys_pud_init(pud, __pa(start), __pa(next),
+		last_map_addr = phys_pud_init(pud, __pa(start), __pa(end),
 						 page_size_mask);
 
 		spin_lock(&init_mm.page_table_lock);
