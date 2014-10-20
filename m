Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709AbaJTKMj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 06:12:39 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:64753 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404AbaJTKLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 06:11:48 -0400
X-Original-SENDERIP: 10.177.220.156
X-Original-MAILFROM: minchan@kernel.org
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Michael Kerrisk <mtk.manpages@gmail.com>, linux-api@vger.kernel.org,
        Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Jason Evans <je@fb.com>,
        zhangyanfei@cn.fujitsu.com,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Minchan Kim <minchan@kernel.org>, sparclinux@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH v17 3/7] sparc: add pmd_[dirty|mkclean] for THP
Date: Mon, 20 Oct 2014 19:12:00 +0900
Message-Id: <1413799924-17946-4-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1413799924-17946-1-git-send-email-minchan@kernel.org>
References: <1413799924-17946-1-git-send-email-minchan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MADV_FREE needs pmd_dirty and pmd_mkclean for detecting recent
overwrite of the contents since MADV_FREE syscall is called for
THP page.

This patch adds pmd_dirty and pmd_mkclean for THP page MADV_FREE
support.

Acked-by: David S. Miller <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 arch/sparc/include/asm/pgtable_64.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/sparc/include/asm/pgtable_64.h b/arch/sparc/include/asm/pgtable_64.h
index 3770bf5c6e1b..b80a309d7e00 100644
--- a/arch/sparc/include/asm/pgtable_64.h
+++ b/arch/sparc/include/asm/pgtable_64.h
@@ -666,6 +666,13 @@ static inline unsigned long pmd_young(pmd_t pmd)
 	return pte_young(pte);
 }
 
+static inline int pmd_dirty(pmd_t pmd)
+{
+	pte_t pte = __pte(pmd_val(pmd));
+
+	return pte_dirty(pte);
+}
+
 static inline unsigned long pmd_write(pmd_t pmd)
 {
 	pte_t pte = __pte(pmd_val(pmd));
@@ -723,6 +730,15 @@ static inline pmd_t pmd_mkdirty(pmd_t pmd)
 	return __pmd(pte_val(pte));
 }
 
+static inline pmd_t pmd_mkclean(pmd_t pmd)
+{
+	pte_t pte = __pte(pmd_val(pmd));
+
+	pte = pte_mkclean(pte);
+
+	return __pmd(pte_val(pte));
+}
+
 static inline pmd_t pmd_mkyoung(pmd_t pmd)
 {
 	pte_t pte = __pte(pmd_val(pmd));
-- 
2.0.0

