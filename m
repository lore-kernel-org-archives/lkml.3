Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889AbaGAAcZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 20:32:25 -0400
Received: from mga02.intel.com ([134.134.136.20]:17894 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750996AbaGAAcU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 20:32:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,578,1400050800"; 
   d="scan'208";a="566321685"
From: Andi Kleen <andi@firstfloor.org>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Andi Kleen <ak@linux.intel.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: [PATCH] hwpoison: Fix race with changing page during offlining v2
Date: Mon, 30 Jun 2014 17:32:16 -0700
Message-Id: <1404174736-17480-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

When a hwpoison page is locked it could change state
due to parallel modifications.  Check after the lock
if the page is still the same compound page.

[v2: Removed earlier non LRU check which should be already
covered elsewhere]

Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 mm/memory-failure.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index cd8989c..99e5077 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1168,6 +1168,16 @@ int memory_failure(unsigned long pfn, int trapno, int flags)
 	lock_page(hpage);
 
 	/*
+	 * The page could have changed compound pages during the locking.
+	 * If this happens just bail out.
+	 */
+	if (compound_head(p) != hpage) {
+		action_result(pfn, "different compound page after locking", IGNORED);
+		res = -EBUSY;
+		goto out;
+	}
+
+	/*
 	 * We use page flags to determine what action should be taken, but
 	 * the flags can be modified by the error containment action.  One
 	 * example is an mlocked page, where PG_mlocked is cleared by
-- 
1.9.3

