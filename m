Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158Ab3HLT5I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 15:57:08 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:27328 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247Ab3HLT4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 15:56:43 -0400
Message-ID: <201308121956.r7CJugwx010311@farm-0021.internal.tilera.com>
From: Chris Metcalf <cmetcalf@tilera.com>
Date: Mon, 12 Aug 2013 14:57:12 -0400
Subject: [PATCH] tile: Enable interrupts in do_work_pending()
To: <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A recent change triggered a WARN_ON that interrupts were disabled,
and in fact other architectures enable interrupts uniformly for their
related do_work_pending() type code, and all the things we call from
this routine appear to expect interrupts to be enabled.  So, enable them.

Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
---
 arch/tile/kernel/process.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/tile/kernel/process.c b/arch/tile/kernel/process.c
index 2629ff1..9892f03 100644
--- a/arch/tile/kernel/process.c
+++ b/arch/tile/kernel/process.c
@@ -550,6 +550,9 @@ int do_work_pending(struct pt_regs *regs, u32 thread_info_flags)
 	}
 #endif
 
+	/* Enable interrupts; they are disabled again on return to caller. */
+	local_irq_enable();
+
 	if (thread_info_flags & _TIF_NEED_RESCHED) {
 		schedule();
 		return 1;
-- 
1.8.3.1

