Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271Ab3JWJbr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 05:31:47 -0400
Received: from mail.windriver.com ([147.11.1.11]:64154 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913Ab3JWJbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 05:31:45 -0400
From: Tiejun Chen <tiejun.chen@windriver.com>
To: <scottwood@freescale.com>
CC: <benh@kernel.crashing.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Subject: [v6][PATCH 5/5] powerpc/book3e/kgdb: Fix a single stgep case of lazy IRQ
Date: Wed, 23 Oct 2013 17:31:25 +0800
Message-ID: <1382520685-11609-6-git-send-email-tiejun.chen@windriver.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1382520685-11609-1-git-send-email-tiejun.chen@windriver.com>
References: <1382520685-11609-1-git-send-email-tiejun.chen@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In lazy EE magic, we may have a lazy interrupt occured while
entering kgdb, but we really don't want to replay that interrupt
for kgdb, so we have to clear the PACA_IRQ_HARD_DIS force to
make sure we can exit directly from this debug exception.

Signed-off-by: Tiejun Chen <tiejun.chen@windriver.com>
---
 arch/powerpc/kernel/kgdb.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/powerpc/kernel/kgdb.c b/arch/powerpc/kernel/kgdb.c
index 447c14b..9872f58 100644
--- a/arch/powerpc/kernel/kgdb.c
+++ b/arch/powerpc/kernel/kgdb.c
@@ -185,6 +185,14 @@ static int kgdb_singlestep(struct pt_regs *regs)
 		/* Restore current_thread_info lastly. */
 		memcpy(exception_thread_info, backup_current_thread_info, sizeof *thread_info);
 
+#ifdef CONFIG_PPC64
+	/*
+	 * Clear the PACA_IRQ_HARD_DIS from the pending mask
+	 * since we are about to exit this directly from debug
+	 * exception without any replay interrupt in lazy EE case.
+	 */
+	local_paca->irq_happened &= ~PACA_IRQ_HARD_DIS;
+#endif
 	return 1;
 }
 
-- 
1.7.9.5

