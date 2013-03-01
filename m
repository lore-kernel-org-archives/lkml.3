Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751586Ab3CASvt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 13:51:49 -0500
Received: from co1ehsobe002.messaging.microsoft.com ([216.32.180.185]:39824
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750779Ab3CASvs convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 13:51:48 -0500
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzc89bh4015Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz2fh95h668h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah139eh13b6h1441h14ddh1504h1537h162dh1631h1758h1898h18e1h1946h19b5h906i1155h)
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <michal.simek@xilinx.com>, <monstr@monstr.eu>,
        Russell King <linux@arm.linux.org.uk>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Will Deacon <will.deacon@arm.com>, Jason Cooper <jason@lakedaemon.net>,
        Tony Lindgren <tony@atomide.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Soren Brinkmann <soren.brinkmann@xilinx.com>
Subject: [PATCH RFC] arm: l2x0: Leverage power saving features
Date: Fri, 1 Mar 2013 10:51:26 -0800
X-Mailer: git-send-email 1.8.1.3
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
X-OriginalArrivalTime: 01 Mar 2013 18:51:43.0359 (UTC) FILETIME=[D11990F0:01CE16AD]
X-RCIS-Action: ALLOW
Message-ID: <da92149b-159b-40e3-87b4-a0a448d1da8b@CO1EHSMHS031.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enable the 'dynamic clock stop' and 'standby mode' features in the
l2x0 disable path.

Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
---
Hi,

we are currently implementing a suspend to RAM like low power mode for
Zynq.
The code for entering suspend looks like this:
	outer_disable();                                                 
        cpu_suspend(0, zynq_pm_suspend);                                 
        outer_resume();

In our low power guidelines we mention the pl310's standby and clock stop
feature and that they should be enabled for low power modes. The question
arising here now is: Does the outer_disable() make these features redundant,
or does it make sense to add it like shown in this patch?

	Thanks,
	Sören

 arch/arm/mm/cache-l2x0.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm/mm/cache-l2x0.c b/arch/arm/mm/cache-l2x0.c
index c2f3739..3565df1 100644
--- a/arch/arm/mm/cache-l2x0.c
+++ b/arch/arm/mm/cache-l2x0.c
@@ -286,8 +286,20 @@ static void l2x0_flush_range(unsigned long start, unsigned long end)
 static void l2x0_disable(void)
 {
 	unsigned long flags;
+	unsigned long reg;
+	u32 l2x0_revision;
 
 	raw_spin_lock_irqsave(&l2x0_lock, flags);
+
+	l2x0_revision = readl_relaxed(l2x0_base + L2X0_CACHE_ID) &
+		L2X0_CACHE_ID_RTL_MASK;
+
+	if (l2x0_revision >= L2X0_CACHE_ID_RTL_R3P0) {
+		reg = readl_relaxed(l2x0_base + L2X0_POWER_CTRL);
+		reg |= L2X0_STNDBY_MODE_EN | L2X0_DYNAMIC_CLK_GATING_EN;
+		writel_relaxed(reg, l2x0_base + L2X0_POWER_CTRL);
+	}
+
 	__l2x0_flush_all();
 	writel_relaxed(0, l2x0_base + L2X0_CTRL);
 	dsb();
-- 
1.8.1.3


