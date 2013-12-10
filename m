Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745Ab3LJJJM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 04:09:12 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:17830 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303Ab3LJJJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 04:09:08 -0500
Message-ID: <52A6D9B0.7040506@huawei.com>
Date: Tue, 10 Dec 2013 17:06:56 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>,
        <x86@kernel.org>, <linn@hp.com>, <penberg@kernel.org>,
        <yinghai@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, <linux-mm@kvack.org>
CC: Xishi Qiu <qiuxishi@huawei.com>
Subject: [PATCH] mm,x86: fix span coverage in e820_all_mapped()
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.196]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the following case, e820_all_mapped() will return 1.
A < start < B-1 and B < end < C, it means <start, end> spans two regions.
<start, end>:	        [start - end]
e820 addr:	    ...[A - B-1][B - C]...

Signed-off-by: Xishi Qiu <qiuxishi@huawei.com>
---
 arch/x86/kernel/e820.c |   15 +++------------
 1 files changed, 3 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 174da5f..31ecab2 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -85,20 +85,11 @@ int __init e820_all_mapped(u64 start, u64 end, unsigned type)
 
 		if (type && ei->type != type)
 			continue;
-		/* is the region (part) in overlap with the current region ?*/
+		/* is the region (part) in overlap with the current region ? */
 		if (ei->addr >= end || ei->addr + ei->size <= start)
 			continue;
-
-		/* if the region is at the beginning of <start,end> we move
-		 * start to the end of the region since it's ok until there
-		 */
-		if (ei->addr <= start)
-			start = ei->addr + ei->size;
-		/*
-		 * if start is now at or beyond end, we're done, full
-		 * coverage
-		 */
-		if (start >= end)
+		/* is the region full coverage of <start, end> ? */
+		if (ei->addr <= start && ei->addr + ei->size >= end)
 			return 1;
 	}
 	return 0;
-- 
1.7.1


