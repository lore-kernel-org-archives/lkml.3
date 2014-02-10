Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364AbaBJUHn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 15:07:43 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:34830 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753893AbaBJTpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 14:45:19 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: robert.hodaszi@digi.com, Peter Chen <peter.chen@freescale.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 059/124] usb: ehci: add freescale imx28 special write register method
Date: Mon, 10 Feb 2014 11:39:59 -0800
Message-Id: <1392061264-28124-60-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1392061264-28124-1-git-send-email-kamal@canonical.com>
References: <1392061264-28124-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Chen <peter.chen@freescale.com>

commit feffe09f510c475df082546815f9e4a573f6a233 upstream.

According to Freescale imx28 Errata, "ENGR119653 USB: ARM to USB
register error issue", All USB register write operations must
use the ARM SWP instruction. So, we implement a special ehci_write
for imx28.

Discussion for it at below:
http://marc.info/?l=linux-usb&m=137996395529294&w=2

Without this patcheset, imx28 works unstable at high AHB bus loading.
If the bus loading is not high, the imx28 usb can work well at the most
of time. There is a IC errata for this problem, usually, we consider
IC errata is a problem not a new feature, and this workaround is needed
for that, so we need to add them to stable tree 3.11+.

Cc: robert.hodaszi@digi.com
Signed-off-by: Peter Chen <peter.chen@freescale.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Tested-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/host/ehci.h | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/ehci.h b/drivers/usb/host/ehci.h
index 36c3a82..1522a07 100644
--- a/drivers/usb/host/ehci.h
+++ b/drivers/usb/host/ehci.h
@@ -200,6 +200,7 @@ struct ehci_hcd {			/* one per controller */
 	unsigned		use_dummy_qh:1;	/* AMD Frame List table quirk*/
 	unsigned		has_synopsys_hc_bug:1; /* Synopsys HC */
 	unsigned		frame_index_bug:1; /* MosChip (AKA NetMos) */
+	unsigned		imx28_write_fix:1; /* For Freescale i.MX28 */
 
 	/* required for usb32 quirk */
 	#define OHCI_CTRL_HCFS          (3 << 6)
@@ -673,6 +674,18 @@ static inline unsigned int ehci_readl(const struct ehci_hcd *ehci,
 #endif
 }
 
+#ifdef CONFIG_SOC_IMX28
+static inline void imx28_ehci_writel(const unsigned int val,
+		volatile __u32 __iomem *addr)
+{
+	__asm__ ("swp %0, %0, [%1]" : : "r"(val), "r"(addr));
+}
+#else
+static inline void imx28_ehci_writel(const unsigned int val,
+		volatile __u32 __iomem *addr)
+{
+}
+#endif
 static inline void ehci_writel(const struct ehci_hcd *ehci,
 		const unsigned int val, __u32 __iomem *regs)
 {
@@ -681,7 +694,10 @@ static inline void ehci_writel(const struct ehci_hcd *ehci,
 		writel_be(val, regs) :
 		writel(val, regs);
 #else
-	writel(val, regs);
+	if (ehci->imx28_write_fix)
+		imx28_ehci_writel(val, regs);
+	else
+		writel(val, regs);
 #endif
 }
 
-- 
1.8.3.2

