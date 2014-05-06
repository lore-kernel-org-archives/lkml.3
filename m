Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933700AbaEFBeI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 21:34:08 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:29243 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933687AbaEFBeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 21:34:05 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tony Luck <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        linux-sh@vger.kernel.org
Subject: [PATCH v3 2/8] sh, irq: Remove irq_reserve_irq calling
Date: Mon,  5 May 2014 18:33:20 -0700
Message-Id: <1399340006-31550-3-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1399340006-31550-1-git-send-email-yinghai@kernel.org>
References: <1399340006-31550-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

in sh calling path:
	register_intc_controller
		==> irq_create_identity_mapping/irq_create_strict_mappins
			==>irq_alloc_desc: it will set bits on allocate_irq
		==> intc_register_irq
			==> irq_reserve_irq: set bits again

so we can kill this irq_reserve_irq calling.

-v2: Fix comment style according to Sergei Shtylyov.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Simon Horman <horms@verge.net.au>
Cc: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-sh@vger.kernel.org
Acked-by: Simon Horman <horms+renesas@verge.net.au>
---
 drivers/sh/intc/core.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/sh/intc/core.c b/drivers/sh/intc/core.c
index 8f32a13..d146ce1 100644
--- a/drivers/sh/intc/core.c
+++ b/drivers/sh/intc/core.c
@@ -80,12 +80,7 @@ static void __init intc_register_irq(struct intc_desc *desc,
 	unsigned int data[2], primary;
 	unsigned long flags;
 
-	/*
-	 * Register the IRQ position with the global IRQ map, then insert
-	 * it in to the radix tree.
-	 */
-	irq_reserve_irq(irq);
-
+	/* Insert it in to the radix tree. */
 	raw_spin_lock_irqsave(&intc_big_lock, flags);
 	radix_tree_insert(&d->tree, enum_id, intc_irq_xlate_get(irq));
 	raw_spin_unlock_irqrestore(&intc_big_lock, flags);
-- 
1.8.4.5

