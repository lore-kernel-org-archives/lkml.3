Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484AbaCaAa2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 20:30:28 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36261 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752886AbaC3XY7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:24:59 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, robert.hodaszi@digi.com,
        "Peter Chen" <peter.chen@freescale.com>,
        "Marc Kleine-Budde" <mkl@pengutronix.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Alan Stern" <stern@rowland.harvard.edu>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.477396739@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 038/200] usb: ehci: add freescale imx28 special write
 register method
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2:adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/host/ehci.h | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/ehci.h
+++ b/drivers/usb/host/ehci.h
@@ -147,6 +147,7 @@ struct ehci_hcd {			/* one per controlle
 	unsigned		use_dummy_qh:1;	/* AMD Frame List table quirk*/
 	unsigned		has_synopsys_hc_bug:1; /* Synopsys HC */
 	unsigned		frame_index_bug:1; /* MosChip (AKA NetMos) */
+	unsigned		imx28_write_fix:1; /* For Freescale i.MX28 */
 
 	/* required for usb32 quirk */
 	#define OHCI_CTRL_HCFS          (3 << 6)
@@ -654,6 +655,18 @@ static inline unsigned int ehci_readl(co
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
@@ -662,7 +675,10 @@ static inline void ehci_writel(const str
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
 

