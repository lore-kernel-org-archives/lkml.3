Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814Ab3FJMxG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 08:53:06 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:45006 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752243Ab3FJMxB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 08:53:01 -0400
Date: Mon, 10 Jun 2013 14:52:46 +0200
From: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, davem@davemloft.net,
        Alessandro Rubini <rubini@gnudd.com>,
        Federico Vaga <federico.vaga@gmail.com>
Subject: [PATCH 3/3] arch/x86/pci/sta2x11-fixup.c: reset and enable STA2X11
 MediaLB clock
Message-ID: <0c15eefb893b10a37290e9e832bfd07cb94341b3.1370856733.git.asnaghi@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
References: <cover.1370856733.git.asnaghi@st.com>
In-Reply-To: <cover.1370856733.git.asnaghi@st.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MediaLB peripheral, devoted to the MOST protocol, must be reset
using chipset registers, so this code is not part of the MLB PCI
driver.

Signed-off-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
Signed-off-by: Federico Vaga <federico.vaga@gmail.com>
---
 arch/x86/pci/sta2x11-fixup.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/arch/x86/pci/sta2x11-fixup.c b/arch/x86/pci/sta2x11-fixup.c
index 9d8a509..3eae9ab 100644
--- a/arch/x86/pci/sta2x11-fixup.c
+++ b/arch/x86/pci/sta2x11-fixup.c
@@ -26,6 +26,9 @@
 #include <linux/pci_ids.h>
 #include <linux/export.h>
 #include <linux/list.h>
+#include <linux/delay.h>
+#include <linux/mfd/sta2x11-mfd.h>
+#include <asm/sta2x11.h>
 
 #define STA2X11_SWIOTLB_SIZE (4*1024*1024)
 extern int swiotlb_late_init_with_default_size(size_t default_size);
@@ -212,6 +215,20 @@ static void sta2x11_setup_pdev(struct pci_dev *pdev)
 }
 DECLARE_PCI_FIXUP_ENABLE(PCI_VENDOR_ID_STMICRO, PCI_ANY_ID, sta2x11_setup_pdev);
 
+static void sta2x11_most_enable(struct pci_dev *pdev)
+{
+	/* trying to reset the MLB */
+	sta2x11_apbreg_mask(pdev, APBREG_PCG, APBREG_MLB, 0);
+	sta2x11_apbreg_mask(pdev, APBREG_PUR, APBREG_MLB, 0);
+	msleep_interruptible(100);
+
+	/* Config clock and release device from reset */
+	sta2x11_apbreg_mask(pdev, APBREG_PCG, APBREG_MLB, APBREG_MLB);
+	sta2x11_apbreg_mask(pdev, APBREG_PUR, APBREG_MLB, APBREG_MLB);
+	msleep_interruptible(100);
+}
+DECLARE_PCI_FIXUP_ENABLE(PCI_VENDOR_ID_STMICRO, 0xcc12, sta2x11_most_enable);
+
 /*
  * The following three functions are exported (used in swiotlb: FIXME)
  */
-- 
1.7.7.2
