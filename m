Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138Ab3AVVYs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 16:24:48 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:43872 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754734Ab3AVVYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 16:24:42 -0500
Subject: [PATCH 3/5] use new pagetable helpers in try_preserve_large_page()
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, Gleb Natapov <gleb@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>, Rik van Riel <riel@redhat.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Tue, 22 Jan 2013 13:24:32 -0800
References: <20130122212428.8DF70119@kernel.stglabs.ibm.com>
In-Reply-To: <20130122212428.8DF70119@kernel.stglabs.ibm.com>
Message-Id: <20130122212432.14F3D993@kernel.stglabs.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012221-5806-0000-0000-00001E9C4A94
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


try_preserve_large_page() can be slightly simplified by using
the new page_level_*() helpers.  This also moves the 'level'
over to the new pg_level enum type.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/arch/x86/mm/pageattr.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff -puN arch/x86/mm/pageattr.c~use-new-pagetable-helpers arch/x86/mm/pageattr.c
--- linux-2.6.git/arch/x86/mm/pageattr.c~use-new-pagetable-helpers	2013-01-22 13:17:15.792312210 -0800
+++ linux-2.6.git-dave/arch/x86/mm/pageattr.c	2013-01-22 13:17:15.796312243 -0800
@@ -396,7 +396,7 @@ try_preserve_large_page(pte_t *kpte, uns
 	pte_t new_pte, old_pte, *tmp;
 	pgprot_t old_prot, new_prot, req_prot;
 	int i, do_split = 1;
-	unsigned int level;
+	enum pg_level level;
 
 	if (cpa->force_split)
 		return 1;
@@ -412,15 +412,12 @@ try_preserve_large_page(pte_t *kpte, uns
 
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
_

