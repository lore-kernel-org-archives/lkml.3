Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031159Ab3HIVAE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 17:00:04 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:26150 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031117Ab3HIVAA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 17:00:00 -0400
Message-ID: <201308092100.r79L00P9011261@lab-41.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Fri, 9 Aug 2013 16:09:41 -0400
Subject: [PATCH] tile: do less L1 I-cache eviction
To: <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We had been doing an automatic full eviction of the L1 I$
everywhere whenever we did a kernel-space TLB flush.  It turns
out this isn't necessary, since all the callers already handle
doing a flush if necessary.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/tlb.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/arch/tile/kernel/tlb.c b/arch/tile/kernel/tlb.c
index 3fd54d5..f23b535 100644
--- a/arch/tile/kernel/tlb.c
+++ b/arch/tile/kernel/tlb.c
@@ -91,8 +91,14 @@ void flush_tlb_all(void)
 	}
 }
 
+/*
+ * Callers need to flush the L1I themselves if necessary, e.g. for
+ * kernel module unload.  Otherwise we assume callers are not using
+ * executable pgprot_t's.  Using EVICT_L1I means that dataplane cpus
+ * will get an unnecessary interrupt otherwise.
+ */
 void flush_tlb_kernel_range(unsigned long start, unsigned long end)
 {
-	flush_remote(0, HV_FLUSH_EVICT_L1I, cpu_online_mask,
+	flush_remote(0, 0, NULL,
 		     start, end - start, PAGE_SIZE, cpu_online_mask, NULL, 0);
 }
-- 
1.8.3.1

