Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934578AbaBDVMI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:12:08 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57154 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934441AbaBDVLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:11:38 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        robert.hodaszi@digi.com, Peter Chen <peter.chen@freescale.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 3.13 025/140] usb: ehci: add freescale imx28 special write register method
Date: Tue,  4 Feb 2014 13:10:12 -0800
Message-Id: <20140204211037.681112291@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204211036.967663852@linuxfoundation.org>
References: <20140204211036.967663852@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/usb/host/ehci.h |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/ehci.h
+++ b/drivers/usb/host/ehci.h
@@ -225,6 +225,7 @@ struct ehci_hcd {			/* one per controlle
 	unsigned		has_synopsys_hc_bug:1; /* Synopsys HC */
 	unsigned		frame_index_bug:1; /* MosChip (AKA NetMos) */
 	unsigned		need_oc_pp_cycle:1; /* MPC834X port power */
+	unsigned		imx28_write_fix:1; /* For Freescale i.MX28 */
 
 	/* required for usb32 quirk */
 	#define OHCI_CTRL_HCFS          (3 << 6)
@@ -728,6 +729,18 @@ static inline unsigned int ehci_readl(co
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
@@ -736,7 +749,10 @@ static inline void ehci_writel(const str
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
 


