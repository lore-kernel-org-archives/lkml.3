Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274AbaDRN7Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 09:59:16 -0400
Received: from mail-bl2on0114.outbound.protection.outlook.com ([65.55.169.114]:19958
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752764AbaDRN65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 09:58:57 -0400
From: <tthayer@altera.com>
To: <linux-can@vger.kernel.org>, <wg@grandegger.com>, <mkl@pengutronix.de>,
        <tglx@linutronix.de>
CC: <socketcan@hartkopp.net>, <anilkumar@ti.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <tthayer.linux@gmail.com>, Thor Thayer <tthayer@altera.com>
Subject: [PATCHv2] net: c_can: Add support for D_CAN Module RAM Init
Date: Fri, 18 Apr 2014 09:03:14 -0500
Message-ID: <1397829794-9714-2-git-send-email-tthayer@altera.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1397829794-9714-1-git-send-email-tthayer@altera.com>
References: <1397829794-9714-1-git-send-email-tthayer@altera.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.232;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(458001)(199002)(189002)(85852003)(92726001)(89996001)(44976005)(83072002)(87286001)(93916002)(575784001)(86362001)(86152002)(2201001)(92566001)(84676001)(74502001)(16796002)(80976001)(2009001)(97736001)(19580405001)(83322001)(80022001)(19580395003)(20776003)(47776003)(74662001)(31966008)(81542001)(76176999)(99396002)(50986999)(81342001)(87936001)(76482001)(42186004)(50466002)(48376002)(62966002)(77156001)(77982001)(6806004)(88136002)(36756003)(46102001)(50226001)(4396001);DIR:OUT;SFP:1102;SCL:1;SRVR:BN1BFFO11HUB032;H:SJ-ITEXEDGE02.altera.priv.altera.com;FPR:A4F8C036.A7F4941A.35F7B287.DE141EF2.203C3;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-OriginatorOrg: altera.onmicrosoft.com
X-Forefront-PRVS: 018577E36E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thor Thayer <tthayer@altera.com>

The D_CAN driver was written to support the TI D_CAN implementation
which placed the D_CAN RAM reset in a separate register. In the
standard D_CAN module the RAM Init is in the D_CAN module so
handle the RAM Init differently.
This patch has only been tested on the standard D_CAN module (but not
on the TI D_CAN module).

Signed-off-by: Thor Thayer <tthayer@altera.com>
---
Changes in v2:
-Rename raminit_type_flag to raminit_type
-New constants for raminit_type
---
---
 drivers/net/can/c_can/c_can.h          |    3 ++
 drivers/net/can/c_can/c_can_platform.c |   51 +++++++++++++++++++++++++-------
 2 files changed, 44 insertions(+), 10 deletions(-)

diff --git a/drivers/net/can/c_can/c_can.h b/drivers/net/can/c_can/c_can.h
index faa8404..73c6c88 100644
--- a/drivers/net/can/c_can/c_can.h
+++ b/drivers/net/can/c_can/c_can.h
@@ -88,6 +88,7 @@ enum reg {
 	C_CAN_INTPND2_REG,
 	C_CAN_MSGVAL1_REG,
 	C_CAN_MSGVAL2_REG,
+	C_CAN_FUNCTION_REG,
 };
 
 static const u16 reg_map_c_can[] = {
@@ -139,6 +140,7 @@ static const u16 reg_map_d_can[] = {
 	[C_CAN_BRPEXT_REG]	= 0x0E,
 	[C_CAN_INT_REG]		= 0x10,
 	[C_CAN_TEST_REG]	= 0x14,
+	[C_CAN_FUNCTION_REG]	= 0x18,
 	[C_CAN_TXRQST1_REG]	= 0x88,
 	[C_CAN_TXRQST2_REG]	= 0x8A,
 	[C_CAN_NEWDAT1_REG]	= 0x9C,
@@ -201,6 +203,7 @@ struct c_can_priv {
 	unsigned int instance;
 	void (*raminit) (const struct c_can_priv *priv, bool enable);
 	u32 dlc[C_CAN_MSG_OBJ_TX_NUM];
+	u32 raminit_type;
 };
 
 struct net_device *alloc_c_can_dev(void);
diff --git a/drivers/net/can/c_can/c_can_platform.c b/drivers/net/can/c_can/c_can_platform.c
index 806d927..af3366f 100644
--- a/drivers/net/can/c_can/c_can_platform.c
+++ b/drivers/net/can/c_can/c_can_platform.c
@@ -41,6 +41,14 @@
 #define CAN_RAMINIT_DONE_MASK(i)	(0x100 << (i))
 #define CAN_RAMINIT_ALL_MASK(i)		(0x101 << (i))
 static DEFINE_SPINLOCK(raminit_lock);
+#define DCAN_RAM_INIT_BIT		(1 << 3)
+struct c_can_ram_init_masks {
+	u32 start;
+	u32 done;
+	u32 all;
+};
+#define CAN_RAMINIT_TYPE_STANDARD	0
+#define CAN_RAMINIT_TYPE_TI		1
 /*
  * 16-bit c_can registers can be arranged differently in the memory
  * architecture of different implementations. For example: 16-bit
@@ -82,9 +90,19 @@ static void c_can_hw_raminit_wait(const struct c_can_priv *priv, u32 mask,
 
 static void c_can_hw_raminit(const struct c_can_priv *priv, bool enable)
 {
-	u32 mask = CAN_RAMINIT_ALL_MASK(priv->instance);
+	struct c_can_ram_init_masks ram_init_masks;
 	u32 ctrl;
 
+	if (priv->raminit_type == CAN_RAMINIT_TYPE_TI) {
+		ram_init_masks.start = CAN_RAMINIT_START_MASK(priv->instance);
+		ram_init_masks.done = CAN_RAMINIT_DONE_MASK(priv->instance);
+		ram_init_masks.all = CAN_RAMINIT_ALL_MASK(priv->instance);
+	} else {
+		ram_init_masks.start = DCAN_RAM_INIT_BIT;
+		ram_init_masks.done = 0;
+		ram_init_masks.all = 0;
+	}
+
 	spin_lock(&raminit_lock);
 
 	ctrl = readl(priv->raminit_ctrlreg);
@@ -92,18 +110,18 @@ static void c_can_hw_raminit(const struct c_can_priv *priv, bool enable)
 	 * looking at the 0 -> transition, but is not self clearing;
 	 * And we clear the init done bit as well.
 	 */
-	ctrl &= ~CAN_RAMINIT_START_MASK(priv->instance);
-	ctrl |= CAN_RAMINIT_DONE_MASK(priv->instance);
+	ctrl &= ~ram_init_masks.start;
+	ctrl |= ram_init_masks.done;
 	writel(ctrl, priv->raminit_ctrlreg);
-	ctrl &= ~CAN_RAMINIT_DONE_MASK(priv->instance);
-	c_can_hw_raminit_wait(priv, ctrl, mask);
+	ctrl &= ~ram_init_masks.done;
+	c_can_hw_raminit_wait(priv, ctrl, ram_init_masks.all);
 
 	if (enable) {
 		/* Set start bit and wait for the done bit. */
-		ctrl |= CAN_RAMINIT_START_MASK(priv->instance);
+		ctrl |= ram_init_masks.start;
 		writel(ctrl, priv->raminit_ctrlreg);
-		ctrl |= CAN_RAMINIT_DONE_MASK(priv->instance);
-		c_can_hw_raminit_wait(priv, ctrl, mask);
+		ctrl |= ram_init_masks.done;
+		c_can_hw_raminit_wait(priv, ctrl, ram_init_masks.all);
 	}
 	spin_unlock(&raminit_lock);
 }
@@ -221,11 +239,24 @@ static int c_can_plat_probe(struct platform_device *pdev)
 			priv->instance = pdev->id;
 
 		res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
+		/* Not all D_CAN module have a separate register for the D_CAN
+		 * RAM initialization. Use default RAM init bit in D_CAN module
+		 * if not specified in DT.
+		 */
+		if (!res) {
+			priv->raminit = c_can_hw_raminit;
+			priv->raminit_type = CAN_RAMINIT_TYPE_STANDARD;
+			priv->raminit_ctrlreg = addr +
+				priv->regs[C_CAN_FUNCTION_REG];
+			break;
+		}
 		priv->raminit_ctrlreg = devm_ioremap_resource(&pdev->dev, res);
-		if (IS_ERR(priv->raminit_ctrlreg) || (int)priv->instance < 0)
+		if (IS_ERR(priv->raminit_ctrlreg) || (int)priv->instance < 0) {
 			dev_info(&pdev->dev, "control memory is not used for raminit\n");
-		else
+		} else {
 			priv->raminit = c_can_hw_raminit;
+			priv->raminit_type = CAN_RAMINIT_TYPE_TI;
+		}
 		break;
 	default:
 		ret = -EINVAL;
-- 
1.7.9.5

