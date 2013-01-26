Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435Ab3AZBx7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 20:53:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48744 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754636Ab3AZBx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 20:53:56 -0500
Date: Fri, 25 Jan 2013 17:53:43 -0800
From: tip-bot for Dave Hansen <dave@linux.vnet.ibm.com>
Message-ID: <tip-f3c4fbb68e93b10c781c0cc462a9d80770244da6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        dave@linux.vnet.ibm.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dave@linux.vnet.ibm.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <20130122212432.14F3D993@kernel.stglabs.ibm.com>
References: <20130122212432.14F3D993@kernel.stglabs.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86, mm:
  Use new pagetable helpers in try_preserve_large_page()
Git-Commit-ID: f3c4fbb68e93b10c781c0cc462a9d80770244da6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 25 Jan 2013 17:53:48 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f3c4fbb68e93b10c781c0cc462a9d80770244da6
Gitweb:     http://git.kernel.org/tip/f3c4fbb68e93b10c781c0cc462a9d80770244da6
Author:     Dave Hansen <dave@linux.vnet.ibm.com>
AuthorDate: Tue, 22 Jan 2013 13:24:32 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 25 Jan 2013 16:33:23 -0800

x86, mm: Use new pagetable helpers in try_preserve_large_page()

try_preserve_large_page() can be slightly simplified by using
the new page_level_*() helpers.  This also moves the 'level'
over to the new pg_level enum type.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/20130122212432.14F3D993@kernel.stglabs.ibm.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/mm/pageattr.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 40f92f3..2a5c9ab 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -396,7 +396,7 @@ try_preserve_large_page(pte_t *kpte, unsigned long address,
 	pte_t new_pte, old_pte, *tmp;
 	pgprot_t old_prot, new_prot, req_prot;
 	int i, do_split = 1;
-	unsigned int level;
+	enum pg_level level;
 
 	if (cpa->force_split)
 		return 1;
@@ -412,15 +412,12 @@ try_preserve_large_page(pte_t *kpte, unsigned long address,
 
 	switch (level) {
 	case PG_LEVEL_2M:
-		psize = PMD_PAGE_SIZE;
-		pmask = PMD_PAGE_MASK;
-		break;
 #ifdef CONFIG_X86_64
 	case PG_LEVEL_1G:
-		psize = PUD_PAGE_SIZE;
-		pmask = PUD_PAGE_MASK;
-		break;
 #endif
+		psize = page_level_size(level);
+		pmask = page_level_mask(level);
+		break;
 	default:
 		do_split = -EINVAL;
 		goto out_unlock;
