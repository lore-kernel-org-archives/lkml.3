Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590AbaGGAwg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 20:52:36 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:42398 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510AbaGGAwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 20:52:34 -0400
X-Original-SENDERIP: 10.177.220.169
X-Original-MAILFROM: minchan@kernel.org
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Linux API <linux-api@vger.kernel.org>, Hugh Dickins <hughd@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Jason Evans <je@fb.com>,
        Zhang Yanfei <zhangyanfei@cn.fujitsu.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Minchan Kim <minchan@kernel.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Dominik Dingel <dingel@linux.vnet.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390@vger.kernel.org
Subject: [PATCH v10 5/7] s390: add pmd_[dirty|mkclean] for THP
Date: Mon,  7 Jul 2014 09:53:56 +0900
Message-Id: <1404694438-10272-6-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404694438-10272-1-git-send-email-minchan@kernel.org>
References: <1404694438-10272-1-git-send-email-minchan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MADV_FREE needs pmd_dirty and pmd_mkclean for detecting recent
overwrite of the contents since MADV_FREE syscall is called for
THP page but for s390 pmds only referenced bit is available
because there is no free bit left in the pmd entry for the
software dirty bit so this patch adds dumb pmd_dirty which
returns always true by suggesting by Martin.

They finally find a solution in future.
http://marc.info/?l=linux-api&m=140440328820808&w=2

Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: Dominik Dingel <dingel@linux.vnet.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Cc: linux-s390@vger.kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 arch/s390/include/asm/pgtable.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index fcba5e03839f..9862fcb0592b 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -1586,6 +1586,18 @@ static inline pmd_t pmd_mkdirty(pmd_t pmd)
 	return pmd;
 }
 
+static inline int pmd_dirty(pmd_t pmd)
+{
+	/* No dirty bit in the segment table entry */
+	return 1;
+}
+
+static inline pmd_t pmd_mkclean(pmd_t pmd)
+{
+	/* No dirty bit in the segment table entry */
+	return pmd;
+}
+
 #define __HAVE_ARCH_PMDP_TEST_AND_CLEAR_YOUNG
 static inline int pmdp_test_and_clear_young(struct vm_area_struct *vma,
 					    unsigned long address, pmd_t *pmdp)
-- 
2.0.0

