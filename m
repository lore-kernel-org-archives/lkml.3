Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934524AbaGXTvV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 15:51:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14554 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934310AbaGXTvU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 15:51:20 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>, Chen Yucong <slaoub@gmail.com>,
        Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: [PATCH 2/2] hwpoison: call action_result() in failure path of hwpoison_user_mappings()
Date: Thu, 24 Jul 2014 15:50:53 -0400
Message-Id: <1406231453-27928-2-git-send-email-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <1406231453-27928-1-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1406231453-27928-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hwpoison_user_mappings() could fail for various reasons, so printk()s
to print out the reasons should be done in each failure check inside
hwpoison_user_mappings().
And currently we don't call action_result() when hwpoison_user_mappings()
fails, which is not consistent with other exit points of memory error
handler. So this patch fixes these messaging problems.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
---
 mm/memory-failure.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git mmotm-2014-07-22-15-58.orig/mm/memory-failure.c mmotm-2014-07-22-15-58/mm/memory-failure.c
index f465b98d0209..44c6bd201d3a 100644
--- mmotm-2014-07-22-15-58.orig/mm/memory-failure.c
+++ mmotm-2014-07-22-15-58/mm/memory-failure.c
@@ -911,8 +911,10 @@ static int hwpoison_user_mappings(struct page *p, unsigned long pfn,
 	if (!page_mapped(hpage))
 		return SWAP_SUCCESS;
 
-	if (PageKsm(p))
+	if (PageKsm(p)) {
+		pr_err("MCE %#lx: can't handle KSM pages.\n", pfn);
 		return SWAP_FAIL;
+	}
 
 	if (PageSwapCache(p)) {
 		printk(KERN_ERR
@@ -1245,7 +1247,7 @@ int memory_failure(unsigned long pfn, int trapno, int flags)
 	 */
 	if (hwpoison_user_mappings(p, pfn, trapno, flags, &hpage)
 	    != SWAP_SUCCESS) {
-		printk(KERN_ERR "MCE %#lx: cannot unmap page, give up\n", pfn);
+		action_result(pfn, "unmapping failed", IGNORED);
 		res = -EBUSY;
 		goto out;
 	}
-- 
1.9.3

