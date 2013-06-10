Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189Ab3FJJO0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 05:14:26 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:4265 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141Ab3FJJOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 05:14:24 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 10 Jun 2013 02:13:02 -0700
From: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
To: <gregkh@linuxfoundation.org>
CC: <linux-tegra@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Subject: [PATCH 1/2] memory: tegra20-mc: Fix hang in IRQ handler.
Date: Mon, 10 Jun 2013 12:13:43 +0300
Message-ID: <1370855624-30564-2-git-send-email-ttynkkynen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1370855624-30564-1-git-send-email-ttynkkynen@nvidia.com>
References: <1370855624-30564-1-git-send-email-ttynkkynen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In Tegra20 memory controller any MC interrupt would cause an
infinite loop in the IRQ handler.

Signed-off-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
---
 drivers/memory/tegra20-mc.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/memory/tegra20-mc.c b/drivers/memory/tegra20-mc.c
index 2ca5f28..bd5a553 100644
--- a/drivers/memory/tegra20-mc.c
+++ b/drivers/memory/tegra20-mc.c
@@ -193,8 +193,11 @@ static irqreturn_t tegra20_mc_isr(int irq, void *data)
 	mask &= stat;
 	if (!mask)
 		return IRQ_NONE;
-	while ((bit = ffs(mask)) != 0)
+	while ((bit = ffs(mask)) != 0) {
 		tegra20_mc_decode(mc, bit - 1);
+		mask &= BIT(bit);
+	}
+
 	mc_writel(mc, stat, MC_INTSTATUS);
 	return IRQ_HANDLED;
 }
-- 
1.8.1.5

