Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932983AbaHHV7Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 17:59:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60530 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933141AbaHHVg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 17:36:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 21/39] sparc64: Fix bugs in get_user_pages_fast() wrt. THP.
Date: Fri,  8 Aug 2014 14:35:07 -0700
Message-Id: <20140808213355.885172320@linuxfoundation.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <20140808213354.980430919@linuxfoundation.org>
References: <20140808213354.980430919@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit 04df419de34104d8818b8c5cffaa062fa36d20ea ]

The large PMD path needs to check _PAGE_VALID not _PAGE_PRESENT, to
decide if it needs to bail and return 0.

pmd_large() should therefore just check _PAGE_PMD_HUGE.

Calls to gup_huge_pmd() are guarded with a check of pmd_large(), so we
just need to add a valid bit check.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sparc/include/asm/pgtable_64.h |    2 +-
 arch/sparc/mm/gup.c                 |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/arch/sparc/include/asm/pgtable_64.h
+++ b/arch/sparc/include/asm/pgtable_64.h
@@ -633,7 +633,7 @@ static inline unsigned long pmd_large(pm
 {
 	pte_t pte = __pte(pmd_val(pmd));
 
-	return (pte_val(pte) & _PAGE_PMD_HUGE) && pte_present(pte);
+	return pte_val(pte) & _PAGE_PMD_HUGE;
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
--- a/arch/sparc/mm/gup.c
+++ b/arch/sparc/mm/gup.c
@@ -73,7 +73,7 @@ static int gup_huge_pmd(pmd_t *pmdp, pmd
 	struct page *head, *page, *tail;
 	int refs;
 
-	if (!pmd_large(pmd))
+	if (!(pmd_val(pmd) & _PAGE_VALID))
 		return 0;
 
 	if (write && !pmd_write(pmd))


