Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759324Ab3BMMOy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 07:14:54 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36626 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754310Ab3BMMOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 07:14:53 -0500
Date: Wed, 13 Feb 2013 04:12:03 -0800
From: tip-bot for Mel Gorman <mgorman@suse.de>
Message-ID: <tip-0ee364eb316348ddf3e0dfcd986f5f13f528f821@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        hannes@cmpxchg.org, riel@redhat.coM, mgorman@suse.de,
        tglx@linutronix.de, mhocko@suse.cz
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        riel@redhat.coM, mgorman@suse.de, hannes@cmpxchg.org,
        tglx@linutronix.de, mhocko@suse.cz
In-Reply-To: <20130211145236.GX21389@suse.de>
References: <20130211145236.GX21389@suse.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/mm:
  Check if PUD is large when validating a kernel address
Git-Commit-ID: 0ee364eb316348ddf3e0dfcd986f5f13f528f821
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 13 Feb 2013 04:12:10 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0ee364eb316348ddf3e0dfcd986f5f13f528f821
Gitweb:     http://git.kernel.org/tip/0ee364eb316348ddf3e0dfcd986f5f13f528f821
Author:     Mel Gorman <mgorman@suse.de>
AuthorDate: Mon, 11 Feb 2013 14:52:36 +0000
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 13 Feb 2013 10:02:55 +0100

x86/mm: Check if PUD is large when validating a kernel address

A user reported the following oops when a backup process reads
/proc/kcore:

 BUG: unable to handle kernel paging request at ffffbb00ff33b000
 IP: [<ffffffff8103157e>] kern_addr_valid+0xbe/0x110
 [...]

 Call Trace:
  [<ffffffff811b8aaa>] read_kcore+0x17a/0x370
  [<ffffffff811ad847>] proc_reg_read+0x77/0xc0
  [<ffffffff81151687>] vfs_read+0xc7/0x130
  [<ffffffff811517f3>] sys_read+0x53/0xa0
  [<ffffffff81449692>] system_call_fastpath+0x16/0x1b

Investigation determined that the bug triggered when reading
system RAM at the 4G mark. On this system, that was the first
address using 1G pages for the virt->phys direct mapping so the
PUD is pointing to a physical address, not a PMD page.

The problem is that the page table walker in kern_addr_valid() is
not checking pud_large() and treats the physical address as if
it was a PMD.  If it happens to look like pmd_none then it'll
silently fail, probably returning zeros instead of real data. If
the data happens to look like a present PMD though, it will be
walked resulting in the oops above.

This patch adds the necessary pud_large() check.

Unfortunately the problem was not readily reproducible and now
they are running the backup program without accessing
/proc/kcore so the patch has not been validated but I think it
makes sense.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Reviewed-by: Rik van Riel <riel@redhat.coM>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: stable@vger.kernel.org
Cc: linux-mm@kvack.org
Link: http://lkml.kernel.org/r/20130211145236.GX21389@suse.de
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/pgtable.h | 5 +++++
 arch/x86/mm/init_64.c          | 3 +++
 2 files changed, 8 insertions(+)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 5199db2..1c1a955 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -142,6 +142,11 @@ static inline unsigned long pmd_pfn(pmd_t pmd)
 	return (pmd_val(pmd) & PTE_PFN_MASK) >> PAGE_SHIFT;
 }
 
+static inline unsigned long pud_pfn(pud_t pud)
+{
+	return (pud_val(pud) & PTE_PFN_MASK) >> PAGE_SHIFT;
+}
+
 #define pte_page(pte)	pfn_to_page(pte_pfn(pte))
 
 static inline int pmd_large(pmd_t pte)
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 2ead3c8..75c9a6a 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -831,6 +831,9 @@ int kern_addr_valid(unsigned long addr)
 	if (pud_none(*pud))
 		return 0;
 
+	if (pud_large(*pud))
+		return pfn_valid(pud_pfn(*pud));
+
 	pmd = pmd_offset(pud, addr);
 	if (pmd_none(*pmd))
 		return 0;
