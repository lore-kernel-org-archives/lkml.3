Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608Ab3I3U3W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 16:29:22 -0400
Received: from mga14.intel.com ([143.182.124.37]:17327 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756421Ab3I3U3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 16:29:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1010,1371106800"; 
   d="scan'208";a="403328851"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@linux.intel.com>, tony.luck@intel.com, tytso@mit.edu
Subject: [PATCH 01/11] random: don't feed stack data into pool when interrupt regs NULL
Date: Mon, 30 Sep 2013 13:29:02 -0700
Message-Id: <1380572952-30729-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1380572952-30729-1-git-send-email-andi@firstfloor.org>
References: <1380572952-30729-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

In some cases, e.g. after this

arch/ia64/kernel/irq.c:185:                     struct pt_regs *old_regs = set_irq_regs(NULL);
arch/ia64/kernel/irq_ia64.c:560:                        struct pt_regs *old_regs = set_irq_regs(NULL);

the regs passed to add_interrupt_randomness() could be NULL.

In this case fast_mix would use two uninitialized ints from the stack
and mix it into the pool.

In this case set the input to 0.

Cc: tony.luck@intel.com
Cc: tytso@mit.edu
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/char/random.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 7737b5b..25ed2dc 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -752,6 +752,8 @@ void add_interrupt_randomness(int irq, int irq_flags)
 		__u64 ip = instruction_pointer(regs);
 		input[2] = ip;
 		input[3] = ip >> 32;
+	} else {
+		input[2] = input[3] = 0;
 	}
 
 	fast_mix(fast_pool, input, sizeof(input));
-- 
1.8.3.1

