Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059AbaKRKfB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 05:35:01 -0500
Received: from www.linutronix.de ([62.245.132.108]:38012 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753851AbaKRKe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 05:34:59 -0500
Date: Tue, 18 Nov 2014 11:34:37 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jiang Liu <jiang.liu@linux.intel.com>
cc: Bjorn Helgaas <bhelgaas@google.com>, Ingo Molnar <mingo@redhat.com>,
        Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yijing Wang <wangyijing@huawei.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Tony Luck <tony.luck@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-pci@vger.kernel.org, LAK <linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] asm-generic: Add msi.h
Message-ID: <alpine.DEB.2.11.1411181133080.3909@nanos>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To support MSI irq domains we want a generic data structure for
allocation, but we need the option to provide an architecture specific
version of it. So instead of playing #ifdef games in linux/msi.h we
add a generic header file and let architectures decide whether to
include it or to provide their own implementation and provide the
required typedef.
    
I know that typedefs are not really nice, but in this case there are no
forward declarations required and it's the simplest solution.
    
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Yijing Wang <wangyijing@huawei.com>
Cc: Yingjoe Chen <yingjoe.chen@mediatek.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: Alexander Gordeev <agordeev@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>

diff --git a/include/asm-generic/msi.h b/include/asm-generic/msi.h
new file mode 100644
index 000000000000..61c58d8878ce
--- /dev/null
+++ b/include/asm-generic/msi.h
@@ -0,0 +1,32 @@
+#ifndef __ASM_GENERIC_MSI_H
+#define __ASM_GENERIC_MSI_H
+
+#include <linux/types.h>
+
+#ifndef NUM_MSI_ALLOC_SCRATCHPAD_REGS
+# define NUM_MSI_ALLOC_SCRATCHPAD_REGS	2
+#endif
+
+struct msi_desc;
+
+/**
+ * struct msi_alloc_info - Default structure for MSI interrupt allocation.
+ * @desc:	Pointer to msi descriptor
+ * @hwirq:	Associated hw interrupt number in the domain
+ * @scratchpad:	Storage for implementation specific scratch data
+ *
+ * Architectures can provide their own implementation by not including
+ * asm-generic/msi.h into their arch specific header file.
+ */
+typedef struct msi_alloc_info {
+	struct msi_desc			*desc;
+	irq_hw_number_t			hwirq;
+	union {
+		unsigned long		ul;
+		void			*ptr;
+	} scratchpad[NUM_MSI_ALLOC_SCRATCHPAD_REGS];
+} msi_alloc_info_t;
+
+#define GENERIC_MSI_DOMAIN_OPS		1
+
+#endif
