Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751670AbaBVHaK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 02:30:10 -0500
Received: from smtp21.mail.ru ([94.100.176.174]:42244 "EHLO smtp21.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751035AbaBVHaI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 02:30:08 -0500
X-Greylist: delayed 5254 seconds by postgrey-1.27 at vger.kernel.org; Sat, 22 Feb 2014 02:30:08 EST
From: Alexander Shiyan <shc_work@mail.ru>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <zbr@ioremap.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Shawn Guo <shawn.guo@linaro.org>, Sascha Hauer <kernel@pengutronix.de>,
        Alexander Shiyan <shc_work@mail.ru>
Subject: [PATCH 3/4] w1: mxc_w1: Driver cleanup
Date: Sat, 22 Feb 2014 11:29:50 +0400
Message-Id: <1393054191-8623-3-git-send-email-shc_work@mail.ru>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393054191-8623-1-git-send-email-shc_work@mail.ru>
References: <1393054191-8623-1-git-send-email-shc_work@mail.ru>
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Remove old and currently wrong address of the FSF from license
  parts of the code.
- Remove unused #include and sort remaining headers alphabetically.
- Remove unised definitions.
- Add definitions for bit-fields.
- Add missing module owner field.

Signed-off-by: Alexander Shiyan <shc_work@mail.ru>
---
 drivers/w1/masters/mxc_w1.c | 39 ++++++++++++++++-----------------------
 1 file changed, 16 insertions(+), 23 deletions(-)

diff --git a/drivers/w1/masters/mxc_w1.c b/drivers/w1/masters/mxc_w1.c
index 6525b2c..8e3de6a 100644
--- a/drivers/w1/masters/mxc_w1.c
+++ b/drivers/w1/masters/mxc_w1.c
@@ -10,24 +10,16 @@
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
- *
  */
 
-#include <linux/module.h>
-#include <linux/interrupt.h>
-#include <linux/platform_device.h>
 #include <linux/clk.h>
-#include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/io.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
 
 #include "../w1.h"
 #include "../w1_int.h"
-#include "../w1_log.h"
 
 /* According to the mx27 Datasheet the reset procedure should take up to about
  * 1350us. We set the timeout to 500*100us = 50ms for sure */
@@ -36,13 +28,13 @@
 /*
  * MXC W1 Register offsets
  */
-#define MXC_W1_CONTROL          0x00
-#define MXC_W1_TIME_DIVIDER     0x02
-#define MXC_W1_RESET            0x04
-#define MXC_W1_COMMAND          0x06
-#define MXC_W1_TXRX             0x08
-#define MXC_W1_INTERRUPT        0x0A
-#define MXC_W1_INTERRUPT_EN     0x0C
+#define MXC_W1_CONTROL		0x00
+# define MXC_W1_CONTROL_RDST	BIT(3)
+# define MXC_W1_CONTROL_WR(x)	BIT(5 - (x))
+# define MXC_W1_CONTROL_PST	BIT(6)
+# define MXC_W1_CONTROL_RPP	BIT(7)
+#define MXC_W1_TIME_DIVIDER	0x02
+#define MXC_W1_RESET		0x04
 
 struct mxc_w1_device {
 	void __iomem *regs;
@@ -61,12 +53,12 @@ static u8 mxc_w1_ds2_reset_bus(void *data)
 	unsigned int timeout_cnt = 0;
 	struct mxc_w1_device *dev = data;
 
-	__raw_writeb(0x80, (dev->regs + MXC_W1_CONTROL));
+	__raw_writeb(MXC_W1_CONTROL_RPP, (dev->regs + MXC_W1_CONTROL));
 
 	while (1) {
 		reg_val = __raw_readb(dev->regs + MXC_W1_CONTROL);
 
-		if (((reg_val >> 7) & 0x1) == 0 ||
+		if (!(reg_val & MXC_W1_CONTROL_RPP) ||
 		    timeout_cnt > MXC_W1_RESET_TIMEOUT)
 			break;
 		else
@@ -74,7 +66,7 @@ static u8 mxc_w1_ds2_reset_bus(void *data)
 
 		udelay(100);
 	}
-	return (reg_val >> 6) & 0x1;
+	return !!(reg_val & MXC_W1_CONTROL_PST);
 }
 
 /*
@@ -90,16 +82,16 @@ static u8 mxc_w1_ds2_touch_bit(void *data, u8 bit)
 					 * datasheet.
 					 */
 
-	__raw_writeb((1 << (5 - bit)), ctrl_addr);
+	__raw_writeb(MXC_W1_CONTROL_WR(bit), ctrl_addr);
 
 	while (timeout_cnt--) {
-		if (!((__raw_readb(ctrl_addr) >> (5 - bit)) & 0x1))
+		if (!(__raw_readb(ctrl_addr) & MXC_W1_CONTROL_WR(bit)))
 			break;
 
 		udelay(1);
 	}
 
-	return ((__raw_readb(ctrl_addr)) >> 3) & 0x1;
+	return !!(__raw_readb(ctrl_addr) & MXC_W1_CONTROL_RDST);
 }
 
 static int mxc_w1_probe(struct platform_device *pdev)
@@ -177,6 +169,7 @@ MODULE_DEVICE_TABLE(of, mxc_w1_dt_ids);
 static struct platform_driver mxc_w1_driver = {
 	.driver = {
 		.name = "mxc_w1",
+		.owner = THIS_MODULE,
 		.of_match_table = mxc_w1_dt_ids,
 	},
 	.probe = mxc_w1_probe,
-- 
1.8.3.2

