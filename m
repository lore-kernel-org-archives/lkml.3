Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756304Ab3BUSkO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 13:40:14 -0500
Received: from kiruna.synopsys.com ([198.182.44.80]:63902 "EHLO
	kiruna.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756157Ab3BUSkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 13:40:12 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Andrew Morton <akpm@linux-foundation.org>, Chris Zankel <chris@zankel.net>,
        Max Filippov <jcmvbkbc@gmail.com>, Marc Gauthier <marc@tensilica.com>
CC: Vineet Gupta <Vineet.Gupta1@synopsys.com>, Tejun Heo <tj@kernel.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, Ingo Molnar <mingo@kernel.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] memblock: add assertion for zero allocation size
Date: Fri, 22 Feb 2013 00:09:21 +0530
Message-ID: <1361471962-25164-2-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1361471962-25164-1-git-send-email-vgupta@synopsys.com>
References: <1361471962-25164-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.197.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This came to light when calling memblock allocator from arc port (for
copying flattended DT). If a "0" alignment is passed, the allocator
round_up() call incorrectly rounds up the size to 0.

round_up(num, alignto) => ((num - 1) | (alignto -1)) + 1

While the obvious allocation failure causes kernel to panic, it is
better to BUG_ON() if effective size for allocation (as passed by caller
and/or computed after alignemtn rounding) is zero.

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
---
 mm/memblock.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index 1bcd9b9..32b36d0 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -824,6 +824,8 @@ static phys_addr_t __init memblock_alloc_base_nid(phys_addr_t size,
 	/* align @size to avoid excessive fragmentation on reserved array */
 	size = round_up(size, align);
 
+	BUG_ON(!size);
+
 	found = memblock_find_in_range_node(0, max_addr, size, align, nid);
 	if (found && !memblock_reserve(found, size))
 		return found;
-- 
1.7.4.1

