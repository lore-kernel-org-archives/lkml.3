Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755115Ab3CVTMr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 15:12:47 -0400
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:17325
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754928Ab3CVTMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 15:12:45 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
From: Stuart Yoder <stuart.yoder@freescale.com>
To: <mikey@neuling.org>
CC: <chen.gang.flying.transformer@gmail.com>, <galak@kernel.crashing.org>,
        <gang.chen@asianux.com>, <benh@kernel.crashing.org>,
        <sfr@canb.auug.org.au>, <paulus@samba.org>, <matt@ozlabs.org>,
        <imunsie@au1.ibm.com>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>,
        Stuart Yoder <stuart.yoder@freescale.com>
Subject: [PATCH] PPC: define the conditions where the ePAPR idle hcall can be supported
Date: Fri, 22 Mar 2013 14:12:13 -0500
Message-ID: <1363979533-24485-1-git-send-email-stuart.yoder@freescale.com>
X-Mailer: git-send-email 1.7.9.7
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stuart Yoder <stuart.yoder@freescale.com>

For 32-bit, CONFIG_EPAPR_PARAVIRT pulls in both epapr_paravirt.c
and epapr_hcalls.c which contains the 32-bit paravirt idle loop.

For 64-bit, the paravirt idle loop is in idle_book3e.S and that
source file is included only if CONFIG_PPC_BOOK3E_64 defined.

This patch makes that dependency for 64-bit explicit.

Signed-off-by: Stuart Yoder <stuart.yoder@freescale.com>
---
 arch/powerpc/kernel/epapr_paravirt.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/powerpc/kernel/epapr_paravirt.c b/arch/powerpc/kernel/epapr_paravirt.c
index f3eab85..d44a571 100644
--- a/arch/powerpc/kernel/epapr_paravirt.c
+++ b/arch/powerpc/kernel/epapr_paravirt.c
@@ -23,8 +23,10 @@
 #include <asm/code-patching.h>
 #include <asm/machdep.h>
 
+#if !defined(CONFIG_64BIT) || defined(CONFIG_PPC_BOOK3E_64)
 extern void epapr_ev_idle(void);
 extern u32 epapr_ev_idle_start[];
+#endif
 
 bool epapr_paravirt_enabled;
 
@@ -47,11 +49,15 @@ static int __init epapr_paravirt_init(void)
 
 	for (i = 0; i < (len / 4); i++) {
 		patch_instruction(epapr_hypercall_start + i, insts[i]);
+#if !defined(CONFIG_64BIT) || defined(CONFIG_PPC_BOOK3E_64)
 		patch_instruction(epapr_ev_idle_start + i, insts[i]);
+#endif
 	}
 
+#if !defined(CONFIG_64BIT) || defined(CONFIG_PPC_BOOK3E_64)
 	if (of_get_property(hyper_node, "has-idle", NULL))
 		ppc_md.power_save = epapr_ev_idle;
+#endif
 
 	epapr_paravirt_enabled = true;
 
-- 
1.7.9.7


