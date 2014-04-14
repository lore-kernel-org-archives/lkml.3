Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851AbaDNNdF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 09:33:05 -0400
Received: from mail-bl2on0123.outbound.protection.outlook.com ([65.55.169.123]:49929
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754064AbaDNNdD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 09:33:03 -0400
X-Greylist: delayed 891 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Apr 2014 09:33:02 EDT
From: <dinguyen@altera.com>
To: <dinh.linux@gmail.com>, <mturquette@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Dinh Nguyen <dinguyen@altera.com>
Subject: [PATCH] clk: socfpga: fix clock driver for 3.15
Date: Mon, 14 Apr 2014 08:15:36 -0500
Message-ID: <1397481336-5592-1-git-send-email-dinguyen@altera.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:66.35.236.232;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10019001)(6009001)(458001)(199002)(189002)(164054003)(80022001)(48376002)(33646001)(4396001)(62966002)(20776003)(86362001)(46102001)(47776003)(87286001)(50986999)(6806004)(87936001)(74502001)(31966008)(93916002)(74662001)(80976001)(76482001)(97736001)(86152002)(77156001)(2009001)(92726001)(92566001)(88136002)(44976005)(19580395003)(79102001)(99396002)(36756003)(77982001)(89996001)(81342001)(53416003)(83322001)(19580405001)(50226001)(85852003)(83072002)(81542001);DIR:OUT;SFP:1102;SCL:1;SRVR:BY2FFO11HUB015;H:SJ-ITEXEDGE02.altera.priv.altera.com;FPR:A280F1E6.8ED29D00.32F5154B.E92FCF0.2032A;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-OriginatorOrg: altera.onmicrosoft.com
X-Forefront-PRVS: 0181F4652A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dinh Nguyen <dinguyen@altera.com>

commit [1771b10d6 clk: respect the clock dependencies in of_clk_init]
exposed a flaw in the socfpga clock driver and prevents the platform
from booting on 3.15-rc1.

Because the "altr,clk-mgr" is not really a clock, it should not be using
CLK_OF_DECLARE, instead we should be mapping the clk-mgr's base address
one of the functional clock init function. Use the socfpga_pll_init function
to map the clk_mgr_base_addr as this clock should always be initialized first.

Signed-off-by: Dinh Nguyen <dinguyen@altera.com>
---
Hi Mike,

This patch is needed to fix the SOCFPGA platform from booting on 3.15-rc1.

Thanks,
Dinh
---
 drivers/clk/socfpga/clk-pll.c |    7 +++++++
 drivers/clk/socfpga/clk.c     |   23 +++--------------------
 2 files changed, 10 insertions(+), 20 deletions(-)

diff --git a/drivers/clk/socfpga/clk-pll.c b/drivers/clk/socfpga/clk-pll.c
index 88dafb5..de6da95 100644
--- a/drivers/clk/socfpga/clk-pll.c
+++ b/drivers/clk/socfpga/clk-pll.c
@@ -20,6 +20,7 @@
 #include <linux/clk-provider.h>
 #include <linux/io.h>
 #include <linux/of.h>
+#include <linux/of_address.h>
 
 #include "clk.h"
 
@@ -43,6 +44,8 @@
 
 #define to_socfpga_clk(p) container_of(p, struct socfpga_pll, hw.hw)
 
+void __iomem *clk_mgr_base_addr;
+
 static unsigned long clk_pll_recalc_rate(struct clk_hw *hwclk,
 					 unsigned long parent_rate)
 {
@@ -87,6 +90,7 @@ static __init struct clk *__socfpga_pll_init(struct device_node *node,
 	const char *clk_name = node->name;
 	const char *parent_name[SOCFPGA_MAX_PARENTS];
 	struct clk_init_data init;
+	struct device_node *clkmgr_np;
 	int rc;
 	int i = 0;
 
@@ -96,6 +100,9 @@ static __init struct clk *__socfpga_pll_init(struct device_node *node,
 	if (WARN_ON(!pll_clk))
 		return NULL;
 
+	clkmgr_np = of_find_compatible_node(NULL, NULL, "altr,clk-mgr");
+	clk_mgr_base_addr = of_iomap(clkmgr_np, 0);
+	BUG_ON(!clk_mgr_base_addr);
 	pll_clk->hw.reg = clk_mgr_base_addr + reg;
 
 	of_property_read_string(node, "clock-output-names", &clk_name);
diff --git a/drivers/clk/socfpga/clk.c b/drivers/clk/socfpga/clk.c
index 35a960a..43db947 100644
--- a/drivers/clk/socfpga/clk.c
+++ b/drivers/clk/socfpga/clk.c
@@ -17,28 +17,11 @@
  * You should have received a copy of the GNU General Public License
  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
-#include <linux/clk.h>
-#include <linux/clkdev.h>
-#include <linux/clk-provider.h>
-#include <linux/io.h>
 #include <linux/of.h>
-#include <linux/of_address.h>
 
 #include "clk.h"
 
-void __iomem *clk_mgr_base_addr;
-
-static const struct of_device_id socfpga_child_clocks[] __initconst = {
-	{ .compatible = "altr,socfpga-pll-clock", socfpga_pll_init, },
-	{ .compatible = "altr,socfpga-perip-clk", socfpga_periph_init, },
-	{ .compatible = "altr,socfpga-gate-clk", socfpga_gate_init, },
-	{},
-};
-
-static void __init socfpga_clkmgr_init(struct device_node *node)
-{
-	clk_mgr_base_addr = of_iomap(node, 0);
-	of_clk_init(socfpga_child_clocks);
-}
-CLK_OF_DECLARE(socfpga_mgr, "altr,clk-mgr", socfpga_clkmgr_init);
+CLK_OF_DECLARE(socfpga_pll_clk, "altr,socfpga-pll-clock", socfpga_pll_init);
+CLK_OF_DECLARE(socfpga_perip_clk, "altr,socfpga-perip-clk", socfpga_periph_init);
+CLK_OF_DECLARE(socfpga_gate_clk, "altr,socfpga-gate-clk", socfpga_gate_init);
 
-- 
1.7.9.5

