Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751086AbaCGFA2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 00:00:28 -0500
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:2119 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751674AbaCGE6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 23:58:33 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h1354h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh25cch25f6h2605h1155h)
From: Chenhui Zhao <chenhui.zhao@freescale.com>
To: <linuxppc-dev@lists.ozlabs.org>
CC: <linux-kernel@vger.kernel.org>, <scottwood@freescale.com>,
        <leoli@freescale.com>, <Jason.Jin@freescale.com>
Subject: [PATCH 5/9] powerpc/85xx: disable irq by hardware when suspend for 64-bit
Date: Fri, 7 Mar 2014 12:58:01 +0800
Message-ID: <1394168285-32275-5-git-send-email-chenhui.zhao@freescale.com>
X-Mailer: git-send-email 1.7.3
In-Reply-To: <1394168285-32275-1-git-send-email-chenhui.zhao@freescale.com>
References: <1394168285-32275-1-git-send-email-chenhui.zhao@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In 64-bit mode, kernel just clears the irq soft-enable flag
in struct paca_struct to disable external irqs. But, in
the case of suspend, irqs should be disabled by hardware.
Therefore, hook a function to ppc_md.suspend_disable_irqs
to really disable irqs.

Signed-off-by: Chenhui Zhao <chenhui.zhao@freescale.com>
---
 arch/powerpc/platforms/85xx/corenet_generic.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/platforms/85xx/corenet_generic.c b/arch/powerpc/platforms/85xx/corenet_generic.c
index 3fdf9f3..983d81f 100644
--- a/arch/powerpc/platforms/85xx/corenet_generic.c
+++ b/arch/powerpc/platforms/85xx/corenet_generic.c
@@ -32,6 +32,13 @@
 #include <sysdev/fsl_pci.h>
 #include "smp.h"
 
+#if defined(CONFIG_PPC64) && defined(CONFIG_SUSPEND)
+static void fsl_suspend_disable_irqs(void)
+{
+	__hard_irq_disable();
+}
+#endif
+
 void __init corenet_gen_pic_init(void)
 {
 	struct mpic *mpic;
@@ -58,6 +65,11 @@ void __init corenet_gen_setup_arch(void)
 
 	fsl_rcpm_init();
 
+#if defined(CONFIG_PPC64) && defined(CONFIG_SUSPEND)
+	/* physically disable irq for 64-bit mode when suspend */
+	ppc_md.suspend_disable_irqs = fsl_suspend_disable_irqs;
+#endif
+
 	pr_info("%s board from Freescale Semiconductor\n", ppc_md.name);
 }
 
-- 
1.7.3


