Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538AbaHNBxu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 21:53:50 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:57873 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422AbaHNBx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 21:53:26 -0400
X-Original-SENDERIP: 10.177.222.156
X-Original-MAILFROM: minchan@kernel.org
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Linux API <linux-api@vger.kernel.org>, Hugh Dickins <hughd@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Jason Evans <je@fb.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Minchan Kim <minchan@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Subject: [PATCH v14 3/8] sparc: add pmd_[dirty|mkclean] for THP
Date: Thu, 14 Aug 2014 10:53:27 +0900
Message-Id: <1407981212-17818-4-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1407981212-17818-1-git-send-email-minchan@kernel.org>
References: <1407981212-17818-1-git-send-email-minchan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MADV_FREE needs pmd_dirty and pmd_mkclean for detecting recent
overwrite of the contents since MADV_FREE syscall is called for
THP page.

This patch adds pmd_dirty and pmd_mkclean for THP page MADV_FREE
support.

Cc: "David S. Miller" <davem@davemloft.net>
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

