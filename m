Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751436Ab3IRAjQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 20:39:16 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:53178 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088Ab3IRAjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 20:39:13 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Fengguang Wu <fengguang.wu@intel.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Tony Luck <tony.luck@intel.com>, gong.chen@linux.intel.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [PATCH v3 4/4] mm/hwpoison: fix the lack of one reference count against poisoned page
Date: Wed, 18 Sep 2013 08:38:57 +0800
Message-Id: <1379464737-23592-4-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1379464737-23592-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1379464737-23592-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091800-8878-0000-0000-000008E1B47C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The lack of one reference count against poisoned page for hwpoison_inject w/o
hwpoison_filter enabled result in hwpoison detect -1 users still referenced
the page, however, the number should be 0 except the poison handler held one
after successfully unmap. This patch fix it by hold one referenced count against
poisoned page for hwpoison_inject w/ and w/o hwpoison_filter enabled.

Before patch:

[   71.902112] Injecting memory failure at pfn 224706
[   71.902137] MCE 0x224706: dirty LRU page recovery: Failed
[   71.902138] MCE 0x224706: dirty LRU page still referenced by -1 users

After patch:

[   94.710860] Injecting memory failure at pfn 215b68
[   94.710885] MCE 0x215b68: dirty LRU page recovery: Recovered

Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Acked-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 mm/hwpoison-inject.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/hwpoison-inject.c b/mm/hwpoison-inject.c
index afc2daa..4c84678 100644
--- a/mm/hwpoison-inject.c
+++ b/mm/hwpoison-inject.c
@@ -20,8 +20,6 @@ static int hwpoison_inject(void *data, u64 val)
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	if (!hwpoison_filter_enable)
-		goto inject;
 	if (!pfn_valid(pfn))
 		return -ENXIO;
 
@@ -33,6 +31,9 @@ static int hwpoison_inject(void *data, u64 val)
 	if (!get_page_unless_zero(hpage))
 		return 0;
 
+	if (!hwpoison_filter_enable)
+		goto inject;
+
 	if (!PageLRU(p) && !PageHuge(p))
 		shake_page(p, 0);
 	/*
-- 
1.7.5.4

