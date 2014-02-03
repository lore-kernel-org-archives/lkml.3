Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543AbaBCLZm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 06:25:42 -0500
Received: from 8.mo3.mail-out.ovh.net ([87.98.172.249]:44538 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751037AbaBCLZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 06:25:41 -0500
From: Boris BREZILLON <b.brezillon@overkiz.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Boris BREZILLON <b.brezillon@overkiz.com>
Subject: [PATCH 1/3] clk: at91: fix programmable clk irq handling
Date: Mon,  3 Feb 2014 12:25:28 +0100
Message-Id: <1391426731-9392-2-git-send-email-b.brezillon@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1391426731-9392-1-git-send-email-b.brezillon@overkiz.com>
References: <1391426731-9392-1-git-send-email-b.brezillon@overkiz.com>
X-Ovh-Tracer-Id: 8986088632964577309
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrieelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrieelucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The prog irq is a level irq reflecting the prog clk status. As a result the
irq line will stay high when the prog clk is ready and the system will
hang.
Disable the irq when it is handled to avoid this problem.

Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
---
 drivers/clk/at91/clk-programmable.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/at91/clk-programmable.c b/drivers/clk/at91/clk-programmable.c
index fd792b2..02f62a0 100644
--- a/drivers/clk/at91/clk-programmable.c
+++ b/drivers/clk/at91/clk-programmable.c
@@ -55,6 +55,7 @@ static irqreturn_t clk_programmable_irq_handler(int irq, void *dev_id)
 	struct clk_programmable *prog = (struct clk_programmable *)dev_id;
 
 	wake_up(&prog->wait);
+	disable_irq_nosync(prog->irq);
 
 	return IRQ_HANDLED;
 }
@@ -74,8 +75,10 @@ static int clk_programmable_prepare(struct clk_hw *hw)
 
 	pmc_write(pmc, AT91_PMC_PCKR(id), tmp);
 
-	while (!(pmc_read(pmc, AT91_PMC_SR) & mask))
+	while (!(pmc_read(pmc, AT91_PMC_SR) & mask)) {
+		enable_irq(prog->irq);
 		wait_event(prog->wait, pmc_read(pmc, AT91_PMC_SR) & mask);
+	}
 
 	return 0;
 }
-- 
1.7.9.5

