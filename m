Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758145AbaGCNXT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 09:23:19 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:59892 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757930AbaGCNXO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 09:23:14 -0400
From: Manuel Lauss <manuel.lauss@gmail.com>
To: Linux-MIPS <linux-mips@linux-mips.org>,
        Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, Manuel Lauss <manuel.lauss@gmail.com>
Subject: [RFC PATCH v2 07/11] MIPS: Alchemy: irda: use clk framework
Date: Thu,  3 Jul 2014 15:22:38 +0200
Message-Id: <1404393762-858019-8-git-send-email-manuel.lauss@gmail.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404393762-858019-1-git-send-email-manuel.lauss@gmail.com>
References: <1404393762-858019-1-git-send-email-manuel.lauss@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Test the existence of the irda_clk clock object, use it to en/dis-
able it when date is being transferred.

Signed-off-by: Manuel Lauss <manuel.lauss@gmail.com>
---
 drivers/net/irda/au1k_ir.c | 48 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 46 insertions(+), 2 deletions(-)

diff --git a/drivers/net/irda/au1k_ir.c b/drivers/net/irda/au1k_ir.c
index 5f91e3e..aab2cf7 100644
--- a/drivers/net/irda/au1k_ir.c
+++ b/drivers/net/irda/au1k_ir.c
@@ -18,6 +18,7 @@
  *  with this program; if not, see <http://www.gnu.org/licenses/>.
  */
 
+#include <linux/clk.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
 #include <linux/interrupt.h>
@@ -175,6 +176,7 @@ struct au1k_private {
 
 	struct resource *ioarea;
 	struct au1k_irda_platform_data *platdata;
+	struct clk *irda_clk;
 };
 
 static int qos_mtt_bits = 0x07;  /* 1 ms or more */
@@ -514,9 +516,39 @@ static irqreturn_t au1k_irda_interrupt(int dummy, void *dev_id)
 static int au1k_init(struct net_device *dev)
 {
 	struct au1k_private *aup = netdev_priv(dev);
-	u32 enable, ring_address;
+	u32 enable, ring_address, phyck;
+	struct clk *c;
 	int i;
 
+	c = clk_get(NULL, "irda_clk");
+	if (IS_ERR(c))
+		return PTR_ERR(c);
+	i = clk_prepare_enable(c);
+	if (i) {
+		clk_put(c);
+		return i;
+	}
+
+	switch (clk_get_rate(c)) {
+	case 40000000:
+		phyck = IR_PHYCLK_40MHZ;
+		break;
+	case 48000000:
+		phyck = IR_PHYCLK_48MHZ;
+		break;
+	case 56000000:
+		phyck = IR_PHYCLK_56MHZ;
+		break;
+	case 64000000:
+		phyck = IR_PHYCLK_64MHZ;
+		break;
+	default:
+		clk_disable_unprepare(c);
+		clk_put(c);
+		return -EINVAL;
+	}
+	aup->irda_clk = c;
+
 	enable = IR_HC | IR_CE | IR_C;
 #ifndef CONFIG_CPU_LITTLE_ENDIAN
 	enable |= IR_BE;
@@ -545,7 +577,7 @@ static int au1k_init(struct net_device *dev)
 	irda_write(aup, IR_RING_SIZE,
 				(RING_SIZE_64 << 8) | (RING_SIZE_64 << 12));
 
-	irda_write(aup, IR_CONFIG_2, IR_PHYCLK_48MHZ | IR_ONE_PIN);
+	irda_write(aup, IR_CONFIG_2, phyck | IR_ONE_PIN);
 	irda_write(aup, IR_RING_ADDR_CMPR, 0);
 
 	au1k_irda_set_speed(dev, 9600);
@@ -619,6 +651,9 @@ static int au1k_irda_stop(struct net_device *dev)
 	free_irq(aup->irq_tx, dev);
 	free_irq(aup->irq_rx, dev);
 
+	clk_disable_unprepare(aup->irda_clk);
+	clk_put(aup->irda_clk);
+
 	return 0;
 }
 
@@ -853,6 +888,7 @@ static int au1k_irda_probe(struct platform_device *pdev)
 	struct au1k_private *aup;
 	struct net_device *dev;
 	struct resource *r;
+	struct clk *c;
 	int err;
 
 	dev = alloc_irdadev(sizeof(struct au1k_private));
@@ -886,6 +922,14 @@ static int au1k_irda_probe(struct platform_device *pdev)
 	if (!aup->ioarea)
 		goto out;
 
+	/* bail out early if clock doesn't exist */
+	c = clk_get(NULL, "irda_clk");
+	if (IS_ERR(c)) {
+		err = PTR_ERR(c);
+		goto out;
+	}
+	clk_put(c);
+
 	aup->iobase = ioremap_nocache(r->start, resource_size(r));
 	if (!aup->iobase)
 		goto out2;
-- 
2.0.0

