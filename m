Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933319Ab3E1IAR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 04:00:17 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:40404 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933246Ab3E1IAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 04:00:15 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zz853kzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h1354h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dc1h1155h)
From: Zhao Chenhui <chenhui.zhao@freescale.com>
To: <linuxppc-dev@lists.ozlabs.org>, <scottwood@freescale.com>
CC: <linux-kernel@vger.kernel.org>, <leoli@freescale.com>
Subject: [PATCH] powerpc/mpic: fix irq distribution problem when MPIC_SINGLE_DEST_CPU
Date: Tue, 28 May 2013 15:59:43 +0800
Message-ID: <1369727984-21505-1-git-send-email-chenhui.zhao@freescale.com>
X-Mailer: git-send-email 1.7.3
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the mpic with a flag MPIC_SINGLE_DEST_CPU, only one bit should be
set in interrupt destination registers.

The code is applicable to 64-bit platforms as well as 32-bit.

Signed-off-by: Zhao Chenhui <chenhui.zhao@freescale.com>
---
 arch/powerpc/sysdev/mpic.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/sysdev/mpic.c b/arch/powerpc/sysdev/mpic.c
index 0a13ecb..3cc2f91 100644
--- a/arch/powerpc/sysdev/mpic.c
+++ b/arch/powerpc/sysdev/mpic.c
@@ -54,7 +54,7 @@ static DEFINE_RAW_SPINLOCK(mpic_lock);
 
 #ifdef CONFIG_PPC32	/* XXX for now */
 #ifdef CONFIG_IRQ_ALL_CPUS
-#define distribute_irqs	(!(mpic->flags & MPIC_SINGLE_DEST_CPU))
+#define distribute_irqs	(1)
 #else
 #define distribute_irqs	(0)
 #endif
@@ -1703,7 +1703,7 @@ void mpic_setup_this_cpu(void)
 	 * it differently, then we should make sure we also change the default
 	 * values of irq_desc[].affinity in irq.c.
  	 */
-	if (distribute_irqs) {
+	if (distribute_irqs && !(mpic->flags & MPIC_SINGLE_DEST_CPU)) {
 	 	for (i = 0; i < mpic->num_sources ; i++)
 			mpic_irq_write(i, MPIC_INFO(IRQ_DESTINATION),
 				mpic_irq_read(i, MPIC_INFO(IRQ_DESTINATION)) | msk);
-- 
1.7.3


