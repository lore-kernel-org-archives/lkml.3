Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751486Ab3HTGz1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 02:55:27 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:43842 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab3HTGzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 02:55:16 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Rik van Riel <riel@redhat.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v2 1/4] mm/pgtable: Fix continue to preallocate pmds even if failure occurrence
Date: Tue, 20 Aug 2013 14:54:53 +0800
Message-Id: <1376981696-4312-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082006-9574-0000-0000-00000940DC52
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v1 -> v2:
 * remove failed.

preallocate_pmds will continue to preallocate pmds even if failure
occurrence, and then free all the preallocate pmds if there is
failure, this patch fix it by stop preallocate if failure occurrence
and go to free path.

Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 arch/x86/mm/pgtable.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index dfa537a..65c2106 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -196,21 +196,18 @@ static void free_pmds(pmd_t *pmds[])
 static int preallocate_pmds(pmd_t *pmds[])
 {
 	int i;
-	bool failed = false;
 
 	for(i = 0; i < PREALLOCATED_PMDS; i++) {
 		pmd_t *pmd = (pmd_t *)__get_free_page(PGALLOC_GFP);
 		if (pmd == NULL)
-			failed = true;
+			goto err;
 		pmds[i] = pmd;
 	}
 
-	if (failed) {
-		free_pmds(pmds);
-		return -ENOMEM;
-	}
-
 	return 0;
+err:
+	free_pmds(pmds);
+	return -ENOMEM;
 }
 
 /*
-- 
1.8.1.2

