Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569Ab3BUUxA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 15:53:00 -0500
Received: from us01smtp3.synopsys.com ([198.182.44.81]:49723 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747Ab3BUUw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 15:52:58 -0500
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Yinghai Lu <yinghai@kernel.org>
CC: Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, Ingo Molnar <mingo@kernel.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 1/2] memblock: add assertion for zero allocation alignment
Date: Fri, 22 Feb 2013 02:22:20 +0530
Message-ID: <1361479940-8078-1-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <CAE9FiQV20uj_kOViCOd4gdPFuAf28fEbjhGCrzNogQWx5T3+zg@mail.gmail.com>
References: <CAE9FiQV20uj_kOViCOd4gdPFuAf28fEbjhGCrzNogQWx5T3+zg@mail.gmail.com>
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
better to warn the caller to fix the code.

Tejun suggested that instead of BUG_ON(!align) - which might be
ineffective due to pending console init and such, it is better to
WARN_ON, and continue the boot with a reasonable default align.

Caller passing @size need not be handled similarly as the subsequent
panic will indicate that anyhow.

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
---
 mm/memblock.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index 1bcd9b9..8080cf8 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -821,6 +821,9 @@ static phys_addr_t __init memblock_alloc_base_nid(phys_addr_t size,
 {
 	phys_addr_t found;
 
+	if (WARN_ON(!align))
+		align = __alignof__(long long);
+
 	/* align @size to avoid excessive fragmentation on reserved array */
 	size = round_up(size, align);
 
-- 
1.7.4.1

