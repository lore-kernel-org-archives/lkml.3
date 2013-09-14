Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932513Ab3INXzK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 19:55:10 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:53667 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756930Ab3INXys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 19:54:48 -0400
From: Wanpeng Li <liwanp@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Fengguang Wu <fengguang.wu@intel.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Tony Luck <tony.luck@intel.com>, gong.chen@linux.intel.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>
Subject: [RESEND PATCH v2 4/4] mm/hwpoison: fix the lack of one reference count against poisoned page 
Date: Sun, 15 Sep 2013 07:53:59 +0800
Message-Id: <1379202839-23939-4-git-send-email-liwanp@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1379202839-23939-1-git-send-email-liwanp@linux.vnet.ibm.com>
References: <1379202839-23939-1-git-send-email-liwanp@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13091423-1618-0000-0000-000004A0E1F3
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
Signed-off-by: Wanpeng Li <liwanp@linux.vnet.ibm.com>
---
 mm/hwpoison-inject.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

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
1.8.1.2

