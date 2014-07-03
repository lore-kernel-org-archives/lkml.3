Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932144AbaGCNZG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 09:25:06 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:49336 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756804AbaGCNXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 09:23:08 -0400
From: Manuel Lauss <manuel.lauss@gmail.com>
To: Linux-MIPS <linux-mips@linux-mips.org>,
        Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, Manuel Lauss <manuel.lauss@gmail.com>
Subject: [RFC PATCH v2 06/11] MIPS: Alchemy: db1200: use clk framework
Date: Thu,  3 Jul 2014 15:22:37 +0200
Message-Id: <1404393762-858019-7-git-send-email-manuel.lauss@gmail.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1404393762-858019-1-git-send-email-manuel.lauss@gmail.com>
References: <1404393762-858019-1-git-send-email-manuel.lauss@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make use of the clk framework to give us a rate as close to 50MHz
as possible.

Signed-off-by: Manuel Lauss <manuel.lauss@gmail.com>
---
 arch/mips/alchemy/devboards/db1200.c | 45 ++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 25 deletions(-)

diff --git a/arch/mips/alchemy/devboards/db1200.c b/arch/mips/alchemy/devboards/db1200.c
index 8c71cde..f255586 100644
--- a/arch/mips/alchemy/devboards/db1200.c
+++ b/arch/mips/alchemy/devboards/db1200.c
@@ -18,6 +18,7 @@
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#include <linux/clk.h>
 #include <linux/dma-mapping.h>
 #include <linux/gpio.h>
 #include <linux/i2c.h>
@@ -129,7 +130,6 @@ static int __init db1200_detect_board(void)
 
 int __init db1200_board_setup(void)
 {
-	unsigned long freq0, clksrc, div, pfc;
 	unsigned short whoami;
 
 	if (db1200_detect_board())
@@ -149,30 +149,6 @@ int __init db1200_board_setup(void)
 		"  Board-ID %d	Daughtercard ID %d\n", get_system_type(),
 		(whoami >> 4) & 0xf, (whoami >> 8) & 0xf, whoami & 0xf);
 
-	/* SMBus/SPI on PSC0, Audio on PSC1 */
-	pfc = AU1X_RDSYS(AU1000_SYS_PINFUNC);
-	pfc &= ~(SYS_PINFUNC_P0A | SYS_PINFUNC_P0B);
-	pfc &= ~(SYS_PINFUNC_P1A | SYS_PINFUNC_P1B | SYS_PINFUNC_FS3);
-	pfc |= SYS_PINFUNC_P1C; /* SPI is configured later */
-	AU1X_WRSYS(pfc, AU1000_SYS_PINFUNC);
-
-	/* Clock configurations: PSC0: ~50MHz via Clkgen0, derived from
-	 * CPU clock; all other clock generators off/unused.
-	 */
-	div = (get_au1x00_speed() + 25000000) / 50000000;
-	if (div & 1)
-		div++;
-	div = ((div >> 1) - 1) & 0xff;
-
-	freq0 = div << SYS_FC_FRDIV0_BIT;
-	AU1X_WRSYS(freq0, AU1000_SYS_FREQCTRL0);
-	freq0 |= SYS_FC_FE0;	/* enable F0 */
-	AU1X_WRSYS(freq0, AU1000_SYS_FREQCTRL0);
-
-	/* psc0_intclk comes 1:1 from F0 */
-	clksrc = SYS_CS_MUX_FQ0 << SYS_CS_ME0_BIT;
-	AU1X_WRSYS(clksrc, AU1000_SYS_CLKSRC);
-
 	return 0;
 }
 
@@ -845,6 +821,7 @@ int __init db1200_dev_setup(void)
 	unsigned long pfc;
 	unsigned short sw;
 	int swapped, bid;
+	struct clk *c;
 
 	bid = BCSR_WHOAMI_BOARD(bcsr_read(BCSR_WHOAMI));
 	if ((bid == BCSR_WHOAMI_PB1200_DDR1) ||
@@ -857,6 +834,24 @@ int __init db1200_dev_setup(void)
 	irq_set_irq_type(AU1200_GPIO7_INT, IRQ_TYPE_LEVEL_LOW);
 	bcsr_init_irq(DB1200_INT_BEGIN, DB1200_INT_END, AU1200_GPIO7_INT);
 
+	/* SMBus/SPI on PSC0, Audio on PSC1 */
+	pfc = AU1X_RDSYS(AU1000_SYS_PINFUNC);
+	pfc &= ~(SYS_PINFUNC_P0A | SYS_PINFUNC_P0B);
+	pfc &= ~(SYS_PINFUNC_P1A | SYS_PINFUNC_P1B | SYS_PINFUNC_FS3);
+	pfc |= SYS_PINFUNC_P1C; /* SPI is configured later */
+	AU1X_WRSYS(pfc, AU1000_SYS_PINFUNC);
+
+	/* get 50MHz for I2C driver on PSC0 */
+	c = clk_get(NULL, "psc0_intclk");
+	if (!IS_ERR(c)) {
+		pfc = clk_round_rate(c, 50000000);
+		if ((pfc < 1) || (abs(50000000 - pfc) > 2500000))
+			pr_warn("DB1200: cant get I2C close to 50MHz\n");
+		else
+			clk_set_rate(c, pfc);
+		clk_put(c);
+	}
+
 	/* insert/eject pairs: one of both is always screaming.	 To avoid
 	 * issues they must not be automatically enabled when initially
 	 * requested.
-- 
2.0.0

